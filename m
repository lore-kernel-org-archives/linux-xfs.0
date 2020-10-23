Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC8AC388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 14:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9057322254
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 14:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="M8kF83YM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750662AbgJWOhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 10:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372730AbgJWOhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 10:37:15 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E701C0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 07:37:14 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id n11so1559337ota.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 07:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ue1eoYp/rV3X5fZ+14rS63RmMW1v9BsYmIiuPRkgMlc=;
        b=M8kF83YM7xkRfHNyf/imBorp00wSjhbgh/S8X7DXov96K6NtfkVZ7v9QVfIAfZA9H9
         O7EQwr6GuFK75XbpMbj/wQE2MrtKGKUaELIbUX3Dj3BYu3iF0wd3dYl4sruBBDTnyJgg
         Zx8zI5CS4WAbjTeKFiU1Htb5hwRJFgP2ypNP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ue1eoYp/rV3X5fZ+14rS63RmMW1v9BsYmIiuPRkgMlc=;
        b=Xps+94EPakjxUHD+3nfWM6n4/x2yD77Sb/pe0IzOB6nzyczHjJsvh5rQc/fTr/KTVu
         ZDZK663+F3cOW6A/dUgYVPVV3Gffg6+IbOfuJuV5kZQ121RpiPLUATwXfmU1J5Rqj9g9
         WmXh0QOif1w7RXBAJ0q6WfIWC3DV4t5D9WFGXSA0n9wWYT7H+FXK2UPHmUE0L7hyCNlz
         S52qqoaQdrTZJVXPED8ak1vxvG2/6JppgF1s/QhTOk7GGSWbEN6aI4zWVX/P1cxuOQKs
         4YoHE7/i3SDEQR9BYqv32ydWRV3AQxbiRhyNwbKGZMkS/8dZvbrRY/0RTjtUtcjfXqIb
         2yCw==
X-Gm-Message-State: AOAM532905xDvtoxIJz4yISjOoDUh5QPltQqc06MFP2LyejC6+YGGEQZ
        15gvnFGXyVCwWAvixJzlRX4xO1OCyfzuDphDpZKU8w==
X-Google-Smtp-Source: ABdhPJyi58HmdEa7AIVzkzyqQTfTPkHR4zZzgTo7KlLhbs3gCVZsj5F1oZVA2pGhIrfdST5nhUdlVgXIJM7T0/Qt6U4=
X-Received: by 2002:a05:6830:1647:: with SMTP id h7mr1951924otr.281.1603463832695;
 Fri, 23 Oct 2020 07:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20201021163242.1458885-1-daniel.vetter@ffwll.ch>
 <20201023122216.2373294-1-daniel.vetter@ffwll.ch> <20201023122216.2373294-4-daniel.vetter@ffwll.ch>
 <20201023141619.GC20115@casper.infradead.org>
In-Reply-To: <20201023141619.GC20115@casper.infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 23 Oct 2020 16:37:01 +0200
Message-ID: <CAKMK7uESHHHzEC2U3xVKQEBZqS5xwQJeYFpwMz3b8OaoFEYcUQ@mail.gmail.com>
Subject: Re: [PATCH 04/65] mm: Extract might_alloc() debug check
To:     Matthew Wilcox <willy@infradead.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Waiman Long <longman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        linux-xfs@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 23, 2020 at 4:16 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Oct 23, 2020 at 02:21:15PM +0200, Daniel Vetter wrote:
> > Note that unlike fs_reclaim_acquire/release gfpflags_allow_blocking
> > does not consult the PF_MEMALLOC flags. But there is no flag
> > equivalent for GFP_NOWAIT, hence this check can't go wrong due to
> > memalloc_no*_save/restore contexts.
>
> I have a patch series that adds memalloc_nowait_save/restore.

tbh this was a typoed git send-email, but thanks for the heads-up,
I'll adjust the patch accordingly.

Cheers, Daniel

> https://lore.kernel.org/linux-mm/20200625113122.7540-7-willy@infradead.org/



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
