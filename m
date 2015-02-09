Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 326D27F90
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 09:20:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F36CD8F8073
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 07:20:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6qtSGlKrnNdtLbTT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 07:20:49 -0800 (PST)
Date: Mon, 9 Feb 2015 10:20:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 11/18] xfs: randomly do sparse inode allocations in
	DEBUG mode
Message-ID: <20150209152044.GE18336@laptop.bfoster>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-12-git-send-email-bfoster@redhat.com>
	<20150208230232.GH4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150208230232.GH4251@dastard>
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

On Mon, Feb 09, 2015 at 10:02:32AM +1100, Dave Chinner wrote:
> On Fri, Feb 06, 2015 at 02:52:58PM -0500, Brian Foster wrote:
> > Sparse inode allocations generally only occur when full inode chunk
> > allocation fails. This requires some level of filesystem space usage and
> > fragmentation.
> > 
> > For filesystems formatted with sparse inode chunks enabled, do random
> > sparse inode chunk allocs when compiled in DEBUG mode to increase test
> > coverage.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 090d114..3e5d3eb 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -652,9 +652,18 @@ xfs_ialloc_ag_alloc(
> >  
> >  	struct xfs_perag *pag;
> >  
> > +#ifdef DEBUG
> > +	int		do_sparse = 0;
> > +
> > +	/* randomly do sparse inode allocations */
> > +	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb))
> > +		do_sparse = prandom_u32() & 1;
> > +#endif
> > +
> 
> Bit ugly with all the ifdefs. If you define the do_sparse variable
> outside the ifdef, then the rest of the code other than this check
> doesn't need ifdefs.
> 

Ok.

> >  	memset(&args, 0, sizeof(args));
> >  	args.tp = tp;
> >  	args.mp = tp->t_mountp;
> > +	args.fsbno = NULLFSBLOCK;
> >  
> >  	/*
> >  	 * Locking will ensure that we don't have two callers in here
> > @@ -675,6 +684,10 @@ xfs_ialloc_ag_alloc(
> >  	agno = be32_to_cpu(agi->agi_seqno);
> >  	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
> >  		     args.mp->m_ialloc_blks;
> > +#ifdef DEBUG
> > +	if (do_sparse)
> > +		goto sparse_alloc;
> > +#endif
> >  	if (likely(newino != NULLAGINO &&
> >  		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
> >  		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
> > @@ -713,8 +726,7 @@ xfs_ialloc_ag_alloc(
> >  		 * subsequent requests.
> >  		 */
> >  		args.minalignslop = 0;
> > -	} else
> > -		args.fsbno = NULLFSBLOCK;
> > +	}
> >  
> >  	if (unlikely(args.fsbno == NULLFSBLOCK)) {
> >  		/*
> > @@ -769,6 +781,9 @@ xfs_ialloc_ag_alloc(
> >  	 * Finally, try a sparse allocation if the filesystem supports it and
> >  	 * the sparse allocation length is smaller than a full chunk.
> >  	 */
> > +#ifdef DEBUG
> > +sparse_alloc:
> > +#endif
> >  	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
> >  	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks &&
> >  	    args.fsbno == NULLFSBLOCK) {
> 
> The label can go after the if() statement, right? We've already
> guaranteed all those other parameters are true, though I suspect
> there's a case where that m_ialloc_min_blks < m_ialloc_blks will
> fail: block size larger than inode chunk size (e.g. 64k block size, 512
> byte inodes) so that would result in the code above failing to
> allocate any inode chunks at all...
> 

Hmm, yeah I added that blks comparison recently simply to prevent
another allocation attempt on such systems where the block size is >=
the chunk size.

This changes behavior of such systems either way, but debug mode has
that effect regardless I suppose. We hit a codepath that we wouldn't
normally hit in that large bsize configuration, but it's debug mode and
the alignment/size of the allocation should be equivalent to the
original allocation code so I think it should be fine to move the label.

Brian

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
