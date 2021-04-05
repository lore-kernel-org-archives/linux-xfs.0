Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8529DC433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 16:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E54561398
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 16:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhDEQdy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:33:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238558AbhDEQdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 12:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lUGotOrLgQayPtrMXlqsQguUlfVoiGaQadopw4gfAis=;
        b=Ne9aq+dCPuH05Wb85Cp50iSaz5cguI4YwhSCw8Wob8X8w3JeETny2u/1Xxl9T9hyW51KqI
        B3E9nxuafm+swWPrp1u0dJ1D630w30ilOsGc1wiAsVQKtOvwu4x5rQfd8JqU+wXG2dfqOn
        AUlEyk+LxCl0WX7FuGzqKe33pp5k8vI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-2gBAlxOgMwalgRrLRUBbjA-1; Mon, 05 Apr 2021 12:33:40 -0400
X-MC-Unique: 2gBAlxOgMwalgRrLRUBbjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5D1A87A82A;
        Mon,  5 Apr 2021 16:33:39 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 727C319715;
        Mon,  5 Apr 2021 16:33:39 +0000 (UTC)
Date:   Mon, 5 Apr 2021 12:33:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: move the XFS_IFEXTENTS check into
 xfs_iread_extents
Message-ID: <YGs74VLTto/FyLbk@bfoster>
References: <20210402142409.372050-1-hch@lst.de>
 <20210402142409.372050-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402142409.372050-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 04:24:03PM +0200, Christoph Hellwig wrote:
> Move the XFS_IFEXTENTS check from the callers into xfs_iread_extents to
> simplify the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks reasonable enough on its own:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c  | 82 ++++++++++++++++-----------------------
>  fs/xfs/scrub/bmap.c       |  9 ++---
>  fs/xfs/xfs_bmap_util.c    | 16 +++-----
>  fs/xfs/xfs_dir2_readdir.c |  8 ++--
>  fs/xfs/xfs_dquot.c        |  8 ++--
>  fs/xfs/xfs_iomap.c        | 16 +++-----
>  fs/xfs/xfs_qm.c           |  8 ++--
>  fs/xfs/xfs_reflink.c      |  8 ++--
>  8 files changed, 62 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5574d345d066ed..b8cab14ca8ce8d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1223,6 +1223,9 @@ xfs_iread_extents(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
> +	if (ifp->if_flags & XFS_IFEXTENTS)
> +		return 0;
> +
>  	if (XFS_IS_CORRUPT(mp, ifp->if_format != XFS_DINODE_FMT_BTREE)) {
>  		error = -EFSCORRUPTED;
>  		goto out;
> @@ -1278,11 +1281,9 @@ xfs_bmap_first_unused(
>  
>  	ASSERT(xfs_ifork_has_extents(ifp));
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	lowest = max = *first_unused;
>  	for_each_xfs_iext(ifp, &icur, &got) {
> @@ -1330,11 +1331,9 @@ xfs_bmap_last_before(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	if (!xfs_iext_lookup_extent_before(ip, ifp, last_block, &icur, &got))
>  		*last_block = 0;
> @@ -1353,11 +1352,9 @@ xfs_bmap_last_extent(
>  	struct xfs_iext_cursor	icur;
>  	int			error;
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	xfs_iext_last(ifp, &icur);
>  	if (!xfs_iext_get_extent(ifp, &icur, rec))
> @@ -3984,11 +3981,9 @@ xfs_bmapi_read(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapr);
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(NULL, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
>  		eof = true;
> @@ -4468,11 +4463,9 @@ xfs_bmapi_write(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapw);
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			goto error0;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		goto error0;
>  
>  	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.icur, &bma.got))
>  		eof = true;
> @@ -4751,11 +4744,9 @@ xfs_bmapi_remap(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	if (xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got)) {
>  		/* make sure we only reflink into a hole. */
> @@ -5426,9 +5417,10 @@ __xfs_bunmapi(
>  	else
>  		max_len = len;
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> -	    (error = xfs_iread_extents(tp, ip, whichfork)))
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
>  		return error;
> +
>  	if (xfs_iext_count(ifp) == 0) {
>  		*rlen = 0;
>  		return 0;
> @@ -5914,11 +5906,9 @@ xfs_bmap_collapse_extents(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> @@ -6031,11 +6021,9 @@ xfs_bmap_insert_extents(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> @@ -6134,12 +6122,10 @@ xfs_bmap_split_extent(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		/* Read in all the extents */
> -		error = xfs_iread_extents(tp, ip, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	/* Read in all the extents */
> +	error = xfs_iread_extents(tp, ip, whichfork);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * If there are not extents, or split_fsb lies in a hole we are done.
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 33559c3a4bc3d4..fb50ec9a4303a1 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -449,11 +449,10 @@ xchk_bmap_btree(
>  
>  	/* Load the incore bmap cache if it's not loaded. */
>  	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
> -	if (!info->was_loaded) {
> -		error = xfs_iread_extents(sc->tp, ip, whichfork);
> -		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> -			goto out;
> -	}
> +
> +	error = xfs_iread_extents(sc->tp, ip, whichfork);
> +	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> +		goto out;
>  
>  	/* Check the btree structure. */
>  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e7d68318e6a55c..e7f9537634f3cf 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -225,11 +225,9 @@ xfs_bmap_count_blocks(
>  
>  	switch (ifp->if_format) {
>  	case XFS_DINODE_FMT_BTREE:
> -		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -			error = xfs_iread_extents(tp, ip, whichfork);
> -			if (error)
> -				return error;
> -		}
> +		error = xfs_iread_extents(tp, ip, whichfork);
> +		if (error)
> +			return error;
>  
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		error = xfs_btree_count_blocks(cur, &btblocks);
> @@ -471,11 +469,9 @@ xfs_getbmap(
>  	first_bno = bno = XFS_BB_TO_FSBT(mp, bmv->bmv_offset);
>  	len = XFS_BB_TO_FSB(mp, bmv->bmv_length);
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, whichfork);
> -		if (error)
> -			goto out_unlock_ilock;
> -	}
> +	error = xfs_iread_extents(NULL, ip, whichfork);
> +	if (error)
> +		goto out_unlock_ilock;
>  
>  	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got)) {
>  		/*
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 66deddd5e29698..477df4869d19bd 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -258,11 +258,9 @@ xfs_dir2_leaf_readbuf(
>  	int			ra_want;
>  	int			error = 0;
>  
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
> -		if (error)
> -			goto out;
> -	}
> +	error = xfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
> +	if (error)
> +		goto out;
>  
>  	/*
>  	 * Look for mapped directory blocks at or above the current offset.
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bd8379b98374f8..83c5334fe978f2 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -748,11 +748,9 @@ xfs_dq_get_next_id(
>  	start = (xfs_fsblock_t)next_id / mp->m_quotainfo->qi_dqperchunk;
>  
>  	lock_flags = xfs_ilock_data_map_shared(quotip);
> -	if (!(quotip->i_df.if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
> +	if (error)
> +		return error;
>  
>  	if (xfs_iext_lookup_extent(quotip, &quotip->i_df, start, &cur, &got)) {
>  		/* contiguous chunk, bump startoff for the id calculation */
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e17ab7f42928a5..129a0bafb46c0d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -893,11 +893,9 @@ xfs_buffered_write_iomap_begin(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapw);
>  
> -	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> -		if (error)
> -			goto out_unlock;
> -	}
> +	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +	if (error)
> +		goto out_unlock;
>  
>  	/*
>  	 * Search the data fork first to look up our source mapping.  We
> @@ -1208,11 +1206,9 @@ xfs_seek_iomap_begin(
>  		return -EIO;
>  
>  	lockmode = xfs_ilock_data_map_shared(ip);
> -	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> -		if (error)
> -			goto out_unlock;
> -	}
> +	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +	if (error)
> +		goto out_unlock;
>  
>  	if (xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap)) {
>  		/*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6fde318b9fed27..fd835a202c51eb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1165,11 +1165,9 @@ xfs_qm_dqusage_adjust(
>  	if (XFS_IS_REALTIME_INODE(ip)) {
>  		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  
> -		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> -			if (error)
> -				goto error0;
> -		}
> +		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> +		if (error)
> +			goto error0;
>  
>  		xfs_bmap_count_leaves(ifp, &rtblks);
>  	}
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 725c7d8e44381b..13cd62b89c4e30 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1392,11 +1392,9 @@ xfs_reflink_inode_has_shared_extents(
>  	int				error;
>  
>  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> -		if (error)
> -			return error;
> -	}
> +	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> +	if (error)
> +		return error;
>  
>  	*has_shared = false;
>  	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
> -- 
> 2.30.1
> 

