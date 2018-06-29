Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933168AbeF2Ozm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jun 2018 10:55:42 -0400
Date: Fri, 29 Jun 2018 07:55:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/21] xfs: repair the AGF and AGFL
Message-ID: <20180629145538.GM5711@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986823481.3155.13034509035761369722.stgit@magnolia>
 <824fc014-2af0-dcad-6bd1-d765f6cb2be9@oracle.com>
 <20180628232115.GD2234@dastard>
 <ef551764-f911-bbfe-0be5-a60d1d679326@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef551764-f911-bbfe-0be5-a60d1d679326@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 06:35:06PM -0700, Allison Henderson wrote:
> On 06/28/2018 04:21 PM, Dave Chinner wrote:
> > On Thu, Jun 28, 2018 at 02:14:51PM -0700, Allison Henderson wrote:
> > > On 06/24/2018 12:23 PM, Darrick J. Wong wrote:
> > > > +static const struct xfs_repair_find_ag_btree repair_agf[] = {
> > > > +	[REPAIR_AGF_BNOBT] = {
> > > > +		.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +		.buf_ops = &xfs_allocbt_buf_ops,
> > > > +		.magic = XFS_ABTB_CRC_MAGIC,
> > > > +	},
> > > > +	[REPAIR_AGF_CNTBT] = {
> > > > +		.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +		.buf_ops = &xfs_allocbt_buf_ops,
> > > > +		.magic = XFS_ABTC_CRC_MAGIC,
> > > > +	},
> > > > +	[REPAIR_AGF_RMAPBT] = {
> > > > +		.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +		.buf_ops = &xfs_rmapbt_buf_ops,
> > > > +		.magic = XFS_RMAP_CRC_MAGIC,
> > > > +	},
> > > > +	[REPAIR_AGF_REFCOUNTBT] = {
> > > > +		.rmap_owner = XFS_RMAP_OWN_REFC,
> > > > +		.buf_ops = &xfs_refcountbt_buf_ops,
> > > > +		.magic = XFS_REFC_CRC_MAGIC,
> > > > +	},
> > > > +	[REPAIR_AGF_END] = {
> > > > +		.buf_ops = NULL,
> > > > +	},
> > > > +};
> > > > +
> > > > +/*
> > > > + * Find the btree roots.  This is /also/ a chicken and egg problem because we
> > > > + * have to use the rmapbt (rooted in the AGF) to find the btrees rooted in the
> > > > + * AGF.  We also have no idea if the btrees make any sense.  If we hit obvious
> > > > + * corruptions in those btrees we'll bail out.
> > > > + */
> > > It would help if maybe we could put the /*IN*/ or /*OUT*/ on the
> > > parameters here?  And maybe a blurb about their usage.  From looking
> > > at how their used in the memcpy, I'm guessing that agf_bp is IN and
> > > fab is OUT.  But it's otherwise its not really clear on how they're
> > > meant to be used with out going the function to see how it handles
> > > them.
> > 
> > IMO, that's what kerneldoc format comments are for. I'd much prefer
> > we use kerneldoc format than go back to the bad old terse 3-4 word
> > post-variable declaration comments that we used to have.
> > 

<nod> I'll straighten this mess out.  The pattern underneath this is
that we partially fill out the structure with the characteristics of the
block we want the code to help us look for, and then the code fills in
the rest (the block number and btree height) of the structure as it
rummages around the AG.

I thought that having a static template that could be memcpy'd into the
stack variable was a useful thing, but seeing as it just complicates
matters I'll just move this template to the stack variable's definition.
At the time I was planning for more than one user of each template, but
that never came to fruition so it's better to simplify the data
structure lifetime and initialization semantics.

--D

> > Cheers,
> > 
> > Dave.
> > 
> 
> Sure, that sounds like it would be fine too :-)
> 
> Allison
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
