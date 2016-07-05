Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FB957CAF
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 22:36:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00924304053
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 20:36:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7aQwXJr9EFK5E7Fd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jul 2016 20:36:37 -0700 (PDT)
Date: Mon, 4 Jul 2016 20:36:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: lock the rt summary inode when unmapping realtime
	extents
Message-ID: <20160705033628.GB16957@birch.djwong.org>
References: <20160629200234.GE4917@birch.djwong.org>
	<20160629222142.GQ12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160629222142.GQ12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2016 at 08:21:42AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2016 at 01:02:34PM -0700, Darrick J. Wong wrote:
> > When we're deleting realtime extents, lock the summary inode
> > in case we need to update the summary info.  This prevents an
> > assert on the rsumip inode lock on a debug kernel.
> > 
> > (Same idea as "xfs: lock rt summary inode on allocation".)
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 97820c1..9c7227b 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5524,6 +5524,8 @@ __xfs_bunmapi(
> >  		 */
> >  		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> >  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> > +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> > +		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> 
> These need a lockdep annotations, right? i.e.
> 
> 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> 	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> 
> Because they are nested inside the inode ilock?

Yes, they do, as does the other _ilock(rbmip) in xfs_bmap_util.c.
Will send updated patch.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
