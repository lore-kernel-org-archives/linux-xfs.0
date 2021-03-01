Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00664C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 13:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65E760C3D
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 13:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhCANez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:34:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235827AbhCANdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 08:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614605544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8J4sLnUG579yl+ky13MKGDJpFWS7ZFv2rd6RPC0mvk=;
        b=fwDJhaVxxZbebFoczn/GM7KWBroy16NXVpfIT9fKfVd4E+9agut1zzBi15mt0gdfjaYCex
        kS889OKwTOAlvzxvbNBouj9ogPGpCXyyBrynkvcnf/ys8ZerRSpeMXNqT49SGgzQeeshh4
        eGq12MP4HEJvI6NT6slILDr1HYpU6SI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-w_BVpE7HM1-NEH4gWEMGNA-1; Mon, 01 Mar 2021 08:32:22 -0500
X-MC-Unique: w_BVpE7HM1-NEH4gWEMGNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EE2F107ACE3;
        Mon,  1 Mar 2021 13:32:21 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84BED10016FF;
        Mon,  1 Mar 2021 13:32:20 +0000 (UTC)
Date:   Mon, 1 Mar 2021 08:32:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YDzs4mQmiYN1UwFr@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <YDeiLOdFhIMJegWZ@bfoster>
 <20210225220305.GO4662@dread.disaster.area>
 <YDpyYj7+WHx9FviY@bfoster>
 <20210301045422.GD4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301045422.GD4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 03:54:22PM +1100, Dave Chinner wrote:
> On Sat, Feb 27, 2021 at 11:25:06AM -0500, Brian Foster wrote:
> > On Fri, Feb 26, 2021 at 09:03:05AM +1100, Dave Chinner wrote:
> > > On Thu, Feb 25, 2021 at 08:12:12AM -0500, Brian Foster wrote:
> > > > On Thu, Feb 25, 2021 at 08:10:58AM +1100, Dave Chinner wrote:
> > > > > On Tue, Feb 23, 2021 at 04:32:11PM +1100, Dave Chinner wrote:
> > > The problem that I talk about is introduced by this patch and also
> > > fixed by this patch. The problem does not exist until we have code
> > > that depends on an async CIL push guaranteeing that items in the CIL
> > > are unpinned. A stock xfs_log_force_seq(0) call guarantees that the
> > > log reaches disk by waiting on the CIL push then pushing the iclogs.
> > > All it does is elide waiting for the final iclogs to hit the disk.
> > > 
> > > By eliding the "wait for CIL push" in an async xfs_log_force_seq()
> > > call, we also elide the "push iclogs" part of the log force and
> > > that's what causes the AIL problem. We don't push the iclogs, so the
> > > items committed to the last iclog don't get dispatched and the items
> > > never get unpinned because the checkpoint never completes.
> > > 
> > 
> > So in general it sounds like this patch broke async log force by
> > skipping the current iclog switch somehow or another and then this
> > change is incorporated to fix it (hence there is no outstanding bug
> > upstream). That makes a bit more sense. I'll get the detailed context
> > from the patches.
> 
> Yes.
> 
> > > As to the "root cause of the hang" I now know what that is too, but
> > > addressing it is outside the scope of this patchset. It's taken me a
> > > long time to identify this, but I've been seeing symptoms of it for
> > > quite a long time (i.e. years) but until doing this async CIL push
> > > work I've never been able to identify the cause.
> > > 
> > > That is, the root cause is that the AIL cannot force a pinned buffer
> > > to disk, and a log force (of any kind) does not guarantee a pinned
> > > item is unpinned. That's because the CIL is pipelined, meaning that
> > > an item can be pinned in one CIL context, and while that is being
> > > pushed, the front end can relog that same item and pin it in the
> > > current CIL context. Hence it has two pins, not one. Now when the
> > > original log force completes, the pin from the first CIL context has
> > > been removed, but the pin from the current CIL context is still
> > > present.
> > > 
> > 
> > Somewhat related to the above point, ISTM our current behavior can lead
> > to scenarios where the potential window for elevated pin counts is
> > somewhat artificially widened. IOW, the log vector for a pincount == 1
> > item might have been written out to disk, but the log item itself not
> > unpinned for some time later because the commit record is still sitting
> > in an active iclog. The unpin processing of the item doesn't occur until
> > that commit record iclog is synced out and I/O completes, which leaves
> > plenty of time for another pin to come along in the meantime (and the
> > scenario potentially repeats, starving out pincount == 0 state). So ISTM
> > the "damage" is done to some degree long before the AIL has any
> > opportunity to fix it, particularly if the only recourse it has is a log
> > force.
> > 
> > (And of course there's a huge tradeoff between current behavior and
> > something that unconditionally synced out commit record iclogs,
> > particularly depending on CIL checkpoint sizes, so that's a broad
> > simplification and not a valid solution.)
> 
> Yes, this can be an issue because when the single CIL work is CPU
> bound, it is the first iclog write of the checkpoint that pushes the
> previous commit record to disk. So, like you say, there's a natural
> pin overlap in this situation.
> 
> > > Hence when we are relogging buffers over time (e.g. repeatedly
> > > modifying a directory), the AIL always sees the buffer pinned and
> > > cannot flush it. Even if the buffer has been moved to the delwri
> > > list (i.e. had a successful push) we still can't write it out
> > > because the delwri code skips pinned buffers.
> > > 
> > > This iterative pin continues preventing the AIL from flushing the
> > > buffer until it pins the tail of the log. When the log runs out of
> > > space and blocks the modifying/relogging task(s), the log force the
> > > AIL issues allows the CIL to be pushed without the front end
> > > relogging the item and re-pinning the item. At the completion of the
> > > log force, the AIL can now push the unpinned buffer and hence move
> > > the tail of the log forward which frees up log reservation space.
> > > This then wakes the front end, which goes back to it's relogging
> > > game and the cycle repeats over.
> > > 
> > 
> > The description of the nested pin behavior makes sense. I've observed
> > the same thing recently when looking at some unrelated shutdown
> > problems.
> > 
> > In any event, if I'm following correctly the deadlock issue was a
> > transient problem with this patch and not an upstream problem. However
> > there is still a pipeline stall/performance issue that manifests as
> > described above, and that preexists the proposed changes. Yes?
> 
> Yes, AFAICT, this pin problem dates back to day zero. Before delayed
> logging it required the inode or buffer to be relogged in almost
> every iclog that was written (think a long running truncate removing
> hundreds of thousands of extents). But before delayed logging, this
> was very slow and limited by iclog IO so having the AIL stall would
> have largely been unnoticed.
> 
> > > This is really nasty behaviour, and it's only recently that I've got
> > > a handle on it. I found it because my original "async CIL push" code
> > > resulted in long stalls every time the log is filled and the tail is
> > > pinned by a buffer that is being relogged in this manner....
> > > 
> > > I'm not sure how to fix this yet - the AIL needs to block the front
> > > end relogging to allow the buffer to be unpinned. Essentially, we
> > > need to hold the pinned items locked across a CIL push to guarantee
> > > they are unpinned, but that's the complete opposite of what the AIL
> > > currently does to prevent the front end from seeing long tail lock
> > > latencies when modifying stuff....
> > 
> > When this stall problem manifests, I'm assuming it's exacerbated by
> > delayed logging and the commit record behavior I described above. If
> > that's the case, could the AIL communicate writeback pressure through
> > affected log items such that checkpoints in which they are resident are
> > flushed out completely/immediately when the checkpoints occur? I suppose
> > that would require a log item flag or some such, which does raise a
> > concern of unnecessarily tagging many items (it's not clear to me how
> > likely that really is), but I'm curious if that would be an effective
> > POC at least..
> 
> I don't think we need to do anything like that. All we need to do to
> ensure that the AIL can flush a pinned buffer is to lock it, kick
> the log and wait for the pin count to go to zero. Then we can write
> it just fine, blocking only the front end transactions that need
> that buffer lock.  Same goes for inodes, though xfs_iunpin_wait()
> already does this....
> 

Yeah, but why would we want to block xfsaild on a single item like that?
Wouldn't holding the item locked like that just create a new stall point
within xfsaild? Maybe I'm missing something, but what you describe here
basically just sounds like a "lock the item and run a sync log force"
pattern.

I agree that the implementation I handwave about above seems overkill,
but I'm really curious what the disadvantage of some form of logic in
the logging code to do something like "if this checkpoint contains items
that are AIL resident && under some measure of writeback pressure && the
next iclog is active, want_sync the commit record iclog on background
push to reduce item pin count times" might be.

Brian

> The only issue is determining if this causes unaaceptible long tail
> latencies on buffers like the AG headers....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

