Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92801C54E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 05:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9AB20736
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 05:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoU4v2YB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgELF0j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 01:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgELF0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 01:26:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A8DC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 22:26:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k7so3934916pjs.5
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 22:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kj3Q1GywfyD9Jw06PGHy31zVtzGycwUjCWVauECL1qU=;
        b=NoU4v2YBE8/ujQRazQRxMUPuv7XWfRmoUo+bLwYYfa3sFuOLqEM36hkvGJqpfX+eS+
         Nw1tdmHBxDYCsUrPpFPiJm8syitHcL8p2hl5eRg/hlW7DlMd7PeLPlfcCWisgdW7TXsI
         yTIt+aSEiKIWfk/blDUwTXrxHsLEhGseiOnV36mAyNYZ1EUDjFzJY3nXQKaSd3ZZcxjp
         PQWanUg0RjIgUgTWl+y4jFjlHYqmWeJip/BLgm87uHjr7nGGwMyTsvwZIZv/OeS6fEtR
         BPOEaxFJFLYhnYKzpGntwsnWwj4+cMPpFB7FQIp0QYGF8anc1t8FrbJRzojayXtZKUCV
         rz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kj3Q1GywfyD9Jw06PGHy31zVtzGycwUjCWVauECL1qU=;
        b=j8fEIeY6qfOEN9L2ZdRNqsKC9U412FCtml58Aa7OymSAi8cBfAVwoYscpj45JEbGHX
         SChh+EEJlS6a3r46eCAVMBAmfNHi7Dg0nqTmWyDHEFiFzMqrXloPh+Mpy22CjWZdlTJv
         r2Ye4P2GcAu3glYSVaGXk6OIZUFptWXnK1tdVsejC63EfhItEjSJ5sgxgj/gFM2BO+rq
         qBLa2hp1BPaVZOvNz82oQvk1F8hELZTnc55JYQPhK2IH97ql2xhiIj9XKAQtBu7eO4u8
         7iAhHhM5UC+7as6v/TvC9A7VFQNtwUkmAT4VFiXIU3letfs+EAe4uw0Cfu2IxbzkDzVb
         55cQ==
X-Gm-Message-State: AGi0Pub9zfMR3poFw+gonbZB3sFdoWxbQkMt/+Ty5jqrLnDRllqAcZHz
        5fAhlbvTaKindg/++GiWCA9gxL4h+N0=
X-Google-Smtp-Source: APiQypKCuxBlQgO1jgWO6ETMSjTJ7x4kXUBOy5ovjld3z3FuZJ9La9SYmJuZx+iDz496yh5ZCujWxQ==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr19489713pjb.150.1589261198359;
        Mon, 11 May 2020 22:26:38 -0700 (PDT)
Received: from garuda.localnet ([122.172.252.201])
        by smtp.gmail.com with ESMTPSA id t206sm10798170pfc.212.2020.05.11.22.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 22:26:37 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: move the per-fork nextents fields into struct xfs_ifork
Date:   Tue, 12 May 2020 10:56:34 +0530
Message-ID: <6941980.UF1O58JnQj@garuda>
In-Reply-To: <20200510072404.986627-5-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-5-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 10 May 2020 12:54:02 PM IST Christoph Hellwig wrote:
> There are thee number of extents counters, one for each of the forks,

... three number of ....

The patch itself looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

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
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e4fe3dca9883b..1b01675e9c80b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -62,7 +62,7 @@ xfs_inode_hasattr(
>  {
>  	if (!XFS_IFORK_Q(ip) ||
>  	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     ip->i_d.di_anextents == 0))
> +	     ip->i_afp->if_nextents == 0))
>  		return 0;
>  	return 1;
>  }
> @@ -214,7 +214,7 @@ xfs_attr_set_args(
>  	 */
>  	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>  	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	     dp->i_afp->if_nextents == 0)) {
>  
>  		/*
>  		 * Build initial attribute list (if required).
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 863444e2dda7e..64b172180c42c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -723,7 +723,6 @@ xfs_attr_fork_remove(
>  	ip->i_d.di_forkoff = 0;
>  	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
>  
> -	ASSERT(ip->i_d.di_anextents == 0);
>  	ASSERT(ip->i_afp == NULL);
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 34518a6dc7376..c1136be49abeb 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -61,10 +61,10 @@ xfs_bmap_compute_maxlevels(
>  	int		sz;		/* root block size */
>  
>  	/*
> -	 * The maximum number of extents in a file, hence the maximum
> -	 * number of leaf entries, is controlled by the type of di_nextents
> -	 * (a signed 32-bit number, xfs_extnum_t), or by di_anextents
> -	 * (a signed 16-bit number, xfs_aextnum_t).
> +	 * The maximum number of extents in a file, hence the maximum number of
> +	 * leaf entries, is controlled by the size of the on-disk extent count,
> +	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> +	 * number for the attr fork.
>  	 *
>  	 * Note that we can no longer assume that if we are in ATTR1 that
>  	 * the fork offset of all the inodes will be
> @@ -120,10 +120,11 @@ xfs_bmbt_lookup_first(
>   */
>  static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
>  {
> +	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
> +
>  	return whichfork != XFS_COW_FORK &&
>  		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
> -		XFS_IFORK_NEXTENTS(ip, whichfork) >
> -			XFS_IFORK_MAXEXT(ip, whichfork);
> +		ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork);
>  }
>  
>  /*
> @@ -131,10 +132,11 @@ static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
>   */
>  static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  {
> +	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
> +
>  	return whichfork != XFS_COW_FORK &&
>  		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
> -		XFS_IFORK_NEXTENTS(ip, whichfork) <=
> -			XFS_IFORK_MAXEXT(ip, whichfork);
> +		ifp->if_nextents <= XFS_IFORK_MAXEXT(ip, whichfork);
>  }
>  
>  /*
> @@ -334,7 +336,7 @@ xfs_bmap_check_leaf_extents(
>  	}
>  
>  	/* skip large extent count inodes */
> -	if (ip->i_d.di_nextents > 10000)
> +	if (ip->i_df.if_nextents > 10000)
>  		return;
>  
>  	bno = NULLFSBLOCK;
> @@ -750,7 +752,7 @@ xfs_bmap_extents_to_btree(
>  		xfs_bmbt_disk_set_all(arp, &rec);
>  		cnt++;
>  	}
> -	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));
> +	ASSERT(cnt == ifp->if_nextents);
>  	xfs_btree_set_numrecs(ablock, cnt);
>  
>  	/*
> @@ -802,7 +804,7 @@ xfs_bmap_local_to_extents_empty(
>  	ASSERT(whichfork != XFS_COW_FORK);
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(ifp->if_bytes == 0);
> -	ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
> +	ASSERT(ifp->if_nextents == 0);
>  
>  	xfs_bmap_forkoff_reset(ip, whichfork);
>  	ifp->if_flags &= ~XFS_IFINLINE;
> @@ -907,7 +909,7 @@ xfs_bmap_local_to_extents(
>  	xfs_iext_first(ifp, &icur);
>  	xfs_iext_insert(ip, &icur, &rec, 0);
>  
> -	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
> +	ifp->if_nextents = 1;
>  	ip->i_d.di_nblocks = 1;
>  	xfs_trans_mod_dquot_byino(tp, ip,
>  		XFS_TRANS_DQ_BCOUNT, 1L);
> @@ -972,7 +974,8 @@ xfs_bmap_add_attrfork_extents(
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
>  	int			error;		/* error return value */
>  
> -	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
> +	if (ip->i_df.if_nextents * sizeof(struct xfs_bmbt_rec) <=
> +	    XFS_IFORK_DSIZE(ip))
>  		return 0;
>  	cur = NULL;
>  	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
> @@ -1091,10 +1094,6 @@ xfs_bmap_add_attrfork(
>  		goto trans_cancel;
>  	if (XFS_IFORK_Q(ip))
>  		goto trans_cancel;
> -	if (XFS_IS_CORRUPT(mp, ip->i_d.di_anextents != 0)) {
> -		error = -EFSCORRUPTED;
> -		goto trans_cancel;
> -	}
>  	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
>  		/*
>  		 * For inodes coming from pre-6.2 filesystems.
> @@ -1183,13 +1182,13 @@ xfs_iread_bmbt_block(
>  	xfs_extnum_t		num_recs;
>  	xfs_extnum_t		j;
>  	int			whichfork = cur->bc_ino.whichfork;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  
>  	block = xfs_btree_get_block(cur, level, &bp);
>  
>  	/* Abort if we find more records than nextents. */
>  	num_recs = xfs_btree_get_numrecs(block);
> -	if (unlikely(ir->loaded + num_recs >
> -		     XFS_IFORK_NEXTENTS(ip, whichfork))) {
> +	if (unlikely(ir->loaded + num_recs > ifp->if_nextents)) {
>  		xfs_warn(ip->i_mount, "corrupt dinode %llu, (btree extents).",
>  				(unsigned long long)ip->i_ino);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
> @@ -1215,7 +1214,7 @@ xfs_iread_bmbt_block(
>  				xfs_bmap_fork_to_state(whichfork));
>  		trace_xfs_read_extent(ip, &ir->icur,
>  				xfs_bmap_fork_to_state(whichfork), _THIS_IP_);
> -		xfs_iext_next(XFS_IFORK_PTR(ip, whichfork), &ir->icur);
> +		xfs_iext_next(ifp, &ir->icur);
>  	}
>  
>  	return 0;
> @@ -1254,8 +1253,7 @@ xfs_iread_extents(
>  	if (error)
>  		goto out;
>  
> -	if (XFS_IS_CORRUPT(mp,
> -			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
> +	if (XFS_IS_CORRUPT(mp, ir.loaded != ifp->if_nextents)) {
>  		error = -EFSCORRUPTED;
>  		goto out;
>  	}
> @@ -1463,23 +1461,22 @@ xfs_bmap_last_offset(
>   */
>  int					/* 1=>1 block, 0=>otherwise */
>  xfs_bmap_one_block(
> -	xfs_inode_t	*ip,		/* incore inode */
> -	int		whichfork)	/* data or attr fork */
> +	struct xfs_inode	*ip,		/* incore inode */
> +	int			whichfork)	/* data or attr fork */
>  {
> -	struct xfs_ifork *ifp;		/* inode fork pointer */
> -	int		rval;		/* return value */
> -	xfs_bmbt_irec_t	s;		/* internal version of extent */
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	int			rval;		/* return value */
> +	struct xfs_bmbt_irec	s;		/* internal version of extent */
>  	struct xfs_iext_cursor icur;
>  
>  #ifndef DEBUG
>  	if (whichfork == XFS_DATA_FORK)
>  		return XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize;
>  #endif	/* !DEBUG */
> -	if (XFS_IFORK_NEXTENTS(ip, whichfork) != 1)
> +	if (ifp->if_nextents != 1)
>  		return 0;
>  	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
>  		return 0;
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
>  	xfs_iext_first(ifp, &icur);
>  	xfs_iext_get_extent(ifp, &icur, &s);
> @@ -1501,10 +1498,11 @@ xfs_bmap_add_extent_delay_real(
>  	struct xfs_bmalloca	*bma,
>  	int			whichfork)
>  {
> +	struct xfs_mount	*mp = bma->ip->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
>  	struct xfs_bmbt_irec	*new = &bma->got;
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
> -	struct xfs_ifork	*ifp;	/* inode fork pointer */
>  	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
> @@ -1514,16 +1512,9 @@ xfs_bmap_add_extent_delay_real(
>  	xfs_filblks_t		da_old; /* old count del alloc blocks used */
>  	xfs_filblks_t		temp=0;	/* value for da_new calculations */
>  	int			tmp_rval;	/* partial logging flags */
> -	struct xfs_mount	*mp;
> -	xfs_extnum_t		*nextents;
>  	struct xfs_bmbt_irec	old;
>  
> -	mp = bma->ip->i_mount;
> -	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
>  	ASSERT(whichfork != XFS_ATTR_FORK);
> -	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
> -						&bma->ip->i_d.di_nextents);
> -
>  	ASSERT(!isnullstartblock(new->br_startblock));
>  	ASSERT(!bma->cur ||
>  	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
> @@ -1614,7 +1605,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_remove(bma->ip, &bma->icur, state);
>  		xfs_iext_prev(ifp, &bma->icur);
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
> -		(*nextents)--;
> +		ifp->if_nextents--;
>  
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -1718,8 +1709,8 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_startblock = new->br_startblock;
>  		PREV.br_state = new->br_state;
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
> +		ifp->if_nextents++;
>  
> -		(*nextents)++;
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -1784,7 +1775,8 @@ xfs_bmap_add_extent_delay_real(
>  		 * The left neighbor is not contiguous.
>  		 */
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> -		(*nextents)++;
> +		ifp->if_nextents++;
> +
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -1870,7 +1862,8 @@ xfs_bmap_add_extent_delay_real(
>  		 * The right neighbor is not contiguous.
>  		 */
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, new);
> -		(*nextents)++;
> +		ifp->if_nextents++;
> +
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -1955,7 +1948,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
>  		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
> -		(*nextents)++;
> +		ifp->if_nextents++;
>  
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -2159,8 +2152,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_remove(ip, icur, state);
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -				XFS_IFORK_NEXTENTS(ip, whichfork) - 2);
> +		ifp->if_nextents -= 2;
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2212,8 +2204,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_remove(ip, icur, state);
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &LEFT);
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> +		ifp->if_nextents--;
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2255,9 +2246,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_remove(ip, icur, state);
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &PREV);
> +		ifp->if_nextents--;
>  
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2364,8 +2354,8 @@ xfs_bmap_add_extent_unwritten_real(
>  
>  		xfs_iext_update_extent(ip, state, icur, &PREV);
>  		xfs_iext_insert(ip, icur, new, state);
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> +		ifp->if_nextents++;
> +
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2440,9 +2430,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_update_extent(ip, state, icur, &PREV);
>  		xfs_iext_next(ifp, icur);
>  		xfs_iext_insert(ip, icur, new, state);
> +		ifp->if_nextents++;
>  
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2493,9 +2482,8 @@ xfs_bmap_add_extent_unwritten_real(
>  		xfs_iext_next(ifp, icur);
>  		xfs_iext_insert(ip, icur, &r[1], state);
>  		xfs_iext_insert(ip, icur, &r[0], state);
> +		ifp->if_nextents += 2;
>  
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -				XFS_IFORK_NEXTENTS(ip, whichfork) + 2);
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
>  		else {
> @@ -2810,9 +2798,8 @@ xfs_bmap_add_extent_hole_real(
>  		xfs_iext_remove(ip, icur, state);
>  		xfs_iext_prev(ifp, icur);
>  		xfs_iext_update_extent(ip, state, icur, &left);
> +		ifp->if_nextents--;
>  
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  		if (cur == NULL) {
>  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
>  		} else {
> @@ -2910,8 +2897,8 @@ xfs_bmap_add_extent_hole_real(
>  		 * Insert a new entry.
>  		 */
>  		xfs_iext_insert(ip, icur, new, state);
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> +		ifp->if_nextents++;
> +
>  		if (cur == NULL) {
>  			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
>  		} else {
> @@ -4512,8 +4499,7 @@ xfs_bmapi_write(
>  		goto error0;
>  
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
> -	       XFS_IFORK_NEXTENTS(ip, whichfork) >
> -		XFS_IFORK_MAXEXT(ip, whichfork));
> +	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
>  	xfs_bmapi_finish(&bma, whichfork, 0);
>  	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
>  		orig_nmap, *nmap);
> @@ -5056,8 +5042,7 @@ xfs_bmap_del_extent_real(
>  	 */
>  	if (tp->t_blk_res == 0 &&
>  	    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_NEXTENTS(ip, whichfork) >=
> -			XFS_IFORK_MAXEXT(ip, whichfork) &&
> +	    ifp->if_nextents >= XFS_IFORK_MAXEXT(ip, whichfork) &&
>  	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
>  		return -ENOSPC;
>  
> @@ -5109,8 +5094,8 @@ xfs_bmap_del_extent_real(
>  		 */
>  		xfs_iext_remove(ip, icur, state);
>  		xfs_iext_prev(ifp, icur);
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> +		ifp->if_nextents--;
> +
>  		flags |= XFS_ILOG_CORE;
>  		if (!cur) {
>  			flags |= xfs_ilog_fext(whichfork);
> @@ -5218,8 +5203,8 @@ xfs_bmap_del_extent_real(
>  			}
>  		} else
>  			flags |= xfs_ilog_fext(whichfork);
> -		XFS_IFORK_NEXT_SET(ip, whichfork,
> -			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> +
> +		ifp->if_nextents++;
>  		xfs_iext_next(ifp, icur);
>  		xfs_iext_insert(ip, icur, &new, state);
>  		break;
> @@ -5667,6 +5652,7 @@ xfs_bmse_merge(
>  	struct xfs_btree_cur		*cur,
>  	int				*logflags)	/* output */
>  {
> +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_bmbt_irec		new;
>  	xfs_filblks_t			blockcount;
>  	int				error, i;
> @@ -5685,8 +5671,7 @@ xfs_bmse_merge(
>  	 * Update the on-disk extent count, the btree if necessary and log the
>  	 * inode.
>  	 */
> -	XFS_IFORK_NEXT_SET(ip, whichfork,
> -			   XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> +	ifp->if_nextents--;
>  	*logflags |= XFS_ILOG_CORE;
>  	if (!cur) {
>  		*logflags |= XFS_ILOG_DEXT;
> @@ -5724,7 +5709,7 @@ xfs_bmse_merge(
>  
>  done:
>  	xfs_iext_remove(ip, icur, 0);
> -	xfs_iext_prev(XFS_IFORK_PTR(ip, whichfork), icur);
> +	xfs_iext_prev(ifp, icur);
>  	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), icur,
>  			&new);
>  
> @@ -6074,8 +6059,7 @@ xfs_bmap_split_extent(
>  	/* Add new extent */
>  	xfs_iext_next(ifp, &icur);
>  	xfs_iext_insert(ip, &icur, &new, 0);
> -	XFS_IFORK_NEXT_SET(ip, whichfork,
> -			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
> +	ifp->if_nextents++;
>  
>  	if (cur) {
>  		error = xfs_bmbt_lookup_eq(cur, &new, &i);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 1dbf2f980a26a..5b59d3f7746b3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1104,7 +1104,7 @@ xfs_dir2_sf_to_block(
>  	ASSERT(ifp->if_bytes == dp->i_d.di_size);
>  	ASSERT(ifp->if_u1.if_data != NULL);
>  	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
> -	ASSERT(dp->i_d.di_nextents == 0);
> +	ASSERT(dp->i_df.if_nextents == 0);
>  
>  	/*
>  	 * Copy the directory into a temporary buffer.
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5547bbb3cf945..a374e2a81e764 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -245,8 +245,6 @@ xfs_inode_from_disk(
>  	to->di_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
>  	to->di_extsize = be32_to_cpu(from->di_extsize);
> -	to->di_nextents = be32_to_cpu(from->di_nextents);
> -	to->di_anextents = be16_to_cpu(from->di_anextents);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat	= from->di_aformat;
>  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> @@ -311,8 +309,8 @@ xfs_inode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> +	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index e4cbcaf62a32b..fecccfb26463c 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -22,8 +22,6 @@ struct xfs_icdinode {
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> -	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
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
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
>  	case S_IFCHR:
> @@ -282,6 +283,8 @@ xfs_iformat_attr_fork(
>  	int			error = 0;
>  
>  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> +	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +
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
> 


-- 
chandan



