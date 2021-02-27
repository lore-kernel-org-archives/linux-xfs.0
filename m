Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E314C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 16:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556F864E01
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 16:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhB0Q0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 Feb 2021 11:26:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhB0Q0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Feb 2021 11:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614443114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dvpGBMFlceO4zVZnozjxWa82KIpaP2jWtbZBWBT++aw=;
        b=fY59ubbKw+PJ217N11nShPBOCGevsmwsrse2d+SshaZy00w1nU3iOhJk4teNtfnITHuy3j
        9Z4hbZ2D6y/XCw8+APKNV1jV5En6mkeievenN9KtfJtcbM0dI4k3RuaA7gKPJxg+uvpHVI
        Wpe14vcjrtTD8uiT9uxTtxfm4UB42Ng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-eL8hxRujMWmDmq9eCM7-Vg-1; Sat, 27 Feb 2021 11:25:10 -0500
X-MC-Unique: eL8hxRujMWmDmq9eCM7-Vg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 025FB814302;
        Sat, 27 Feb 2021 16:25:09 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B4242D108;
        Sat, 27 Feb 2021 16:25:08 +0000 (UTC)
Date:   Sat, 27 Feb 2021 11:25:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YDpyYj7+WHx9FviY@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <YDeiLOdFhIMJegWZ@bfoster>
 <20210225220305.GO4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225220305.GO4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 26, 2021 at 09:03:05AM +1100, Dave Chinner wrote:
> On Thu, Feb 25, 2021 at 08:12:12AM -0500, Brian Foster wrote:
> > On Thu, Feb 25, 2021 at 08:10:58AM +1100, Dave Chinner wrote:
> > > On Tue, Feb 23, 2021 at 04:32:11PM +1100, Dave Chinner wrote:
> > > The problem being tripped over here is that we no longer force the
> > > final iclogs in a CIL push to disk - we leave the iclog with the
> > > commit record in it in ACTIVE state, and by not waiting and forcing
> > > all the iclogs to disk, the buffer never gets unpinned because there
> > > isn't any more log pressure to force it out because everything is
> > > blocked on reservation space.
> > > 
> > > The solution to this is to have the CIL push change the state of the
> > > commit iclog to WANT_SYNC before it is released. This means the CIL
> > > push will always flush the iclog to disk and the checkpoint will
> > > complete and unpin the buffers.
> > > 
> > > Right now, we really only want to do this state switch for these
> > > async pushes - for small sync transactions and fsync we really want
> > > the iclog aggregation that we have now to optimise iclogbuf usage,
> > > so I'll have to pass a new flag through the push code and back into
> > > xlog_write(). That will make this patch behave the same as we
> > > currently do.
> > > 
> > 
> > Unfortunately I've not yet caught up to reviewing your most recently
> > posted set of log patches so I can easily be missing some context, but
> > when passing through some of the feedback/updates so far this has me
> > rather confused. We discussed this pre-existing CIL behavior in the
> > previous version, I suggested some similar potential behavior change
> > where we would opportunistically send off checkpoint iclogs for I/O a
> > bit earlier than normal and you argued [1] against it. Now it sounds
> > like not only are we implementing that, but it's actually necessary to
> > fix a log hang problem..? What am I missing?
> 
> You're talking about this comment?
> 

Yes.

> | > That means there's an increased chance that
> | > the next iclog in the ring may be active. Perhaps we could introduce
> | > some logic to switch out the commit record iclog before the CIL push
> | > returns in those particular cases.  For example, switch out if the
> | > current checkpoint hit multiple iclogs..? Or hit multiple iclogs and the
> | > next iclog in the ring is clean..?
> |
> | We could just call xlog_state_switch_iclogs() to mark it WANT_SYNC,
> | but then we can't aggregate more changes into it and fill it up. If
> | someone starts waiting on that iclog (i.e. a log force), then it
> | immediately gets marked WANT_SYNC and submitted to disk when it is
> | released. But if there is no-one waiting on it, then we largely
> | don't care if an asynchronous checkpoint is committed immediately,
> | at the start of the next checkpoint, or at worst, within 30s when
> | the log worker next kicks a log force....
> 
> I'm arguing against the general case here of submitting iclog
> buffers with checkpoints in them early. THere is no reason to do that
> because the xfs_log_force() code will kick the iclog to disk if
> necessary. That still stands - I have not changed behaviour
> unconditionally.
> 

But the suggestion wasn't to change behavior unconditionally. That seems
fairly clear to me even from just the quoted snippet above..?

> This patch only kicks the commit_iclog to disk if the cause of the
> CIL push was an async call to xlog_cil_force_seq(). That can occur
> from xfs_iunpin() and, with this patch, the AIL.
> 
> In both cases, all they care about is that the CIL checkpoint fully
> completes in the near future. For xfs_iunpin(), the log force
> doesn't guarantee the inode is actually unpinned, hence it waits on
> the pin count and not the log force. So waiting for the CIL push is
> unnecessary as long as the CIL push gets the entire checkpoint to
> disk.
> 
> Similarly, the AIL only needs the log force to guarantee the CIL
> commits to disk in the near future, but it does not need to block
> waiting for that to occur.
> 
> So in these cases, we don't want to block while the CIL is pushing
> just so the log force code can iterate the last iclog the CIL wrote
> to flush it to disk. Instead, we pass a flag to the CIL to tell it
> "you need to push the commit record to disk" so we don't have to
> wait for it to then check if it pushed the commit record or not.
> This is a special case, not the general case where we are running
> lots of fsync or sync transactions.
> 
> In the general case, we are trying to aggregate as many sync
> transactions/fsync log forces as possible into the current iclog to
> batch them up effectively. We'll continue to batch them while there
> is space in the current iclog and the previous iclog is in the
> WANT_SYNC/SYNCING state indicating it is still being written to
> disk.
> 
> This automated batching behaviour of the iclog state machine is one
> of the reasons XFS has always had excellent performance under
> synci transaction/fsync heavy workloads such as NFS/CIFS servers. It
> is functionality we need to preserve, and this patch does not
> actually change that behaviour.
> 

Sure, this all makes sense.

> > The updated iclog behavior does sound more friendly to me than what we
> > currently do (obviously, based on my previous comments),
> 
> As per above, the conditional behaviour I've added here is actually
> less friendly :)
> 

Heh. :P

> > but I am
> > slightly skeptical of how such a change fixes the root cause of a hang.
> > Is this a stall/perf issue or an actual log deadlock? If the latter,
> > what prevents this deadlock on current upstream?
> 
> The problem that I talk about is introduced by this patch and also
> fixed by this patch. The problem does not exist until we have code
> that depends on an async CIL push guaranteeing that items in the CIL
> are unpinned. A stock xfs_log_force_seq(0) call guarantees that the
> log reaches disk by waiting on the CIL push then pushing the iclogs.
> All it does is elide waiting for the final iclogs to hit the disk.
> 
> By eliding the "wait for CIL push" in an async xfs_log_force_seq()
> call, we also elide the "push iclogs" part of the log force and
> that's what causes the AIL problem. We don't push the iclogs, so the
> items committed to the last iclog don't get dispatched and the items
> never get unpinned because the checkpoint never completes.
> 

So in general it sounds like this patch broke async log force by
skipping the current iclog switch somehow or another and then this
change is incorporated to fix it (hence there is no outstanding bug
upstream). That makes a bit more sense. I'll get the detailed context
from the patches.

> So this "AIL can hang because tail items aren't unpinned" condition
> is exposed by async CIL forces. It is also fixed by this patch
> passing the async push state to the CIL push and having it ensure
> that the commit iclog if written out if the CIL push was triggered
> by an async push.
> 
> Like all log forces, async pushes are rare, but we have to ensure
> tehy behave correctly. There is no bug in the code before this
> patch, and there is no bug in the code (that I know of) after this
> patch. I've described a condition that we have to handle in this
> patch that, if we don't, we end up with broken AIL pushing.
> 

Ok.

> As to the "root cause of the hang" I now know what that is too, but
> addressing it is outside the scope of this patchset. It's taken me a
> long time to identify this, but I've been seeing symptoms of it for
> quite a long time (i.e. years) but until doing this async CIL push
> work I've never been able to identify the cause.
> 
> That is, the root cause is that the AIL cannot force a pinned buffer
> to disk, and a log force (of any kind) does not guarantee a pinned
> item is unpinned. That's because the CIL is pipelined, meaning that
> an item can be pinned in one CIL context, and while that is being
> pushed, the front end can relog that same item and pin it in the
> current CIL context. Hence it has two pins, not one. Now when the
> original log force completes, the pin from the first CIL context has
> been removed, but the pin from the current CIL context is still
> present.
> 

Somewhat related to the above point, ISTM our current behavior can lead
to scenarios where the potential window for elevated pin counts is
somewhat artificially widened. IOW, the log vector for a pincount == 1
item might have been written out to disk, but the log item itself not
unpinned for some time later because the commit record is still sitting
in an active iclog. The unpin processing of the item doesn't occur until
that commit record iclog is synced out and I/O completes, which leaves
plenty of time for another pin to come along in the meantime (and the
scenario potentially repeats, starving out pincount == 0 state). So ISTM
the "damage" is done to some degree long before the AIL has any
opportunity to fix it, particularly if the only recourse it has is a log
force.

(And of course there's a huge tradeoff between current behavior and
something that unconditionally synced out commit record iclogs,
particularly depending on CIL checkpoint sizes, so that's a broad
simplification and not a valid solution.)

> Hence when we are relogging buffers over time (e.g. repeatedly
> modifying a directory), the AIL always sees the buffer pinned and
> cannot flush it. Even if the buffer has been moved to the delwri
> list (i.e. had a successful push) we still can't write it out
> because the delwri code skips pinned buffers.
> 
> This iterative pin continues preventing the AIL from flushing the
> buffer until it pins the tail of the log. When the log runs out of
> space and blocks the modifying/relogging task(s), the log force the
> AIL issues allows the CIL to be pushed without the front end
> relogging the item and re-pinning the item. At the completion of the
> log force, the AIL can now push the unpinned buffer and hence move
> the tail of the log forward which frees up log reservation space.
> This then wakes the front end, which goes back to it's relogging
> game and the cycle repeats over.
> 

The description of the nested pin behavior makes sense. I've observed
the same thing recently when looking at some unrelated shutdown
problems.

In any event, if I'm following correctly the deadlock issue was a
transient problem with this patch and not an upstream problem. However
there is still a pipeline stall/performance issue that manifests as
described above, and that preexists the proposed changes. Yes?

> This is really nasty behaviour, and it's only recently that I've got
> a handle on it. I found it because my original "async CIL push" code
> resulted in long stalls every time the log is filled and the tail is
> pinned by a buffer that is being relogged in this manner....
> 
> I'm not sure how to fix this yet - the AIL needs to block the front
> end relogging to allow the buffer to be unpinned. Essentially, we
> need to hold the pinned items locked across a CIL push to guarantee
> they are unpinned, but that's the complete opposite of what the AIL
> currently does to prevent the front end from seeing long tail lock
> latencies when modifying stuff....
> 

When this stall problem manifests, I'm assuming it's exacerbated by
delayed logging and the commit record behavior I described above. If
that's the case, could the AIL communicate writeback pressure through
affected log items such that checkpoints in which they are resident are
flushed out completely/immediately when the checkpoints occur? I suppose
that would require a log item flag or some such, which does raise a
concern of unnecessarily tagging many items (it's not clear to me how
likely that really is), but I'm curious if that would be an effective
POC at least..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

