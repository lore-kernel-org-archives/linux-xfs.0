Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D9CCA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DB2720736
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UN+sjzR8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgELQLB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:11:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgELQLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 12:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589299858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b4ib944r7vEokTnPDbrRFYpawVGzQ6iZMFZVPvdlERA=;
        b=UN+sjzR88isuz7yMIFU6ClPIShw1FL/CYxBwNs6Cursbvl4uJd2EACieyT8GCx9qXRXqRj
        zyH3g5emGiXMuIZLRUhhFvYm98KDhITYtwGcgOLgaOKomd+9ES9EacG+lrqzpNlIvaaBgn
        GtOHYphB/BbSabmEWqnuFH81kt5FJ2I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-HIU7rylXPRq62QSLQU3h5Q-1; Tue, 12 May 2020 12:10:56 -0400
X-MC-Unique: HIU7rylXPRq62QSLQU3h5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F00BB8005B7;
        Tue, 12 May 2020 16:10:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D3BA6E6EB;
        Tue, 12 May 2020 16:10:55 +0000 (UTC)
Date:   Tue, 12 May 2020 12:10:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: move the per-fork nextents fields into struct
 xfs_ifork
Message-ID: <20200512161053.GH37029@bfoster>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510072404.986627-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 10, 2020 at 09:24:02AM +0200, Christoph Hellwig wrote:
> There are thee number of extents counters, one for each of the forks,
> Two are in the legacy icdinode and one is directly in struct xfs_inode.
> Switch to a single counter in the xfs_ifork structure where it uses up
> padding at the end of the structure.  This simplifies various bits of
> code that just wants the number of extents counter and can now directly
> dereference it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |   4 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c  |   1 -
>  fs/xfs/libxfs/xfs_bmap.c       | 126 ++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_dir2_block.c |   2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  |   6 +-
>  fs/xfs/libxfs/xfs_inode_buf.h  |   2 -
>  fs/xfs/libxfs/xfs_inode_fork.c |  12 ++--
>  fs/xfs/libxfs/xfs_inode_fork.h |  20 +++---
>  fs/xfs/scrub/bmap.c            |   3 +-
>  fs/xfs/scrub/parent.c          |   2 +-
>  fs/xfs/xfs_bmap_util.c         |  28 ++++----
>  fs/xfs/xfs_file.c              |   2 +-
>  fs/xfs/xfs_icache.c            |   1 -
>  fs/xfs/xfs_inode.c             |  19 +++--
>  fs/xfs/xfs_inode.h             |   1 -
>  fs/xfs/xfs_inode_item.c        |  14 ++--
>  fs/xfs/xfs_ioctl.c             |  25 +++----
>  fs/xfs/xfs_iomap.c             |   2 +-
>  fs/xfs/xfs_iops.c              |   2 +-
>  fs/xfs/xfs_itable.c            |   4 +-
>  fs/xfs/xfs_qm_syscalls.c       |   2 +-
>  fs/xfs/xfs_quotaops.c          |   2 +-
>  fs/xfs/xfs_symlink.c           |   2 +-
>  fs/xfs/xfs_trace.h             |   2 +-
>  24 files changed, 122 insertions(+), 162 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 863444e2dda7e..64b172180c42c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -723,7 +723,6 @@ xfs_attr_fork_remove(
>  	ip->i_d.di_forkoff = 0;
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
>  
> -	ASSERT(ip->i_d.di_anextents == 0);

Perhaps we could create an analogous assert in xfs_idestroy_fork()?

>  	ASSERT(ip->i_afp == NULL);
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
...
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 2fe325e38fd88..195da3552c5b5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -188,12 +188,11 @@ xfs_iformat_btree(
>  	 * or the number of extents is greater than the number of
>  	 * blocks.
>  	 */
> -	if (unlikely(XFS_IFORK_NEXTENTS(ip, whichfork) <=
> -					XFS_IFORK_MAXEXT(ip, whichfork) ||
> +	if (unlikely(ifp->if_nextents <= XFS_IFORK_MAXEXT(ip, whichfork) ||
>  		     nrecs == 0 ||
>  		     XFS_BMDR_SPACE_CALC(nrecs) >
>  					XFS_DFORK_SIZE(dip, mp, whichfork) ||
> -		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks) ||
> +		     ifp->if_nextents > ip->i_d.di_nblocks) ||
>  		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
>  		xfs_warn(mp, "corrupt inode %Lu (btree).",
>  					(unsigned long long) ip->i_ino);
> @@ -229,6 +228,8 @@ xfs_iformat_data_fork(
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  
> +	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +

Could use a comment here that the format calls below might depend on
this being set (i.e. xfs_iformat_btree() just above).

>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
>  	case S_IFCHR:
> @@ -282,6 +283,8 @@ xfs_iformat_attr_fork(
>  	int			error = 0;
>  
>  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> +	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +

Same here. Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
> @@ -617,7 +620,7 @@ xfs_iflush_fork(
>  		       !(iip->ili_fields & extflag[whichfork]));
>  		if ((iip->ili_fields & extflag[whichfork]) &&
>  		    (ifp->if_bytes > 0)) {
> -			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
> +			ASSERT(ifp->if_nextents > 0);
>  			(void)xfs_iextents_copy(ip, (xfs_bmbt_rec_t *)cp,
>  				whichfork);
>  		}
> @@ -676,7 +679,6 @@ xfs_ifork_init_cow(
>  				       KM_NOFS);
>  	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
>  	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
> -	ip->i_cnextents = 0;
>  }
>  
>  /* Verify the inline contents of the data fork of an inode. */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index f46a8c1db5964..a69d425fe68df 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -23,6 +23,7 @@ struct xfs_ifork {
>  	} if_u1;
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	unsigned char		if_flags;	/* per-fork flags */
> +	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  };
>  
>  /*
> @@ -67,18 +68,6 @@ struct xfs_ifork {
>  		((w) == XFS_ATTR_FORK ? \
>  			((ip)->i_d.di_aformat = (n)) : \
>  			((ip)->i_cformat = (n))))
> -#define XFS_IFORK_NEXTENTS(ip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		(ip)->i_d.di_nextents : \
> -		((w) == XFS_ATTR_FORK ? \
> -			(ip)->i_d.di_anextents : \
> -			(ip)->i_cnextents))
> -#define XFS_IFORK_NEXT_SET(ip,w,n) \
> -	((w) == XFS_DATA_FORK ? \
> -		((ip)->i_d.di_nextents = (n)) : \
> -		((w) == XFS_ATTR_FORK ? \
> -			((ip)->i_d.di_anextents = (n)) : \
> -			((ip)->i_cnextents = (n))))
>  #define XFS_IFORK_MAXEXT(ip, w) \
>  	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
>  
> @@ -86,6 +75,13 @@ struct xfs_ifork {
>  	(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
>  	 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)
>  
> +static inline xfs_extnum_t xfs_ifork_nextents(struct xfs_ifork *ifp)
> +{
> +	if (!ifp)
> +		return 0;
> +	return ifp->if_nextents;
> +}
> +
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
>  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 283424d6d2bb6..157f72efec5e9 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -566,6 +566,7 @@ xchk_bmap_check_rmaps(
>  	struct xfs_scrub	*sc,
>  	int			whichfork)
>  {
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
>  	loff_t			size;
>  	xfs_agnumber_t		agno;
>  	int			error;
> @@ -598,7 +599,7 @@ xchk_bmap_check_rmaps(
>  		break;
>  	}
>  	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> -	    (size == 0 || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
> +	    (size == 0 || ifp->if_nextents > 0))
>  		return 0;
>  
>  	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 5705adc43a75f..855aa8bcab64b 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -90,7 +90,7 @@ xchk_parent_count_parent_dentries(
>  	 * if there is one.
>  	 */
>  	lock_mode = xfs_ilock_data_map_shared(parent);
> -	if (parent->i_d.di_nextents > 0)
> +	if (parent->i_df.if_nextents > 0)
>  		error = xfs_dir3_data_readahead(parent, 0, 0);
>  	xfs_iunlock(parent, lock_mode);
>  	if (error)
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index cc23a3e23e2d1..4f277a6253b8d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1220,7 +1220,7 @@ xfs_swap_extents_check_format(
>  	 * if the target inode has less extents that then temporary inode then
>  	 * why did userspace call us?
>  	 */
> -	if (ip->i_d.di_nextents < tip->i_d.di_nextents)
> +	if (ip->i_df.if_nextents < tip->i_df.if_nextents)
>  		return -EINVAL;
>  
>  	/*
> @@ -1241,14 +1241,12 @@ xfs_swap_extents_check_format(
>  
>  	/* Check temp in extent form to max in target */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) >
> -			XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
> +	    tip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
>  		return -EINVAL;
>  
>  	/* Check target in extent form to max in temp */
>  	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) >
> -			XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
> +	    ip->i_df.if_nextents > XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
>  		return -EINVAL;
>  
>  	/*
> @@ -1264,7 +1262,7 @@ xfs_swap_extents_check_format(
>  		if (XFS_IFORK_Q(ip) &&
>  		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
>  			return -EINVAL;
> -		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
> +		if (tip->i_df.if_nextents <=
>  		    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
>  			return -EINVAL;
>  	}
> @@ -1274,7 +1272,7 @@ xfs_swap_extents_check_format(
>  		if (XFS_IFORK_Q(tip) &&
>  		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
>  			return -EINVAL;
> -		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
> +		if (ip->i_df.if_nextents <=
>  		    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
>  			return -EINVAL;
>  	}
> @@ -1427,15 +1425,15 @@ xfs_swap_extent_forks(
>  	/*
>  	 * Count the number of extended attribute blocks
>  	 */
> -	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
> -	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
> +	if (XFS_IFORK_Q(ip) && ip->i_afp->if_nextents > 0 &&
> +	    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
>  		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
>  				&aforkblks);
>  		if (error)
>  			return error;
>  	}
> -	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
> -	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
> +	if (XFS_IFORK_Q(tip) && tip->i_afp->if_nextents > 0 &&
> +	    tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
>  		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
>  				&taforkblks);
>  		if (error)
> @@ -1468,7 +1466,6 @@ xfs_swap_extent_forks(
>  	ip->i_d.di_nblocks = tip->i_d.di_nblocks - taforkblks + aforkblks;
>  	tip->i_d.di_nblocks = tmp + taforkblks - aforkblks;
>  
> -	swap(ip->i_d.di_nextents, tip->i_d.di_nextents);
>  	swap(ip->i_d.di_format, tip->i_d.di_format);
>  
>  	/*
> @@ -1615,9 +1612,9 @@ xfs_swap_extents(
>  	 * performed with log redo items!
>  	 */
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> -		int		w	= XFS_DATA_FORK;
> -		uint32_t	ipnext	= XFS_IFORK_NEXTENTS(ip, w);
> -		uint32_t	tipnext	= XFS_IFORK_NEXTENTS(tip, w);
> +		int		w = XFS_DATA_FORK;
> +		uint32_t	ipnext = ip->i_df.if_nextents;
> +		uint32_t	tipnext	= tip->i_df.if_nextents;
>  
>  		/*
>  		 * Conceptually this shouldn't affect the shape of either bmbt,
> @@ -1720,7 +1717,6 @@ xfs_swap_extents(
>  		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
>  		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
>  
> -		swap(ip->i_cnextents, tip->i_cnextents);
>  		swap(ip->i_cowfp, tip->i_cowfp);
>  
>  		if (ip->i_cowfp && ip->i_cowfp->if_bytes)
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4b8bdecc38635..403c90309a8ff 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1102,7 +1102,7 @@ xfs_dir_open(
>  	 * certain to have the next operation be a read there.
>  	 */
>  	mode = xfs_ilock_data_map_shared(ip);
> -	if (ip->i_d.di_nextents > 0)
> +	if (ip->i_df.if_nextents > 0)
>  		error = xfs_dir3_data_readahead(ip, 0, 0);
>  	xfs_iunlock(ip, mode);
>  	return error;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 5a3a520b95288..791d5d5e318cf 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -63,7 +63,6 @@ xfs_inode_alloc(
>  	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
>  	ip->i_afp = NULL;
>  	ip->i_cowfp = NULL;
> -	ip->i_cnextents = 0;
>  	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
>  	ip->i_flags = 0;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7d3144dc99b72..1677c4e7207ed 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -825,7 +825,7 @@ xfs_ialloc(
>  		inode->i_mode &= ~S_ISGID;
>  
>  	ip->i_d.di_size = 0;
> -	ip->i_d.di_nextents = 0;
> +	ip->i_df.if_nextents = 0;
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	tv = current_time(inode);
> @@ -919,7 +919,6 @@ xfs_ialloc(
>  	 * Attribute fork settings for new inode.
>  	 */
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
> -	ip->i_d.di_anextents = 0;
>  
>  	/*
>  	 * Log the new values stuffed into the inode.
> @@ -1686,7 +1685,7 @@ xfs_inactive_truncate(
>  	if (error)
>  		goto error_trans_cancel;
>  
> -	ASSERT(ip->i_d.di_nextents == 0);
> +	ASSERT(ip->i_df.if_nextents == 0);
>  
>  	error = xfs_trans_commit(tp);
>  	if (error)
> @@ -1836,7 +1835,7 @@ xfs_inactive(
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) &&
>  	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
> -	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
> +	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
>  		truncate = 1;
>  
>  	error = xfs_qm_dqattach(ip);
> @@ -1862,7 +1861,6 @@ xfs_inactive(
>  	}
>  
>  	ASSERT(!ip->i_afp);
> -	ASSERT(ip->i_d.di_anextents == 0);
>  	ASSERT(ip->i_d.di_forkoff == 0);
>  
>  	/*
> @@ -2731,8 +2729,7 @@ xfs_ifree(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(ip->i_d.di_nextents == 0);
> -	ASSERT(ip->i_d.di_anextents == 0);
> +	ASSERT(ip->i_df.if_nextents == 0);
>  	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
> @@ -3628,7 +3625,7 @@ xfs_iflush(
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
>  	ASSERT(xfs_isiflocked(ip));
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
> -	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> +	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  
>  	*bpp = NULL;
>  
> @@ -3710,7 +3707,7 @@ xfs_iflush_int(
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
>  	ASSERT(xfs_isiflocked(ip));
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
> -	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> +	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  	ASSERT(iip != NULL && iip->ili_fields != 0);
>  
>  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
> @@ -3751,13 +3748,13 @@ xfs_iflush_int(
>  			goto flush_out;
>  		}
>  	}
> -	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
> +	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
>  				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %Lu, "
>  			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
>  			__func__, ip->i_ino,
> -			ip->i_d.di_nextents + ip->i_d.di_anextents,
> +			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
>  			ip->i_d.di_nblocks, ip);
>  		goto flush_out;
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index ff846197941e4..24dae63ba16c0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -57,7 +57,6 @@ typedef struct xfs_inode {
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> -	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
>  	unsigned int		i_cformat;	/* format of cow fork */
>  
>  	/* VFS inode */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index cefa2484f0dbf..401ba26aeed7b 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -39,7 +39,7 @@ xfs_inode_item_data_fork_size(
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
> -		    ip->i_d.di_nextents > 0 &&
> +		    ip->i_df.if_nextents > 0 &&
>  		    ip->i_df.if_bytes > 0) {
>  			/* worst case, doesn't subtract delalloc extents */
>  			*nbytes += XFS_IFORK_DSIZE(ip);
> @@ -80,7 +80,7 @@ xfs_inode_item_attr_fork_size(
>  	switch (ip->i_d.di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
> -		    ip->i_d.di_anextents > 0 &&
> +		    ip->i_afp->if_nextents > 0 &&
>  		    ip->i_afp->if_bytes > 0) {
>  			/* worst case, doesn't subtract unused space */
>  			*nbytes += XFS_IFORK_ASIZE(ip);
> @@ -148,7 +148,7 @@ xfs_inode_item_format_data_fork(
>  			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
>  
>  		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
> -		    ip->i_d.di_nextents > 0 &&
> +		    ip->i_df.if_nextents > 0 &&
>  		    ip->i_df.if_bytes > 0) {
>  			struct xfs_bmbt_rec *p;
>  
> @@ -233,12 +233,12 @@ xfs_inode_item_format_attr_fork(
>  			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
>  
>  		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
> -		    ip->i_d.di_anextents > 0 &&
> +		    ip->i_afp->if_nextents > 0 &&
>  		    ip->i_afp->if_bytes > 0) {
>  			struct xfs_bmbt_rec *p;
>  
>  			ASSERT(xfs_iext_count(ip->i_afp) ==
> -				ip->i_d.di_anextents);
> +				ip->i_afp->if_nextents);
>  
>  			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT);
>  			data_bytes = xfs_iextents_copy(ip, p, XFS_ATTR_FORK);
> @@ -326,8 +326,8 @@ xfs_inode_to_log_dinode(
>  	to->di_size = from->di_size;
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
> -	to->di_nextents = from->di_nextents;
> -	to->di_anextents = from->di_anextents;
> +	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> +	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = from->di_dmevmask;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 4ee0d13232f3f..7a71c03e9022b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1104,26 +1104,17 @@ xfs_fill_fsxattr(
>  	bool			attr,
>  	struct fsxattr		*fa)
>  {
> +	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
> +
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_projid = ip->i_d.di_projid;
> -
> -	if (attr) {
> -		if (ip->i_afp) {
> -			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
> -				fa->fsx_nextents = xfs_iext_count(ip->i_afp);
> -			else
> -				fa->fsx_nextents = ip->i_d.di_anextents;
> -		} else
> -			fa->fsx_nextents = 0;
> -	} else {
> -		if (ip->i_df.if_flags & XFS_IFEXTENTS)
> -			fa->fsx_nextents = xfs_iext_count(&ip->i_df);
> -		else
> -			fa->fsx_nextents = ip->i_d.di_nextents;
> -	}
> +	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
> +		fa->fsx_nextents = xfs_iext_count(ifp);
> +	else
> +		fa->fsx_nextents = xfs_ifork_nextents(ifp);
>  }
>  
>  STATIC int
> @@ -1211,7 +1202,7 @@ xfs_ioctl_setattr_xflags(
>  	uint64_t		di_flags2;
>  
>  	/* Can't change realtime flag if any extents are allocated. */
> -	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
> +	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
>  	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
>  		return -EINVAL;
>  
> @@ -1389,7 +1380,7 @@ xfs_ioctl_setattr_check_extsize(
>  	xfs_extlen_t		size;
>  	xfs_fsblock_t		extsize_fsb;
>  
> -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_d.di_nextents &&
> +	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
>  	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
>  		return -EINVAL;
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index bb590a267a7f9..b4fd918749e5f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1258,7 +1258,7 @@ xfs_xattr_iomap_begin(
>  	lockmode = xfs_ilock_attr_map_shared(ip);
>  
>  	/* if there are no attribute fork or extents, return ENOENT */
> -	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
> +	if (!XFS_IFORK_Q(ip) || !ip->i_afp->if_nextents) {
>  		error = -ENOENT;
>  		goto out_unlock;
>  	}
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 26a71237d70f6..d66528fa36570 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -872,7 +872,7 @@ xfs_setattr_size(
>  	/*
>  	 * Short circuit the truncate case for zero length files.
>  	 */
> -	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
> +	if (newsize == 0 && oldsize == 0 && ip->i_df.if_nextents == 0) {
>  		if (!(iattr->ia_valid & (ATTR_CTIME|ATTR_MTIME)))
>  			return 0;
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index ff2da28fed90e..80da86c5703fb 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -104,9 +104,9 @@ xfs_bulkstat_one_int(
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize_blks = dic->di_extsize;
> -	buf->bs_extents = dic->di_nextents;
> +	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>  	xfs_bulkstat_health(ip, buf);
> -	buf->bs_aextents = dic->di_anextents;
> +	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 944486f2b2874..9edf761eec739 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -302,7 +302,7 @@ xfs_qm_scall_trunc_qfile(
>  		goto out_unlock;
>  	}
>  
> -	ASSERT(ip->i_d.di_nextents == 0);
> +	ASSERT(ip->i_df.if_nextents == 0);
>  
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	error = xfs_trans_commit(tp);
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 38669e8272060..b5d10ecb54743 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -36,7 +36,7 @@ xfs_qm_fill_state(
>  	}
>  	tstate->flags |= QCI_SYSFILE;
>  	tstate->blocks = ip->i_d.di_nblocks;
> -	tstate->nextents = ip->i_d.di_nextents;
> +	tstate->nextents = ip->i_df.if_nextents;
>  	tstate->spc_timelimit = (u32)q->qi_btimelimit;
>  	tstate->ino_timelimit = (u32)q->qi_itimelimit;
>  	tstate->rt_spc_timelimit = (u32)q->qi_rtbtimelimit;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 973441992b084..8cf2fcb509c12 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -384,7 +384,7 @@ xfs_inactive_symlink_rmt(
>  	 * either 1 or 2 extents and that we can
>  	 * free them all in one bunmapi call.
>  	 */
> -	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
> +	ASSERT(ip->i_df.if_nextents > 0 && ip->i_df.if_nextents <= 2);
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
>  	if (error)
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a4323a63438d8..ba2ab69e1fc7d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1898,7 +1898,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  		__entry->which = which;
>  		__entry->ino = ip->i_ino;
>  		__entry->format = ip->i_d.di_format;
> -		__entry->nex = ip->i_d.di_nextents;
> +		__entry->nex = ip->i_df.if_nextents;
>  		__entry->broot_size = ip->i_df.if_broot_bytes;
>  		__entry->fork_off = XFS_IFORK_BOFF(ip);
>  	),
> -- 
> 2.26.2
> 

