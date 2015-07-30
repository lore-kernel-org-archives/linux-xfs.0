Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 609807F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 14:09:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EABCFAC001
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 12:09:24 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OtThKQDuFGj6DkSz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 12:09:14 -0700 (PDT)
Date: Thu, 30 Jul 2015 12:09:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/24] xfs: refcount btree add more reserved blocks
Message-ID: <20150730190907.GH10043@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223324.17414.85659.stgit@birch.djwong.org>
	<20150730003517.GH16638@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150730003517.GH16638@dastard>
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

On Thu, Jul 30, 2015 at 10:35:17AM +1000, Dave Chinner wrote:
> On Wed, Jul 29, 2015 at 03:33:24PM -0700, Darrick J. Wong wrote:
> > Since XFS reserves a small amount of space in each AG as the minimum
> > free space needed for an operation, save some more space in case we
> > touch the refcount btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c  |   13 +++++++++++++
> >  fs/xfs/libxfs/xfs_format.h |    2 ++
> >  2 files changed, 15 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 40e8129..cb6b3d9 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -50,10 +50,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
> >  STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
> >  		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
> >  
> > +unsigned int
> > +XFS_REFC_BLOCK(
> 
> No need to shout for functions.

OK, er, ok. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
