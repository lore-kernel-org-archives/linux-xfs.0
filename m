Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Feb 2007 23:41:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1D7fBm7010740
	for <xfs@oss.sgi.com>; Mon, 12 Feb 2007 23:41:14 -0800
Date: Tue, 13 Feb 2007 18:41:18 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] remove unused "lsn" argument of xfs_trans_commit
Message-ID: <37EB31D054F1B23EE06E3692@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <45C95BAF.6080005@sandeen.net>
References: <45C95BAF.6080005@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Sounds a good idea.


I was curious why we actually have it and looked at the IRIX code.
----------------------------
revision 1.97
date: 1998/01/18 09:05:49;  author: rcc;  state: Exp;  lines: +11 -3
added extra argument to xfs_trans_commit for IO_DSYNC speedup.
pv: 555963  rv: lord@cray
----------------------------
It uses the lsn from a commit in a subsequent log force to ensure the
iclog sync'ed has that transaction I assume.
And I think in the linux code we get the lsn from the inode item,
iip->ili_last_lsn...

--Tim

--On 6 February 2007 10:55:11 PM -0600 Eric Sandeen <sandeen@sandeen.net> wrote:

>  The last argument "lsn" of xfs_trans_commit() is always called with NULL.
>   dmapi/xfs_dm.c          |    4 ++--
>  quota/xfs_dquot.c       |    3 +--
>  quota/xfs_qm.c          |    5 ++---
>  quota/xfs_qm_syscalls.c |    6 +++---
>  xfs_attr.c              |   12 ++++--------
>  xfs_attr_leaf.c         |    2 +-
>  xfs_bmap.c              |    4 ++--
>  xfs_dfrag.c             |    2 +-
>  xfs_fsops.c             |    4 ++--
>  xfs_inode.c             |    2 +-
>  xfs_iomap.c             |    7 +++----
>  xfs_log_recover.c       |    4 ++--
>  xfs_mount.c             |    2 +-
>  xfs_qmops.c             |    2 +-
>  xfs_rename.c            |    2 +-
>  xfs_rtalloc.c           |    6 +++---
>  xfs_rw.c                |    4 ++--
>  xfs_trans.c             |    6 ------
>  xfs_trans.h             |    4 +---
>  xfs_utils.c             |    5 ++---
>  xfs_vfsops.c            |    2 +-
>  xfs_vnodeops.c          |   33 ++++++++++++++++-----------------
>  22 files changed, 52 insertions(+), 69 deletions(-)
>   Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>   ---
>   Index: linux/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux/fs/xfs.orig/dmapi/xfs_dm.c
> +++ linux/fs/xfs/dmapi/xfs_dm.c
> @@ -1168,7 +1168,7 @@ xfs_dm_f_set_eventlist(
>   	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	VN_HOLD(vp);
> -	xfs_trans_commit(tp, 0, NULL);
> +	xfs_trans_commit(tp, 0);
>   	return(0);
>  }
> @@ -3021,7 +3021,7 @@ xfs_dm_set_region(
>   	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	VN_HOLD(vp);
> -	xfs_trans_commit(tp, 0, NULL);
> +	xfs_trans_commit(tp, 0);
>   	/* Return the proper value for *exactflagp depending upon whether or not
>  	   we "changed" the user's managed region.  In other words, if the user
> Index: linux/fs/xfs/quota/xfs_dquot.c
> ===================================================================
> --- linux/fs/xfs.orig/quota/xfs_dquot.c
> +++ linux/fs/xfs/quota/xfs_dquot.c
> @@ -753,8 +753,7 @@ xfs_qm_idtodq(
>  		goto error0;
>  	}
>  	if (tp) {
> -		if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES,
> -					     NULL)))
> +		if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES)))
>  			goto error1;
>  	}
>  Index: linux/fs/xfs/quota/xfs_qm.c
> ===================================================================
> --- linux/fs/xfs.orig/quota/xfs_qm.c
> +++ linux/fs/xfs/quota/xfs_qm.c
> @@ -1453,8 +1453,7 @@ xfs_qm_qino_alloc(
>  	XFS_SB_UNLOCK(mp, s);
>  	xfs_mod_sb(tp, sbfields);
>  -	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES,
> -				     NULL))) {
> +	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES))) {
>  		xfs_fs_cmn_err(CE_ALERT, mp, "XFS qino_alloc failed!");
>  		return error;
>  	}
> @@ -2405,7 +2404,7 @@ xfs_qm_write_sb_changes(
>  	}
>   	xfs_mod_sb(tp, flags);
> -	(void) xfs_trans_commit(tp, 0, NULL);
> +	(void) xfs_trans_commit(tp, 0);
>   	return 0;
>  }
> Index: linux/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- linux/fs/xfs.orig/quota/xfs_qm_syscalls.c
> +++ linux/fs/xfs/quota/xfs_qm_syscalls.c
> @@ -735,7 +735,7 @@ xfs_qm_scall_setqlim(
>  	xfs_trans_log_dquot(tp, dqp);
>   	xfs_dqtrace_entry(dqp, "Q_SETQLIM: COMMIT");
> -	xfs_trans_commit(tp, 0, NULL);
> +	xfs_trans_commit(tp, 0);
>  	xfs_qm_dqprint(dqp);
>  	xfs_qm_dqrele(dqp);
>  	mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
> @@ -809,7 +809,7 @@ xfs_qm_log_quotaoff_end(
>  	 * We don't care about quotoff's performance.
>  	 */
>  	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>  	return (error);
>  }
>  @@ -852,7 +852,7 @@ xfs_qm_log_quotaoff(
>  	 * We don't care about quotoff's performance.
>  	 */
>  	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>   error0:
>  	if (error) {
> Index: linux/fs/xfs/xfs_attr.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_attr.c
> +++ linux/fs/xfs/xfs_attr.c
> @@ -328,8 +328,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const  				xfs_trans_set_sync(args.trans);
>  			}
>  			err2 = xfs_trans_commit(args.trans,
> -						 XFS_TRANS_RELEASE_LOG_RES,
> -						 NULL);
> +						 XFS_TRANS_RELEASE_LOG_RES);
>  			xfs_iunlock(dp, XFS_ILOCK_EXCL);
>   			/*
> @@ -397,8 +396,7 @@ xfs_attr_set_int(xfs_inode_t *dp, const  	 * Commit the last in the sequence
> of transactions.
>  	 */
>  	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES,
> -				 NULL);
> +	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>   	/*
> @@ -544,8 +542,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, con
>  	 * Commit the last in the sequence of transactions.
>  	 */
>  	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES,
> -				 NULL);
> +	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>   	/*
> @@ -859,8 +856,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
>  	 * Commit the last in the sequence of transactions.
>  	 */
>  	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES,
> -				 NULL);
> +	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>   	return(error);
> Index: linux/fs/xfs/xfs_attr_leaf.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_attr_leaf.c
> +++ linux/fs/xfs/xfs_attr_leaf.c
> @@ -3053,7 +3053,7 @@ xfs_attr_rolltrans(xfs_trans_t **transp,
>  	 * is in progress. The caller takes the responsibility to cancel
>  	 * the duplicate transaction that gets returned.
>  	 */
> -	if ((error = xfs_trans_commit(trans, 0, NULL)))
> +	if ((error = xfs_trans_commit(trans, 0)))
>  		return (error);
>   	trans = *transp;
> Index: linux/fs/xfs/xfs_bmap.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_bmap.c
> +++ linux/fs/xfs/xfs_bmap.c
> @@ -4071,7 +4071,7 @@ xfs_bmap_add_attrfork(
>  	}
>  	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
>  		goto error2;
> -	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(ip->i_df.if_ext_max ==
>  	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
>  	return error;
> @@ -4227,7 +4227,7 @@ xfs_bmap_finish(
>  	logres = ntp->t_log_res;
>  	logcount = ntp->t_log_count;
>  	ntp = xfs_trans_dup(*tp);
> -	error = xfs_trans_commit(*tp, 0, NULL);
> +	error = xfs_trans_commit(*tp, 0);
>  	*tp = ntp;
>  	*committed = 1;
>  	/*
> Index: linux/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_dfrag.c
> +++ linux/fs/xfs/xfs_dfrag.c
> @@ -382,7 +382,7 @@ xfs_swap_extents(
>  		xfs_trans_set_sync(tp);
>  	}
>  -	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
>  	locked = 0;
>    error0:
> Index: linux/fs/xfs/xfs_fsops.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_fsops.c
> +++ linux/fs/xfs/xfs_fsops.c
> @@ -346,7 +346,7 @@ xfs_growfs_data_private(
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, nfree);
>  	if (dpct)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error) {
>  		return error;
>  	}
> @@ -605,7 +605,7 @@ xfs_fs_log_dummy(
>  	xfs_trans_ihold(tp, ip);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_trans_set_sync(tp);
> -	xfs_trans_commit(tp, 0, NULL);
> +	xfs_trans_commit(tp, 0);
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  }
> Index: linux/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_inode.c
> +++ linux/fs/xfs/xfs_inode.c
> @@ -1746,7 +1746,7 @@ xfs_itruncate_finish(
>  			xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
>  		}
>  		ntp = xfs_trans_dup(ntp);
> -		(void) xfs_trans_commit(*tp, 0, NULL);
> +		(void) xfs_trans_commit(*tp, 0);
>  		*tp = ntp;
>  		error = xfs_trans_reserve(ntp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
>  					  XFS_TRANS_PERM_LOG_RES,
> Index: linux/fs/xfs/xfs_iomap.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_iomap.c
> +++ linux/fs/xfs/xfs_iomap.c
> @@ -543,7 +543,7 @@ xfs_iomap_write_direct(
>  	error = xfs_bmap_finish(&tp, &free_list, &committed);
>  	if (error)
>  		goto error0;
> -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (error)
>  		goto error_out;
>  @@ -840,8 +840,7 @@ xfs_iomap_write_allocate(
>  			if (error)
>  				goto trans_cancel;
>  -			error = xfs_trans_commit(tp,
> -					XFS_TRANS_RELEASE_LOG_RES, NULL);
> +			error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  			if (error)
>  				goto error0;
>  @@ -948,7 +947,7 @@ xfs_iomap_write_unwritten(
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  -		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
>  			return XFS_ERROR(error);
> Index: linux/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_log_recover.c
> +++ linux/fs/xfs/xfs_log_recover.c
> @@ -3016,7 +3016,7 @@ xlog_recover_process_efi(
>  	}
>   	efip->efi_flags |= XFS_EFI_RECOVERED;
> -	xfs_trans_commit(tp, 0, NULL);
> +	xfs_trans_commit(tp, 0);
>  }
>   /*
> @@ -3143,7 +3143,7 @@ xlog_recover_clear_agi_bucket(
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
>  -	(void) xfs_trans_commit(tp, 0, NULL);
> +	(void) xfs_trans_commit(tp, 0);
>  }
>   /*
> Index: linux/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_mount.c
> +++ linux/fs/xfs/xfs_mount.c
> @@ -1653,7 +1653,7 @@ xfs_mount_log_sbunit(
>  		return;
>  	}
>  	xfs_mod_sb(tp, fields);
> -	xfs_trans_commit(tp, 0, NULL);
> +	xfs_trans_commit(tp, 0);
>  }
>   Index: linux/fs/xfs/xfs_qmops.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_qmops.c
> +++ linux/fs/xfs/xfs_qmops.c
> @@ -78,7 +78,7 @@ xfs_mount_reset_sbqflags(xfs_mount_t *mp
>  		return error;
>  	}
>  	xfs_mod_sb(tp, XFS_SB_QFLAGS);
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>  	return error;
>  }
>  Index: linux/fs/xfs/xfs_rename.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_rename.c
> +++ linux/fs/xfs/xfs_rename.c
> @@ -584,7 +584,7 @@ xfs_rename(
>  	 * trans_commit will unlock src_ip, target_ip & decrement
>  	 * the vnode references.
>  	 */
> -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (target_ip != NULL) {
>  		xfs_refcache_purge_ip(target_ip);
>  		IRELE(target_ip);
> Index: linux/fs/xfs/xfs_rtalloc.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_rtalloc.c
> +++ linux/fs/xfs/xfs_rtalloc.c
> @@ -150,7 +150,7 @@ xfs_growfs_rt_alloc(
>  		error = xfs_bmap_finish(&tp, &flist, &committed);
>  		if (error)
>  			goto error_exit;
> -		xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +		xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  		/*
>  		 * Now we need to clear the allocated blocks.
>  		 * Do this one block per transaction, to keep it simple.
> @@ -187,7 +187,7 @@ xfs_growfs_rt_alloc(
>  			/*
>  			 * Commit the transaction.
>  			 */
> -			xfs_trans_commit(tp, 0, NULL);
> +			xfs_trans_commit(tp, 0);
>  		}
>  		/*
>  		 * Go on to the next extent, if any.
> @@ -2042,7 +2042,7 @@ xfs_growfs_rt(
>  		/*
>  		 * Commit the transaction.
>  		 */
> -		xfs_trans_commit(tp, 0, NULL);
> +		xfs_trans_commit(tp, 0);
>  	}
>   	if (error)
> Index: linux/fs/xfs/xfs_rw.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_rw.c
> +++ linux/fs/xfs/xfs_rw.c
> @@ -83,7 +83,7 @@ xfs_write_clear_setuid(
>  	}
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  }
> @@ -164,7 +164,7 @@ xfs_write_sync_logforce(
>  			xfs_trans_ihold(tp, ip);
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  			xfs_trans_set_sync(tp);
> -			error = xfs_trans_commit(tp, 0, NULL);
> +			error = xfs_trans_commit(tp, 0);
>  			xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		}
>  	}
> Index: linux/fs/xfs/xfs_trans.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_trans.c
> +++ linux/fs/xfs/xfs_trans.c
> @@ -753,7 +753,6 @@ int
>  _xfs_trans_commit(
>  	xfs_trans_t	*tp,
>  	uint		flags,
> -	xfs_lsn_t	*commit_lsn_p,
>  	int		*log_flushed)
>  {
>  	xfs_log_iovec_t		*log_vector;
> @@ -812,8 +811,6 @@ shut_us_down:
>  		xfs_trans_free_busy(tp);
>  		xfs_trans_free(tp);
>  		XFS_STATS_INC(xs_trans_empty);
> -		if (commit_lsn_p)
> -			*commit_lsn_p = commit_lsn;
>  		return (shutdown);
>  	}
>  	ASSERT(tp->t_ticket != NULL);
> @@ -864,9 +861,6 @@ shut_us_down:
>  		kmem_free(log_vector, nvec * sizeof(xfs_log_iovec_t));
>  	}
>  -	if (commit_lsn_p)
> -		*commit_lsn_p = commit_lsn;
> -
>  	/*
>  	 * If we got a log write error. Unpin the logitems that we
>  	 * had pinned, clean up, free trans structure, and return error.
> Index: linux/fs/xfs/xfs_trans.h
> ===================================================================
> --- linux/fs/xfs.orig/xfs_trans.h
> +++ linux/fs/xfs/xfs_trans.h
> @@ -988,10 +988,8 @@ void		xfs_trans_log_efd_extent(xfs_trans
>  					 xfs_extlen_t);
>  int		_xfs_trans_commit(xfs_trans_t *,
>  				  uint flags,
> -				  xfs_lsn_t *,
>  				  int *);
> -#define xfs_trans_commit(tp, flags, lsn) \
> -	_xfs_trans_commit(tp, flags, lsn, NULL)
> +#define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
>  void		xfs_trans_cancel(xfs_trans_t *, int);
>  void		xfs_trans_ail_init(struct xfs_mount *);
>  xfs_lsn_t	xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
> Index: linux/fs/xfs/xfs_utils.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_utils.c
> +++ linux/fs/xfs/xfs_utils.c
> @@ -222,7 +222,7 @@ xfs_dir_ialloc(
>  		}
>   		ntp = xfs_trans_dup(tp);
> -		code = xfs_trans_commit(tp, 0, NULL);
> +		code = xfs_trans_commit(tp, 0);
>  		tp = ntp;
>  		if (committed != NULL) {
>  			*committed = 1;
> @@ -460,8 +460,7 @@ xfs_truncate_file(
>  				 XFS_TRANS_ABORT);
>  	} else {
>  		xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES,
> -					 NULL);
> +		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>  Index: linux/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_vfsops.c
> +++ linux/fs/xfs/xfs_vfsops.c
> @@ -1539,7 +1539,7 @@ xfs_syncsub(
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ihold(tp, ip);
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -		error = xfs_trans_commit(tp, 0, NULL);
> +		error = xfs_trans_commit(tp, 0);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		xfs_log_force(mp, (xfs_lsn_t)0, log_flags);
>  	}
> Index: linux/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux/fs/xfs.orig/xfs_vnodeops.c
> +++ linux/fs/xfs/xfs_vnodeops.c
> @@ -873,7 +873,7 @@ xfs_setattr(
>  		if (mp->m_flags & XFS_MOUNT_WSYNC)
>  			xfs_trans_set_sync(tp);
>  -		code = xfs_trans_commit(tp, commit_flags, NULL);
> +		code = xfs_trans_commit(tp, commit_flags);
>  	}
>   	/*
> @@ -1176,7 +1176,7 @@ xfs_fsync(
>  		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		if (flag & FSYNC_WAIT)
>  			xfs_trans_set_sync(tp);
> -		error = _xfs_trans_commit(tp, 0, NULL, &log_flushed);
> +		error = _xfs_trans_commit(tp, 0, &log_flushed);
>   		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
> @@ -1291,8 +1291,7 @@ xfs_inactive_free_eofblocks(
>  					  XFS_TRANS_ABORT));
>  		} else {
>  			error = xfs_trans_commit(tp,
> -						XFS_TRANS_RELEASE_LOG_RES,
> -						NULL);
> +						XFS_TRANS_RELEASE_LOG_RES);
>  		}
>  		xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	}
> @@ -1406,7 +1405,7 @@ xfs_inactive_symlink_rmt(
>  	 * we need to unlock the inode since the new transaction doesn't
>  	 * have the inode attached.
>  	 */
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>  	tp = ntp;
>  	if (error) {
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> @@ -1503,7 +1502,7 @@ xfs_inactive_attrs(
>  	tp = *tpp;
>  	mp = ip->i_mount;
>  	ASSERT(ip->i_d.di_forkoff != 0);
> -	xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>   	error = xfs_attr_inactive(ip);
> @@ -1790,7 +1789,7 @@ xfs_inactive(
>  		 * nothing we can do except to try to keep going.
>  		 */
>  		(void) xfs_bmap_finish(&tp,  &free_list, &committed);
> -		(void) xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +		(void) xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	}
>  	/*
>  	 * Release the dquots held by inode, if any.
> @@ -2026,7 +2025,7 @@ xfs_create(
>  		goto abort_rele;
>  	}
>  -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (error) {
>  		IRELE(ip);
>  		tp = NULL;
> @@ -2511,7 +2510,7 @@ xfs_remove(
>  		goto error_rele;
>  	}
>  -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (error) {
>  		IRELE(ip);
>  		goto std_return;
> @@ -2719,7 +2718,7 @@ xfs_link(
>  		goto abort_return;
>  	}
>  -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (error)
>  		goto std_return;
>  @@ -2936,7 +2935,7 @@ xfs_mkdir(
>  		goto error2;
>  	}
>  -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	XFS_QM_DQRELE(mp, udqp);
>  	XFS_QM_DQRELE(mp, gdqp);
>  	if (error) {
> @@ -3190,7 +3189,7 @@ xfs_rmdir(
>  		goto std_return;
>  	}
>  -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	if (error) {
>  		IRELE(cdp);
>  		goto std_return;
> @@ -3535,7 +3534,7 @@ xfs_symlink(
>  	if (error) {
>  		goto error2;
>  	}
> -	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  	XFS_QM_DQRELE(mp, udqp);
>  	XFS_QM_DQRELE(mp, gdqp);
>  @@ -3790,7 +3789,7 @@ xfs_set_dmattrs (
>   	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	IHOLD(ip);
> -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>   	return error;
>  }
> @@ -4148,7 +4147,7 @@ retry:
>  			goto error0;
>  		}
>  -		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error) {
>  			break;
> @@ -4455,7 +4454,7 @@ xfs_free_file_space(
>  			goto error0;
>  		}
>  -		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
> +		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>  @@ -4649,7 +4648,7 @@ xfs_change_file_space(
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_trans_set_sync(tp);
>  -	error = xfs_trans_commit(tp, 0, NULL);
> +	error = xfs_trans_commit(tp, 0);
>   	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>
>
