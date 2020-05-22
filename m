Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9952FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63BED20756
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpQVOLPd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgEVMT3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbgEVMT2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:19:28 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44939C061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 05:19:28 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d5so1608231ios.9
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 05:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N9ZxkGmw4yLtfogJ23ZRkmobzxEzbBk4C6Sps8DdW3o=;
        b=bpQVOLPdpaeQ4IhpmAVQr/QOyEGA13NmF4ei9E7Ws2I7nVk+1oUjYBgWj2kFhMwsuY
         d/jn5a0ZRv4A2Ei9sYtnPuI6+eJqS7BLEb4EZkr3RdZkL3/8o+yXW2vrgIsj5RzdtVaO
         EETWgbsuA0FhH0xekIC39aGGI3jzoBEN+ISFfQmDhQC39/2+RUgvkxRgUelk82HXOQbV
         /hgecH2zV4SLTvtnLSYbckWHpknGybuURQ8sJaFhMDmvdKYpukVTEFlej3O4bCt5ncYu
         h3GZrhu5rrC9MqgjuCfyeGUbCariKT29NN2pnq9jKUhC2UuC2dcH+fXqUoRah1ZBHrUm
         7aUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N9ZxkGmw4yLtfogJ23ZRkmobzxEzbBk4C6Sps8DdW3o=;
        b=D6b1FgCcadCLXhyZ2TieLZHDoexaBNyC90ksDUwzftbR+egqI+R4/f2O9j3G18IMEi
         F1WjQdVRCmS2FwHnsNTP3uk4WnOPximID4LCZBg+U9yctgzFPlyi9Bvw7mXsvxal6ZX/
         uLFEGrxFvSG0cKYDw85plHMER0rua2HTCfa2TunLprwAqWbr6TmceqPkihpRdFqrJBfD
         ZdqemPctQ4EHsFQF+I7SfzKbpUfSeamK4Yn195ZphupXvjDrieMGwqO7xeDMsCVum5hl
         ZM73cuNiKanOvDSDAusyz6IjpNM4UBytJh2r3G/RXsbdA1qJAmNUIczG4naJXNx9+fPJ
         CSsw==
X-Gm-Message-State: AOAM5311aoV0zcIG4dt+UupYgXj+mx+DWNMmdAf83Glefqy8SIcMZ0tQ
        98K8RPEwJ/h8oO5ghySO71cfzrMe/m4kdD1+WThifJIO
X-Google-Smtp-Source: ABdhPJyT43dB26pFASz2rqWyai3GCSRhctjdJRUxuA1FCtK9Z37Ib2RXilMPesraUAfz9hImbyGi68sjzlmzwws4DSg=
X-Received: by 2002:a05:6638:45d:: with SMTP id r29mr7584259jap.93.1590149967608;
 Fri, 22 May 2020 05:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <20200522035029.3022405-14-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-14-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 15:19:16 +0300
Message-ID: <CAOQ4uxiit=kANPpQBDuT5kU4uuzO1Oi2p8HwU4wuoF1k7viXuw@mail.gmail.com>
Subject: Re: [PATCH 13/24] xfs: make inode reclaim almost non-blocking
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:51 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Now that dirty inode writeback doesn't cause read-modify-write
> cycles on the inode cluster buffer under memory pressure, the need
> to throttle memory reclaim to the rate at which we can clean dirty
> inodes goes away. That is due to the fact that we no longer thrash
> inode cluster buffers under memory pressure to clean dirty inodes.
>
> This means inode writeback no longer stalls on memory allocation
> or read IO, and hence can be done asynchrnously without generating
> memory pressure. As a result, blocking inode writeback in reclaim is
> no longer necessary to prevent reclaim priority windup as cleaning
> dirty inodes is no longer dependent on having memory reserves
> available for the filesystem to make progress reclaiming inodes.
>
> Hence we can convert inode reclaim to be non-blocking for shrinker
> callouts, both for direct reclaim and kswapd.
>
> On a vanilla kernel, running a 16-way fsmark create workload on a
> 4 node/16p/16GB RAM machine, I can reliably pin 14.75GB of RAM via
> userspace mlock(). The OOM killer gets invoked at 15GB of
> pinned RAM.
>
> With this patch alone, pinning memory triggers premature OOM
> killer invocation, sometimes with as much as 45% of RAM being free.
> It's trivially easy to trigger the OOM killer when reclaim does not
> block.
>
> With pinning inode clusters in RAM adn then adding this patch, I can

typo: adn

> reliably pin 14.5GB of RAM and still have the fsmark workload run to
> completion. The OOM killer gets invoked 14.75GB of pinned RAM, which
> is only a small amount of memory less than the vanilla kernel. It is
> much more reliable than just with async reclaim alone.
>
> simoops shows that allocation stalls go away when async reclaim is
> used. Vanilla kernel:
>
> Run time: 1924 seconds
> Read latency (p50: 3,305,472) (p95: 3,723,264) (p99: 4,001,792)
> Write latency (p50: 184,064) (p95: 553,984) (p99: 807,936)
> Allocation latency (p50: 2,641,920) (p95: 3,911,680) (p99: 4,464,640)
> work rate = 13.45/sec (avg 13.44/sec) (p50: 13.46) (p95: 13.58) (p99: 13.70)
> alloc stall rate = 3.80/sec (avg: 2.59) (p50: 2.54) (p95: 2.96) (p99: 3.02)
>
> With inode cluster pinning and async reclaim:
>
> Run time: 1924 seconds
> Read latency (p50: 3,305,472) (p95: 3,715,072) (p99: 3,977,216)
> Write latency (p50: 187,648) (p95: 553,984) (p99: 789,504)
> Allocation latency (p50: 2,748,416) (p95: 3,919,872) (p99: 4,448,256)
> work rate = 13.28/sec (avg 13.32/sec) (p50: 13.26) (p95: 13.34) (p99: 13.34)
> alloc stall rate = 0.02/sec (avg: 0.02) (p50: 0.01) (p95: 0.03) (p99: 0.03)
>
> Latencies don't really change much, nor does the work rate. However,
> allocation almost never stalls with these changes, whilst the
> vanilla kernel is sometimes reporting 20 stalls/s over a 60s sample
> period. This difference is due to inode reclaim being largely
> non-blocking now.
>
> IOWs, once we have pinned inode cluster buffers, we can make inode
> reclaim non-blocking without a major risk of premature and/or
> spurious OOM killer invocation, and without any changes to memory
> reclaim infrastructure.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

I can confirm observing the stalls on production servers and that
this patch alone fixes the stalls.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
