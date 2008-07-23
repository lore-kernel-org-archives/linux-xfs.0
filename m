Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 01:12:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N8CF2m017043
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 01:12:15 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3E641B3B23C
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 01:13:24 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Sj2pu3bNgfL3udnG for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 01:13:24 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6N8DFNg003905
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 10:13:15 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6N8DFWw003903
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 10:13:15 +0200
Date: Wed, 23 Jul 2008 10:13:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] kill xfs_lock_dir_and_entry
Message-ID: <20080723081315.GA3863@lst.de>
References: <20080502105803.GC17870@lst.de> <20080520063639.GC8869@lst.de> <20080627130627.GC23431@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627130627.GC23431@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

ping^3 - this time for real :)

On Fri, Jun 27, 2008 at 03:06:27PM +0200, Christoph Hellwig wrote:
> ping^2
> 
> On Tue, May 20, 2008 at 08:36:39AM +0200, Christoph Hellwig wrote:
> > ping?
> > 
> > On Fri, May 02, 2008 at 12:58:03PM +0200, Christoph Hellwig wrote:
> > > When multiple inodes are locked in XFS it happens in order of the inode
> > > number, with the everything but the first inode trylocked if any of
> > > the previous inodes is in the AIL.
> > > 
> > > Except for the sorting of the inodes this logic is implemented in
> > > xfs_lock_inodes, but also partially duplicated in xfs_lock_dir_and_entry
> > > in a particularly stupid way adds a lock roundtrip if the inode ordering
> > > is not optimal.
> > > 
> > > This patch adds a new helper xfs_lock_two_inodes that takes two inodes
> > > and locks them in the most optimal way according to the above locking
> > > protocol and uses it for all places that want to lock two inodes.
> > > 
> > > The only caller of xfs_lock_inodes is xfs_rename which might lock up to
> > > four inodes.
> > > 
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> > > ===================================================================
> > > --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-05-02 08:30:24.000000000 +0200
> > > +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-05-02 08:30:30.000000000 +0200
> > > @@ -1897,111 +1897,6 @@ std_return:
> > >  }
> > >  
> > >  #ifdef DEBUG
> > > -/*
> > > - * Some counters to see if (and how often) we are hitting some deadlock
> > > - * prevention code paths.
> > > - */
> > > -
> > > -int xfs_rm_locks;
> > > -int xfs_rm_lock_delays;
> > > -int xfs_rm_attempts;
> > > -#endif
> > > -
> > > -/*
> > > - * The following routine will lock the inodes associated with the
> > > - * directory and the named entry in the directory. The locks are
> > > - * acquired in increasing inode number.
> > > - *
> > > - * If the entry is "..", then only the directory is locked. The
> > > - * vnode ref count will still include that from the .. entry in
> > > - * this case.
> > > - *
> > > - * There is a deadlock we need to worry about. If the locked directory is
> > > - * in the AIL, it might be blocking up the log. The next inode we lock
> > > - * could be already locked by another thread waiting for log space (e.g
> > > - * a permanent log reservation with a long running transaction (see
> > > - * xfs_itruncate_finish)). To solve this, we must check if the directory
> > > - * is in the ail and use lock_nowait. If we can't lock, we need to
> > > - * drop the inode lock on the directory and try again. xfs_iunlock will
> > > - * potentially push the tail if we were holding up the log.
> > > - */
> > > -STATIC int
> > > -xfs_lock_dir_and_entry(
> > > -	xfs_inode_t	*dp,
> > > -	xfs_inode_t	*ip)	/* inode of entry 'name' */
> > > -{
> > > -	int		attempts;
> > > -	xfs_ino_t	e_inum;
> > > -	xfs_inode_t	*ips[2];
> > > -	xfs_log_item_t	*lp;
> > > -
> > > -#ifdef DEBUG
> > > -	xfs_rm_locks++;
> > > -#endif
> > > -	attempts = 0;
> > > -
> > > -again:
> > > -	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> > > -
> > > -	e_inum = ip->i_ino;
> > > -
> > > -	xfs_itrace_ref(ip);
> > > -
> > > -	/*
> > > -	 * We want to lock in increasing inum. Since we've already
> > > -	 * acquired the lock on the directory, we may need to release
> > > -	 * if if the inum of the entry turns out to be less.
> > > -	 */
> > > -	if (e_inum > dp->i_ino) {
> > > -		/*
> > > -		 * We are already in the right order, so just
> > > -		 * lock on the inode of the entry.
> > > -		 * We need to use nowait if dp is in the AIL.
> > > -		 */
> > > -
> > > -		lp = (xfs_log_item_t *)dp->i_itemp;
> > > -		if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> > > -			if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> > > -				attempts++;
> > > -#ifdef DEBUG
> > > -				xfs_rm_attempts++;
> > > -#endif
> > > -
> > > -				/*
> > > -				 * Unlock dp and try again.
> > > -				 * xfs_iunlock will try to push the tail
> > > -				 * if the inode is in the AIL.
> > > -				 */
> > > -
> > > -				xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > > -
> > > -				if ((attempts % 5) == 0) {
> > > -					delay(1); /* Don't just spin the CPU */
> > > -#ifdef DEBUG
> > > -					xfs_rm_lock_delays++;
> > > -#endif
> > > -				}
> > > -				goto again;
> > > -			}
> > > -		} else {
> > > -			xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > -		}
> > > -	} else if (e_inum < dp->i_ino) {
> > > -		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > > -
> > > -		ips[0] = ip;
> > > -		ips[1] = dp;
> > > -		xfs_lock_inodes(ips, 2, XFS_ILOCK_EXCL);
> > > -	}
> > > -	/* else	 e_inum == dp->i_ino */
> > > -	/*     This can happen if we're asked to lock /x/..
> > > -	 *     the entry is "..", which is also the parent directory.
> > > -	 */
> > > -
> > > -	return 0;
> > > -}
> > > -
> > > -#ifdef DEBUG
> > >  int xfs_locked_n;
> > >  int xfs_small_retries;
> > >  int xfs_middle_retries;
> > > @@ -2135,6 +2030,45 @@ again:
> > >  #endif
> > >  }
> > >  
> > > +void
> > > +xfs_lock_two_inodes(
> > > +	xfs_inode_t		*ip0,
> > > +	xfs_inode_t		*ip1,
> > > +	uint			lock_mode)
> > > +{
> > > +	xfs_inode_t		*temp;
> > > +	int			attempts = 0;
> > > +	xfs_log_item_t		*lp;
> > > +
> > > +	ASSERT(ip0->i_ino != ip1->i_ino);
> > > +
> > > +	if (ip0->i_ino > ip1->i_ino) {
> > > +		temp = ip0;
> > > +		ip0 = ip1;
> > > +		ip1 = temp;
> > > +	}
> > > +
> > > + again:
> > > +	xfs_ilock(ip0, xfs_lock_inumorder(lock_mode, 0));
> > > +
> > > +	/*
> > > +	 * If the first lock we have locked is in the AIL, we must TRY to get
> > > +	 * the second lock. If we can't get it, we must release the first one
> > > +	 * and try again.
> > > +	 */
> > > +	lp = (xfs_log_item_t *)ip0->i_itemp;
> > > +	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
> > > +		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
> > > +			xfs_iunlock(ip0, lock_mode);
> > > +			if ((++attempts % 5) == 0)
> > > +				delay(1); /* Don't just spin the CPU */
> > > +			goto again;
> > > +		}
> > > +	} else {
> > > +		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
> > > +	}
> > > +}
> > > +
> > >  int
> > >  xfs_remove(
> > >  	xfs_inode_t             *dp,
> > > @@ -2210,9 +2144,7 @@ xfs_remove(
> > >  		goto out_trans_cancel;
> > >  	}
> > >  
> > > -	error = xfs_lock_dir_and_entry(dp, ip);
> > > -	if (error)
> > > -		goto out_trans_cancel;
> > > +	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
> > >  
> > >  	/*
> > >  	 * At this point, we've gotten both the directory and the entry
> > > @@ -2239,9 +2171,6 @@ xfs_remove(
> > >  		}
> > >  	}
> > >  
> > > -	/*
> > > -	 * Entry must exist since we did a lookup in xfs_lock_dir_and_entry.
> > > -	 */
> > >  	XFS_BMAP_INIT(&free_list, &first_block);
> > >  	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
> > >  					&first_block, &free_list, resblks);
> > > @@ -2347,7 +2276,6 @@ xfs_link(
> > >  {
> > >  	xfs_mount_t		*mp = tdp->i_mount;
> > >  	xfs_trans_t		*tp;
> > > -	xfs_inode_t		*ips[2];
> > >  	int			error;
> > >  	xfs_bmap_free_t         free_list;
> > >  	xfs_fsblock_t           first_block;
> > > @@ -2395,15 +2323,7 @@ xfs_link(
> > >  		goto error_return;
> > >  	}
> > >  
> > > -	if (sip->i_ino < tdp->i_ino) {
> > > -		ips[0] = sip;
> > > -		ips[1] = tdp;
> > > -	} else {
> > > -		ips[0] = tdp;
> > > -		ips[1] = sip;
> > > -	}
> > > -
> > > -	xfs_lock_inodes(ips, 2, XFS_ILOCK_EXCL);
> > > +	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
> > >  
> > >  	/*
> > >  	 * Increment vnode ref counts since xfs_trans_commit &
> > > Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
> > > ===================================================================
> > > --- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2008-04-26 17:43:14.000000000 +0200
> > > +++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2008-05-02 08:30:30.000000000 +0200
> > > @@ -128,7 +128,6 @@ xfs_swap_extents(
> > >  	xfs_swapext_t	*sxp)
> > >  {
> > >  	xfs_mount_t	*mp;
> > > -	xfs_inode_t	*ips[2];
> > >  	xfs_trans_t	*tp;
> > >  	xfs_bstat_t	*sbp = &sxp->sx_stat;
> > >  	bhv_vnode_t	*vp, *tvp;
> > > @@ -153,16 +152,7 @@ xfs_swap_extents(
> > >  	vp = XFS_ITOV(ip);
> > >  	tvp = XFS_ITOV(tip);
> > >  
> > > -	/* Lock in i_ino order */
> > > -	if (ip->i_ino < tip->i_ino) {
> > > -		ips[0] = ip;
> > > -		ips[1] = tip;
> > > -	} else {
> > > -		ips[0] = tip;
> > > -		ips[1] = ip;
> > > -	}
> > > -
> > > -	xfs_lock_inodes(ips, 2, lock_flags);
> > > +	xfs_lock_two_inodes(ip, tip, lock_flags);
> > >  	locked = 1;
> > >  
> > >  	/* Verify that both files have the same format */
> > > @@ -265,7 +255,7 @@ xfs_swap_extents(
> > >  		locked = 0;
> > >  		goto error0;
> > >  	}
> > > -	xfs_lock_inodes(ips, 2, XFS_ILOCK_EXCL);
> > > +	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> > >  
> > >  	/*
> > >  	 * Count the number of extended attribute blocks
> > > Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
> > > ===================================================================
> > > --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-05-01 22:56:57.000000000 +0200
> > > +++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-05-02 08:30:30.000000000 +0200
> > > @@ -522,6 +522,7 @@ void		xfs_iflush_all(struct xfs_mount *)
> > >  void		xfs_ichgtime(xfs_inode_t *, int);
> > >  xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
> > >  void		xfs_lock_inodes(xfs_inode_t **, int, uint);
> > > +void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
> > >  
> > >  void		xfs_synchronize_atime(xfs_inode_t *);
> > >  void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
> > ---end quoted text---
> ---end quoted text---
---end quoted text---
