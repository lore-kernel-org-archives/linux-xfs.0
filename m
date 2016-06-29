Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8ABF07CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 17:21:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C60F304039
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 15:21:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jfVay85hxJBo2SNQ for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2016 15:21:44 -0700 (PDT)
Date: Thu, 30 Jun 2016 08:21:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: lock the rt summary inode when unmapping realtime
	extents
Message-ID: <20160629222142.GQ12670@dastard>
References: <20160629200234.GE4917@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160629200234.GE4917@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 29, 2016 at 01:02:34PM -0700, Darrick J. Wong wrote:
> When we're deleting realtime extents, lock the summary inode
> in case we need to update the summary info.  This prevents an
> assert on the rsumip inode lock on a debug kernel.
> 
> (Same idea as "xfs: lock rt summary inode on allocation".)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 97820c1..9c7227b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5524,6 +5524,8 @@ __xfs_bunmapi(
>  		 */
>  		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);

These need a lockdep annotations, right? i.e.

	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);

Because they are nested inside the inode ilock?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
