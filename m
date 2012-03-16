Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GH7jHS105102 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 12:07:45 -0500
Message-ID: <4F63735D.5040302@sgi.com>
Date: Fri, 16 Mar 2012 12:07:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/10] xfs: initialise xfssync work before running
	quotachecks
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-9-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/06/12 22:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Because the mount process can run a quotacheck and consume lots of
> inodes, we need to be able to run periodic inode reclaim during the
> mount process. This will prevent running the system out of memory
> during quota checks.
>
> This essentially reverts 2bcf6e97, but that is safe to do now that
> the quota sync code that was causing problems during long quotacheck
> executions is now gone.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_super.c |   15 ++++++++-------
>   1 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 13fa0cf..150d8f4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1343,22 +1343,22 @@ xfs_fs_fill_super(

>   	/*
>   	 * Blow away any referenced inode in the filestreams cache.
> @@ -1397,6 +1397,7 @@ xfs_fs_fill_super(
>   	xfs_flush_buftarg(mp->m_ddev_targp, 1);
>
>   	xfs_unmountfs(mp);
> +	xfs_syncd_stop(mp);
>   	goto out_free_sb;
>   }
>


Shouldn't the xfs_syncd_stop() preceed the xfs_unmountfs()?

xfs_unmountfs() calls xfs_free_perag() and there is an iterator in inode 
and data sync workers.

Mark Tinguely
<tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
