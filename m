Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 09:52:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DGqCOA003436
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 09:52:12 -0700
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF5FD1ADEC4D
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 09:53:42 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by cuda.sgi.com with ESMTP id Vf5BSEo9Nuojj3EU for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 09:53:42 -0700 (PDT)
Date: Sat, 13 Sep 2008 12:53:41 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 01/10] XFS: split out two helpers from xfs_syncsub
Message-ID: <20080913165341.GA17721@josefsipek.net>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com> <1221314230-28618-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314230-28618-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 11:57:01PM +1000, Dave Chinner wrote:
...
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 53d85ec..59da332 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -315,6 +315,93 @@ xfs_sync_inodes(
>  	return XFS_ERROR(last_error);
>  }
>  
> +STATIC int
> +xfs_commit_dummy_trans(
> +	struct xfs_mount	*mp,
> +	uint			log_flags)
> +{
> +	struct xfs_inode	*ip = mp->m_rootip;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	/*
> +	 * Put a dummy transaction in the log to tell recovery
> +	 * that all others are OK.
> +	 */
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
> +	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		return error;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ihold(tp, ip);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	/* XXX(hch): ignoring the error here.. */

Why? Was this supposed to be ignored in the final version of these patches?

> +	error = xfs_trans_commit(tp, 0);
> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	xfs_log_force(mp, 0, log_flags);
> +	return 0;
> +}

Josef 'Jeff' Sipek.

-- 
UNIX is user-friendly ... it's just selective about who its friends are
