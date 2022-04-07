Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60238C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 02:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiDGCCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiDGCCC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 22:02:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8587A6E01
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 19:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F729617EE
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76714C385A3;
        Thu,  7 Apr 2022 02:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649296801;
        bh=9UGfpDL4EYZgmOiRxcq+bY41sDWrR6WXgI9wqNfVcz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tQpGMu+Dq82Wnmt1lRqvxOfwoA1QgHGT0L+mq9TjbKU0wPzE0O8z+WWH5+7seE1Va
         18lvZXtpD1EjB4b1tgWyto9pl7tY6CNBR7Qtj1AlAmdyTJuj2BTjcHs/51gU/oO4PY
         +3FHYshhcb9NgB2fYmIElJ+F5nHdUIX1JMNbYypJlsUMoBSbDsquo0FAtkN8qLezAJ
         WMqNZnIJz8/NMtg758Z7TXHsVlk2B4I0lrepDQYutNepqXGH38QxNDTuMRNb+3A7el
         B0Q0P823+2AY1daLvWNGZT4VSsEnTqXLUv6S0VNqNkmn5zC61by/HHn+y1Yr4dhson
         XSUklbWG0Mrqw==
Date:   Wed, 6 Apr 2022 19:00:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
Message-ID: <20220407020000.GA27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-17-chandan.babu@oracle.com>
 <20220407014627.GV27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407014627.GV27690@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 06:46:27PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 06, 2022 at 11:49:00AM +0530, Chandan Babu R wrote:
> > This commit enables upgrading existing inodes to use large extent counters
> > provided that underlying filesystem's superblock has large extent counter
> > feature enabled.
> > 
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 10 ++++++++++
> >  fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
> >  fs/xfs/libxfs/xfs_format.h     |  8 ++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++++++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
> >  fs/xfs/xfs_bmap_item.c         |  2 ++
> >  fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
> >  fs/xfs/xfs_dquot.c             |  3 +++
> >  fs/xfs/xfs_iomap.c             |  5 +++++
> >  fs/xfs/xfs_reflink.c           |  5 +++++
> >  fs/xfs/xfs_rtalloc.c           |  3 +++
> >  11 files changed, 74 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 23523b802539..66c4fc55c9d7 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -776,8 +776,18 @@ xfs_attr_set(
> >  	if (args->value || xfs_inode_hasattr(dp)) {
> >  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> >  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> > +		if (error == -EFBIG)
> > +			error = xfs_iext_count_upgrade(args->trans, dp,
> > +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> >  		if (error)
> >  			goto out_trans_cancel;
> > +
> > +		if (error == -EFBIG) {
> > +			error = xfs_iext_count_upgrade(args->trans, dp,
> > +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> > +			if (error)
> > +				goto out_trans_cancel;
> > +		}
> >  	}
> >  
> >  	error = xfs_attr_lookup(args);
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 4fab0c92ab70..82d5467ddf2c 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4524,14 +4524,16 @@ xfs_bmapi_convert_delalloc(
> >  		return error;
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> >  
> >  	error = xfs_iext_count_may_overflow(ip, whichfork,
> >  			XFS_IEXT_ADD_NOSPLIT_CNT);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip,
> > +				XFS_IEXT_ADD_NOSPLIT_CNT);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > -	xfs_trans_ijoin(tp, ip, 0);
> > -
> >  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
> >  	    bma.got.br_startoff > offset_fsb) {
> >  		/*
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 43de892d0305..bb327ea43ca1 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -934,6 +934,14 @@ enum xfs_dinode_fmt {
> >  #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
> >  #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
> >  
> > +/*
> > + * This macro represents the maximum value by which a filesystem operation can
> > + * increase the value of an inode's data/attr fork extent count.
> > + */
> > +#define XFS_MAX_EXTCNT_UPGRADE_NR	\
> > +	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
> > +	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
> > +
> >  /*
> >   * Inode minimum and maximum sizes.
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index bb5d841aac58..1245e9f1ca81 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -756,3 +756,22 @@ xfs_iext_count_may_overflow(
> >  
> >  	return 0;
> >  }
> > +
> > +int
> > +xfs_iext_count_upgrade(
> 
> Hmm.  I think the @nr_to_add parameter is supposed to be the one
> that caused xfs_iext_count_may_overflow to return -EFBIG, right?
> 
> I was about to comment that it would be really helpful to have a comment
> above this function dropping a hint that this is the case:
> 
> /*
>  * Upgrade this inode's extent counter fields to be able to handle a
>  * potential increase in the extent count by this number.  Normally
>  * this is the same quantity that caused xfs_iext_count_may_overflow to
>  * return -EFBIG.
>  */
> int
> xfs_iext_count_upgrade(...
> 
> ...though I worry that this will cause fatal warnings about the
> otherwise unused parameter on non-debug kernels?  I'm not sure why it
> matters that nr_to_add is constrained to a small value?  Is it just to
> prevent obviously huge values?  AFAICT all the current callers pass in
> small #defined integer values.
> 
> That said, if the assert here is something Dave asked for in a previous
> review, then I won't stand in the way:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	uint			nr_to_add)
> > +{
> > +	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> > +
> > +	if (!xfs_has_large_extent_counts(ip->i_mount) ||
> > +	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64) ||


	    xfs_inode_has_large_extent_counts(ip) || ?

--D

> > +	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> > +		return -EFBIG;
> > +
> > +	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 6f9d69f8896e..4f68c1f20beb 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -275,6 +275,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> >  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> >  int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
> >  		int nr_to_add);
> > +int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
> > +		uint nr_to_add);
> >  
> >  /* returns true if the fork has extents but they are not read in yet. */
> >  static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 761dde155099..593ac29cffc7 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -506,6 +506,8 @@ xfs_bui_item_recover(
> >  		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
> >  
> >  	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
> >  	if (error)
> >  		goto err_cancel;
> >  
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 18c1b99311a8..52be58372c63 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -859,6 +859,9 @@ xfs_alloc_file_space(
> >  
> >  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> >  				XFS_IEXT_ADD_NOSPLIT_CNT);
> > +		if (error == -EFBIG)
> > +			error = xfs_iext_count_upgrade(tp, ip,
> > +					XFS_IEXT_ADD_NOSPLIT_CNT);
> >  		if (error)
> >  			goto error;
> >  
> > @@ -914,6 +917,8 @@ xfs_unmap_extent(
> >  
> >  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> >  			XFS_IEXT_PUNCH_HOLE_CNT);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -1195,6 +1200,8 @@ xfs_insert_file_space(
> >  
> >  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> >  			XFS_IEXT_PUNCH_HOLE_CNT);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -1423,6 +1430,9 @@ xfs_swap_extent_rmap(
> >  				error = xfs_iext_count_may_overflow(ip,
> >  						XFS_DATA_FORK,
> >  						XFS_IEXT_SWAP_RMAP_CNT);
> > +				if (error == -EFBIG)
> > +					error = xfs_iext_count_upgrade(tp, ip,
> > +							XFS_IEXT_SWAP_RMAP_CNT);
> >  				if (error)
> >  					goto out;
> >  			}
> > @@ -1431,6 +1441,9 @@ xfs_swap_extent_rmap(
> >  				error = xfs_iext_count_may_overflow(tip,
> >  						XFS_DATA_FORK,
> >  						XFS_IEXT_SWAP_RMAP_CNT);
> > +				if (error == -EFBIG)
> > +					error = xfs_iext_count_upgrade(tp, ip,
> > +							XFS_IEXT_SWAP_RMAP_CNT);
> >  				if (error)
> >  					goto out;
> >  			}
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 5afedcbc78c7..eb211e0ede5d 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -322,6 +322,9 @@ xfs_dquot_disk_alloc(
> >  
> >  	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
> >  			XFS_IEXT_ADD_NOSPLIT_CNT);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, quotip,
> > +				XFS_IEXT_ADD_NOSPLIT_CNT);
> >  	if (error)
> >  		goto err_cancel;
> >  
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 87e1cf5060bd..5a393259a3a3 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -251,6 +251,8 @@ xfs_iomap_write_direct(
> >  		return error;
> >  
> >  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -555,6 +557,9 @@ xfs_iomap_write_unwritten(
> >  
> >  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> >  				XFS_IEXT_WRITE_UNWRITTEN_CNT);
> > +		if (error == -EFBIG)
> > +			error = xfs_iext_count_upgrade(tp, ip,
> > +					XFS_IEXT_WRITE_UNWRITTEN_CNT);
> >  		if (error)
> >  			goto error_on_bmapi_transaction;
> >  
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 54e68e5693fd..1ae6d3434ad2 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -620,6 +620,9 @@ xfs_reflink_end_cow_extent(
> >  
> >  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> >  			XFS_IEXT_REFLINK_END_COW_CNT);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip,
> > +				XFS_IEXT_REFLINK_END_COW_CNT);
> >  	if (error)
> >  		goto out_cancel;
> >  
> > @@ -1121,6 +1124,8 @@ xfs_reflink_remap_extent(
> >  		++iext_delta;
> >  
> >  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
> > +	if (error == -EFBIG)
> > +		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
> >  	if (error)
> >  		goto out_cancel;
> >  
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index b8c79ee791af..3e587e85d5bf 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -806,6 +806,9 @@ xfs_growfs_rt_alloc(
> >  
> >  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> >  				XFS_IEXT_ADD_NOSPLIT_CNT);
> > +		if (error == -EFBIG)
> > +			error = xfs_iext_count_upgrade(tp, ip,
> > +					XFS_IEXT_ADD_NOSPLIT_CNT);
> >  		if (error)
> >  			goto out_trans_cancel;
> >  
> > -- 
> > 2.30.2
> > 
