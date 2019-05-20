Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfETXA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:00:57 -0400
Date: Mon, 20 May 2019 16:00:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/3] libxfs: share kernel's xfs_trans_inode.c
Message-ID: <20190520230043.GH5335@magnolia>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <f26c134c-2e06-4985-8f31-e067ce5d6956@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f26c134c-2e06-4985-8f31-e067ce5d6956@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 17, 2019 at 02:50:15PM -0500, Eric Sandeen wrote:
> Now that the majority of cosmetic changes and compat shims
> are in place, we can directly share kernelspace's
> xfs_trans_inode.c with just a couple more small tweaks.
> In addition to the file move,
> 
> * ili_fsync_fields is added to xfs_inode_log_item (but not used)
> * test_and_set_bit() helper is created
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> To finish the sync, we probably need to move the file under
> libxfs/ in kernelspace, and add XFS_ICHGTIME_CREATE handling
> unless that's deemed undesirable, in which case we can probably
> just carry the delta in userspace...

I already did that as part of the metadir feature series I sent last
December... :)

Nevertheless, I eventually need xfs_trans_ichgtime to accept all four of
the MOD/CHG/CREATE/ACCESS flags, so this is fine.

--D

> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index fe03ba64..cdaa69d8 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -30,8 +30,9 @@ typedef struct xfs_inode_log_item {
>  	xfs_log_item_t		ili_item;		/* common portion */
>  	struct xfs_inode	*ili_inode;		/* inode pointer */
>  	unsigned short		ili_lock_flags;		/* lock flags */
> -	unsigned int		ili_fields;		/* fields to be logged */
>  	unsigned int		ili_last_fields;	/* fields when flushed*/
> +	unsigned int		ili_fields;		/* fields to be logged */
> +	unsigned int		ili_fsync_fields;	/* ignored by userspace */
>  } xfs_inode_log_item_t;
>  
>  typedef struct xfs_buf_log_item {
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 160498d7..8c681e0b 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -93,6 +93,7 @@ CFILES = cache.c \
>  	xfs_rtbitmap.c \
>  	xfs_sb.c \
>  	xfs_symlink_remote.c \
> +	xfs_trans_inode.c \
>  	xfs_trans_resv.c \
>  	xfs_types.c
>  
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 7551ed65..fc785664 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -608,6 +608,15 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
>  	return *p & mask;
>  }
>  
> +/* Sets and returns original value of the bit */
> +static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
> +{
> +	if (test_bit(nr, addr))
> +		return 1;
> +	set_bit(nr, addr);
> +	return 0;
> +}
> +
>  /* Keep static checkers quiet about nonstatic functions by exporting */
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 6ef4841f..29dd10f7 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -330,25 +330,6 @@ xfs_trans_cancel(
>  	xfs_trans_free(tp);
>  }
>  
> -void
> -xfs_trans_ijoin(
> -	xfs_trans_t		*tp,
> -	xfs_inode_t		*ip,
> -	uint			lock_flags)
> -{
> -	xfs_inode_log_item_t	*iip;
> -
> -	if (ip->i_itemp == NULL)
> -		xfs_inode_item_init(ip, ip->i_mount);
> -	iip = ip->i_itemp;
> -	ASSERT(iip->ili_inode != NULL);
> -
> -	ASSERT(iip->ili_lock_flags == 0);
> -	iip->ili_lock_flags = lock_flags;
> -
> -	xfs_trans_add_item(tp, &iip->ili_item);
> -}
> -
>  void
>  xfs_trans_inode_alloc_buf(
>  	xfs_trans_t		*tp,
> @@ -362,52 +343,6 @@ xfs_trans_inode_alloc_buf(
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> -/*
> - * This is called to mark the fields indicated in fieldmask as needing
> - * to be logged when the transaction is committed.  The inode must
> - * already be associated with the given transaction.
> - *
> - * The values for fieldmask are defined in xfs_log_format.h.  We always
> - * log all of the core inode if any of it has changed, and we always log
> - * all of the inline data/extents/b-tree root if any of them has changed.
> - */
> -void
> -xfs_trans_log_inode(
> -	xfs_trans_t		*tp,
> -	xfs_inode_t		*ip,
> -	uint			flags)
> -{
> -	ASSERT(ip->i_itemp != NULL);
> -
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
> -
> -	/*
> -	 * Always OR in the bits from the ili_last_fields field.
> -	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> -	 * routines in the eventual clearing of the ilf_fields bits.
> -	 * See the big comment in xfs_iflush() for an explanation of
> -	 * this coordination mechanism.
> -	 */
> -	flags |= ip->i_itemp->ili_last_fields;
> -	ip->i_itemp->ili_fields |= flags;
> -}
> -
> -int
> -xfs_trans_roll_inode(
> -	struct xfs_trans	**tpp,
> -	struct xfs_inode	*ip)
> -{
> -	int			error;
> -
> -	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> -	error = xfs_trans_roll(tpp);
> -	if (!error)
> -		xfs_trans_ijoin(*tpp, ip, 0);
> -	return error;
> -}
> -
> -
>  /*
>   * Mark a buffer dirty in the transaction.
>   */
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 1734ae9a..5a89bd03 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -149,33 +149,6 @@ current_time(struct inode *inode)
>  	return tv;
>  }
>  
> -/*
> - * Change the requested timestamp in the given inode.
> - */
> -void
> -xfs_trans_ichgtime(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	int			flags)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -	struct timespec64	tv;
> -
> -	ASSERT(tp);
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -
> -	tv = current_time(inode);
> -
> -	if (flags & XFS_ICHGTIME_MOD)
> -		VFS_I(ip)->i_mtime = tv;
> -	if (flags & XFS_ICHGTIME_CHG)
> -		VFS_I(ip)->i_ctime = tv;
> -	if (flags & XFS_ICHGTIME_CREATE) {
> -		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> -		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> -	}
> -}
> -
>  STATIC uint16_t
>  xfs_flags2diflags(
>  	struct xfs_inode	*ip,
> diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
> new file mode 100644
> index 00000000..87e6335b
> --- /dev/null
> +++ b/libxfs/xfs_trans_inode.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000,2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#include "libxfs_priv.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans.h"
> +#include "xfs_trace.h"
> +
> +/*
> + * Add a locked inode to the transaction.
> + *
> + * The inode must be locked, and it cannot be associated with any transaction.
> + * If lock_flags is non-zero the inode will be unlocked on transaction commit.
> + */
> +void
> +xfs_trans_ijoin(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	uint			lock_flags)
> +{
> +	xfs_inode_log_item_t	*iip;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	if (ip->i_itemp == NULL)
> +		xfs_inode_item_init(ip, ip->i_mount);
> +	iip = ip->i_itemp;
> +
> +	ASSERT(iip->ili_lock_flags == 0);
> +	iip->ili_lock_flags = lock_flags;
> +
> +	/*
> +	 * Get a log_item_desc to point at the new item.
> +	 */
> +	xfs_trans_add_item(tp, &iip->ili_item);
> +}
> +
> +/*
> + * Transactional inode timestamp update. Requires the inode to be locked and
> + * joined to the transaction supplied. Relies on the transaction subsystem to
> + * track dirty state and update/writeback the inode accordingly.
> + */
> +void
> +xfs_trans_ichgtime(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	int			flags)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +	struct timespec64 tv;
> +
> +	ASSERT(tp);
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	tv = current_time(inode);
> +
> +	if (flags & XFS_ICHGTIME_MOD)
> +		inode->i_mtime = tv;
> +	if (flags & XFS_ICHGTIME_CHG)
> +		inode->i_ctime = tv;
> +	if (flags & XFS_ICHGTIME_CREATE) {
> +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> +	}
> +}
> +
> +/*
> + * This is called to mark the fields indicated in fieldmask as needing
> + * to be logged when the transaction is committed.  The inode must
> + * already be associated with the given transaction.
> + *
> + * The values for fieldmask are defined in xfs_inode_item.h.  We always
> + * log all of the core inode if any of it has changed, and we always log
> + * all of the inline data/extents/b-tree root if any of them has changed.
> + */
> +void
> +xfs_trans_log_inode(
> +	xfs_trans_t	*tp,
> +	xfs_inode_t	*ip,
> +	uint		flags)
> +{
> +	struct inode	*inode = VFS_I(ip);
> +
> +	ASSERT(ip->i_itemp != NULL);
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	/*
> +	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
> +	 * don't matter - we either will need an extra transaction in 24 hours
> +	 * to log the timestamps, or will clear already cleared fields in the
> +	 * worst case.
> +	 */
> +	if (inode->i_state & (I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED)) {
> +		spin_lock(&inode->i_lock);
> +		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
> +		spin_unlock(&inode->i_lock);
> +	}
> +
> +	/*
> +	 * Record the specific change for fdatasync optimisation. This
> +	 * allows fdatasync to skip log forces for inodes that are only
> +	 * timestamp dirty. We do this before the change count so that
> +	 * the core being logged in this case does not impact on fdatasync
> +	 * behaviour.
> +	 */
> +	ip->i_itemp->ili_fsync_fields |= flags;
> +
> +	/*
> +	 * First time we log the inode in a transaction, bump the inode change
> +	 * counter if it is configured for this to occur. While we have the
> +	 * inode locked exclusively for metadata modification, we can usually
> +	 * avoid setting XFS_ILOG_CORE if no one has queried the value since
> +	 * the last time it was incremented. If we have XFS_ILOG_CORE already
> +	 * set however, then go ahead and bump the i_version counter
> +	 * unconditionally.
> +	 */
> +	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
> +	    IS_I_VERSION(VFS_I(ip))) {
> +		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
> +			flags |= XFS_ILOG_CORE;
> +	}
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +
> +	/*
> +	 * Always OR in the bits from the ili_last_fields field.
> +	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> +	 * routines in the eventual clearing of the ili_fields bits.
> +	 * See the big comment in xfs_iflush() for an explanation of
> +	 * this coordination mechanism.
> +	 */
> +	flags |= ip->i_itemp->ili_last_fields;
> +	ip->i_itemp->ili_fields |= flags;
> +}
> +
> +int
> +xfs_trans_roll_inode(
> +	struct xfs_trans	**tpp,
> +	struct xfs_inode	*ip)
> +{
> +	int			error;
> +
> +	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> +	error = xfs_trans_roll(tpp);
> +	if (!error)
> +		xfs_trans_ijoin(*tpp, ip, 0);
> +	return error;
> +}
> 
