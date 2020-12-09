Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F04C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 04:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CD122389E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 04:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgLIEUf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:20:35 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49894 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgLIEUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 23:20:35 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5CE5758D494;
        Wed,  9 Dec 2020 15:19:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmqxC-0021LP-3a; Wed, 09 Dec 2020 15:19:50 +1100
Date:   Wed, 9 Dec 2020 15:19:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201209041950.GY3913616@dread.disaster.area>
References: <20201208004028.GU629293@magnolia>
 <20201208111906.GA1679681@bfoster>
 <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209032624.GH1943235@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=8vjVtSlziNgtQrQObZsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 07:26:24PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 08, 2020 at 02:19:13PM -0500, Brian Foster wrote:
> > On Tue, Dec 08, 2020 at 10:10:27AM -0800, Darrick J. Wong wrote:
> > > On Tue, Dec 08, 2020 at 06:19:06AM -0500, Brian Foster wrote:
> > > > On Mon, Dec 07, 2020 at 04:40:28PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Log incompat feature flags in the superblock exist for one purpose: to
> > > > > protect the contents of a dirty log from replay on a kernel that isn't
> > > > > prepared to handle those dirty contents.  This means that they can be
> > > > > cleared if (a) we know the log is clean and (b) we know that there
> > > > > aren't any other threads in the system that might be setting or relying
> > > > > upon a log incompat flag.
> > > > > 
> > > > > Therefore, clear the log incompat flags when we've finished recovering
> > > > > the log, when we're unmounting cleanly, remounting read-only, or
> > > > > freezing; and provide a function so that subsequent patches can start
> > > > > using this.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > > Note: I wrote this so that we could turn on log incompat flags for
> > > > > atomic extent swapping and Allison could probably use it for the delayed
> > > > > logged xattr patchset.  Not gonna try to land this in 5.11, FWIW...
> > > > > ---
....
> > > > unmount, we ensure a full/sync AIL push completes (and moves the in-core
> > > > tail) before we log the feature bit change. I do wonder if it's worth
> > > > complicating the log quiesce path to clear feature bits at all, but I
> > > > suppose it could be a little inconsistent to clean the log on freeze yet
> > > > leave an incompat bit around. Perhaps we should push the clear bit
> > > > sequence down into the log quiesce path between completing the AIL push
> > > > and writing the unmount record. We may have to commit a sync transaction
> > > > and then push the AIL again, but that would cover the unmount and freeze
> > > > cases and I think we could probably do away with the post-recovery bit
> > > > clearing case entirely. A current/recovered mount should clear the
> > > > associated bits on the next log quiesce anyways. Hm?
> > > 
> > > Hm.  You know how xfs_log_quiesce takes and releases the superblock
> > > buffer lock after pushing the AIL but before writing the unmount record?
> > > What if we did the log_incompat feature clearing + bwrite right after
> > > that?
> > > 
> > 
> > Yeah, that's where I was thinking for the unmount side. I'm not sure we
> > want to just bwrite there vs. log+push though. Otherwise, I think
> > there's still a window of potential inconsistency between when the
> > superblock write completes and the unmount record lands on disk.

The only thing the unmount record really does is ensure that the
head and tail of the log point to the unmount record. that's what
marks the log clean, not the unmount record itself. We use a special
record here because we're not actually modifying anything - it's not
a transaction, just a marker to get the log head + tail to point to
the same LSN in the log.

Log covering does the same thing via logging and flushing the
superblock multiple times - it makes sure that the only item in the
commit at the head of the journal has a tail pointer that also
points to the same checkpoint. The fact that it's got a "dirty"
unmodified superblock in rather than being an unmount record is
largely irrelevant - the rest of the log has been marked as clean by
this checkpoint and the replay of the SB from this checkpoint is
effectively a no-op.

In fact, I think it's a "no-op" we can take advantage of.....

> > I
> > _think_ the whole log force -> AIL push (i.e. move log tail) -> update
> > super -> log force -> AIL push sequence ensures that if an older kernel
> > saw the updated super, the log would technically be dirty but we'd at
> > least be sure that all incompat log items are behind the tail.

It's a bit more complex than that - if the log is not dirty, then
the second log force does nothing, and the tail of the log does not
get updated. Hence you have to log, commit and writeback the
superblock twice to ensure that the log tail has been updated in the
journal to after the point in time where the superblock was *first
logged*.

The log covering state machine handles this all correctly, and it
does it using the superblock as the mechanism that moves the tail of
the log forward. I suspect that we could use the second logging of
the superblock in that state machine to clear/set log incompat
flags, as that is the commit that marks the log "empty". If we crash
before the sb write at this point, log recovery will only see the
superblock to recover, so it doesn't matter that there's a change in
log incompat bits here because after recovery we're going to clear
them, right?

I'd like to avoid re-inventing the wheel here if we can :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
