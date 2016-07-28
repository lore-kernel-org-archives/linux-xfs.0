Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45B787CA0
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 13:58:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9137DAC009
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 11:58:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uHizhFpydGzm3fAu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jul 2016 11:58:27 -0700 (PDT)
Date: Thu, 28 Jul 2016 11:58:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/47] xfs: fix locking of the rt bitmap/summary inodes
Message-ID: <20160728185820.GC15753@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907698690.25461.7316591529865921141.stgit@birch.djwong.org>
	<20160726163607.GB31917@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160726163607.GB31917@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Tue, Jul 26, 2016 at 12:36:07PM -0400, Brian Foster wrote:
> On Wed, Jul 20, 2016 at 09:56:26PM -0700, Darrick J. Wong wrote:
> > When we're deleting realtime extents, we need to lock the summary
> > inode in case we need to update the summary info to prevent an assert
> > on the rsumip inode lock on a debug kernel.  While we're at it, fix
> > the locking annotations so that we avoid triggering lockdep warnings.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I haven't tried the rt stuff in quite some time (and even then never
> really played with it much). What's the assert that fails?

The first assert that I noticed is in xfs_rtfree_extent():

ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));

I then noticed that we weren't locking the summary inode either, which
triggers this assert in xfs_bmapi_read():

ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));

which has this call stack:

xfs_rtfree_extent -> xfs_rtmodify_summary -> xfs_rtmodify_summary_int ->
xfs_rtbuf_get -> xfs_bmapi_read.

--D

> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_bmap.c |    4 +++-
> >  fs/xfs/xfs_bmap_util.c   |    4 ++--
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 2f2c85c..c5981f4 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5179,8 +5179,10 @@ xfs_bunmapi(
> >  		/*
> >  		 * Synchronize by locking the bitmap inode.
> >  		 */
> > -		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> > +		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> >  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> > +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> > +		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> >  	}
> >  
> >  	extno = 0;
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index cd4a850..998c3e6 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -214,9 +214,9 @@ xfs_bmap_rtalloc(
> >  	/*
> >  	 * Lock out modifications to both the RT bitmap and summary inodes
> >  	 */
> > -	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> > +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> >  	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> > -	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> > +	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> >  	xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> >  
> >  	/*
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
