Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2L3SqQ183264 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 16:03:28 -0500
Date: Fri, 2 Nov 2012 16:05:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Remove redundant return error from xfs_difree()
Message-ID: <20121102210518.GH9783@sgi.com>
References: <5088BFD5.8060906@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5088BFD5.8060906@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

Hey Jeff,

On Thu, Oct 25, 2012 at 12:28:05PM +0800, Jeff Liu wrote:
> If we can not fetch the related a.g. info when freeing a disk inode, it mostly like a
> fatal issue was occurred and with ASSERT(0) is fine, however, return XFS_ERROR(EINVAL)
> does not make sense here.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/xfs/xfs_ialloc.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 445bf1a..b7ea965 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -1065,7 +1065,6 @@ xfs_difree(
>  		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
>  			__func__, agno, mp->m_sb.sb_agcount);
>  		ASSERT(0);
> -		return XFS_ERROR(EINVAL);
>  	}
>  	agino = XFS_INO_TO_AGINO(mp, inode);
>  	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
> @@ -1073,14 +1072,12 @@ xfs_difree(
>  			__func__, (unsigned long long)inode,
>  			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
>  		ASSERT(0);
> -		return XFS_ERROR(EINVAL);
>  	}
>  	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
>  	if (agbno >= mp->m_sb.sb_agblocks)  {
>  		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
>  			__func__, agbno, mp->m_sb.sb_agblocks);
>  		ASSERT(0);
> -		return XFS_ERROR(EINVAL);
>  	}
>  	/*
>  	 * Get the allocation group header.

Here the return of EINVAL is serving a useful purpose.  The ASSERT is only
activated when xfs debug is configured on, so there is a very real chance that
you might exercise this code.

My read on this is if you pass bad args to xfs_difree it will return EINVAL.
It's just a little defensive coding but it's worth keeping.  In this case it
will result in forced shutdown of the filesystem, which is much better than the
[unspecified] baddness that could happen later in xfs_difree if you have passed
in garbage args.

There... I got my FUD in for the day.  ;)

Thanks for the patch, but I think we need to pass on this one.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
