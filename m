Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728919AbeG3UJT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 16:09:19 -0400
Date: Mon, 30 Jul 2018 14:33:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/14] xfs: repair the AGF
Message-ID: <20180730183300.GF35107@bfoster>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
 <153292968232.24509.16936110804102265045.stgit@magnolia>
 <20180730162224.GB35107@bfoster>
 <20180730173111.GY30972@magnolia>
 <20180730181914.GD35107@bfoster>
 <20180730182231.GZ30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730182231.GZ30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Mon, Jul 30, 2018 at 11:22:31AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 30, 2018 at 02:19:15PM -0400, Brian Foster wrote:
> > On Mon, Jul 30, 2018 at 10:31:11AM -0700, Darrick J. Wong wrote:
> > > On Mon, Jul 30, 2018 at 12:22:24PM -0400, Brian Foster wrote:
> > > > On Sun, Jul 29, 2018 at 10:48:02PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Regenerate the AGF from the rmap data.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  fs/xfs/scrub/agheader_repair.c |  370 ++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/scrub/repair.c          |   27 ++-
> > > > >  fs/xfs/scrub/repair.h          |    4 
> > > > >  fs/xfs/scrub/scrub.c           |    2 
> > > > >  4 files changed, 393 insertions(+), 10 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > > > > index 1e96621ece3a..4842fc598c9b 100644
> > > > > --- a/fs/xfs/scrub/agheader_repair.c
> > > > > +++ b/fs/xfs/scrub/agheader_repair.c
> > > > ...
> > > > > @@ -54,3 +61,366 @@ xrep_superblock(
> > > > ...
> > > > > +/* Repair the AGF. v5 filesystems only. */
> > > > > +int
> > > > > +xrep_agf(
> > > > > +	struct xfs_scrub		*sc)
> > > > > +{
> > > > ...
> > > > > +	/* Start rewriting the header and implant the btrees we found. */
> > > > > +	xrep_agf_init_header(sc, agf_bp, &old_agf);
> > > > > +	xrep_agf_set_roots(sc, agf, fab);
> > > > > +	error = xrep_agf_calc_from_btrees(sc, agf_bp);
> > > > > +	if (error)
> > > > > +		goto out_revert;
> > > > > +
> > > > > +	/* Commit the changes and reinitialize incore state. */
> > > > > +	return xrep_agf_commit_new(sc, agf_bp);
> > > > > +
> > > > > +out_revert:
> > > > > +	/* Mark the incore AGF state stale and revert the AGF. */
> > > > > +	sc->sa.pag->pagf_init = 0;
> > > > 
> > > > Hmm, looking at this again I'm not sure it's safe to reset ->pagf_init
> > > > like this. The contexts where we hold agf might be Ok because I think
> > > > that might prevent some other thread from actually coming in and
> > > > resetting it, but look at xfs_alloc_read_agf() does in this case if the
> > > > agf becomes available with !pagf_init. Specifically, are we at risk of
> > > > corrupting a populated ->pagb_tree or causing other problems by
> > > > reinitializing the spinlock? Perhaps we need another patch to separate
> > > > out some of those fields that should only ever be initialized once.
> > > 
> > > Yikes, the pagb_tree & spinlock should not get reinitialized.  I don't
> > > see where we ever tear them down except for unmount, so I *think* we can
> > > move it to xfs_initialize_perag.  It's a little mystifying why we don't
> > > initialze those things there like we do for the incore inode radix tree.
> > > 
> > > Also it would finally fix the discrepancy with xfsprogs libxfs where
> > > they comment out the RB_ROOT initialization.
> > > 
> > > > With something like that, it might subsequently make sense to factor the
> > > > reinit from disk bits into a helper to be shared between
> > > > xrep_agf_commit_new() and xfs_allo_read_agf(). I also wonder if it's
> > > > sufficient to just update the agf on disk and leave pagf_init == 0.
> > > 
> > > Hmm, wasn't there some verifier that used pag*_init (can't remember
> > > which one) to decide if we were in log recovery?
> > > 
> > 
> > It looks like xfs_attr3_leaf_verify() might do something like that. But
> > don't we have to handle that either way if the error path leaves
> > pagf_init == 0 on return? Actually we might have to address it
> > regardless if we want to use pagf_init if that path isn't holding the
> > agf.
> 
> <nod> I think we should simply add a xlog helper that decides if the log
> is in recovery and call it from xfs_attr3_leaf_verify rather than having
> an open-coded check on some other data structure.
> 

Agreed.

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Otherwise the rest of this patch seems Ok to me.
> > > > 
> > > > Brian
> > > > 
> > > > > +	memcpy(agf, &old_agf, sizeof(old_agf));
> > > > > +	return error;
> > > > > +}
> > > > > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > > > > index 85b048b341a0..17cf48564390 100644
> > > > > --- a/fs/xfs/scrub/repair.c
> > > > > +++ b/fs/xfs/scrub/repair.c
> > > > > @@ -128,9 +128,12 @@ xrep_roll_ag_trans(
> > > > >  	int			error;
> > > > >  
> > > > >  	/* Keep the AG header buffers locked so we can keep going. */
> > > > > -	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> > > > > -	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> > > > > -	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
> > > > > +	if (sc->sa.agi_bp)
> > > > > +		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> > > > > +	if (sc->sa.agf_bp)
> > > > > +		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> > > > > +	if (sc->sa.agfl_bp)
> > > > > +		xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
> > > > >  
> > > > >  	/* Roll the transaction. */
> > > > >  	error = xfs_trans_roll(&sc->tp);
> > > > > @@ -138,9 +141,12 @@ xrep_roll_ag_trans(
> > > > >  		goto out_release;
> > > > >  
> > > > >  	/* Join AG headers to the new transaction. */
> > > > > -	xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> > > > > -	xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> > > > > -	xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
> > > > > +	if (sc->sa.agi_bp)
> > > > > +		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> > > > > +	if (sc->sa.agf_bp)
> > > > > +		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> > > > > +	if (sc->sa.agfl_bp)
> > > > > +		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
> > > > >  
> > > > >  	return 0;
> > > > >  
> > > > > @@ -150,9 +156,12 @@ xrep_roll_ag_trans(
> > > > >  	 * buffers will be released during teardown on our way out
> > > > >  	 * of the kernel.
> > > > >  	 */
> > > > > -	xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> > > > > -	xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> > > > > -	xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> > > > > +	if (sc->sa.agi_bp)
> > > > > +		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> > > > > +	if (sc->sa.agf_bp)
> > > > > +		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> > > > > +	if (sc->sa.agfl_bp)
> > > > > +		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> > > > >  
> > > > >  	return error;
> > > > >  }
> > > > > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > > > > index 5a4e92221916..1d283360b5ab 100644
> > > > > --- a/fs/xfs/scrub/repair.h
> > > > > +++ b/fs/xfs/scrub/repair.h
> > > > > @@ -58,6 +58,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
> > > > >  
> > > > >  int xrep_probe(struct xfs_scrub *sc);
> > > > >  int xrep_superblock(struct xfs_scrub *sc);
> > > > > +int xrep_agf(struct xfs_scrub *sc);
> > > > > +int xrep_agfl(struct xfs_scrub *sc);
> > > > >  
> > > > >  #else
> > > > >  
> > > > > @@ -81,6 +83,8 @@ xrep_calc_ag_resblks(
> > > > >  
> > > > >  #define xrep_probe			xrep_notsupported
> > > > >  #define xrep_superblock			xrep_notsupported
> > > > > +#define xrep_agf			xrep_notsupported
> > > > > +#define xrep_agfl			xrep_notsupported
> > > > >  
> > > > >  #endif /* CONFIG_XFS_ONLINE_REPAIR */
> > > > >  
> > > > > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > > > > index 6efb926f3cf8..1e8a17c8e2b9 100644
> > > > > --- a/fs/xfs/scrub/scrub.c
> > > > > +++ b/fs/xfs/scrub/scrub.c
> > > > > @@ -214,7 +214,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> > > > >  		.type	= ST_PERAG,
> > > > >  		.setup	= xchk_setup_fs,
> > > > >  		.scrub	= xchk_agf,
> > > > > -		.repair	= xrep_notsupported,
> > > > > +		.repair	= xrep_agf,
> > > > >  	},
> > > > >  	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
> > > > >  		.type	= ST_PERAG,
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
