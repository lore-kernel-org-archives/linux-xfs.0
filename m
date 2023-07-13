Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0686C001DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 14:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjGMOXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 10:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjGMOWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 10:22:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC581268D
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 07:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A54B61539
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 14:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9816DC433C7;
        Thu, 13 Jul 2023 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689258173;
        bh=wAKOAKf7x3l6FFOcLvkWxfyp3tXn3TDg2jzBumHn3cQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+4fWlMr+sBfDIrb7bZ+Vq3bUuFH5QVdA0pdn7Mh/zjG1Q5G9CFyr1MdSKM3oFZpd
         x6xbgRm0unodqzAskxoeVO4k2yDMLRjs3VZjw/E1hRQT9gamJBFtV0eZEKyg9sNUzw
         NHQYSxGk3qu2ExJuahJph7O/7PbQrlvRTaK/xGfmH/EbJcFsxNhMwjyB1zfXNhCHBZ
         +WvOqQUduUeN6KtuzQ5NTnN0leaD/OJo2XbA7SRAvLjd8MDXdiE8ADXT8wHIgl7jQf
         V5N8IrGsoVC7X4wl+bodp8XRfE5L1kcEo37KW5IMrxDv9Cf4IuuYFt47j7fsEv5vBu
         Cf5KhqZ63HBjg==
Date:   Thu, 13 Jul 2023 07:22:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 22/23] mdrestore: Define mdrestore ops for v2 format
Message-ID: <20230713142252.GH11476@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-23-chandan.babu@oracle.com>
 <20230712181003.GQ108251@frogsfrogsfrogs>
 <87wmz4i9y5.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmz4i9y5.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2023 at 11:57:27AM +0530, Chandan Babu R wrote:
> On Wed, Jul 12, 2023 at 11:10:03 AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 06, 2023 at 02:58:05PM +0530, Chandan Babu R wrote:
> >> This commit adds functionality to restore metadump stored in v2 format.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  mdrestore/xfs_mdrestore.c | 251 +++++++++++++++++++++++++++++++++++---
> >>  1 file changed, 233 insertions(+), 18 deletions(-)
> >> 
> >> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> >> index c395ae90..7b484071 100644
> >> --- a/mdrestore/xfs_mdrestore.c
> >> +++ b/mdrestore/xfs_mdrestore.c
> >> @@ -12,7 +12,8 @@ struct mdrestore_ops {
> >>  	void (*read_header)(void *header, FILE *md_fp);
> >>  	void (*show_info)(void *header, const char *md_file);
> >>  	void (*restore)(void *header, FILE *md_fp, int ddev_fd,
> >> -			bool is_target_file);
> >> +			bool is_data_target_file, int logdev_fd,
> >> +			bool is_log_target_file);
> >>  };
> >>  
> >>  static struct mdrestore {
> >> @@ -20,6 +21,7 @@ static struct mdrestore {
> >>  	bool			show_progress;
> >>  	bool			show_info;
> >>  	bool			progress_since_warning;
> >> +	bool			external_log;
> >>  } mdrestore;
> >>  
> >>  static void
> >> @@ -143,10 +145,12 @@ show_info_v1(
> >>  
> >>  static void
> >>  restore_v1(
> >> -	void			*header,
> >> -	FILE			*md_fp,
> >> -	int			ddev_fd,
> >> -	bool			is_target_file)
> >> +	void		*header,
> >> +	FILE		*md_fp,
> >> +	int		ddev_fd,
> >> +	bool		is_data_target_file,
> >
> > Why does the indent level change here...
> >
> >> +	int		logdev_fd,
> >> +	bool		is_log_target_file)
> >>  {
> >>  	struct xfs_metablock	*metablock;
> >>  	struct xfs_metablock	*mbp;
> >
> > ...but not here?
> >
> 
> Sorry, I will fix this.
> 
> >> @@ -203,7 +207,7 @@ restore_v1(
> >>  
> >>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
> >>  
> >> -	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
> >> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
> >>  			sb.sb_blocksize);
> >>  
> >>  	bytes_read = 0;
> >> @@ -264,6 +268,195 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
> >>  	.restore	= restore_v1,
> >>  };
> >>  
> >> +static void
> >> +read_header_v2(
> >> +	void				*header,
> >> +	FILE				*md_fp)
> >> +{
> >> +	struct xfs_metadump_header	*xmh = header;
> >> +	bool				want_external_log;
> >> +
> >> +	xmh->xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
> >> +
> >> +	if (fread((uint8_t *)xmh + sizeof(xmh->xmh_magic),
> >> +			sizeof(*xmh) - sizeof(xmh->xmh_magic), 1, md_fp) != 1)
> >> +		fatal("error reading from metadump file\n");
> >> +
> >> +	want_external_log = !!(be32_to_cpu(xmh->xmh_incompat_flags) &
> >> +			XFS_MD2_INCOMPAT_EXTERNALLOG);
> >> +
> >> +	if (want_external_log && !mdrestore.external_log)
> >> +		fatal("External Log device is required\n");
> >> +}
> >> +
> >> +static void
> >> +show_info_v2(
> >> +	void				*header,
> >> +	const char			*md_file)
> >> +{
> >> +	struct xfs_metadump_header	*xmh;
> >> +	uint32_t			incompat_flags;
> >> +
> >> +	xmh = header;
> >> +	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
> >> +
> >> +	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
> >> +		md_file,
> >> +		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
> >> +		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
> >> +		incompat_flags & XFS_MD2_INCOMPAT_EXTERNALLOG ? "":"not ",
> >> +		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
> >> +}
> >> +
> >> +#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
> >> +
> >> +static void
> >> +dump_meta_extent(
> >
> > Aren't we restoring here?  And not dumping?
> >
> 
> You are right. I will rename the function to restore_meta_extent().
> 
> >> +	FILE		*md_fp,
> >> +	int		dev_fd,
> >> +	char		*device,
> >> +	void		*buf,
> >> +	uint64_t	offset,
> >> +	int		len)
> >> +{
> >> +	int		io_size;
> >> +
> >> +	io_size = min(len, MDR_IO_BUF_SIZE);
> >> +
> >> +	do {
> >> +		if (fread(buf, io_size, 1, md_fp) != 1)
> >> +			fatal("error reading from metadump file\n");
> >> +		if (pwrite(dev_fd, buf, io_size, offset) < 0)
> >> +			fatal("error writing to %s device at offset %llu: %s\n",
> >> +				device, offset, strerror(errno));
> >> +		len -= io_size;
> >> +		offset += io_size;
> >> +
> >> +		io_size = min(len, io_size);
> >> +	} while (len);
> >> +}
> >> +
> >> +static void
> >> +restore_v2(
> >> +	void			*header,
> >> +	FILE			*md_fp,
> >> +	int			ddev_fd,
> >> +	bool			is_data_target_file,
> >> +	int			logdev_fd,
> >> +	bool			is_log_target_file)
> >> +{
> >> +	struct xfs_sb		sb;
> >> +	struct xfs_meta_extent	xme;
> >> +	char			*block_buffer;
> >> +	int64_t			bytes_read;
> >> +	uint64_t		offset;
> >> +	int			len;
> >> +
> >> +	block_buffer = malloc(MDR_IO_BUF_SIZE);
> >> +	if (block_buffer == NULL)
> >> +		fatal("Unable to allocate input buffer memory\n");
> >> +
> >> +	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
> >> +		fatal("error reading from metadump file\n");
> >> +
> >> +	if (xme.xme_addr != 0 || xme.xme_len == 1)
> >> +		fatal("Invalid superblock disk address/length\n");
> >
> > Shouldn't we check that xme_addr points to XME_ADDR_DATA_DEVICE?
> >
> 
> Yes, you are right. I will add the check.
> 
> >> +	len = BBTOB(be32_to_cpu(xme.xme_len));
> >> +
> >> +	if (fread(block_buffer, len, 1, md_fp) != 1)
> >> +		fatal("error reading from metadump file\n");
> >> +
> >> +	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> >> +
> >> +	if (sb.sb_magicnum != XFS_SB_MAGIC)
> >> +		fatal("bad magic number for primary superblock\n");
> >> +
> >> +	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
> >> +
> >> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
> >> +			sb.sb_blocksize);
> >> +
> >> +	if (sb.sb_logstart == 0) {
> >> +		ASSERT(mdrestore.external_log == true);
> >
> > This should be more graceful to users:
> >
> > 		if (!mdrestore.external_log)
> > 			fatal("Filesystem has external log but -l not specified.\n");
> 
> mdrestore.external_log is set to true only when the user passes the -l
> option. Also, read_header_v2() would have already verified if the metadump
> file contains data captured from an external log device and that an external
> log device was indeed passed to the restore program. It should be impossible
> to have mdrestore.external_log set to false at this point in
> restore_v2(). Hence, I think a call to ASSERT() is more appropriate.

Ah, ok.  I would've expected ASSERT(logstart != 0 || external_log); but
it's true that Dave more recently has been asking for conditional
assertions to be structured the way you originally wrote it.  Withdrawn.
:)

--D

> -- 
> chandan
