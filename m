Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B3AC4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 23:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D3E23770
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 23:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732642AbgLJX6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 18:58:16 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:33479 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729231AbgLJX6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 18:58:01 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D218110D43C;
        Fri, 11 Dec 2020 08:50:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1knTp6-002cgc-6C; Fri, 11 Dec 2020 08:50:04 +1100
Date:   Fri, 11 Dec 2020 08:50:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201210215004.GC3913616@dread.disaster.area>
References: <20201208004028.GU629293@magnolia>
 <20201208111906.GA1679681@bfoster>
 <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster>
 <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210142358.GB1912831@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=8tb7v53AHeAtl-ARJYUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 09:23:58AM -0500, Brian Foster wrote:
> On Thu, Dec 10, 2020 at 07:51:32AM +1100, Dave Chinner wrote:
> > For changing incompat log flags, covering also provides exactly what
> > we need - an empty log with only a dirty superblock in the journal
> > to recover. All that we need then is to recheck feature flags after
> > recovery (not just clear log incompat flags) because we might need
> > to use this to also set incompat feature flags dynamically.
> > 
> 
> I'd love it if we use a better term for a log isolated to the superblock
> buffer. So far we've discussed an empty log with a dummy superblock, an
> empty log with a dirty superblock, and I suppose we could also have an
> actual empty log. :P "Covered log," perhaps?

On terminology: "covered log" has been around for 25 years
in XFS, and it's very definition is "an empty, up-to-date log except
for a dummy object we logged without any changes to update the log
tail". And, by definition, that dummy object is dirty in the log
even if it contains no actual modifications when it was logged.
So in this case, "dummy" is directly interchangable with "dirty"
when looking at the log contents w.r.t. recovery behaviour.

It's worth looking at a historical change, too. Log covering
originally used the root inode and not the superblock. That caused
problems on linux dirtying VFS inode state, so we changed it to the
superblock in commit 1a387d3be2b3 ("xfs: dummy transactions should
not dirty VFS state") about a decade ago.  Note the name of the
function at the time (xfs_fs_log_dummy()) and that it's description
explicitly mentions that a dummy transaction used for updating the
log tail when covering it.

The only difference in this discussion is fact that we may be
replacing the "dummy" with a modified superblock. Both are still
dirty superblock objects in the log, and serve the same purpose for
covering the log, but instead of using a dummy object we update the
log incompat flags so taht the only thing that gets replayed if we
crash is the modification to the superblock flags...

Finally, no, we can't have a truly empty log while the filesystem is
mounted because log transaction records must not be empty. Further,
we can only bring the log down to an "empty but not quite clean"
state while mounted, because if the log is actually marked clean and
we crash then log recovery will not run and so we will not clean up
files that were open-but-unlinked when the system crashed.


> > > > but didn't necessarily clean the log. I wonder if we can fit that state
> > > > into the existing log covering mechanism by logging the update earlier
> > > > (or maybe via an intermediate state..)? I'll need to go stare at that
> > > > code a bit..
> > 
> > That's kinda what I'd like to see done - it gives us a generic way
> > of altering superblock incompat feature fields and filesystem
> > structures dynamically with no risk of log recovery needing to parse
> > structures it may not know about.
> > 
> 
> We might have to think about if we want to clear such feature bits in
> all log covering scenarios (idle, freeze) vs. just unmount.

I think clearing bits can probably be lazy. Set a state flag to tell
log covering that it needs to do an update, and so when the covering
code finally runs the feature bit modification just happens.


> My previous suggestion in the other sub-thread was to set bits on
> mount and clear on unmount because that (hopefully) simplifies the
> broader implementation.  Otherwise we need to manage dynamic
> setting of bits when the associated log items are active, and that
> still isn't truly representative because the bits would remain set
> long after active items fall out of the log, until the log is
> covered. Either way is possible, but I'm curious what others
> think.

I think that unless we are setting a log incompat flag, log covering
should unconditionally clear the log incompat flags. Because the log
is empty, and recovery of a superblock buffer should -always- be
possible, then by definition we have no log incompat state
present....

As for a mechanism for dynamically adding log incompat flags?
Perhaps we just do that in xfs_trans_alloc() - add an log incompat
flags field into the transaction reservation structure, and if
xfs_trans_alloc() sees an incompat field set and the superblock
doesn't have it set, the first thing it does is run a "set log
incompat flag" transaction before then doing it's normal work...

This should be rare enough it doesn't have any measurable
performance overhead, and it's flexible enough to support any log
incompat feature we might need to implement...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
