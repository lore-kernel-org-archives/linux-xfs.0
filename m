Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4F3C001DF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 17:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjHBRQr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHBRQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 13:16:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AEFE0
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 10:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FAF61A4D
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 17:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B405C433C8;
        Wed,  2 Aug 2023 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690996603;
        bh=XzpRfHVTka5UnzrT/E5eDjvfmbuK4S2UDSyldiMTyPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FhQOAade55f9sR3V6kYgzX1dJ7UAyYBHBSjG1mMjlnbjnXcs6TLw0MpCdqTapVLxQ
         PgalrtVbINrDxvvrCFTZ3GZ6j6kUSaXktNPaC4mICg7nePo4Ba7vFl9oYBrw8eFEDQ
         L9YaRRvBShetCDYaTJv1iD3qpNaQBdYi4WMVy2oWmHCltBw2xtxncwUnzn8jnOLWq5
         hU5KcbCI75wM8xlqLxc2WVeAyiFNS0te/7OwHz+yGR+ujGpcCff/UfOU9+l39NoB9S
         cS9MnSO7ZoJEE24OYZ4YEt7+b0ALH9P6BaySxgC4Hc3cppr5j3sJEAD0R/5nVYkvY/
         oZz/QYIfzb3Tg==
Date:   Wed, 2 Aug 2023 10:16:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 22/23] mdrestore: Define mdrestore ops for v2 format
Message-ID: <20230802171642.GB11352@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-23-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-23-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:26AM +0530, Chandan Babu R wrote:
> This commit adds functionality to restore metadump stored in v2 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good now, thanks for taking care of this!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 234 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 222 insertions(+), 12 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 0fdbfce7..85a61c8b 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -9,15 +9,17 @@
>  #include <libfrog/platform.h>
>  
>  union mdrestore_headers {
> -	__be32			magic;
> -	struct xfs_metablock	v1;
> +	__be32				magic;
> +	struct xfs_metablock		v1;
> +	struct xfs_metadump_header	v2;
>  };
>  
>  struct mdrestore_ops {
>  	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
>  	void (*show_info)(union mdrestore_headers *header, const char *md_file);
>  	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
> -			int ddev_fd, bool is_target_file);
> +			int ddev_fd, bool is_data_target_file, int logdev_fd,
> +			bool is_log_target_file);
>  };
>  
>  static struct mdrestore {
> @@ -25,6 +27,7 @@ static struct mdrestore {
>  	bool			show_progress;
>  	bool			show_info;
>  	bool			progress_since_warning;
> +	bool			external_log;
>  } mdrestore;
>  
>  static void
> @@ -144,7 +147,9 @@ restore_v1(
>  	union mdrestore_headers *h,
>  	FILE			*md_fp,
>  	int			ddev_fd,
> -	bool			is_target_file)
> +	bool			is_data_target_file,
> +	int			logdev_fd,
> +	bool			is_log_target_file)
>  {
>  	struct xfs_metablock	*metablock;	/* header + index + blocks */
>  	__be64			*block_index;
> @@ -197,7 +202,7 @@ restore_v1(
>  
>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
>  			sb.sb_blocksize);
>  
>  	bytes_read = 0;
> @@ -258,6 +263,193 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
>  	.restore	= restore_v1,
>  };
>  
> +static void
> +read_header_v2(
> +	union mdrestore_headers		*h,
> +	FILE				*md_fp)
> +{
> +	bool				want_external_log;
> +
> +	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
> +			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
> +		fatal("error reading from metadump file\n");
> +
> +	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
> +			XFS_MD2_INCOMPAT_EXTERNALLOG);
> +
> +	if (want_external_log && !mdrestore.external_log)
> +		fatal("External Log device is required\n");
> +}
> +
> +static void
> +show_info_v2(
> +	union mdrestore_headers		*h,
> +	const char			*md_file)
> +{
> +	uint32_t			incompat_flags;
> +
> +	incompat_flags = be32_to_cpu(h->v2.xmh_incompat_flags);
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
> +restore_meta_extent(
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
> +	union mdrestore_headers	*h,
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
> +	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> +	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
> +			XME_ADDR_DATA_DEVICE)
> +		fatal("Invalid superblock disk address/length\n");
> +
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
> +		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
> +				len);
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
> @@ -270,15 +462,19 @@ main(
>  	int			argc,
>  	char			**argv)
>  {
> -	union mdrestore_headers headers;
> +	union mdrestore_headers	headers;
>  	FILE			*src_f;
> -	int			dst_fd;
> +	char			*logdev = NULL;
> +	int			data_dev_fd;
> +	int			log_dev_fd;
>  	int			c;
> -	bool			is_target_file;
> +	bool			is_data_dev_file;
> +	bool			is_log_dev_file;
>  
>  	mdrestore.show_progress = false;
>  	mdrestore.show_info = false;
>  	mdrestore.progress_since_warning = false;
> +	mdrestore.external_log = false;
>  
>  	progname = basename(argv[0]);
>  
> @@ -328,6 +524,11 @@ main(
>  	case XFS_MD_MAGIC_V1:
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
> @@ -344,12 +545,21 @@ main(
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
> +	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
> +			is_data_dev_file, log_dev_fd, is_log_dev_file);
>  
> -	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
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
