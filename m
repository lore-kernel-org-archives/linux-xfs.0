Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FCCC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 679F36134F
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbhDLQEQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:04:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239928AbhDLQEQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 12:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618243438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=10EvwXIuYG+ZGLsZXAXtGXeor73//akiMbfsEUU2P/g=;
        b=PbYkcncS/X8geYQi7uhRVMVNDbKAgIA40kAx2wUKdtEXXpStVWr38x1JKq7z1UEMp48D91
        wfftlX/OEPeCNxGdJzAq55c30qvCvMLucmdn4daKEoBULTFMf1LPRkS642/9jXjLskz/bB
        iOVxJet65377bbL8x6dHD2buO9GAQhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-9Ydp4tp5ON6MkWmBA9Ar7w-1; Mon, 12 Apr 2021 12:03:53 -0400
X-MC-Unique: 9Ydp4tp5ON6MkWmBA9Ar7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFB0487A842;
        Mon, 12 Apr 2021 16:03:52 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D4325D6D1;
        Mon, 12 Apr 2021 16:03:52 +0000 (UTC)
Date:   Mon, 12 Apr 2021 12:03:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: remove XFS_IFINLINE
Message-ID: <YHRvZonQmHby7WY3@bfoster>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133819.2618857-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 03:38:18PM +0200, Christoph Hellwig wrote:
> Just check for an inline format fork instead of the using the equivalent
> in-memory XFS_IFINLINE flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c       |  8 ++------
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  9 +++------
>  fs/xfs/libxfs/xfs_bmap.c       |  3 +--
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 11 +++++------
>  fs/xfs/libxfs/xfs_inode_fork.c |  1 -
>  fs/xfs/libxfs/xfs_inode_fork.h |  1 -
>  fs/xfs/scrub/symlink.c         |  2 +-
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  fs/xfs/xfs_iops.c              |  4 ++--
>  fs/xfs/xfs_symlink.c           |  4 ++--
>  11 files changed, 18 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 43ef85678cba6b..96146f425e503d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -362,10 +362,8 @@ xfs_has_attr(
>  	if (!xfs_inode_hasattr(dp))
>  		return -ENOATTR;
>  
> -	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> -		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
>  		return xfs_attr_sf_findname(args, NULL, NULL);
> -	}
>  
>  	if (xfs_attr_is_leaf(dp)) {
>  		error = xfs_attr_leaf_hasname(args, &bp);
> @@ -389,10 +387,8 @@ xfs_attr_remove_args(
>  	if (!xfs_inode_hasattr(args->dp))
>  		return -ENOATTR;
>  
> -	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> -		ASSERT(args->dp->i_afp->if_flags & XFS_IFINLINE);
> +	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
>  		return xfs_attr_shortform_remove(args);
> -	}
>  	if (xfs_attr_is_leaf(args->dp))
>  		return xfs_attr_leaf_removename(args);
>  	return xfs_attr_node_removename(args);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 23e2bf3341a015..1ab7a73b5a9a46 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -654,9 +654,6 @@ xfs_attr_shortform_create(
>  	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS) {
>  		ifp->if_flags &= ~XFS_IFEXTENTS;	/* just in case */
>  		ifp->if_format = XFS_DINODE_FMT_LOCAL;
> -		ifp->if_flags |= XFS_IFINLINE;
> -	} else {
> -		ASSERT(ifp->if_flags & XFS_IFINLINE);
>  	}
>  	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
>  	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
> @@ -733,7 +730,7 @@ xfs_attr_shortform_add(
>  	dp->i_forkoff = forkoff;
>  
>  	ifp = dp->i_afp;
> -	ASSERT(ifp->if_flags & XFS_IFINLINE);
> +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
>  	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
>  		ASSERT(0);
> @@ -851,7 +848,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  	trace_xfs_attr_sf_lookup(args);
>  
>  	ifp = args->dp->i_afp;
> -	ASSERT(ifp->if_flags & XFS_IFINLINE);
> +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
>  	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
> @@ -878,7 +875,7 @@ xfs_attr_shortform_getvalue(
>  	struct xfs_attr_sf_entry *sfe;
>  	int			i;
>  
> -	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
> +	ASSERT(args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
>  	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 580b36f19a26f7..0af3edf8443c73 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -805,7 +805,6 @@ xfs_bmap_local_to_extents_empty(
>  	ASSERT(ifp->if_nextents == 0);
>  
>  	xfs_bmap_forkoff_reset(ip, whichfork);
> -	ifp->if_flags &= ~XFS_IFINLINE;
>  	ifp->if_flags |= XFS_IFEXTENTS;
>  	ifp->if_u1.if_root = NULL;
>  	ifp->if_height = 0;
> @@ -850,7 +849,7 @@ xfs_bmap_local_to_extents(
>  
>  	flags = 0;
>  	error = 0;
> -	ASSERT((ifp->if_flags & (XFS_IFINLINE|XFS_IFEXTENTS)) == XFS_IFINLINE);
> +	ASSERT(!(ifp->if_flags & XFS_IFEXTENTS));
>  	memset(&args, 0, sizeof(args));
>  	args.tp = tp;
>  	args.mp = ip->i_mount;
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 7824af54637513..75e1421f69c458 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1096,7 +1096,7 @@ xfs_dir2_sf_to_block(
>  
>  	trace_xfs_dir2_sf_to_block(args);
>  
> -	ASSERT(ifp->if_flags & XFS_IFINLINE);
> +	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  
>  	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index bd89de61301c85..b031be033838f6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -378,7 +378,7 @@ xfs_dir2_sf_addname(
>  
>  	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
>  	dp = args->dp;
> -	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> @@ -830,9 +830,8 @@ xfs_dir2_sf_create(
>  		dp->i_df.if_flags &= ~XFS_IFEXTENTS;	/* just in case */
>  		dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
>  		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
> -		dp->i_df.if_flags |= XFS_IFINLINE;
>  	}
> -	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(dp->i_df.if_bytes == 0);
>  	i8count = pino > XFS_DIR2_MAX_SHORT_INUM;
>  	size = xfs_dir2_sf_hdr_size(i8count);
> @@ -877,7 +876,7 @@ xfs_dir2_sf_lookup(
>  
>  	xfs_dir2_sf_check(args);
>  
> -	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> @@ -954,7 +953,7 @@ xfs_dir2_sf_removename(
>  
>  	trace_xfs_dir2_sf_removename(args);
>  
> -	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  	oldsize = (int)dp->i_disk_size;
>  	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == oldsize);
> @@ -1053,7 +1052,7 @@ xfs_dir2_sf_replace(
>  
>  	trace_xfs_dir2_sf_replace(args);
>  
> -	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 02ad722004d3f4..3f2c16bf82e8c6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -61,7 +61,6 @@ xfs_init_local_fork(
>  
>  	ifp->if_bytes = size;
>  	ifp->if_flags &= ~XFS_IFEXTENTS;
> -	ifp->if_flags |= XFS_IFINLINE;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 8ffaa7cc1f7c3f..ac8b2182ce8c57 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -30,7 +30,6 @@ struct xfs_ifork {
>  /*
>   * Per-fork incore inode flags.
>   */
> -#define	XFS_IFINLINE	0x01	/* Inline data is read in */
>  #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
>  
>  /*
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index ad7b85e248c78e..599ee277bba2f4 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -51,7 +51,7 @@ xchk_symlink(
>  	}
>  
>  	/* Inline symlink? */
> -	if (ifp->if_flags & XFS_IFINLINE) {
> +	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
>  		if (len > XFS_IFORK_DSIZE(ip) ||
>  		    len > strnlen(ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip)))
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 1d2fe48ad19fb7..da1cc683560c75 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -57,7 +57,7 @@ xfs_dir2_sf_getdents(
>  	xfs_ino_t		ino;
>  	struct xfs_da_geometry	*geo = args->geo;
>  
> -	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
>  	ASSERT(dp->i_df.if_u1.if_data != NULL);
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 607b3f263b0644..8f2f74a496bd24 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -519,7 +519,7 @@ xfs_vn_get_link_inline(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	char			*link;
>  
> -	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
> +	ASSERT(ip->i_df.if_format == XFS_DINODE_FMT_LOCAL);
>  
>  	/*
>  	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
> @@ -1401,7 +1401,7 @@ xfs_setup_iops(
>  		inode->i_fop = &xfs_dir_file_operations;
>  		break;
>  	case S_IFLNK:
> -		if (ip->i_df.if_flags & XFS_IFINLINE)
> +		if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
>  			inode->i_op = &xfs_inline_symlink_inode_operations;
>  		else
>  			inode->i_op = &xfs_symlink_inode_operations;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1a625920ddff94..d4b3567d87943f 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -104,7 +104,7 @@ xfs_readlink(
>  
>  	trace_xfs_readlink(ip);
>  
> -	ASSERT(!(ip->i_df.if_flags & XFS_IFINLINE));
> +	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> @@ -492,7 +492,7 @@ xfs_inactive_symlink(
>  	 * Inline fork state gets removed by xfs_difree() so we have nothing to
>  	 * do here in that case.
>  	 */
> -	if (ip->i_df.if_flags & XFS_IFINLINE) {
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		return 0;
>  	}
> -- 
> 2.30.1
> 

