Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37011C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 07:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344713AbiE0HCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 03:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344712AbiE0HCC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 03:02:02 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC698E2777;
        Fri, 27 May 2022 00:02:00 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id e2so3013467qvq.13;
        Fri, 27 May 2022 00:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yGtyTEdveXRcSR/o79WVTSJwn3zC4/L8aLctM+0PAFI=;
        b=pRWa0t0GYx+8p5KHFLie4wV53c/aEH7XGbL/2DXeRg2+7fNI3VIWZS6fNSmkfr1Ka0
         hB73Hr5CziNNFLaNk9XioEOvfHhIzJoDb7vO7XzEjFNZOxlI7dcQPx0l7+S5bifRstuh
         V5WI0wn2bctDjr3RBVfSmbPIZWfHdW1z7/SYW+FPIl6LNRvvl1L1fll+YEttrzoj2Wov
         DtX4f7U4Fsks1i5eOI3ZmkVdMkpQXVy+2TAFGHGsu/EQVYLi9xpf17V+6op5TWLiROua
         LNMxuLq0kvB5qXkk3TNy5aXQPKsYjXAF5Ih3pjB33dUG6hKPFQiaOgnI5A9BEnuaiWyG
         PTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yGtyTEdveXRcSR/o79WVTSJwn3zC4/L8aLctM+0PAFI=;
        b=3+ZPpRo7FqMoK26vA6DAMqeD+4wxzvdWLYTcav0cCJP4PbWMZDPjnBthjeLcA+Wt8V
         gWnPh+Qd83BzuGmzVHxu+mzUmwHAeUoUwljkWKk/g2IATExYjYIGhLNs7ImquoS464WD
         m7FKGveFD25NxfsNf1ldTc5fjQvuBlklQNJaBaFlIQKDf1bsnKpNAlsoaumrBHhbw477
         vVOTyJVGdOGHManUaRz4FveiKelwqnWbsYYKXWySSrWipyqG6y9lQ/ae7SRCb/rFba58
         c/rLU2LSej4RdQeif23r0/lfo1D5ozEPcLMAxfwAdQjJkPo5xehA3Z/f3BbuThsl8a/Q
         Nzfw==
X-Gm-Message-State: AOAM531KTLb/Pi9BY3eO+oyOrrntIocJ4WvYFzZgPN0xOLgOvUSuvYhw
        QGPCsNTkcvIuN6zQwic15k7LFcma57SYAO3E7nM=
X-Google-Smtp-Source: ABdhPJyOuuMsQeq/7b+s5cnhGc/m7E9zf967H+H8ogM0Zzanzh9j7PrRZf5gQFOM8L+Fr8AF+e32pKDIVtANCXRHQ7s=
X-Received: by 2002:a05:6214:5296:b0:461:d3bb:ba01 with SMTP id
 kj22-20020a056214529600b00461d3bbba01mr33814685qvb.12.1653634919984; Fri, 27
 May 2022 00:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <YpBqfdmwQ675m72G@infradead.org>
In-Reply-To: <YpBqfdmwQ675m72G@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 27 May 2022 10:01:48 +0300
Message-ID: <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 9:06 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> FYI, below is the 5.10-stable backport I have been testing earlier this
> week that fixes a bugzilla reported hang:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=214767
>
> I was just going to submit it to the stable maintaines today after
> beeing out of the holiday, but if you want to add it to this queue
> that is fine with me as well.
>

Let me take it for a short spin in out xfs stable test environment, since
this env has caught one regression with an allegedly safe fix.
This env has also VMs with old xfsprogs, which is kind of important to
test since those LTS patches may end up in distros with old xfsprogs.

If all is well, I'll send your patch later today to stable maintainers
with this first for-5.10 series.

> ---
> From 8e0464752b24f2b3919e8e92298759d116b283eb Mon Sep 17 00:00:00 2001
> From: Dave Chinner <dchinner@redhat.com>
> Date: Fri, 18 Jun 2021 08:21:51 -0700
> Subject: xfs: Fix CIL throttle hang when CIL space used going backwards
>

Damn! this patch slipped through my process (even though I did see
the correspondence on the list).

My (human) process has eliminated the entire 38 patch series
https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/
without noticing the fix that was inside it.

I did read every cover letter carefully for optimization series that I
eliminated
to look for important fixes and more than once I did pick singular fix patches
from optimization/cleanup series.

In this case, I guess Dave was not aware of the severity of the bug fixed
when he wrote the cover letter(?), but the fact that the series is not only
an improvement was not mentioned.

It's good that we have many vectors to find stable fixes :)

Cheers,
Amir.
