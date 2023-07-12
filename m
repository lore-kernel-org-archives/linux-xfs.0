Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07D3EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 18:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjGLSKL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjGLSKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 14:10:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44851FDE
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 11:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6819261888
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 18:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED4DC433C8;
        Wed, 12 Jul 2023 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689185403;
        bh=mdFG4Dg/Jv6GB/jyCZw8ox/PKc63n42ClDkDmPUs/5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qGjJ/n/dkHS+sgJQIidfBTvmo7kuJD/QlHg6KIOqmXhbsXblUw4aXZj8IqjbbHOre
         30DC0IZrsybF0ChS4xb1I2KSyU7ONBksZQfEJHkio9k8DTjfreLW9C3vyzCvYINR99
         Ooh4D5F1LetWjZEc5ERd4y48ofud/GDlA6iaqE3ehw4yqsfn/Dn21CK1s9dZRV87GZ
         NK4ZmBSY+qHNreSNjPndrksc6DHAZVlRpYc9IufS9N9LswWwJCygGxbuR+cGNLoQi5
         6+Y6ZxNWHaeFUhxRJ1Ai0zjLAPYszbfXSwvtTcVKGvrrJtqzyw3ruf4hRL+ft+YFjV
         V605GQz4cJLWQ==
Date:   Wed, 12 Jul 2023 11:10:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 22/23] mdrestore: Define mdrestore ops for v2 format
Message-ID: <20230712181003.GQ108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-23-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-23-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:58:05PM +0530, Chandan Babu R wrote:
> This commit adds functionality to restore metadump stored in v2 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 251 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 233 insertions(+), 18 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index c395ae90..7b484071 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -12,7 +12,8 @@ struct mdrestore_ops {
>  	void (*read_header)(void *header, FILE *md_fp);
>  	void (*show_info)(void *header, const char *md_file);
>  	void (*restore)(void *header, FILE *md_fp, int ddev_fd,
> -			bool is_target_file);
> +			bool is_data_target_file, int logdev_fd,
> +			bool is_log_target_file);
>  };
>  
>  static struct mdrestore {
> @@ -20,6 +21,7 @@ static struct mdrestore {
>  	bool			show_progress;
>  	bool			show_info;
>  	bool			progress_since_warning;
> +	bool			external_log;
>  } mdrestore;
>  
>  static void
> @@ -143,10 +145,12 @@ show_info_v1(
>  
>  static void
>  restore_v1(
> -	void			*header,
> -	FILE			*md_fp,
> -	int			ddev_fd,
> -	bool			is_target_file)
> +	void		*header,
> +	FILE		*md_fp,
> +	int		ddev_fd,
> +	bool		is_data_target_file,

Why does the indent level change here...

> +	int		logdev_fd,
> +	bool		is_log_target_file)
>  {
>  	struct xfs_metablock	*metablock;
>  	struct xfs_metablock	*mbp;

...but not here?

> @@ -203,7 +207,7 @@ restore_v1(
>  
>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
>  			sb.sb_blocksize);
>  
>  	bytes_read = 0;
> @@ -264,6 +268,195 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
>  	.restore	= restore_v1,
>  };
>  
> +static void
> +read_header_v2(
> +	void				*header,
> +	FILE				*md_fp)
> +{
> +	struct xfs_metadump_header	*xmh = header;
> +	bool				want_external_log;
> +
> +	xmh->xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
> +
> +	if (fread((uint8_t *)xmh + sizeof(xmh->xmh_magic),
> +			sizeof(*xmh) - sizeof(xmh->xmh_magic), 1, md_fp) != 1)
> +		fatal("error reading from metadump file\n");
> +
> +	want_external_log = !!(be32_to_cpu(xmh->xmh_incompat_flags) &
> +			XFS_MD2_INCOMPAT_EXTERNALLOG);
> +
> +	if (want_external_log && !mdrestore.external_log)
> +		fatal("External Log device is required\n");
> +}
> +
> +static void
> +show_info_v2(
> +	void				*header,
> +	const char			*md_file)
> +{
> +	struct xfs_metadump_header	*xmh;
> +	uint32_t			incompat_flags;
> +
> +	xmh = header;
> +	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
> +
> +	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
> +		md_file,
> +		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
> +		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
> +		incompat_flags & XFS_MD2_INCOMPAT_EXTERNALLOG ? "":"not ",
> +		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
> +}
> +
> +#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
> +
> +static void
> +dump_meta_extent(

Aren't we restoring here?  And not dumping?

> +	FILE		*md_fp,
> +	int		dev_fd,
> +	char		*device,
> +	void		*buf,
> +	uint64_t	offset,
> +	int		len)
> +{
> +	int		io_size;
> +
> +	io_size = min(len, MDR_IO_BUF_SIZE);
> +
> +	do {
> +		if (fread(buf, io_size, 1, md_fp) != 1)
> +			fatal("error reading from metadump file\n");
> +		if (pwrite(dev_fd, buf, io_size, offset) < 0)
> +			fatal("error writing to %s device at offset %llu: %s\n",
> +				device, offset, strerror(errno));
> +		len -= io_size;
> +		offset += io_size;
> +
> +		io_size = min(len, io_size);
> +	} while (len);
> +}
> +
> +static void
> +restore_v2(
> +	void			*header,
> +	FILE			*md_fp,
> +	int			ddev_fd,
> +	bool			is_data_target_file,
> +	int			logdev_fd,
> +	bool			is_log_target_file)
> +{
> +	struct xfs_sb		sb;
> +	struct xfs_meta_extent	xme;
> +	char			*block_buffer;
> +	int64_t			bytes_read;
> +	uint64_t		offset;
> +	int			len;
> +
> +	block_buffer = malloc(MDR_IO_BUF_SIZE);
> +	if (block_buffer == NULL)
> +		fatal("Unable to allocate input buffer memory\n");
> +
> +	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
> +		fatal("error reading from metadump file\n");
> +
> +	if (xme.xme_addr != 0 || xme.xme_len == 1)
> +		fatal("Invalid superblock disk address/length\n");

Shouldn't we check that xme_addr points to XME_ADDR_DATA_DEVICE?

> +	len = BBTOB(be32_to_cpu(xme.xme_len));
> +
> +	if (fread(block_buffer, len, 1, md_fp) != 1)
> +		fatal("error reading from metadump file\n");
> +
> +	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> +
> +	if (sb.sb_magicnum != XFS_SB_MAGIC)
> +		fatal("bad magic number for primary superblock\n");
> +
> +	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
> +
> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
> +			sb.sb_blocksize);
> +
> +	if (sb.sb_logstart == 0) {
> +		ASSERT(mdrestore.external_log == true);

This should be more graceful to users:

		if (!mdrestore.external_log)
			fatal("Filesystem has external log but -l not specified.\n");

The rest looks ok to me.

--D

> +		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
> +				sb.sb_blocksize);
> +	}
> +
> +	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
> +		fatal("error writing primary superblock: %s\n",
> +			strerror(errno));
> +
> +	bytes_read = len;
> +
> +	do {
> +		char *device;
> +		int fd;
> +
> +		if (fread(&xme, sizeof(xme), 1, md_fp) != 1) {
> +			if (feof(md_fp))
> +				break;
> +			fatal("error reading from metadump file\n");
> +		}
> +
> +		offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);
> +		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
> +		case XME_ADDR_DATA_DEVICE:
> +			device = "data";
> +			fd = ddev_fd;
> +			break;
> +		case XME_ADDR_LOG_DEVICE:
> +			device = "log";
> +			fd = logdev_fd;
> +			break;
> +		default:
> +			fatal("Invalid device found in metadump\n");
> +			break;
> +		}
> +
> +		len = BBTOB(be32_to_cpu(xme.xme_len));
> +
> +		dump_meta_extent(md_fp, fd, device, block_buffer, offset, len);
> +
> +		bytes_read += len;
> +
> +		if (mdrestore.show_progress) {
> +			static int64_t mb_read;
> +			int64_t mb_now = bytes_read >> 20;
> +
> +			if (mb_now != mb_read) {
> +				print_progress("%lld MB read", mb_now);
> +				mb_read = mb_now;
> +			}
> +		}
> +	} while (1);
> +
> +	if (mdrestore.progress_since_warning)
> +		putchar('\n');
> +
> +	memset(block_buffer, 0, sb.sb_sectsize);
> +	sb.sb_inprogress = 0;
> +	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
> +	if (xfs_sb_version_hascrc(&sb)) {
> +		xfs_update_cksum(block_buffer, sb.sb_sectsize,
> +				offsetof(struct xfs_sb, sb_crc));
> +	}
> +
> +	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
> +		fatal("error writing primary superblock: %s\n",
> +			strerror(errno));
> +
> +	free(block_buffer);
> +
> +	return;
> +}
> +
> +static struct mdrestore_ops mdrestore_ops_v2 = {
> +	.read_header	= read_header_v2,
> +	.show_info	= show_info_v2,
> +	.restore	= restore_v2,
> +};
> +
>  static void
>  usage(void)
>  {
> @@ -276,17 +469,24 @@ main(
>  	int 		argc,
>  	char 		**argv)
>  {
> -	FILE		*src_f;
> -	int		dst_fd;
> -	int		c;
> -	bool		is_target_file;
> -	uint32_t	magic;
> -	void		*header;
> -	struct xfs_metablock	mb;
> +	union {
> +		struct xfs_metadump_header	xmh;
> +		struct xfs_metablock		mb;
> +	} md;
> +	FILE				*src_f;
> +	char				*logdev = NULL;
> +	void				*header;
> +	uint32_t			magic;
> +	int				data_dev_fd;
> +	int				log_dev_fd;
> +	int				c;
> +	bool				is_data_dev_file;
> +	bool				is_log_dev_file;
>  
>  	mdrestore.show_progress = false;
>  	mdrestore.show_info = false;
>  	mdrestore.progress_since_warning = false;
> +	mdrestore.external_log = false;
>  
>  	progname = basename(argv[0]);
>  
> @@ -332,11 +532,17 @@ main(
>  	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
>  		fatal("Unable to read metadump magic from metadump file\n");
>  
> +	header = &md;
> +
>  	switch (be32_to_cpu(magic)) {
>  	case XFS_MD_MAGIC_V1:
> -		header = &mb;
>  		mdrestore.mdrops = &mdrestore_ops_v1;
>  		break;
> +
> +	case XFS_MD_MAGIC_V2:
> +		mdrestore.mdrops = &mdrestore_ops_v2;
> +		break;
> +
>  	default:
>  		fatal("specified file is not a metadata dump\n");
>  		break;
> @@ -353,12 +559,21 @@ main(
>  
>  	optind++;
>  
> -	/* check and open target */
> -	dst_fd = open_device(argv[optind], &is_target_file);
> +	/* check and open data device */
> +	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
> +
> +	log_dev_fd = -1;
> +	if (mdrestore.external_log)
> +		/* check and open log device */
> +		log_dev_fd = open_device(logdev, &is_log_dev_file);
> +
> +	mdrestore.mdrops->restore(header, src_f, data_dev_fd, is_data_dev_file,
> +				log_dev_fd, is_log_dev_file);
>  
> -	mdrestore.mdrops->restore(header, src_f, dst_fd, is_target_file);
> +	close(data_dev_fd);
> +	if (mdrestore.external_log)
> +		close(log_dev_fd);
>  
> -	close(dst_fd);
>  	if (src_f != stdin)
>  		fclose(src_f);
>  
> -- 
> 2.39.1
> 
