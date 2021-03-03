Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5087EC43381
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2278064E56
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245598AbhCDARu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1574028AbhCCRVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 12:21:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614792024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1X0dgNzjgU09w090yFxpC7EN3+pAc2CCuUo7o3+nvuM=;
        b=dB/paZxhsdBlq828JVnMj+rX4/C94NuQV/nNj6sTG1C4xCEBgLFh0hCNPafWsEu5MBGvaj
        mkGu1PujPbdGSImL3hJhzzOcuWDEkcNrlHegdffiQ7xYvVOkL+RDILEVyOoX9oraxMf6U3
        F+nO+GTAQS2wtgGAFnJQPdlAAtK7bgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-_UZQa4jNM_mLNgyZe4eCdw-1; Wed, 03 Mar 2021 12:20:23 -0500
X-MC-Unique: _UZQa4jNM_mLNgyZe4eCdw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C5926DD24;
        Wed,  3 Mar 2021 17:20:22 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E917189CE;
        Wed,  3 Mar 2021 17:20:21 +0000 (UTC)
Date:   Wed, 3 Mar 2021 12:20:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YD/FU0E0lht9Kj6/@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <YDeiLOdFhIMJegWZ@bfoster>
 <20210225220305.GO4662@dread.disaster.area>
 <YDpyYj7+WHx9FviY@bfoster>
 <20210301045422.GD4662@dread.disaster.area>
 <YDzs4mQmiYN1UwFr@bfoster>
 <20210303012304.GN4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303012304.GN4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 12:23:04PM +1100, Dave Chinner wrote:
> On Mon, Mar 01, 2021 at 08:32:18AM -0500, Brian Foster wrote:
> > On Mon, Mar 01, 2021 at 03:54:22PM +1100, Dave Chinner wrote:
> > > On Sat, Feb 27, 2021 at 11:25:06AM -0500, Brian Foster wrote:
> > > > On Fri, Feb 26, 2021 at 09:03:05AM +1100, Dave Chinner wrote:
> > > > > This is really nasty behaviour, and it's only recently that I've got
> > > > > a handle on it. I found it because my original "async CIL push" code
> > > > > resulted in long stalls every time the log is filled and the tail is
> > > > > pinned by a buffer that is being relogged in this manner....
> > > > > 
> > > > > I'm not sure how to fix this yet - the AIL needs to block the front
> > > > > end relogging to allow the buffer to be unpinned. Essentially, we
> > > > > need to hold the pinned items locked across a CIL push to guarantee
> > > > > they are unpinned, but that's the complete opposite of what the AIL
> > > > > currently does to prevent the front end from seeing long tail lock
> > > > > latencies when modifying stuff....
> > > > 
> > > > When this stall problem manifests, I'm assuming it's exacerbated by
> > > > delayed logging and the commit record behavior I described above. If
> > > > that's the case, could the AIL communicate writeback pressure through
> > > > affected log items such that checkpoints in which they are resident are
> > > > flushed out completely/immediately when the checkpoints occur? I suppose
> > > > that would require a log item flag or some such, which does raise a
> > > > concern of unnecessarily tagging many items (it's not clear to me how
> > > > likely that really is), but I'm curious if that would be an effective
> > > > POC at least..
> > > 
> > > I don't think we need to do anything like that. All we need to do to
> > > ensure that the AIL can flush a pinned buffer is to lock it, kick
> > > the log and wait for the pin count to go to zero. Then we can write
> > > it just fine, blocking only the front end transactions that need
> > > that buffer lock.  Same goes for inodes, though xfs_iunpin_wait()
> > > already does this....
> > > 
> > 
> > Yeah, but why would we want to block xfsaild on a single item like that?
> 
> Who said anything about blocking the AIL on a single item? :)
> 
> > Wouldn't holding the item locked like that just create a new stall point
> > within xfsaild? Maybe I'm missing something, but what you describe here
> > basically just sounds like a "lock the item and run a sync log force"
> > pattern.
> 
> What I was thinking is that if the item is pinned and at the
> tail of the log, then we leave it locked when we flush it rather
> than unlocking it and relocking it when the delwri submit code gets
> to it. If it gets unpinned before the delwri code gets to it, all
> good. If not, the delwri code being unable to flush it will feed
> back up into the AIL to trigger a log force, which will unpin it
> in the near future and it will be written on the next AIL delwri
> submit cycle.
> 

I'm not sure what you mean by leaving the item locked when we flush it
if it is pinned, since we don't flush pinned items. Perhaps implied is
that this would trylock the buffer first, then only worry about if it's
pinned if we acquire the lock. If so (and the pin is at the tail), hold
the lock and kick the log as a means to ensure that xfsaild is
guaranteed next access to the buffer once unpinned. Hm?

IIUC, that seems interesting. Though as noted in the flush optimization
series, I am a little leery about issuing (even async) log forces with
locks held, at least with the current implementation..

Brian

> The thing we need to be careful of this is minimising the lock hold
> time by the AIL while we unpin the item. That's the "long tail
> latencies" problem I mention above. Essentially, we need to try to
> avoid holding the item locked for a long period of time before
> issuing the log force and/or resubmitting it for IO once it is
> unlocked. I have a few ideas on this, but no patches yet.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

