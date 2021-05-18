Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8344EC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 01:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64F516135D
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 01:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbhERBsA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 May 2021 21:48:00 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40995 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233295AbhERBsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 May 2021 21:48:00 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A0E4380ADED;
        Tue, 18 May 2021 11:46:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1liooh-002EJA-Rn; Tue, 18 May 2021 11:46:39 +1000
Date:   Tue, 18 May 2021 11:46:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/22] xfs: clean up and simplify xfs_dialloc()
Message-ID: <20210518014639.GI2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-22-david@fromorbit.com>
 <20210512214930.GZ8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512214930.GZ8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=fcxuREUz9wl14muPaNIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 02:49:30PM -0700, Darrick J. Wong wrote:
> On Thu, May 06, 2021 at 05:20:53PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because it's a mess.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> > +	/*
> > +	 * Check that there is enough free space for the file plus a chunk of
> > +	 * inodes if we need to allocate some. If this is the first pass across
> > +	 * the AGs, take into account the potential space needed for alignment
> > +	 * of inode chunks when checking the longest contiguous free space in
> > +	 * the AG - this prevents us from getting ENOSPC because we have free
> > +	 * space larger than ialloc_blks but alignment constraints prevent us
> > +	 * from using it.
> > +	 *
> > +	 * If we can't find an AG with space for full alignment slack to be
> > +	 * taken into account, we must be near ENOSPC in all AGs.  Hence we
> > +	 * don't include alignment for the second pass and so if we fail
> > +	 * allocation due to alignment issues then it is most likely a real
> > +	 * ENOSPC condition.
> > +	 *
> > +	 * XXX(dgc): this calculation is now bogus thanks to the per-ag
> > +	 * reservations that xfs_alloc_fix_freelist() now does via
> > +	 * xfs_alloc_space_available(). When the AG fills up, pagf_freeblks will
> > +	 * be more than large enough for the check below to succeed, but
> > +	 * xfs_alloc_space_available() will fail because of the non-zero
> > +	 * metadata reservation and hence we won't actually be able to allocate
> > +	 * more inodes in this AG. We do soooo much unnecessary work near ENOSPC
> > +	 * because of this.
> 
> Yuck.  Can this be fixed by doing:
> 
> 	really_free = pag->pagf_freeblks -
> 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
> 	return really_free >= needspace + ineed && longest >= ineed)
> 
> to account for those reservations, perhaps?

Something like that, though I'd much prefer to factor the freelist
fixup calculations and use them here so we have a single set of
"is there enough space in this AG for allocating X blocks"
functions.

It's somewhat outside the scope of this patchset, so I wrote the
comment rather than trying to address it here and complicate this
patchset....

> > @@ -1624,7 +1746,6 @@ xfs_dialloc(
> >  	 * Files of these types need at least one block if length > 0
> >  	 * (and they won't fit in the inode, but that's hard to figure out).
> >  	 */
> > -	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> >  	if (S_ISDIR(mode))
> >  		start_agno = xfs_ialloc_next_ag(mp);
> >  	else {
> > @@ -1635,7 +1756,7 @@ xfs_dialloc(
> >  
> >  	/*
> >  	 * If we have already hit the ceiling of inode blocks then clear
> > -	 * okalloc so we scan all available agi structures for a free
> > +	 * ok_alloc so we scan all available agi structures for a free
> >  	 * inode.
> >  	 *
> >  	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
> > @@ -1644,7 +1765,7 @@ xfs_dialloc(
> 
> Er... didn't this logic get split into xfs_dialloc_select_ag in 5.11?

Yeah, but that was more about cleaning up the code in xfs_inode.c
by separating out the inode initialisation from the physical inode
allocation. That cleanup and separation is what allows this series
to simplify and clean up the inode allocation because it is no
longer commingled with the inode initialisation after allocation...

> Nice cleanup, at least...
>
>  :)

Yup, along with the 5.11 mods, we've chopped a lot of unnecessary
code out of the inode allocation path... :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
