Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A07C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 04:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3207208A1
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 04:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKUEUx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 23:20:53 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53145 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbfKUEUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 23:20:53 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 11E927E9A49;
        Thu, 21 Nov 2019 15:20:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXddn-0005L4-JP; Thu, 21 Nov 2019 15:00:23 +1100
Date:   Thu, 21 Nov 2019 15:00:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, zhangshaokun@hisilicon.com
Subject: Re: [PATCH] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20191121040023.GD4614@dread.disaster.area>
References: <20191121004437.9633-1-david@fromorbit.com>
 <20191121023836.GV6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121023836.GV6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=U9S6hMvKFfcmaFalgBwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 06:38:36PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 21, 2019 at 11:44:37AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Shaokun Zhang reported that XFs was using substantial CPU time in
> > percpu_count_sum() when running a single threaded benchmark on
> > a high CPU count (128p) machine from xfs_mod_ifree(). The issue
> > is that the filesystem is empty when the benchmark runs, so inode
> > allocation is running with a very low inode free count.
> > 
> > With the percpu counter batching, this means comparisons when the
> > counter is less that 128 * 256 = 32768 use the slow path of adding
> > up all the counters across the CPUs, and this is expensive on high
> > CPU count machines.
> > 
> > The summing in xfs_mod_ifree() is only used to fire an assert if an
> > underrun occurs. The error is ignored by the higher level code.
> > Hence this is really just debug code. Hence we don't need to run it
> > on production kernels, nor do we need such debug checks to return
> > error values just to trigger an assert.
> > 
> > Further, the error handling in xfs_trans_unreserve_and_mod_sb() is
> > largely incorrect - Rolling back the changes in the transaction if
> > only one counter underruns makes all the other counters
> > incorrect.
> 
> Separate change, separate patch...

Yeah, i can split it up, just wanted to see what people thought
about the approach...

> >  	if (idelta) {
> > -		error = xfs_mod_icount(mp, idelta);
> > -		if (error)
> > -			goto out_undo_fdblocks;
> > +		percpu_counter_add_batch(&mp->m_icount, idelta,
> > +					 XFS_ICOUNT_BATCH);
> > +		if (idelta < 0)
> > +			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> > +							XFS_ICOUNT_BATCH) >= 0);
> >  	}
> >  
> >  	if (ifreedelta) {
> > -		error = xfs_mod_ifree(mp, ifreedelta);
> > -		if (error)
> > -			goto out_undo_icount;
> > +		percpu_counter_add(&mp->m_ifree, ifreedelta);
> > +		if (ifreedelta < 0)
> > +			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
> 
> Since the whole thing is a debug statement, why not shove everything
> into a single assert?
> 
> ASSERT(ifreedelta >= 0 || percpu_computer_compare() >= 0); ?

I could, but it still needs to be split over two lines and I find
unnecessarily complex ASSERT checks hinder understanding. I can look
at what I wrote at a glance and immediately understand that the
assert is conditional on the counter being negative, but the single
line compound assert form requires me to stop, read and think about
the logic before I can identify that the ifreedelta check is just a
conditional that reduces the failure scope rather than is a failure
condition itself.

I like simple logic with conditional behaviour being obvious via
pattern matching - it makes my brain hurt less because I'm really
good at visual pattern matching and I'm really bad at reading
and writing code.....

> > -out_undo_frextents:
> > -	if (rtxdelta)
> > -		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
> > -out_undo_ifree:
> > +	xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
> 
> As for these bits... why even bother with a three line helper?  I think
> this is clearer about what's going on:
> 
> 	mp->m_sb.sb_frextents += rtxdelta;
> 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> 	...
> 	ASSERT(!rtxdelta || mp->m_sb.sb_frextents >= 0);
> 	ASSERT(!tp->t_dblocks_delta || mp->m_sb.sb.dblocks >= 0);

That required writing more code and adding more logic I'd have to
think about to write, and then think about again every time I read
it.

> I also wonder if we should be shutting down the fs here if the counts
> go negative, but <shrug> that would be yet a different patch. :)

I also thought about that, but all this accounting should have
already been bounds checked. i.e. We should never get an error here,
and I don't think I've *ever* seen an assert in this code fire.
Hence I just went for the dead simple nuke-it-from-orbit patch...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
