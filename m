Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6220C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 21:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B193207D5
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 21:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgFEVHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 17:07:54 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52564 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbgFEVHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 17:07:53 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 78F0A1066F4;
        Sat,  6 Jun 2020 07:07:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jhJZ4-0000bP-Di; Sat, 06 Jun 2020 07:07:46 +1000
Date:   Sat, 6 Jun 2020 07:07:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/30] xfs: allow multiple reclaimers per AG
Message-ID: <20200605210746.GC2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-20-david@fromorbit.com>
 <20200605162611.GC23747@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605162611.GC23747@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=Mi-Z5BUW8Sa9Dsof9AQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 12:26:11PM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:45:55PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Inode reclaim will still throttle direct reclaim on the per-ag
> > reclaim locks. This is no longer necessary as reclaim can run
> > non-blocking now. Hence we can remove these locks so that we don't
> > arbitrarily block reclaimers just because there are more direct
> > reclaimers than there are AGs.
> > 
> > This can result in multiple reclaimers working on the same range of
> > an AG, but this doesn't cause any apparent issues. Optimising the
> > spread of concurrent reclaimers for best efficiency can be done in a
> > future patchset.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_icache.c | 31 ++++++++++++-------------------
> >  fs/xfs/xfs_mount.c  |  4 ----
> >  fs/xfs/xfs_mount.h  |  1 -
> >  3 files changed, 12 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 74032316ce5cc..c4ba8d7bc45bc 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> ...
> > @@ -1298,11 +1293,9 @@ xfs_reclaim_inodes_ag(
> >  
> >  		} while (nr_found && !done && *nr_to_scan > 0);
> >  
> > -		if (trylock && !done)
> > -			pag->pag_ici_reclaim_cursor = first_index;
> > -		else
> > -			pag->pag_ici_reclaim_cursor = 0;
> > -		mutex_unlock(&pag->pag_ici_reclaim_lock);
> > +		if (done)
> > +			first_index = 0;
> > +		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
> 
> I thought the [READ|WRITE]_ONCE() macros had to do with ordering, not
> necessarily atomicity. Is this write safe if we're running a 32-bit
> kernel, for example? Outside of that the broader functional change seems
> reasonable.

They are used for documenting intentional data races now, too.
That's what these are - we don't care about serialisation, but there
are static checkers that will now spew "data race" warnings because
multiple threads can race reading and writing unserialised
variables.

It is safe on 32 bit machines because these variables are 32 bit on
32 bit machines, and reads/writes of 32 bit variables on 32 bit
machines are atomic (though not serialised).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
