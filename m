Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39402 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933000AbeF1JHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 05:07:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id p11-v6so8133639wmc.4
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 02:07:13 -0700 (PDT)
Date: Thu, 28 Jun 2018 11:07:10 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Fix coverity scan reports
Message-ID: <20180628090710.fxwwnf6bhcjhrwsv@odin.usersys.redhat.com>
References: <20180621123525.5365-1-cmaiolino@redhat.com>
 <20180621162643.GC4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180621162643.GC4838@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi,


> > CID 100898
> > CID 1437081
> > CID 1437129
> > CID 1437191
> > CID 1437201
> > CID 1437212
> > CID 1437341
> 
> These all have to do with the xfs_warn() at the bottom of
> xfs_alloc_get_rec() referencing *bno before we set it but after we've
> decided that the record is bad.  Why not just fix by changing it to:
> 
> xfs_warn(mp, "start block 0x%x block count 0x%x",
> 		rec->alloc.ar_startblock, rec->alloc.ar_blockcount);
> 

I do apologize to take so long to reply to this thread, couldn't come back to it
until now.

Thanks for pointing it to xfs_warn() I had the same impression that Eric
described (or similar), that coverity was complaining we passed it into
xfs_alloc_get_rec() uninitialized, and generating false positives.

After reading your reply I went to check the reports in coverity system and
found out all of them pointing to xfs_warn...

Well, next time I'll make sure to check the reports on their system before
submitting any patch :P

In the mean time I'll re-do the patch as you suggested, although, the values are
in BigEndian, so I believe they should be converted before printed.

Well, I'll re-send the patch and we discuss it there.

Thanks again

> --D
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > There is another coverity issue (CID 1437358), which actually looks more
> > important, which really looks to pass an uninitialized value to
> > xfs_getfsmap_rtdev_rtbitmap_helper(), where such looks to expect the variable to
> > be already initialized. I'm familiar with RT code, so looking into it yet, but
> > I think this one deservers a separated patch if that can really trigger a bug.
> > 
> >  fs/xfs/libxfs/xfs_alloc.c | 14 +++++++-------
> >  fs/xfs/scrub/agheader.c   |  4 ++--
> >  fs/xfs/scrub/alloc.c      |  2 +-
> >  3 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index eef466260d43..ffdd50f5af32 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -421,8 +421,8 @@ xfs_alloc_fixup_trees(
> >  {
> >  	int		error;		/* error code */
> >  	int		i;		/* operation results */
> > -	xfs_agblock_t	nfbno1;		/* first new free startblock */
> > -	xfs_agblock_t	nfbno2;		/* second new free startblock */
> > +	xfs_agblock_t	nfbno1=0;	/* first new free startblock */
> > +	xfs_agblock_t	nfbno2=0;	/* second new free startblock */
> >  	xfs_extlen_t	nflen1=0;	/* first new free length */
> >  	xfs_extlen_t	nflen2=0;	/* second new free length */
> >  	struct xfs_mount *mp;
> > @@ -783,8 +783,8 @@ xfs_alloc_ag_vextent_exact(
> >  	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
> >  	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
> >  	int		error;
> > -	xfs_agblock_t	fbno;	/* start block of found extent */
> > -	xfs_extlen_t	flen;	/* length of found extent */
> > +	xfs_agblock_t	fbno=0;	/* start block of found extent */
> > +	xfs_extlen_t	flen=0;	/* length of found extent */
> >  	xfs_agblock_t	tbno;	/* start block of busy extent */
> >  	xfs_extlen_t	tlen;	/* length of busy extent */
> >  	xfs_agblock_t	tend;	/* end block of busy extent */
> > @@ -1597,7 +1597,7 @@ xfs_alloc_ag_vextent_small(
> >  	int		error;
> >  	xfs_agblock_t	fbno;
> >  	xfs_extlen_t	flen;
> > -	int		i;
> > +	int		i = 0;
> >  
> >  	if ((error = xfs_btree_decrement(ccur, 0, &i)))
> >  		goto error0;
> > @@ -1704,8 +1704,8 @@ xfs_free_ag_extent(
> >  	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
> >  	xfs_btree_cur_t	*cnt_cur;	/* cursor for by-size btree */
> >  	int		error;		/* error return value */
> > -	xfs_agblock_t	gtbno;		/* start of right neighbor block */
> > -	xfs_extlen_t	gtlen;		/* length of right neighbor block */
> > +	xfs_agblock_t	gtbno=0;	/* start of right neighbor block */
> > +	xfs_extlen_t	gtlen=0;	/* length of right neighbor block */
> >  	int		haveleft;	/* have a left neighbor block */
> >  	int		haveright;	/* have a right neighbor block */
> >  	int		i;		/* temp, result code */
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 9bb0745f1ad2..78a7381d6ca0 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -388,8 +388,8 @@ xfs_scrub_agf_xref_cntbt(
> >  	struct xfs_scrub_context	*sc)
> >  {
> >  	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > -	xfs_agblock_t			agbno;
> > -	xfs_extlen_t			blocks;
> > +	xfs_agblock_t			agbno = 0;
> > +	xfs_extlen_t			blocks = 0;
> >  	int				have;
> >  	int				error;
> >  
> > diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> > index 50e4f7fa06f0..c82347da400f 100644
> > --- a/fs/xfs/scrub/alloc.c
> > +++ b/fs/xfs/scrub/alloc.c
> > @@ -47,7 +47,7 @@ xfs_scrub_allocbt_xref_other(
> >  	xfs_extlen_t			len)
> >  {
> >  	struct xfs_btree_cur		**pcur;
> > -	xfs_agblock_t			fbno;
> > +	xfs_agblock_t			fbno = 0;
> >  	xfs_extlen_t			flen;
> >  	int				has_otherrec;
> >  	int				error;
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
