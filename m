Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD7FC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 18:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjEWSGG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 14:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbjEWSGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 14:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4237197
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 11:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D12F361A78
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F12FC433EF;
        Tue, 23 May 2023 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684865163;
        bh=3XAVqjSUK8t5cDmmKd6YQidBBmLo4Ncgj5A3LAdcEtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sq7EUMwT7CM4zejgiR/ql+VP+3YNRhKLWvYCbZCtSUrmxPLqbEYUMzzhETgBpIyRG
         HeJNSWN0u5uEvTIij9RwqDw9eAyZ4lWKMBkKpI7BsKONbA9bWPeowPSVNsH0PQr4ZA
         2DPevb+rwAYBr66jtzrsePyIOGjZuT3I6WFHHyP8UucUIz/ARfS3A/5IMcGC1B0xt5
         tsiMux6IlBqryMzCUBf4yf5zJlrHwy4FyQNFvNN01NABhZSW0m4oNx2bQNOMk7ILIV
         4ZImrbPymKjP8vft0Kw9Ouk5lOPqTS9lSGI7gyjY2xHw3HpuYo1b1Eh/emFXRsJcWv
         NGltS53tD/kxQ==
Date:   Tue, 23 May 2023 11:06:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] mdrestore: Define mdrestore ops for v2 format
Message-ID: <20230523180602.GA11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-23-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-23-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:48PM +0530, Chandan Babu R wrote:
> This commit adds functionality to restore metadump stored in v2 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 209 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 194 insertions(+), 15 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 615ecdc77..9e06d37dc 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -11,7 +11,8 @@ struct mdrestore_ops {
>  	int (*read_header)(void *header, FILE *mdfp);
>  	void (*show_info)(void *header, const char *mdfile);
>  	void (*restore)(void *header, FILE *mdfp, int data_fd,
> -			bool is_target_file);
> +			bool is_data_target_file, int log_fd,
> +			bool is_log_target_file);
>  };
>  
>  static struct mdrestore {
> @@ -148,7 +149,9 @@ restore_v1(
>  	void		*header,
>  	FILE		*mdfp,
>  	int		data_fd,
> -	bool		is_target_file)
> +	bool		is_data_target_file,
> +	int		log_fd,
> +	bool		is_log_target_file)
>  {
>  	struct xfs_metablock	*mbp = header;
>  	struct xfs_metablock	*metablock;
> @@ -203,7 +206,7 @@ restore_v1(
>  
>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(data_fd, is_target_file, sb.sb_dblocks,
> +	verify_device_size(data_fd, is_data_target_file, sb.sb_dblocks,
>  			sb.sb_blocksize);
>  
>  	bytes_read = 0;
> @@ -264,6 +267,163 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
>  	.restore = restore_v1,
>  };
>  
> +static int
> +read_header_v2(
> +	void				*header,
> +	FILE				*mdfp)
> +{
> +	struct xfs_metadump_header	*xmh = header;
> +
> +	rewind(mdfp);

Does rewind() work if @mdfp is a pipe?

I suspect the best you can do is read the first 4 bytes in main, pick
the read_header function from that, and have the read_header_v[12] read
in the rest of the header from there.  I use a lot of:

xfs_metadump -ago /dev/sda - | gzip > foo.md.gz
gzip -d < foo.md.gz | xfs_mdrestore -g - /dev/sdb

to store compressed metadumps for future reference.

(Well ok I use xz or zstd, but you get the point.)

> +
> +	if (fread(xmh, sizeof(*xmh), 1, mdfp) != 1)
> +		fatal("error reading from metadump file\n");
> +	if (xmh->xmh_magic != cpu_to_be32(XFS_MD_MAGIC_V2))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static void
> +show_info_v2(
> +	void				*header,
> +	const char			*mdfile)
> +{
> +	struct xfs_metadump_header	*xmh;
> +	uint32_t			incompat_flags;
> +
> +	xmh = header;
> +	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
> +
> +	printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
> +		mdfile,
> +		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
> +		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
> +		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
> +}
> +
> +static void
> +restore_v2(
> +	void			*header,
> +	FILE			*mdfp,
> +	int			data_fd,
> +	bool			is_data_target_file,
> +	int			log_fd,
> +	bool			is_log_target_file)
> +{
> +	struct xfs_sb		sb;
> +	struct xfs_meta_extent	xme;
> +	char			*block_buffer;
> +	int64_t			bytes_read;
> +	uint64_t		offset;
> +	int			prev_len;
> +	int			len;
> +
> +	if (fread(&xme, sizeof(xme), 1, mdfp) != 1)
> +		fatal("error reading from metadump file\n");
> +
> +	len = be32_to_cpu(xme.xme_len);
> +	len <<= BBSHIFT;

Do we need to validate xme_addr==0 and xme_len==1 here?

> +
> +	block_buffer = calloc(1, len);
> +	if (block_buffer == NULL)
> +		fatal("memory allocation failure\n");
> +
> +	if (fread(block_buffer, len, 1, mdfp) != 1)
> +		fatal("error reading from metadump file\n");
> +
> +	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> +
> +	if (sb.sb_magicnum != XFS_SB_MAGIC)
> +		fatal("bad magic number for primary superblock\n");
> +
> +	if (sb.sb_logstart == 0 && log_fd == -1)
> +		fatal("External Log device is required\n");
> +
> +	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
> +
> +	verify_device_size(data_fd, is_data_target_file, sb.sb_dblocks,
> +			sb.sb_blocksize);
> +
> +	if (sb.sb_logstart == 0)
> +		verify_device_size(log_fd, is_log_target_file, sb.sb_logblocks,
> +				sb.sb_blocksize);
> +
> +	bytes_read = 0;
> +
> +	do {
> +		int fd;
> +
> +		if (mdrestore.show_progress &&
> +			(bytes_read & ((1 << 20) - 1)) == 0)
> +			print_progress("%lld MB read", bytes_read >> 20);

Doesn't this miss a progress report if a metadata extent bumps
bytes_read across a MB boundary without actually landing on it?  Say
you've written 1020K, and the next xfs_meta_extent is 8k long.

	if (metadump.show_progress) {
		static int64_t	mb_read;
		int64_t		mb_now = bytes_read >> 20;

		if (mb_now != mb_read) {
			print_progress("%lld MB read", mb_now);
			mb_read = mb_now;
		}
	}

> +
> +		offset = be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK;
> +		offset <<= BBSHIFT;

offset = BBTOB(be64_to_cpu() ... ); ?

Also, I'd have thought that XME_ADDR_DEVICE_MASK is what you use to
decode the device, not what you use to decode the address within a
device.

> +
> +		if (be64_to_cpu(xme.xme_addr) & XME_ADDR_DATA_DEVICE)
> +			fd = data_fd;
> +		else if (be64_to_cpu(xme.xme_addr) & XME_ADDR_LOG_DEVICE)
> +			fd = log_fd;
> +		else
> +			ASSERT(0);

If you instead defined the constants like this:

#define XME_ADDR_DEVICE_SHIFT	54
#define XME_ADDR_DEVICE_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)

#define XME_ADDR_DATA_DEVICE	(0 << XME_ADDR_DEVICE_SHIFT)
#define XME_ADDR_LOG_DEVICE	(1 << XME_ADDR_DEVICE_SHIFT)
#define XME_ADDR_RT_DEVICE	(2 << XME_ADDR_DEVICE_SHIFT)

#define XME_ADDR_DEVICE_MASK	(3 << XME_ADDR_DEVICE_SHIFT)

Then the above becomes:

	offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);

	switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
	case XME_ADDR_DATA_DEVICE:
		fd = data_fd;
		break;
	...
	}
> +
> +		if (pwrite(fd, block_buffer, len, offset) < 0)
> +			fatal("error writing to %s device at offset %llu: %s\n",
> +				fd == data_fd ? "data": "log", offset,
> +				strerror(errno));
> +
> +                if (fread(&xme, sizeof(xme), 1, mdfp) != 1) {
> +			if (feof(mdfp))
> +				break;
> +			fatal("error reading from metadump file\n");
> +		}
> +
> +		prev_len = len;
> +		len = be32_to_cpu(xme.xme_len);
> +		len <<= BBSHIFT;
> +		if (len > prev_len) {
> +			void *p;
> +			p = realloc(block_buffer, len);

Would it be preferable to declare an 8MB buffer and only copy contents
in that granularity?  Technically speaking, xme_len == -1U would require
us to allocate a 2TB buffer, wouldn't it?

> +			if (p == NULL) {
> +				free(block_buffer);
> +				fatal("memory allocation failure\n");
> +			}
> +			block_buffer = p;
> +		}
> +
> +		if (fread(block_buffer, len, 1, mdfp) != 1)
> +			fatal("error reading from metadump file\n");
> +
> +		bytes_read += len;
> +	} while (1);
> +
> +	if (mdrestore.progress_since_warning)
> +		putchar('\n');
> +
> +        memset(block_buffer, 0, sb.sb_sectsize);

Tabs not spaces.

> +	sb.sb_inprogress = 0;
> +	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
> +	if (xfs_sb_version_hascrc(&sb)) {
> +		xfs_update_cksum(block_buffer, sb.sb_sectsize,
> +				offsetof(struct xfs_sb, sb_crc));
> +	}
> +
> +	if (pwrite(data_fd, block_buffer, sb.sb_sectsize, 0) < 0)
> +		fatal("error writing primary superblock: %s\n",
> +			strerror(errno));
> +
> +	free(block_buffer);
> +
> +	return;
> +}
> +
> +static struct mdrestore_ops mdrestore_ops_v2 = {
> +	.read_header = read_header_v2,
> +	.show_info = show_info_v2,
> +	.restore = restore_v2,
> +};
> +
>  static void
>  usage(void)
>  {
> @@ -276,11 +436,16 @@ main(
>  	int 		argc,
>  	char 		**argv)
>  {
> -	FILE		*src_f;
> -	int		dst_fd;
> -	int		c;
> -	bool		is_target_file;
> -	struct xfs_metablock	mb;
> +	struct xfs_metadump_header	xmh;
> +	struct xfs_metablock		mb;

Hmm...

> +	FILE				*src_f;
> +	char				*logdev = NULL;
> +	void				*header;
> +	int				data_dev_fd;
> +	int				log_dev_fd;
> +	int				c;
> +	bool				is_data_dev_file;
> +	bool				is_log_dev_file;
>  
>  	mdrestore.show_progress = 0;
>  	mdrestore.show_info = 0;
> @@ -327,13 +492,18 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0)
> +	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
>  		mdrestore.mdrops = &mdrestore_ops_v1;
> -	else
> +		header = &mb;
> +	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
> +		mdrestore.mdrops = &mdrestore_ops_v2;
> +		header = &xmh;

Perhaps define a union of both header formats, then pass that to
->read_header, ->show_info, and ->restore?

--D

> +	} else {
>  		fatal("Invalid metadump format\n");
> +	}
>  
>  	if (mdrestore.show_info) {
> -		mdrestore.mdrops->show_info(&mb, argv[optind]);
> +		mdrestore.mdrops->show_info(header, argv[optind]);
>  
>  		if (argc - optind == 1)
>  			exit(0);
> @@ -341,12 +511,21 @@ main(
>  
>  	optind++;
>  
> -	/* check and open target */
> -	dst_fd = open_device(argv[optind], &is_target_file);
> +	/* check and open data device */
> +	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
> +
> +	log_dev_fd = -1;
> +	if (logdev)
> +		/* check and open log device */
> +		log_dev_fd = open_device(logdev, &is_log_dev_file);
> +
> +	mdrestore.mdrops->restore(header, src_f, data_dev_fd, is_data_dev_file,
> +				log_dev_fd, is_log_dev_file);
>  
> -	mdrestore.mdrops->restore(&mb, src_f, dst_fd, is_target_file);
> +	close(data_dev_fd);
> +	if (logdev)
> +		close(log_dev_fd);
>  
> -	close(dst_fd);
>  	if (src_f != stdin)
>  		fclose(src_f);
>  
> -- 
> 2.39.1
> 
