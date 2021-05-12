Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97361C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743F7610A7
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhELWnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 18:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1442539AbhELV7Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 17:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C049861221;
        Wed, 12 May 2021 21:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620856695;
        bh=AMla05M79qSieSISwmUL5JL768jTKznbewtLOcaSD4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhKuNGptsRS0H3MDMhqgwbDRVKG1Ohh4YqQaCcvHLBfOGatIZRcnpRp+3ORF0E3T5
         WBHGdmYlVZQYKZ8aR/IR+zanfkUCp4IJosxqxD9RcNm0zGovQLzlQiLX8XpVfuHEQE
         dFSE+pnRiozFu7hzMT4sT67buuaLt8liZVvQVTKxO+ljiTYbc2Wbrm3JngHnACz8Mk
         f8WTbzsFlwiJK0ScMUYjTUfFneYXYd/KQ+AJuk495ZfiltbCLSKiMfcQbdxXSEukj/
         GUFZHNn9yrvP6j0GyYT26c5TmJvXCzbOXoSIvKaaypvSB21AlPiVRhZ9vBRjMwZ9J8
         UbtdUmF7nH93A==
Date:   Wed, 12 May 2021 14:58:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs: make for_each_perag... a first class citizen
Message-ID: <20210512215814.GA8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-5-david@fromorbit.com>
 <YJks5KC4l9N9/vIT@bfoster>
 <20210511073519.GS63242@dread.disaster.area>
 <YJp4sqtlkMRodcNx@bfoster>
 <20210511213312.GT63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511213312.GT63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 07:33:12AM +1000, Dave Chinner wrote:
> On Tue, May 11, 2021 at 08:29:38AM -0400, Brian Foster wrote:
> > On Tue, May 11, 2021 at 05:35:19PM +1000, Dave Chinner wrote:
> > > On Mon, May 10, 2021 at 08:53:56AM -0400, Brian Foster wrote:
> > > > On Thu, May 06, 2021 at 05:20:36PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > for_each_perag_tag() is defined in xfs_icache.c for local use.
> > > > > Promote this to xfs_ag.h and define equivalent iteration functions
> > > > > so that we can use them to iterate AGs instead to replace open coded
> > > > > perag walks and perag lookups.
> > > > > 
> > > > > We also convert as many of the straight forward open coded AG walks
> > > > > to use these iterators as possible. Anything that is not a direct
> > > > > conversion to an iterator is ignored and will be updated in future
> > > > > commits.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_ag.h    | 17 +++++++++++++++++
> > > > >  fs/xfs/scrub/fscounters.c | 36 ++++++++++++++----------------------
> > > > >  fs/xfs/xfs_extent_busy.c  |  7 ++-----
> > > > >  fs/xfs/xfs_fsops.c        |  8 ++------
> > > > >  fs/xfs/xfs_health.c       |  4 +---
> > > > >  fs/xfs/xfs_icache.c       | 15 ++-------------
> > > > >  6 files changed, 38 insertions(+), 49 deletions(-)
> > > > > 
> > > > ...
> > > > > diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> > > > > index 453ae9adf94c..2dfdac566399 100644
> > > > > --- a/fs/xfs/scrub/fscounters.c
> > > > > +++ b/fs/xfs/scrub/fscounters.c
> > > > ...
> > > > > @@ -229,12 +224,9 @@ xchk_fscount_aggregate_agcounts(
> > > > >  		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
> > > > >  		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
> > > > >  
> > > > > -		xfs_perag_put(pag);
> > > > > -
> > > > > -		if (xchk_should_terminate(sc, &error))
> > > > > -			break;
> > > > >  	}
> > > > > -
> > > > > +	if (pag)
> > > > > +		xfs_perag_put(pag);
> > > > 
> > > > It's not shown in the diff, but there is still an exit path out of the
> > > > above loop that calls xfs_perag_put(). The rest of the patch LGTM.
> > > 
> > > Good spot. Fixed.
> > > 
> > > FWIW, I'm not entirely happy with the way the iterator can break and
> > > require conditional cleanup. I'm thinking that I'll come back to
> > > these and convert them to a iterator structure that will turn this
> > > into the pattern:
> > > 
> > > 	perag_iter_init(&iter, start_agno, end_agno);
> > > 	for_each_perag(pag, iter) {
> > > 		....
> > > 	}
> > > 	perag_iter_done(&iter);
> > > 
> > > and so the code doesn't need to care about whether it exits the loop
> > > via a break or running out of perags to iterate. I haven't fully
> > > thought this through, though, so I'm leaving it alone for now...
> > > 
> > 
> > I think something like that would be an improvement. It's
> > straightforward enough to follow through these changes with the loop
> > break quirk in mind, but I suspect that somebody modifying (and/or
> > reviewing) related code farther in the future might very easily miss
> > something like an external put being required if a loop is modified to
> > break out early.
> 
> *nod*
> 
> I think I'll need to address this when I do the conversion of these
> iterators to use active references to pin or skip perags that are
> being torn down. The iterators becomes slightly more complex at this
> point, so that's probably the best point to address this.

This sounds like a good change to me. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
