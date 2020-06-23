Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DE6C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B5920675
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJvpFP0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgFWCai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:30:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35082 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730456AbgFWCai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 22:30:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2RmjV066157;
        Tue, 23 Jun 2020 02:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nmaQ6yJ8AH92Zb8cVDU+e+cxFKz0hFYwbVtAT53NTC4=;
 b=YJvpFP0ntUN7fsp9nxB07HhuVx9g/P0XrI0HVZx5TPdbIuiVnfDC8DOxU9VaBlw+cE5n
 OxZCJXIl6U9yYtHnpVbWWDlr5NXVJBqkTZkPXTR+ArkoLb1XqYtKlqvfhh4XqXQaMIjF
 UN7jTYi2KuXXqYvoTTRFx1vX4PbL+I5yf+vBYty3l9kxagQMo6XRCR8AiM+6XkiX8urm
 TanH3heQcWPSuUkJ/Z3ryoVe+lidREyneWwi//Tk7qA19gFWbd4scxA+8UBI5BlmbeEC
 03QoRevvf6ijQRoEPAuG7enl3mC9Y8cmvEboqXRq3Sgn7/4abQ+V+CJ5WncVgCnwUsck dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31sebbjju5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 02:30:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2RtHW085050;
        Tue, 23 Jun 2020 02:30:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31svc2tnr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 02:30:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N2UWop014634;
        Tue, 23 Jun 2020 02:30:32 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 02:30:32 +0000
Date:   Mon, 22 Jun 2020 19:30:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/30] xfs: add an inode item lock
Message-ID: <20200623023031.GA7606@magnolia>
References: <20200622081605.1818434-1-david@fromorbit.com>
 <20200622081605.1818434-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622081605.1818434-4-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=1 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=1 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 06:15:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode log item is kind of special in that it can be aggregating
> new changes in memory at the same time time existing changes are
> being written back to disk. This means there are fields in the log
> item that are accessed concurrently from contexts that don't share
> any locking at all.
> 
> e.g. updating ili_last_fields occurs at flush time under the
> ILOCK_EXCL and flush lock at flush time, under the flush lock at IO
> completion time, and is read under the ILOCK_EXCL when the inode is
> logged.  Hence there is no actual serialisation between reading the
> field during logging of the inode in transactions vs clearing the
> field in IO completion.
> 
> We currently get away with this by the fact that we are only
> clearing fields in IO completion, and nothing bad happens if we
> accidentally log more of the inode than we actually modify. Worst
> case is we consume a tiny bit more memory and log bandwidth.
> 
> However, if we want to do more complex state manipulations on the
> log item that requires updates at all three of these potential
> locations, we need to have some mechanism of serialising those
> operations. To do this, introduce a spinlock into the log item to
> serialise internal state.
> 
> This could be done via the xfs_inode i_flags_lock, but this then
> leads to potential lock inversion issues where inode flag updates
> need to occur inside locks that best nest inside the inode log item
> locks (e.g. marking inodes stale during inode cluster freeing).
> Using a separate spinlock avoids these sorts of problems and
> simplifies future code.
> 
> This does not touch the use of ili_fields in the item formatting
> code - that is entirely protected by the ILOCK_EXCL at this point in
> time, so it remains untouched.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

/me thot he'd reviewed this ages ago but apparently, not...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_inode.c | 52 ++++++++++++++++-----------------
>  fs/xfs/xfs_file.c               |  9 ++++--
>  fs/xfs/xfs_inode.c              | 20 ++++++++-----
>  fs/xfs/xfs_inode_item.c         |  7 +++++
>  fs/xfs/xfs_inode_item.h         | 18 ++++++++++--
>  5 files changed, 66 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 4504d215cd59..c66d9d1dd58b 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -82,16 +82,20 @@ xfs_trans_ichgtime(
>   */
>  void
>  xfs_trans_log_inode(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	uint		flags)
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	uint			flags)
>  {
> -	struct inode	*inode = VFS_I(ip);
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	struct inode		*inode = VFS_I(ip);
> +	uint			iversion_flags = 0;
>  
> -	ASSERT(ip->i_itemp != NULL);
> +	ASSERT(iip);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
>  
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +
>  	/*
>  	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
>  	 * don't matter - we either will need an extra transaction in 24 hours
> @@ -104,15 +108,6 @@ xfs_trans_log_inode(
>  		spin_unlock(&inode->i_lock);
>  	}
>  
> -	/*
> -	 * Record the specific change for fdatasync optimisation. This
> -	 * allows fdatasync to skip log forces for inodes that are only
> -	 * timestamp dirty. We do this before the change count so that
> -	 * the core being logged in this case does not impact on fdatasync
> -	 * behaviour.
> -	 */
> -	ip->i_itemp->ili_fsync_fields |= flags;
> -
>  	/*
>  	 * First time we log the inode in a transaction, bump the inode change
>  	 * counter if it is configured for this to occur. While we have the
> @@ -122,23 +117,28 @@ xfs_trans_log_inode(
>  	 * set however, then go ahead and bump the i_version counter
>  	 * unconditionally.
>  	 */
> -	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
> -	    IS_I_VERSION(VFS_I(ip))) {
> -		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
> -			flags |= XFS_ILOG_CORE;
> +	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
> +		if (IS_I_VERSION(inode) &&
> +		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> +			iversion_flags = XFS_ILOG_CORE;
>  	}
>  
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	/*
> +	 * Record the specific change for fdatasync optimisation. This allows
> +	 * fdatasync to skip log forces for inodes that are only timestamp
> +	 * dirty.
> +	 */
> +	spin_lock(&iip->ili_lock);
> +	iip->ili_fsync_fields |= flags;
>  
>  	/*
> -	 * Always OR in the bits from the ili_last_fields field.
> -	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> -	 * routines in the eventual clearing of the ili_fields bits.
> -	 * See the big comment in xfs_iflush() for an explanation of
> -	 * this coordination mechanism.
> +	 * Always OR in the bits from the ili_last_fields field.  This is to
> +	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
> +	 * the eventual clearing of the ili_fields bits.  See the big comment in
> +	 * xfs_iflush() for an explanation of this coordination mechanism.
>  	 */
> -	flags |= ip->i_itemp->ili_last_fields;
> -	ip->i_itemp->ili_fields |= flags;
> +	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
> +	spin_unlock(&iip->ili_lock);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 00db81eac80d..7b05f8fd7b3d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -94,6 +94,7 @@ xfs_file_fsync(
>  {
>  	struct inode		*inode = file->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error = 0;
>  	int			log_flushed = 0;
> @@ -137,13 +138,15 @@ xfs_file_fsync(
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	if (xfs_ipincount(ip)) {
>  		if (!datasync ||
> -		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -			lsn = ip->i_itemp->ili_last_lsn;
> +		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> +			lsn = iip->ili_last_lsn;
>  	}
>  
>  	if (lsn) {
>  		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
> -		ip->i_itemp->ili_fsync_fields = 0;
> +		spin_lock(&iip->ili_lock);
> +		iip->ili_fsync_fields = 0;
> +		spin_unlock(&iip->ili_lock);
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2e5fa6dea83a..e2296f0b7f11 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2704,9 +2704,11 @@ xfs_ifree_cluster(
>  				continue;
>  
>  			iip = ip->i_itemp;
> +			spin_lock(&iip->ili_lock);
>  			iip->ili_last_fields = iip->ili_fields;
>  			iip->ili_fields = 0;
>  			iip->ili_fsync_fields = 0;
> +			spin_unlock(&iip->ili_lock);
>  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  						&iip->ili_item.li_lsn);
>  
> @@ -2742,6 +2744,7 @@ xfs_ifree(
>  {
>  	int			error;
>  	struct xfs_icluster	xic = { 0 };
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
> @@ -2779,7 +2782,9 @@ xfs_ifree(
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  
>  	/* Don't attempt to replay owner changes for a deleted inode */
> -	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
> +	spin_lock(&iip->ili_lock);
> +	iip->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
> +	spin_unlock(&iip->ili_lock);
>  
>  	/*
>  	 * Bump the generation count so no one will be confused
> @@ -3835,20 +3840,19 @@ xfs_iflush_int(
>  	 * know that the information those bits represent is permanently on
>  	 * disk.  As long as the flush completes before the inode is logged
>  	 * again, then both ili_fields and ili_last_fields will be cleared.
> -	 *
> -	 * We can play with the ili_fields bits here, because the inode lock
> -	 * must be held exclusively in order to set bits there and the flush
> -	 * lock protects the ili_last_fields bits.  Store the current LSN of the
> -	 * inode so that we can tell whether the item has moved in the AIL from
> -	 * xfs_iflush_done().  In order to read the lsn we need the AIL lock,
> -	 * because it is a 64 bit value that cannot be read atomically.
>  	 */
>  	error = 0;
>  flush_out:
> +	spin_lock(&iip->ili_lock);
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
> +	spin_unlock(&iip->ili_lock);
>  
> +	/*
> +	 * Store the current LSN of the inode so that we can tell whether the
> +	 * item has moved in the AIL from xfs_iflush_done().
> +	 */
>  	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  				&iip->ili_item.li_lsn);
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index b17384aa8df4..6ef9cbcfc94a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -637,6 +637,7 @@ xfs_inode_item_init(
>  	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, 0);
>  
>  	iip->ili_inode = ip;
> +	spin_lock_init(&iip->ili_lock);
>  	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
>  						&xfs_inode_item_ops);
>  }
> @@ -738,7 +739,11 @@ xfs_iflush_done(
>  	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
>  		list_del_init(&blip->li_bio_list);
>  		iip = INODE_ITEM(blip);
> +
> +		spin_lock(&iip->ili_lock);
>  		iip->ili_last_fields = 0;
> +		spin_unlock(&iip->ili_lock);
> +
>  		xfs_ifunlock(iip->ili_inode);
>  	}
>  	list_del(&tmp);
> @@ -762,9 +767,11 @@ xfs_iflush_abort(
>  		 * Clear the inode logging fields so no more flushes are
>  		 * attempted.
>  		 */
> +		spin_lock(&iip->ili_lock);
>  		iip->ili_last_fields = 0;
>  		iip->ili_fields = 0;
>  		iip->ili_fsync_fields = 0;
> +		spin_unlock(&iip->ili_lock);
>  	}
>  	/*
>  	 * Release the inode's flush lock since we're done with it.
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 4de5070e0765..4a10a1b92ee9 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -16,12 +16,24 @@ struct xfs_mount;
>  struct xfs_inode_log_item {
>  	struct xfs_log_item	ili_item;	   /* common portion */
>  	struct xfs_inode	*ili_inode;	   /* inode ptr */
> -	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> -	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
> -	unsigned short		ili_lock_flags;	   /* lock flags */
> +	unsigned short		ili_lock_flags;	   /* inode lock flags */
> +	/*
> +	 * The ili_lock protects the interactions between the dirty state and
> +	 * the flush state of the inode log item. This allows us to do atomic
> +	 * modifications of multiple state fields without having to hold a
> +	 * specific inode lock to serialise them.
> +	 *
> +	 * We need atomic changes between inode dirtying, inode flushing and
> +	 * inode completion, but these all hold different combinations of
> +	 * ILOCK and iflock and hence we need some other method of serialising
> +	 * updates to the flush state.
> +	 */
> +	spinlock_t		ili_lock;	   /* flush state lock */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
>  	unsigned int		ili_fsync_fields;  /* logged since last fsync */
> +	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> +	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
>  };
>  
>  static inline int xfs_inode_clean(xfs_inode_t *ip)
> -- 
> 2.26.2.761.g0e0b3e54be
> 
