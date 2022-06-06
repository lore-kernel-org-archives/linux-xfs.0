Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B96CCA473
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 14:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbiFFOq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 10:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240034AbiFFOq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 10:46:57 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6626BFC1
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 07:46:54 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 15so5814096qki.6
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jun 2022 07:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eQu9ZnX8ucverwBnDY0Hbf0nWmuq5mODKce4nw3PixY=;
        b=Ubyhrg7oYj6wEKi/XSECYFfgns4Z6SUY6LLvp7TNnqOuq/P9MoGQkkWA76q1IHWVgh
         BJ+amIrxzH6/3bF3YXnHxiUY9VYTPnNH6ayxYOhFfhtyvMPR0hYNy/ATGHnsLWNtuShC
         gIA+xiDHLfCH9pQgB9JKKQuDQo7sy7nOpcUERSvUvkehHmN1ra+VfHpaZC1/NCINr2tb
         mdCuVPgU9LLkHhfDizwvQ0Yq3XfUTrHsx9aCEPp1O4qmAYuOj3AmfA1YzA9xx7Jm6+hA
         A3bjeLRbgHhj2PfOUFds28+XnQYmbB69dDrc/v9fyjmVjX/gK1gld77HQ+TtB5zID5zK
         jFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eQu9ZnX8ucverwBnDY0Hbf0nWmuq5mODKce4nw3PixY=;
        b=1Z51UbimGfmtVWva5q9qLmUUNiPSzkOTkZUj6c4ANPPiS7ubt2oxKkZbU3AMBJWUGt
         rOzalY9XaLY2Z4OFJLzpJIQ+8Jc8xa7NNhkTHTyyqBpN7YzCJ7sHtNaS1C3j8sGF67SY
         q0HCkhdWVlVteMQExCkTNfOIbIC7hw1alBgz/bjt//5SasUxyqDqjk092n88fBqntji7
         9Uh29Ww6N2WIQrXNiqnbpdTovSkcMn1zuZs1q8/xS2uEAo9nv5M5cw/lt5DEOhB0M3z2
         8AdDhwaYQReL/5y/R340zXmMnJHOXeavVRLEJ7ix2GreKRcTwe2BJhfnz1BmCHZ/Kf65
         jWMQ==
X-Gm-Message-State: AOAM532A//sqJ5s1BntxmpYahVAQb3bV1ot0Mw5/ykkANrGaABkTIv4f
        v2x8vliR4limuhn7D/tZajlHjA==
X-Google-Smtp-Source: ABdhPJwUs2Akgf0T0k8/bDLJiGlFm8/U6mOikC7RqSSflYpRf/LqLTdusx1iBPTQnPANF/f7tdt9Fg==
X-Received: by 2002:a05:620a:942:b0:6a6:aed6:29b6 with SMTP id w2-20020a05620a094200b006a6aed629b6mr7017946qkw.147.1654526813425;
        Mon, 06 Jun 2022 07:46:53 -0700 (PDT)
Received: from localhost (cpe-67-251-217-1.hvc.res.rr.com. [67.251.217.1])
        by smtp.gmail.com with ESMTPSA id bi37-20020a05620a31a500b006a6a550d371sm6545080qkb.121.2022.06.06.07.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:46:52 -0700 (PDT)
Date:   Mon, 6 Jun 2022 10:46:51 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "dchinner@redhat.com" <dchinner@redhat.com>
Subject: Re: [PATCH RFC] iomap: invalidate pages past eof in
 iomap_do_writepage()
Message-ID: <Yp4TWwLrNM1Lhwq3@cmpxchg.org>
References: <YpdZKbrtXJJ9mWL7@infradead.org>
 <BB5F778F-BFE5-4CC9-94DE-3118C60E13B6@fb.com>
 <20220602065252.GD1098723@dread.disaster.area>
 <YpjYDjeR2Wpx3ImB@cmpxchg.org>
 <20220602220625.GG1098723@dread.disaster.area>
 <B186E2FB-BCAF-4019-9DFF-9FF05BAC557E@fb.com>
 <20220603052047.GJ1098723@dread.disaster.area>
 <YpojbvB/+wPqHT8y@cmpxchg.org>
 <c3620e1f-91c5-777c-4193-2478c69a033c@fb.com>
 <20220605233213.GN1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220605233213.GN1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

On Mon, Jun 06, 2022 at 09:32:13AM +1000, Dave Chinner wrote:
> On Fri, Jun 03, 2022 at 12:09:06PM -0400, Chris Mason wrote:
> > On 6/3/22 11:06 AM, Johannes Weiner wrote:
> > > On Fri, Jun 03, 2022 at 03:20:47PM +1000, Dave Chinner wrote:
> > > > On Fri, Jun 03, 2022 at 01:29:40AM +0000, Chris Mason wrote:
> > > > > As you describe above, the loops are definitely coming from higher
> > > > > in the stack.  wb_writeback() will loop as long as
> > > > > __writeback_inodes_wb() returns that it’s making progress and
> > > > > we’re still globally over the bg threshold, so write_cache_pages()
> > > > > is just being called over and over again.  We’re coming from
> > > > > wb_check_background_flush(), so:
> > > > > 
> > > > >                  struct wb_writeback_work work = {
> > > > >                          .nr_pages       = LONG_MAX,
> > > > >                          .sync_mode      = WB_SYNC_NONE,
> > > > >                          .for_background = 1,
> > > > >                          .range_cyclic   = 1,
> > > > >                          .reason         = WB_REASON_BACKGROUND,
> > > > >                  };
> > > > 
> > > > Sure, but we end up in writeback_sb_inodes() which does this after
> > > > the __writeback_single_inode()->do_writepages() call that iterates
> > > > the dirty pages:
> > > > 
> > > >                 if (need_resched()) {
> > > >                          /*
> > > >                           * We're trying to balance between building up a nice
> > > >                           * long list of IOs to improve our merge rate, and
> > > >                           * getting those IOs out quickly for anyone throttling
> > > >                           * in balance_dirty_pages().  cond_resched() doesn't
> > > >                           * unplug, so get our IOs out the door before we
> > > >                           * give up the CPU.
> > > >                           */
> > > >                          blk_flush_plug(current->plug, false);
> > > >                          cond_resched();
> > > >                  }
> > > > 
> > > > So if there is a pending IO completion on this CPU on a work queue
> > > > here, we'll reschedule to it because the work queue kworkers are
> > > > bound to CPUs and they take priority over user threads.
> > > 
> > > The flusher thread is also a kworker, though. So it may hit this
> > > cond_resched(), but it doesn't yield until the timeslice expires.
> 
> 17us or 10ms, it doesn't matter. The fact is the writeback thread
> will give up the CPU long before the latency durations (seconds)
> that were reported upthread are seen. Writeback spinning can
> not explain why truncate is not making progress - everything points
> to it being a downstream symptom, not a cause.

Chris can clarify, but I don't remember second-long latencies being
mentioned. Rather sampling periods of multiple seconds during which
the spin bursts occur multiple times.

> Also important to note, as we are talking about kworker sheduling
> hold-offs, the writeback flusher work is unbound (can run on any
> CPU), whilst the IO completion workers in XFS are per-CPU and bound
> to individual CPUs. Bound kernel tasks usually take run queue
> priority on a CPU over unbound and/or user tasks that can be punted
> to a different CPU.

Is that actually true? I'm having trouble finding the corresponding
code in the scheduler.

That said, I'm not sure it matters that much. Even if you take CPU
contention out of the equation entirely, I think we agree it's not a
good idea (from a climate POV) to have CPUs busywait on IO. Even if
that IO is just an ordinary wait_on_page_writeback() on a fast drive.

So if we can get rid of the redirtying, and it sounds like we can, IMO
we should just go ahead and do so.

> > Just to underline this, the long tail latencies aren't softlockups or major
> > explosions.  It's just suboptimal enough that different metrics and
> > dashboards noticed it.
> 
> Sure, but you've brought a problem we don't understand the root
> cause of to my attention. I want to know what the root cause is so
> that I can determine that there are no other unknown underlying
> issues that are contributing to this issue.

It seems to me we're just not on the same page on what the reported
bug is. From my POV, there currently isn't a missing piece in this
puzzle. But Chris worked closer with the prod folks on this, so I'll
leave it to him :)
