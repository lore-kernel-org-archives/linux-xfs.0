Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE4637CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:24:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF272304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 13:24:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id L5RDD9sSuWBvFpAU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 13:24:34 -0700 (PDT)
Date: Tue, 2 Aug 2016 13:24:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/47] xfs: add tracepoints and error injection for
	deferred extent freeing
Message-ID: <20160802202425.GK8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907709074.25461.17602977707506082040.stgit@birch.djwong.org>
	<20160802184800.GB58152@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802184800.GB58152@bfoster.bfoster>
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

On Tue, Aug 02, 2016 at 02:48:00PM -0400, Brian Foster wrote:
> On Wed, Jul 20, 2016 at 09:58:10PM -0700, Darrick J. Wong wrote:
> > Add a couple of tracepoints for the deferred extent free operation and
> > a site for injecting errors while finishing the operation.  This makes
> > it easier to debug deferred ops and test log redo.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c |    7 +++++++
> >  fs/xfs/libxfs/xfs_bmap.c  |    2 ++
> >  fs/xfs/xfs_error.h        |    4 +++-
> >  fs/xfs/xfs_trace.h        |    5 ++++-
> >  4 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 5993f87..22ac3f1 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2702,6 +2702,13 @@ xfs_free_extent(
> >  
> >  	ASSERT(len != 0);
> >  
> > +	trace_xfs_bmap_free_deferred(mp, agno, 0, agbno, len);
> > +
> 
> Hmm, but the bmap code isn't the only caller here. I was thinking that
> maybe we'd be better served by pushing these down into xfs_defer_add()
> and friends, but I guess we don't necessarily have the extent
> information at that layer.

Correct, we don't.

> How about we just rename these tracepoints to match the function names
> so they don't confuse me in the future? :)

I broke with the function name convention so that the entry and exit
tracepoints to deferred items would all have names that easily matched
wildcards to make my life easier:

# trace-cmd record -e 'xfs_*_defer' -e 'xfs_*_deferred' -F ...

> > +	if (XFS_TEST_ERROR(false, mp,
> > +			XFS_ERRTAG_FREE_EXTENT,
> > +			XFS_RANDOM_FREE_EXTENT))
> > +		return -EIO;
> > +
> >  	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
> >  	if (error)
> >  		return error;
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 540a6b7..8e14ff4 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -596,6 +596,8 @@ xfs_bmap_add_free(
> >  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
> >  	new->xefi_startblock = bno;
> >  	new->xefi_blockcount = (xfs_extlen_t)len;
> > +	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
> > +			XFS_FSB_TO_AGBNO(mp, bno), len);
> >  	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> >  }
> >  
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index 2e4f67f..da6f951 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -90,7 +90,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> >  #define XFS_ERRTAG_STRATCMPL_IOERR			19
> >  #define XFS_ERRTAG_DIOWRITE_IOERR			20
> >  #define XFS_ERRTAG_BMAPIFORMAT				21
> > -#define XFS_ERRTAG_MAX					22
> > +#define XFS_ERRTAG_FREE_EXTENT				22
> > +#define XFS_ERRTAG_MAX					23
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -117,6 +118,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> >  #define XFS_RANDOM_STRATCMPL_IOERR			(XFS_RANDOM_DEFAULT/10)
> >  #define XFS_RANDOM_DIOWRITE_IOERR			(XFS_RANDOM_DEFAULT/10)
> >  #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
> > +#define XFS_RANDOM_FREE_EXTENT				1
> >  
> 
> Why not XFS_RANDOM_DEFAULT?

I don't want the injected redo errors going off at random -- I want to set
one and have it go off the very next time we hit it.  This way I can write
the xfstests like so:

mkfs/mount
write to a file; sync
set a logic bomb for the next time we free an extent
truncate the file
<watch bomb go off>
unmount
check that xfs_repair grumbles about the dirty log
mount
check the file

Were the free-extent bomb set to go off at XFS_RANDOM_DEFAULT intervals, it'd
only have a 1/100 chance of triggering, which makes it harder to test.

--D

> 
> Brian
> 
> >  #ifdef DEBUG
> >  extern int xfs_error_test_active;
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index a45b030..939caf5 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -2417,9 +2417,12 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
> >  
> > -DEFINE_PHYS_EXTENT_DEFERRED_EVENT(xfs_defer_phys_extent);
> >  DEFINE_MAP_EXTENT_DEFERRED_EVENT(xfs_defer_map_extent);
> >  
> > +#define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
> > +DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
> > +DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
