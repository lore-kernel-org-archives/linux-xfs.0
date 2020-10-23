Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BABCC388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 14:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE522192A
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 14:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Spx4hwCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465247AbgJWOqD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 10:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S375361AbgJWOqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 10:46:02 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4744C0613D2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 07:46:00 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id n3so2136061oie.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 07:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cmGjJdbt9z1UYbT5/ZpSCpz1o50MyYCTMK9AHq0Aakg=;
        b=Spx4hwCaXf34JyFBNZU5P3z2Yc6125/UltDMuzpO1FUom3Imvy74oVwjnfX6eEVi0B
         zjkOgtlhaqtz+7NG7zdnSLUt5Rs0WTD2wX6fxpxq0VZide9nyesLxotL7/nXMV4OBZYk
         nvC79EU7g32SfEqeva4RGwvPB0L1tnqWAT7KQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cmGjJdbt9z1UYbT5/ZpSCpz1o50MyYCTMK9AHq0Aakg=;
        b=L8uRfZ5efYl2lJ4shUHERhQo3oV5dIkmd+REB9YUGpCXzIFo+18V9PDZaOZ+EN7lAS
         dAXvSGA1SSeDbCmRrI/M0+dqDdcXFNHqhQvmNauenjELG+ETPxUMHW8SvEAHdSNZ9Zrw
         GfyBrz64KRoWMcEYWbJV/hEN58I8agbJBoBKTvpYwDJoMHsIvDHoEAQ54k7asxQRRRWn
         StHzJGpZ+pnfuhA77cFWDHmLKhDU9iA0wYH17nQ8M9BRZcWMg+ovkWMvahkvYmWHt0P1
         guenbI4vi7MoRMvFdMjtMopmIqVp85bSH9PQaCZ5G0g9sHFLEdiqCV5vWtk5v/zcJMfq
         VCfg==
X-Gm-Message-State: AOAM531phN3ll8BGX6M16RoagOCp7D3nVE+HScKijgj9CkVxUJfzgshw
        /alNe8Za6bfwTV5hglBuuQ6qZnX0kdmb4q4YMeVrqg==
X-Google-Smtp-Source: ABdhPJxzM7Q4pHq2VPzHFl40r08AFCr6VXVCJPwfsZqO2s0Hja92tgFb3rm5wRQVurhNjcBpW7T188EV4zJA1keqdEo=
X-Received: by 2002:aca:cc01:: with SMTP id c1mr2005619oig.128.1603464360217;
 Fri, 23 Oct 2020 07:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201021163242.1458885-1-daniel.vetter@ffwll.ch>
 <20201023122216.2373294-1-daniel.vetter@ffwll.ch> <20201023122216.2373294-4-daniel.vetter@ffwll.ch>
 <20201023141619.GC20115@casper.infradead.org> <CAKMK7uESHHHzEC2U3xVKQEBZqS5xwQJeYFpwMz3b8OaoFEYcUQ@mail.gmail.com>
In-Reply-To: <CAKMK7uESHHHzEC2U3xVKQEBZqS5xwQJeYFpwMz3b8OaoFEYcUQ@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 23 Oct 2020 16:45:49 +0200
Message-ID: <CAKMK7uHXJhFov96un9-itsTwkatzdKqSThGpFdJuaW_G-6w5Uw@mail.gmail.com>
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

On Fri, Oct 23, 2020 at 4:37 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On Fri, Oct 23, 2020 at 4:16 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Oct 23, 2020 at 02:21:15PM +0200, Daniel Vetter wrote:
> > > Note that unlike fs_reclaim_acquire/release gfpflags_allow_blocking
> > > does not consult the PF_MEMALLOC flags. But there is no flag
> > > equivalent for GFP_NOWAIT, hence this check can't go wrong due to
> > > memalloc_no*_save/restore contexts.
> >
> > I have a patch series that adds memalloc_nowait_save/restore.
>
> tbh this was a typoed git send-email, but thanks for the heads-up,
> I'll adjust the patch accordingly.

On 2nd thought I think your patch should update
gfpflags_allow_blocking to take into account the new ->memalloc_nowait
flag you're adding. I'll comment over there in that thread.
-Daniel

>
> > https://lore.kernel.org/linux-mm/20200625113122.7540-7-willy@infradead.org/
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
