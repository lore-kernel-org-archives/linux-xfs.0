Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E136C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0A023C43
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbgLIRGC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:06:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732373AbgLIRGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 12:06:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607533473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEk9pWaTYpmgcMd325rWyFceMUkbBY8lYhc+aH1bdv4=;
        b=NZ9slnI4nXWuXgEqqh1NjhRTe0LyD1kvUN67Ld0b2lkcdzvRsDRXw1CHvso/YD64yziI7A
        zWBboJuHdZL9zsdUmJTM3zN9HeEfFBDsHOrHb7GtI2A6veuk0rXWTa8Ur9zjkRnI8MMk9L
        pWaLv9jLMBOqNVSJ4GxTixS6ErT9eaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-j6V9k4gzP3OW_Xzyh-5aWA-1; Wed, 09 Dec 2020 12:04:32 -0500
X-MC-Unique: j6V9k4gzP3OW_Xzyh-5aWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF915C7401;
        Wed,  9 Dec 2020 17:04:30 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2115210016F4;
        Wed,  9 Dec 2020 17:04:30 +0000 (UTC)
Date:   Wed, 9 Dec 2020 12:04:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201209170428.GC1860561@bfoster>
References: <20201208004028.GU629293@magnolia>
 <20201208111906.GA1679681@bfoster>
 <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster>
 <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209155211.GB1860561@bfoster>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 09, 2020 at 10:52:11AM -0500, Brian Foster wrote:
> On Wed, Dec 09, 2020 at 03:19:50PM +1100, Dave Chinner wrote:
> > On Tue, Dec 08, 2020 at 07:26:24PM -0800, Darrick J. Wong wrote:
> > > On Tue, Dec 08, 2020 at 02:19:13PM -0500, Brian Foster wrote:
> > > > On Tue, Dec 08, 2020 at 10:10:27AM -0800, Darrick J. Wong wrote:
> > > > > On Tue, Dec 08, 2020 at 06:19:06AM -0500, Brian Foster wrote:
> > > > > > On Mon, Dec 07, 2020 at 04:40:28PM -0800, Darrick J. Wong wrote:
> > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > 
> > > > > > > Log incompat feature flags in the superblock exist for one purpose: to
> > > > > > > protect the contents of a dirty log from replay on a kernel that isn't
> > > > > > > prepared to handle those dirty contents.  This means that they can be
> > > > > > > cleared if (a) we know the log is clean and (b) we know that there
> > > > > > > aren't any other threads in the system that might be setting or relying
> > > > > > > upon a log incompat flag.
> > > > > > > 
> > > > > > > Therefore, clear the log incompat flags when we've finished recovering
> > > > > > > the log, when we're unmounting cleanly, remounting read-only, or
> > > > > > > freezing; and provide a function so that subsequent patches can start
> > > > > > > using this.
> > > > > > > 
> > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > ---
> > > > > > > Note: I wrote this so that we could turn on log incompat flags for
> > > > > > > atomic extent swapping and Allison could probably use it for the delayed
> > > > > > > logged xattr patchset.  Not gonna try to land this in 5.11, FWIW...
> > > > > > > ---
> > ....
> > > > > > unmount, we ensure a full/sync AIL push completes (and moves the in-core
> > > > > > tail) before we log the feature bit change. I do wonder if it's worth
> > > > > > complicating the log quiesce path to clear feature bits at all, but I
> > > > > > suppose it could be a little inconsistent to clean the log on freeze yet
> > > > > > leave an incompat bit around. Perhaps we should push the clear bit
> > > > > > sequence down into the log quiesce path between completing the AIL push
> > > > > > and writing the unmount record. We may have to commit a sync transaction
> > > > > > and then push the AIL again, but that would cover the unmount and freeze
> > > > > > cases and I think we could probably do away with the post-recovery bit
> > > > > > clearing case entirely. A current/recovered mount should clear the
> > > > > > associated bits on the next log quiesce anyways. Hm?
> > > > > 
> > > > > Hm.  You know how xfs_log_quiesce takes and releases the superblock
> > > > > buffer lock after pushing the AIL but before writing the unmount record?
> > > > > What if we did the log_incompat feature clearing + bwrite right after
> > > > > that?
> > > > > 
> > > > 
> > > > Yeah, that's where I was thinking for the unmount side. I'm not sure we
> > > > want to just bwrite there vs. log+push though. Otherwise, I think
> > > > there's still a window of potential inconsistency between when the
> > > > superblock write completes and the unmount record lands on disk.
> > 
> > The only thing the unmount record really does is ensure that the
> > head and tail of the log point to the unmount record. that's what
> > marks the log clean, not the unmount record itself. We use a special
> > record here because we're not actually modifying anything - it's not
> > a transaction, just a marker to get the log head + tail to point to
> > the same LSN in the log.
> > 
> 
> Right..
> 
> > Log covering does the same thing via logging and flushing the
> > superblock multiple times - it makes sure that the only item in the
> > commit at the head of the journal has a tail pointer that also
> > points to the same checkpoint. The fact that it's got a "dirty"
> > unmodified superblock in rather than being an unmount record is
> > largely irrelevant - the rest of the log has been marked as clean by
> > this checkpoint and the replay of the SB from this checkpoint is
> > effectively a no-op.
> > 
> 
> That's close to what I was trying to accomplish above (independent of
> whether the approach was actually correct ;). The difference is that I
> wasn't trying to mark the log clean generically, but guarantee it's
> "clean of incompat items" by the time the superblock buffer that clears
> the incompat feature bit hits the log. That way a recovery would update
> the superblock on current kernels and old kernels would either see a
> dirty log or the a clean log with the updated super.
> 
> > In fact, I think it's a "no-op" we can take advantage of.....
> > 
> > > > I
> > > > _think_ the whole log force -> AIL push (i.e. move log tail) -> update
> > > > super -> log force -> AIL push sequence ensures that if an older kernel
> > > > saw the updated super, the log would technically be dirty but we'd at
> > > > least be sure that all incompat log items are behind the tail.
> > 
> > It's a bit more complex than that - if the log is not dirty, then
> > the second log force does nothing, and the tail of the log does not
> > get updated. Hence you have to log, commit and writeback the
> > superblock twice to ensure that the log tail has been updated in the
> > journal to after the point in time where the superblock was *first
> > logged*.
> > 
> 
> I'm a little confused by your statement. The second log force would come
> after we've explicitly logged the superblock (having cleared the feature
> bit), so the log would have to be dirty at that point. Do you mean if
> the log is not dirty from the start, something else, or just misread?
> 
> > The log covering state machine handles this all correctly, and it
> > does it using the superblock as the mechanism that moves the tail of
> > the log forward. I suspect that we could use the second logging of
> > the superblock in that state machine to clear/set log incompat
> > flags, as that is the commit that marks the log "empty". If we crash
> > before the sb write at this point, log recovery will only see the
> > superblock to recover, so it doesn't matter that there's a change in
> > log incompat bits here because after recovery we're going to clear
> > them, right?
> > 
> 
> Hmm.. but if we update the superblock in the same checkpoint that marks
> the log empty and then fail before the superblock write, the superblock
> update is lost since recovery would never happen (because the log is
> empty). I think the more significant problem with that is we can now
> present a filesystem with a clean log to an older kernel with the bit
> set.
> 

Hmmmm.. but does log covering actually mark the log clean? I was
thinking it did from your description but from a quick test it appears
it does not. Perhaps that's what you mean by "empty" instead of clean,
since the log is not technically empty but it contains a no-op change.

If that's the case, perhaps we can do an explicit log cover in any of
the quiesce paths, as you describe, before logging the unmount record.
The first superblock update is essentially no-op to stamp a new tail in
the log (as is done today), the next logs the actual superblock change
and updates the on-disk tail to point to the just written checkpoint,
then we writeback the superblock and mark the log clean with an unmount
record. On recovery, we either see a dirty log with the superblock bit
set, a dirty log with the superblock bit cleared but that has already
been covered (so is safely recoverable on an old kernel), or a clean
log. Am I following that about right..?

Brian

> This is why I was trying to basically log the superblock update in a
> checkpoint that also ensured the tail moved forward past incompat items
> but didn't necessarily clean the log. I wonder if we can fit that state
> into the existing log covering mechanism by logging the update earlier
> (or maybe via an intermediate state..)? I'll need to go stare at that
> code a bit..
> 
> > I'd like to avoid re-inventing the wheel here if we can :)
> > 
> 
> Agreed. The idle log covering mechanism crossed my mind but I didn't
> look further into it because I thought it was an isolated mechanism (and
> hadn't grok'd the details of it). I.e., we'd still have to handle freeze
> and unmount separately so it made more sense to grok those cases first.
> If you think there's a possibility to rework it so the same covering
> mechanism can be reused across idle, quiesce, unmount, and that we can
> conditionally fit a superblock log incompat bit clear into that
> sequence, that sounds like a nice overall approach to me.
> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 

