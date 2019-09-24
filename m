Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4C6C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 22:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D75C207FD
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 22:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441769AbfIXW3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 18:29:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59979 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438025AbfIXW3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 18:29:07 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 58F4D43E671;
        Wed, 25 Sep 2019 08:29:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iCtIr-0005vf-Mf; Wed, 25 Sep 2019 08:29:01 +1000
Date:   Wed, 25 Sep 2019 08:29:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Lower CIL flush limit for large logs
Message-ID: <20190924222901.GI16973@dread.disaster.area>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-2-david@fromorbit.com>
 <20190916163325.GZ2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916163325.GZ2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=wqFDAPPxoy882HgVTp8A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 09:33:25AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 09, 2019 at 11:51:58AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The current CIL size aggregation limit is 1/8th the log size. This
> > means for large logs we might be aggregating at least 250MB of dirty objects
> > in memory before the CIL is flushed to the journal. With CIL shadow
> > buffers sitting around, this means the CIL is often consuming >500MB
> > of temporary memory that is all allocated under GFP_NOFS conditions.
> > 
> > Flushing the CIL can take some time to do if there is other IO
> > ongoing, and can introduce substantial log force latency by itself.
> > It also pins the memory until the objects are in the AIL and can be
> > written back and reclaimed by shrinkers. Hence this threshold also
> > tends to determine the minimum amount of memory XFS can operate in
> > under heavy modification without triggering the OOM killer.
> > 
> > Modify the CIL space limit to prevent such huge amounts of pinned
> > metadata from aggregating. We can have 2MB of log IO in flight at
> > once, so limit aggregation to 16x this size. This threshold was
> > chosen as it little impact on performance (on 16-way fsmark) or log
> > traffic but pins a lot less memory on large logs especially under
> > heavy memory pressure.  An aggregation limit of 8x had 5-10%
> > performance degradation and a 50% increase in log throughput for
> > the same workload, so clearly that was too small for highly
> > concurrent workloads on large logs.
> 
> It would be nice to capture at least some of this reasoning in the
> already lengthy comment preceeding the #define....

A lot of it is already there, but I will revise it.

> 
> > This was found via trace analysis of AIL behaviour. e.g. insertion
> > from a single CIL flush:
> > 
> > xfs_ail_insert: old lsn 0/0 new lsn 1/3033090 type XFS_LI_INODE flags IN_AIL
> > 
> > $ grep xfs_ail_insert /mnt/scratch/s.t |grep "new lsn 1/3033090" |wc -l
> > 1721823
> > $
> > 
> > So there were 1.7 million objects inserted into the AIL from this
> > CIL checkpoint, the first at 2323.392108, the last at 2325.667566 which
> > was the end of the trace (i.e. it hadn't finished). Clearly a major
> > problem.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_priv.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index b880c23cb6e4..187a43ffeaf7 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -329,7 +329,8 @@ struct xfs_cil {
> >   * enforced to ensure we stay within our maximum checkpoint size bounds.
> >   * threshold, yet give us plenty of space for aggregation on large logs.
> 
> ...also, does XLOG_CIL_SPACE_LIMIT correspond to "a lower threshold at
> which background pushing is attempted", or "a separate, higher bound"?
> I think it's the first (????) but ... I don't know.  The name made me
> think it was the second, but the single use of the symbol suggests the
> first. :)

See, the comment here talks about two limits, because that was how
the initial implementation worked - the background CIL push was not
async, so there was some juggling done to prevent new commits from
blocking on background pushes in progress unless the size was
actually growing to large.  This patch pretty much describes the
whole issue here:

https://lore.kernel.org/linux-xfs/1285552073-14663-2-git-send-email-david@fromorbit.com/

That's in commit 80168676ebfe ("xfs: force background CIL push under
sustained load") which went into 2.6.38 or so. The cause of the
problem in that case was concurrent transaction commit load causing
lock contention and preventing a background push from getting the
context lock to do the actual push.

The hard limit in the CIL code was dropped when the background push
was converted to run asynchronously to use a work queue in 2012 as
it allowed the locking to be changed (down_write_trylock ->
down_write) to turn it into a transaction commit barrier while the
contexts are switched over.  That was done in 2012 via commit
4c2d542f2e78 ("xfs: Do background CIL flushes via a workqueue") and
so we haven't actually capped CIL checkpoint sizes since 2012.

Essentially, the comment you point out documents the two limits from
the original code, and this commit is restoring that behaviour for
background CIL pushes....

I'll do some work to update it all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
