Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 09:57:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DGvRgX004007
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 09:57:27 -0700
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25B95126C5F2
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 09:58:57 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by cuda.sgi.com with ESMTP id tO0ZkqDcT6f88RtE for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 09:58:57 -0700 (PDT)
Date: Sat, 13 Sep 2008 12:58:56 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 05/10] XFS: xfssyncd: don't call xfs_sync
Message-ID: <20080913165856.GB17721@josefsipek.net>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com> <1221314230-28618-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314230-28618-6-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 11:57:05PM +1000, Dave Chinner wrote:
...
> @@ -533,8 +538,15 @@ xfs_sync_worker(
>  {
>  	int		error;
>  
> -	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
> -		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
> +	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
> +		xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
> +		/* dgc: errors ignored here */

Again, why?

> +		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
> +		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
> +		if (xfs_log_need_covered(mp))
> +			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
> +	}
>  	mp->m_sync_seq++;
>  	wake_up(&mp->m_wait_single_sync_task);
>  }

Josef 'Jeff' Sipek.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds
