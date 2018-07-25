Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728882AbeGYMhm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 08:37:42 -0400
Date: Wed, 25 Jul 2018 07:26:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: clean up IRELE/iput callsites
Message-ID: <20180725112625.GB3601@bfoster>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129832.28208.4218463670080722161.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153248129832.28208.4218463670080722161.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 06:14:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the IRELE macro with a proper function so that we can do proper
> typechecking and so that we can stop open-coding iput in scrub, which
> means that we'll be able to ftrace inode lifetimes going through scrub
> correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/common.c    |    2 +-
>  fs/xfs/scrub/dir.c       |    2 +-
>  fs/xfs/scrub/parent.c    |    6 +++---
>  fs/xfs/scrub/scrub.c     |    2 +-
>  fs/xfs/xfs_bmap_item.c   |    4 ++--
>  fs/xfs/xfs_export.c      |    2 +-
>  fs/xfs/xfs_filestream.c  |    4 ++--
>  fs/xfs/xfs_icache.c      |    4 ++--
>  fs/xfs/xfs_inode.c       |   17 +++++++++++++----
>  fs/xfs/xfs_inode.h       |    7 ++-----
>  fs/xfs/xfs_iops.c        |    4 ++--
>  fs/xfs/xfs_itable.c      |    2 +-
>  fs/xfs/xfs_log_recover.c |    4 ++--
>  fs/xfs/xfs_mount.c       |    4 ++--
>  fs/xfs/xfs_qm.c          |   22 +++++++++++-----------
>  fs/xfs/xfs_qm_syscalls.c |    8 ++++----
>  fs/xfs/xfs_quotaops.c    |    2 +-
>  fs/xfs/xfs_rtalloc.c     |    6 +++---
>  fs/xfs/xfs_symlink.c     |    2 +-
>  19 files changed, 55 insertions(+), 49 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 8e18bc0fedd0..fa05f8126b00 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
...
> @@ -497,4 +493,5 @@ extern struct kmem_zone	*xfs_inode_zone;
>  
>  bool xfs_inode_verify_forks(struct xfs_inode *ip);
>  
> +

Spurious whitespace change..?

Otherwise looks fine to me (modulo Christoph's scrub/IRELE() question):

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0fa29f39d658..4101410021ca 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -208,7 +208,7 @@ xfs_generic_create(
>  	xfs_finish_inode_setup(ip);
>  	if (!tmpfile)
>  		xfs_cleanup_inode(dir, inode, dentry);
> -	iput(inode);
> +	xfs_irele(ip);
>  	goto out_free_acl;
>  }
>  
> @@ -390,7 +390,7 @@ xfs_vn_symlink(
>   out_cleanup_inode:
>  	xfs_finish_inode_setup(cip);
>  	xfs_cleanup_inode(dir, inode, dentry);
> -	iput(inode);
> +	xfs_irele(cip);
>   out:
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 65810827a8d0..e9508ba01ed1 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -114,7 +114,7 @@ xfs_bulkstat_one_int(
>  		break;
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -	IRELE(ip);
> +	xfs_irele(ip);
>  
>  	error = formatter(buffer, ubsize, ubused, buf);
>  	if (!error)
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b181b5f57a19..8fa6730653ae 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5094,11 +5094,11 @@ xlog_recover_process_one_iunlink(
>  	 */
>  	ip->i_d.di_dmevmask = 0;
>  
> -	IRELE(ip);
> +	xfs_irele(ip);
>  	return agino;
>  
>   fail_iput:
> -	IRELE(ip);
> +	xfs_irele(ip);
>   fail:
>  	/*
>  	 * We can't read in the inode this bucket points to, or this inode
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 4fb361cde32a..8f739e4d0d1c 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1039,7 +1039,7 @@ xfs_mountfs(
>   out_rtunmount:
>  	xfs_rtunmount_inodes(mp);
>   out_rele_rip:
> -	IRELE(rip);
> +	xfs_irele(rip);
>  	/* Clean out dquots that might be in memory after quotacheck. */
>  	xfs_qm_unmount(mp);
>  	/*
> @@ -1095,7 +1095,7 @@ xfs_unmountfs(
>  	xfs_fs_unreserve_ag_blocks(mp);
>  	xfs_qm_unmount_quotas(mp);
>  	xfs_rtunmount_inodes(mp);
> -	IRELE(mp->m_rootip);
> +	xfs_irele(mp->m_rootip);
>  
>  	/*
>  	 * We can potentially deadlock here if we have an inode cluster
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9ceb85cce33a..52ed7904df10 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -231,15 +231,15 @@ xfs_qm_unmount_quotas(
>  	 */
>  	if (mp->m_quotainfo) {
>  		if (mp->m_quotainfo->qi_uquotaip) {
> -			IRELE(mp->m_quotainfo->qi_uquotaip);
> +			xfs_irele(mp->m_quotainfo->qi_uquotaip);
>  			mp->m_quotainfo->qi_uquotaip = NULL;
>  		}
>  		if (mp->m_quotainfo->qi_gquotaip) {
> -			IRELE(mp->m_quotainfo->qi_gquotaip);
> +			xfs_irele(mp->m_quotainfo->qi_gquotaip);
>  			mp->m_quotainfo->qi_gquotaip = NULL;
>  		}
>  		if (mp->m_quotainfo->qi_pquotaip) {
> -			IRELE(mp->m_quotainfo->qi_pquotaip);
> +			xfs_irele(mp->m_quotainfo->qi_pquotaip);
>  			mp->m_quotainfo->qi_pquotaip = NULL;
>  		}
>  	}
> @@ -1200,12 +1200,12 @@ xfs_qm_dqusage_adjust(
>  			goto error0;
>  	}
>  
> -	IRELE(ip);
> +	xfs_irele(ip);
>  	*res = BULKSTAT_RV_DIDONE;
>  	return 0;
>  
>  error0:
> -	IRELE(ip);
> +	xfs_irele(ip);
>  	*res = BULKSTAT_RV_GIVEUP;
>  	return error;
>  }
> @@ -1575,11 +1575,11 @@ xfs_qm_init_quotainos(
>  
>  error_rele:
>  	if (uip)
> -		IRELE(uip);
> +		xfs_irele(uip);
>  	if (gip)
> -		IRELE(gip);
> +		xfs_irele(gip);
>  	if (pip)
> -		IRELE(pip);
> +		xfs_irele(pip);
>  	return error;
>  }
>  
> @@ -1588,15 +1588,15 @@ xfs_qm_destroy_quotainos(
>  	xfs_quotainfo_t	*qi)
>  {
>  	if (qi->qi_uquotaip) {
> -		IRELE(qi->qi_uquotaip);
> +		xfs_irele(qi->qi_uquotaip);
>  		qi->qi_uquotaip = NULL; /* paranoia */
>  	}
>  	if (qi->qi_gquotaip) {
> -		IRELE(qi->qi_gquotaip);
> +		xfs_irele(qi->qi_gquotaip);
>  		qi->qi_gquotaip = NULL;
>  	}
>  	if (qi->qi_pquotaip) {
> -		IRELE(qi->qi_pquotaip);
> +		xfs_irele(qi->qi_pquotaip);
>  		qi->qi_pquotaip = NULL;
>  	}
>  }
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index abc8a21e3a82..2c51f2992d3d 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -189,15 +189,15 @@ xfs_qm_scall_quotaoff(
>  	 * Release our quotainode references if we don't need them anymore.
>  	 */
>  	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
> -		IRELE(q->qi_uquotaip);
> +		xfs_irele(q->qi_uquotaip);
>  		q->qi_uquotaip = NULL;
>  	}
>  	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
> -		IRELE(q->qi_gquotaip);
> +		xfs_irele(q->qi_gquotaip);
>  		q->qi_gquotaip = NULL;
>  	}
>  	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
> -		IRELE(q->qi_pquotaip);
> +		xfs_irele(q->qi_pquotaip);
>  		q->qi_pquotaip = NULL;
>  	}
>  
> @@ -250,7 +250,7 @@ xfs_qm_scall_trunc_qfile(
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>  out_put:
> -	IRELE(ip);
> +	xfs_irele(ip);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 205fbb2a77e4..a7c0c657dfaf 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -45,7 +45,7 @@ xfs_qm_fill_state(
>  	tstate->ino_warnlimit = q->qi_iwarnlimit;
>  	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
>  	if (tempqip)
> -		IRELE(ip);
> +		xfs_irele(ip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 329d4d26c13e..ae592a2d5ce2 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1215,7 +1215,7 @@ xfs_rtmount_inodes(
>  	ASSERT(sbp->sb_rsumino != NULLFSINO);
>  	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
>  	if (error) {
> -		IRELE(mp->m_rbmip);
> +		xfs_irele(mp->m_rbmip);
>  		return error;
>  	}
>  	ASSERT(mp->m_rsumip != NULL);
> @@ -1227,9 +1227,9 @@ xfs_rtunmount_inodes(
>  	struct xfs_mount	*mp)
>  {
>  	if (mp->m_rbmip)
> -		IRELE(mp->m_rbmip);
> +		xfs_irele(mp->m_rbmip);
>  	if (mp->m_rsumip)
> -		IRELE(mp->m_rsumip);
> +		xfs_irele(mp->m_rsumip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 3783afcb68d2..7f85342a09e6 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -381,7 +381,7 @@ xfs_symlink(
>  	 */
>  	if (ip) {
>  		xfs_finish_inode_setup(ip);
> -		IRELE(ip);
> +		xfs_irele(ip);
>  	}
>  
>  	xfs_qm_dqrele(udqp);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
