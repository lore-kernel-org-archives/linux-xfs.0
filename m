Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62916C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Apr 2022 00:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiDHAOb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiDHAOa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 20:14:30 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C433AF846C
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 17:12:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8A99C10E5768;
        Fri,  8 Apr 2022 10:12:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nccEk-00F2jA-Dm; Fri, 08 Apr 2022 10:12:26 +1000
Date:   Fri, 8 Apr 2022 10:12:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: use a separate frextents counter for rt extent
 reservations
Message-ID: <20220408001226.GO1544202@dread.disaster.area>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
 <164936442248.457511.4389675360381809144.stgit@magnolia>
 <20220407231725.GM1544202@dread.disaster.area>
 <20220407234528.GD27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407234528.GD27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624f7deb
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QRu45rXPF3eWxxOc6K4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 04:45:28PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 08, 2022 at 09:17:25AM +1000, Dave Chinner wrote:
> > On Thu, Apr 07, 2022 at 01:47:02PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -498,10 +498,31 @@ xfs_trans_apply_sb_deltas(
> > >  			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
> > >  	}
> > >  
> > > -	if (tp->t_frextents_delta)
> > > -		be64_add_cpu(&sbp->sb_frextents, tp->t_frextents_delta);
> > > -	if (tp->t_res_frextents_delta)
> > > -		be64_add_cpu(&sbp->sb_frextents, tp->t_res_frextents_delta);
> > > +	/*
> > > +	 * Updating frextents requires careful handling because it does not
> > > +	 * behave like the lazysb counters because we cannot rely on log
> > > +	 * recovery in older kenels to recompute the value from the rtbitmap.
> > > +	 * This means that the ondisk frextents must be consistent with the
> > > +	 * rtbitmap.
> > > +	 *
> > > +	 * Therefore, log the frextents change to the ondisk superblock and
> > > +	 * update the incore superblock so that future calls to xfs_log_sb
> > > +	 * write the correct value ondisk.
> > > +	 *
> > > +	 * Don't touch m_frextents because it includes incore reservations,
> > > +	 * and those are handled by the unreserve function.
> > > +	 */
> > > +	if (tp->t_frextents_delta || tp->t_res_frextents_delta) {
> > > +		struct xfs_mount	*mp = tp->t_mountp;
> > > +		int64_t			rtxdelta;
> > > +
> > > +		rtxdelta = tp->t_frextents_delta + tp->t_res_frextents_delta;
> > > +
> > > +		spin_lock(&mp->m_sb_lock);
> > > +		be64_add_cpu(&sbp->sb_frextents, rtxdelta);
> > > +		mp->m_sb.sb_frextents += rtxdelta;
> > > +		spin_unlock(&mp->m_sb_lock);
> > > +	}
> > 
> > Hmmmm.  This wants a comment in xfs_log_sb() to explain why we
> > aren't updating mp->m_sb.sb_frextents from mp->m_frextents like we
> > do with all the other per-cpu counters tracking resource usage.
> 
> Ok.  How about this for xfs_log_sb:
> 
> /*
>  * Do not update sb_frextents here because it is not part of the lazy sb
>  * counters (despite having a percpu counter) and therefore must be
>  * consistent with the ondisk rtbitmap.
>  */

Good! But i think we can do better. :)

/*
 * Do not update sb_frextents here because it is not part of the
 * lazy sb counters (despite having a percpu counter). It is always
 * kept consistent with the ondisk rtbitmap by
 * xfs_trans_apply_sb_deltas() and hence we don't need have to
 * update it here.
 */

> > >  
> > >  	if (tp->t_dblocks_delta) {
> > >  		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
> > > @@ -614,7 +635,12 @@ xfs_trans_unreserve_and_mod_sb(
> > >  	if (ifreedelta)
> > >  		percpu_counter_add(&mp->m_ifree, ifreedelta);
> > >  
> > > -	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
> > > +	if (rtxdelta) {
> > > +		error = xfs_mod_frextents(mp, rtxdelta);
> > > +		ASSERT(!error);
> > > +	}
> > > +
> > > +	if (!(tp->t_flags & XFS_TRANS_SB_DIRTY))
> > >  		return;
> > >  
> > >  	/* apply remaining deltas */
> > > @@ -622,7 +648,6 @@ xfs_trans_unreserve_and_mod_sb(
> > >  	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > >  	mp->m_sb.sb_icount += idelta;
> > >  	mp->m_sb.sb_ifree += ifreedelta;
> > > -	mp->m_sb.sb_frextents += rtxdelta;
> > 
> > This makes my head hurt trying to work out if this is necessary or
> > not. (the lazy sb stuff in these functions has always strained my
> > cognitive abilities, even though I wrote it in the first place!)
> > 
> > A comment explaining why we don't need to update
> > mp->m_sb.sb_frextents when XFS_TRANS_SB_DIRTY is set would be useful
> > in the above if (rtxdelta) update above.
> 
> And how about this?
> 
> /*
>  * Do not touch sb_frextents here because we are dealing with incore
>  * reservation.  sb_frextents is not part of the lazy sb counters so it
>  * must be consistent with the ondisk rtibitmap and must never include
>  * incore reservations.
>  */

Yup, makes sense :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
