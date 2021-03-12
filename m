Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD721C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 01:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA70464F90
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 01:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCLBPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 20:15:43 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37397 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhCLBPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 20:15:42 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BC13C1041358;
        Fri, 12 Mar 2021 12:15:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKWOx-001Tss-M1; Fri, 12 Mar 2021 12:15:39 +1100
Date:   Fri, 12 Mar 2021 12:15:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/45] xfs: convert CIL busy extents to per-cpu
Message-ID: <20210312011539.GH63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-39-david@fromorbit.com>
 <20210311003601.GL3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311003601.GL3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=k-ReQ_0xFo0pnyzktQAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 04:36:01PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:36PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To get them out from under the CIL lock.
> > 
> > This is an unordered list, so we can simply punt it to per-cpu lists
> > during transaction commits and reaggregate it back into a single
> > list during the CIL push work.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++++--------
> >  1 file changed, 18 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index a2f93bd7644b..7428b98c8279 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -501,6 +501,9 @@ xlog_cil_insert_items(
> >  		atomic_add(cilpcp->space_used, &ctx->space_used);
> >  		cilpcp->space_used = 0;
> >  	}
> > +	/* attach the transaction to the CIL if it has any busy extents */
> > +	if (!list_empty(&tp->t_busy))
> > +		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
> >  	put_cpu_ptr(cilpcp);
> >  
> >  	/*
> > @@ -540,9 +543,6 @@ xlog_cil_insert_items(
> >  			list_move_tail(&lip->li_cil, &cil->xc_cil);
> >  	}
> >  
> > -	/* attach the transaction to the CIL if it has any busy extents */
> > -	if (!list_empty(&tp->t_busy))
> > -		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> >  	spin_unlock(&cil->xc_cil_lock);
> >  
> >  	if (tp->t_ticket->t_curr_res < 0)
> > @@ -802,7 +802,10 @@ xlog_cil_push_work(
> >  		ctx->ticket->t_curr_res += cilpcp->space_reserved;
> >  		cilpcp->space_used = 0;
> >  		cilpcp->space_reserved = 0;
> > -
> > +		if (!list_empty(&cilpcp->busy_extents)) {
> > +			list_splice_init(&cilpcp->busy_extents,
> > +					&ctx->busy_extents);
> > +		}
> >  	}
> >  
> >  	spin_lock(&cil->xc_push_lock);
> > @@ -1459,17 +1462,24 @@ static void __percpu *
> >  xlog_cil_pcp_alloc(
> >  	struct xfs_cil		*cil)
> >  {
> > +	void __percpu		*pcptr;
> >  	struct xlog_cil_pcp	*cilpcp;
> > +	int			cpu;
> >  
> > -	cilpcp = alloc_percpu(struct xlog_cil_pcp);
> > -	if (!cilpcp)
> > +	pcptr = alloc_percpu(struct xlog_cil_pcp);
> > +	if (!pcptr)
> >  		return NULL;
> >  
> > +	for_each_possible_cpu(cpu) {
> > +		cilpcp = per_cpu_ptr(pcptr, cpu);
> 
> So... in my mind, "cilpcp" and "pcptr" aren't really all that distinct
> from each other.  I /think/ you're trying to use "cilpcp" everywhere
> else to mean "pointer to a particular CPU's CIL data", and this change
> makes that usage consistent in the alloc function.

Yeah, it's had to have short, concise, distinct names here because
the generic pointer returned is a pointer to per cpu memory that
contains CIL specific per-cpu structures...

> However, this leaves xlog_cil_pcp_free using "cilpcp" to refer to the
> entire chunk of per-CPU data structures.

I'll fix that, I obviously missed that when trying to clean this up
to be consistent...

> Given that the first refers to
> a specific structure and the second refers to them all in aggregate,
> maybe _pcp_alloc and _pcp_free should use a name that at least sounds
> plural?
> 
> e.g.
> 
> 	void __percpu	*all_cilpcps = alloc_percpu(...);
> 
> 	for_each_possible_cpu(cpu) {
> 		cilpcp = per_cpu_ptr(all_cilpcps, cpu);
> 		cilpcp->magicval = 7777;
> 	}

The problem with "all" is that it implies a "global" all, not
something that is owned by this specific CIL instance. i.e. there
will be a per-cpu CIL area for every filesystem that is mounted, and
they are actually all linked together into a global list for CPU
hotplug to walk. So "all" CIL pcps to me means walking this list:

static LIST_HEAD(xlog_cil_pcp_list);
static DEFINE_SPINLOCK(xlog_cil_pcp_lock);

which is linked by the cil->xc_pcp_list list heads in each CIL
instance so that CPU hotplug can do the right thing.

"pcp" is typical shorthand for a "per cpu pointer" but it's
horrible when we have pointers to per-cpu lists, lists of per-cpu
aware structures, pointers to per-cpu regions, pointers to per-cpu
data (structures) within per-cpu regions, etc.

There is no way to win here, it's going to be confusing whatever we
do. I've tried to keep it simple:

pcptr			- generic pointer to allocated per CPU region
cil->xc_pcp		- CIL instance pointer to allocated percpu region
cil->xc_pcp_list	- global list for CPU hotplug pcp management

cilpcp			- pointer to specfic CPU instance of the CIL
			  percpu data inside cil->xc_pcp region.

I might just change the generic (void percpu *) regions to "pcp" so
that they align with all the other uses of "pcp" in the naming.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
