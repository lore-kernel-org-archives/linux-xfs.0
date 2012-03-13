Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLsDTO074550 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:54:13 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iEb7bjoj4bjod9xe for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 14:54:11 -0700 (PDT)
Date: Wed, 14 Mar 2012 08:54:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: remove the per-filesystem list of dquots
Message-ID: <20120313215409.GI5091@dastard>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.997632929@bombadil.infradead.org>
	<20120313200354.GI7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313200354.GI7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 13, 2012 at 03:03:54PM -0500, Ben Myers wrote:
> Hey Christoph,
> 
> On Tue, Mar 13, 2012 at 04:52:36AM -0400, Christoph Hellwig wrote:
> > Instead of keeping a separate per-filesystem list of dquots we can walk
> > the radix tree for the two places where we need to iterate all quota
> > structures.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > ---
> >  fs/xfs/xfs_dquot.c |   37 ++----
> >  fs/xfs/xfs_dquot.h |    3 
> >  fs/xfs/xfs_qm.c    |  283 +++++++++++++++++++++++------------------------------
> >  fs/xfs/xfs_qm.h    |    4 
> >  4 files changed, 142 insertions(+), 185 deletions(-)
> > 
> > V2: remove the useless flags/type argument to the iterator callbacks
> >
> 
> ...
> 
> > Index: xfs/fs/xfs/xfs_qm.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_qm.c	2012-03-13 09:37:53.236788274 +0100
> > +++ xfs/fs/xfs/xfs_qm.c	2012-03-13 09:39:32.823456788 +0100
> > @@ -169,6 +169,196 @@ xfs_qm_rele_quotafs_ref(
> >  }
> >  
> >  /*
> > + * We use the batch lookup interface to iterate over the dquots as it
> > + * currently is the only interface into the radix tree code that allows
> > + * fuzzy lookups instead of exact matches.  Holding the lock over multiple
> > + * operations is fine as all callers are used either during mount/umount
> > + * or quotaoff.
> > + */
> > +#define XFS_DQ_LOOKUP_BATCH	32
> > +
> > +STATIC int
> > +xfs_qm_dquot_walk(
> > +	struct xfs_mount	*mp,
> > +	int			type,
> > +	int			(*execute)(struct xfs_dquot *dqp))
> > +{
> > +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> > +	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
> > +	uint32_t		next_index;
> > +	int			last_error = 0;
> > +	int			skipped;
> > +	int			nr_found;
> > +
> > +restart:
> > +	skipped = 0;
> > +	next_index = 0;
> > +	nr_found = 0;
> > +
> > +	while (1) {
> > +		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
> 
> Eesh.. that probably doesn't need to go onto the stack.  I know we are
> doing it elsewhere too, and that we also sometimes complain about other
> peoples' stack usage.  Don't necessarily have to clean it up now,
> though.  ;)

Actually, if we do the walk from the shrinker we can't reliably
allocate it, so it has to go on the stack. That being said, there
are optimised generic radix tree walk methods being worked on, so
this will go away soon...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
