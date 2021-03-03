Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8864C28CFB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91FF5601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351122AbhCCDQ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:28 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:52128 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233654AbhCCBYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 20:24:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id C3CA9E6ADD3;
        Wed,  3 Mar 2021 12:23:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHGEC-00CGcs-MC; Wed, 03 Mar 2021 12:23:04 +1100
Date:   Wed, 3 Mar 2021 12:23:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210303012304.GN4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <YDeiLOdFhIMJegWZ@bfoster>
 <20210225220305.GO4662@dread.disaster.area>
 <YDpyYj7+WHx9FviY@bfoster>
 <20210301045422.GD4662@dread.disaster.area>
 <YDzs4mQmiYN1UwFr@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDzs4mQmiYN1UwFr@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=UQpl2JReXQ5wmOcdS3MA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 08:32:18AM -0500, Brian Foster wrote:
> On Mon, Mar 01, 2021 at 03:54:22PM +1100, Dave Chinner wrote:
> > On Sat, Feb 27, 2021 at 11:25:06AM -0500, Brian Foster wrote:
> > > On Fri, Feb 26, 2021 at 09:03:05AM +1100, Dave Chinner wrote:
> > > > This is really nasty behaviour, and it's only recently that I've got
> > > > a handle on it. I found it because my original "async CIL push" code
> > > > resulted in long stalls every time the log is filled and the tail is
> > > > pinned by a buffer that is being relogged in this manner....
> > > > 
> > > > I'm not sure how to fix this yet - the AIL needs to block the front
> > > > end relogging to allow the buffer to be unpinned. Essentially, we
> > > > need to hold the pinned items locked across a CIL push to guarantee
> > > > they are unpinned, but that's the complete opposite of what the AIL
> > > > currently does to prevent the front end from seeing long tail lock
> > > > latencies when modifying stuff....
> > > 
> > > When this stall problem manifests, I'm assuming it's exacerbated by
> > > delayed logging and the commit record behavior I described above. If
> > > that's the case, could the AIL communicate writeback pressure through
> > > affected log items such that checkpoints in which they are resident are
> > > flushed out completely/immediately when the checkpoints occur? I suppose
> > > that would require a log item flag or some such, which does raise a
> > > concern of unnecessarily tagging many items (it's not clear to me how
> > > likely that really is), but I'm curious if that would be an effective
> > > POC at least..
> > 
> > I don't think we need to do anything like that. All we need to do to
> > ensure that the AIL can flush a pinned buffer is to lock it, kick
> > the log and wait for the pin count to go to zero. Then we can write
> > it just fine, blocking only the front end transactions that need
> > that buffer lock.  Same goes for inodes, though xfs_iunpin_wait()
> > already does this....
> > 
> 
> Yeah, but why would we want to block xfsaild on a single item like that?

Who said anything about blocking the AIL on a single item? :)

> Wouldn't holding the item locked like that just create a new stall point
> within xfsaild? Maybe I'm missing something, but what you describe here
> basically just sounds like a "lock the item and run a sync log force"
> pattern.

What I was thinking is that if the item is pinned and at the
tail of the log, then we leave it locked when we flush it rather
than unlocking it and relocking it when the delwri submit code gets
to it. If it gets unpinned before the delwri code gets to it, all
good. If not, the delwri code being unable to flush it will feed
back up into the AIL to trigger a log force, which will unpin it
in the near future and it will be written on the next AIL delwri
submit cycle.

The thing we need to be careful of this is minimising the lock hold
time by the AIL while we unpin the item. That's the "long tail
latencies" problem I mention above. Essentially, we need to try to
avoid holding the item locked for a long period of time before
issuing the log force and/or resubmitting it for IO once it is
unlocked. I have a few ideas on this, but no patches yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
