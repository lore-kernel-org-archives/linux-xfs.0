Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8219FC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 12:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5758D222BE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 12:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404790AbfIYMJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 08:09:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404622AbfIYMJC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Sep 2019 08:09:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01006877A64;
        Wed, 25 Sep 2019 12:09:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A8D961559;
        Wed, 25 Sep 2019 12:09:01 +0000 (UTC)
Date:   Wed, 25 Sep 2019 08:08:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Lower CIL flush limit for large logs
Message-ID: <20190925120859.GC21991@bfoster>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-2-david@fromorbit.com>
 <20190916163325.GZ2229799@magnolia>
 <20190924222901.GI16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924222901.GI16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 25 Sep 2019 12:09:02 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 08:29:01AM +1000, Dave Chinner wrote:
> On Mon, Sep 16, 2019 at 09:33:25AM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 09, 2019 at 11:51:58AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The current CIL size aggregation limit is 1/8th the log size. This
> > > means for large logs we might be aggregating at least 250MB of dirty objects
> > > in memory before the CIL is flushed to the journal. With CIL shadow
> > > buffers sitting around, this means the CIL is often consuming >500MB
> > > of temporary memory that is all allocated under GFP_NOFS conditions.
> > > 
> > > Flushing the CIL can take some time to do if there is other IO
> > > ongoing, and can introduce substantial log force latency by itself.
> > > It also pins the memory until the objects are in the AIL and can be
> > > written back and reclaimed by shrinkers. Hence this threshold also
> > > tends to determine the minimum amount of memory XFS can operate in
> > > under heavy modification without triggering the OOM killer.
> > > 
> > > Modify the CIL space limit to prevent such huge amounts of pinned
> > > metadata from aggregating. We can have 2MB of log IO in flight at
> > > once, so limit aggregation to 16x this size. This threshold was
> > > chosen as it little impact on performance (on 16-way fsmark) or log
> > > traffic but pins a lot less memory on large logs especially under
> > > heavy memory pressure.  An aggregation limit of 8x had 5-10%
> > > performance degradation and a 50% increase in log throughput for
> > > the same workload, so clearly that was too small for highly
> > > concurrent workloads on large logs.
> > 
> > It would be nice to capture at least some of this reasoning in the
> > already lengthy comment preceeding the #define....
> 
> A lot of it is already there, but I will revise it.
> 
> > 
> > > This was found via trace analysis of AIL behaviour. e.g. insertion
> > > from a single CIL flush:
> > > 
> > > xfs_ail_insert: old lsn 0/0 new lsn 1/3033090 type XFS_LI_INODE flags IN_AIL
> > > 
> > > $ grep xfs_ail_insert /mnt/scratch/s.t |grep "new lsn 1/3033090" |wc -l
> > > 1721823
> > > $
> > > 
> > > So there were 1.7 million objects inserted into the AIL from this
> > > CIL checkpoint, the first at 2323.392108, the last at 2325.667566 which
> > > was the end of the trace (i.e. it hadn't finished). Clearly a major
> > > problem.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_priv.h | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > > index b880c23cb6e4..187a43ffeaf7 100644
> > > --- a/fs/xfs/xfs_log_priv.h
> > > +++ b/fs/xfs/xfs_log_priv.h
> > > @@ -329,7 +329,8 @@ struct xfs_cil {
> > >   * enforced to ensure we stay within our maximum checkpoint size bounds.
> > >   * threshold, yet give us plenty of space for aggregation on large logs.
> > 
> > ...also, does XLOG_CIL_SPACE_LIMIT correspond to "a lower threshold at
> > which background pushing is attempted", or "a separate, higher bound"?
> > I think it's the first (????) but ... I don't know.  The name made me
> > think it was the second, but the single use of the symbol suggests the
> > first. :)
> 
> See, the comment here talks about two limits, because that was how
> the initial implementation worked - the background CIL push was not
> async, so there was some juggling done to prevent new commits from
> blocking on background pushes in progress unless the size was
> actually growing to large.  This patch pretty much describes the
> whole issue here:
> 
> https://lore.kernel.org/linux-xfs/1285552073-14663-2-git-send-email-david@fromorbit.com/
> 
> That's in commit 80168676ebfe ("xfs: force background CIL push under
> sustained load") which went into 2.6.38 or so. The cause of the
> problem in that case was concurrent transaction commit load causing
> lock contention and preventing a background push from getting the
> context lock to do the actual push.
> 

More related to the next patch, but what prevents a similar but
generally unbound concurrent workload from exceeding the new hard limit
once transactions start to block post commit?

Brian

> The hard limit in the CIL code was dropped when the background push
> was converted to run asynchronously to use a work queue in 2012 as
> it allowed the locking to be changed (down_write_trylock ->
> down_write) to turn it into a transaction commit barrier while the
> contexts are switched over.  That was done in 2012 via commit
> 4c2d542f2e78 ("xfs: Do background CIL flushes via a workqueue") and
> so we haven't actually capped CIL checkpoint sizes since 2012.
> 
> Essentially, the comment you point out documents the two limits from
> the original code, and this commit is restoring that behaviour for
> background CIL pushes....
> 
> I'll do some work to update it all.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
