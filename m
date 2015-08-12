Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 68CCB7F3F
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 07:48:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5486D8F8037
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 05:48:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ukXIjMDyrbNKoWm3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 05:48:42 -0700 (PDT)
Date: Wed, 12 Aug 2015 08:48:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 13/13] xfs: add missing bmap cancel calls in error paths
Message-ID: <20150812124840.GC20635@bfoster.bfoster>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439233309-19959-14-git-send-email-bfoster@redhat.com>
	<20150812072109.GC14237@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150812072109.GC14237@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 12, 2015 at 12:21:09AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 10, 2015 at 03:01:49PM -0400, Brian Foster wrote:
> > If a failure occurs after the bmap free list is populated and before
> > xfs_bmap_finish() completes successfully (which returns a partial list
> > on failure), the bmap free list must be cancelled. Otherwise, the extent
> > items on the list are never freed and a memory leak occurs.
> > 
> > Several random error paths throughout the code suffer this problem. Fix
> > these up such that xfs_bmap_cancel() is always called on error.
> 
> Looks sensible.  I wonder if we should attach the freelist to the
> transaction and make xfs_trans_commit call into bmap_finish and
> xfs_trans_cancel into xfs_bmap_cancel in the longer run?
> 

Perhaps... that's an interesting thought. I guess we'd also need to
consider other transaction operations (i.e., xfs_trans_roll()) to
support patterns such as that in xfs_attr_set(), for example. That one
also joins the inode between handling of the free list and transaction
commit, so that would need to be pushed down one way or another.

I wonder if there are enough vanilla bmap_finish()->trans_commit()
callers (e.g., without any intermediate code) to justify creation of a
new higher level xfs_trans_bmap_finish_commit() helper or some such that
handles both (retaining the existing interfaces for everything else).

> > +STATIC int
> >  xfs_growfs_rt_alloc(
> > -	xfs_mount_t	*mp,		/* file system mount point */
> > -	xfs_extlen_t	oblocks,	/* old count of blocks */
> > -	xfs_extlen_t	nblocks,	/* new count of blocks */
> > -	xfs_inode_t	*ip)		/* inode (bitmap/summary) */
> > +	struct xfs_mount	*mp,		/* file system mount point */
> > +	xfs_extlen_t		oblocks,	/* old count of blocks */
> > +	xfs_extlen_t		nblocks,	/* new count of blocks */
> > +	struct xfs_inode	*ip)		/* inode (bitmap/summary) */
> >  {
> > -	xfs_fileoff_t	bno;		/* block number in file */
> > -	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
> > -	int		committed;	/* transaction committed flag */
> > -	xfs_daddr_t	d;		/* disk block address */
> > -	int		error;		/* error return value */
> > -	xfs_fsblock_t	firstblock;	/* first block allocated in xaction */
> > -	xfs_bmap_free_t	flist;		/* list of freed blocks */
> > -	xfs_fsblock_t	fsbno;		/* filesystem block for bno */
> > -	xfs_bmbt_irec_t	map;		/* block map output */
> > -	int		nmap;		/* number of block maps */
> > -	int		resblks;	/* space reservation */
> > +	xfs_fileoff_t		bno;		/* block number in file */
> > +	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
> > +	int			committed;	/* transaction committed flag */
> > +	xfs_daddr_t		d;		/* disk block address */
> > +	int			error;		/* error return value */
> > +	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
> > +	struct xfs_bmap_free	flist;		/* list of freed blocks */
> > +	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
> > +	struct xfs_bmbt_irec	map;		/* block map output */
> > +	int			nmap;		/* number of block maps */
> > +	int			resblks;	/* space reservation */
> > +	struct xfs_trans	*tp;
> 
> Do we really need all this unrelated reformatting?

No, I've just been conditioned at this point to try and fix up any of
the typedefs that I notice in functions I touch so we can eventually
kill them. This was RT code, so I suspect isn't touched often and ended
up larger than typical.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
