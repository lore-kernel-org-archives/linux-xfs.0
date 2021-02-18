Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013F5C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 07:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0AB61494
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 07:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBRHzh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 02:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhBRHwq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 02:52:46 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3039DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 23:51:09 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fa16so874662pjb.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 23:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=+lqdI/WJohYsXT4fAKdlVv1XEuod0Vv/50s+N9toB0c=;
        b=eSBvVM78pAk/+g9YNHieVSlAozumdyIyIYL8qn8TYLEjeo2aOwk3XYPg1b8ZmHl5AD
         WkFogtz0VBvrE9rdOyPHuxMHzBmmHy7fxI5w4OODo86nzNRjKWnBx1Kf/J5ZA0LklZNS
         ek5Hs1C2bETToqJpuUSzn3BK7xqN83HlO9hxbUUIAZfRap3gkkV3ixqJMBkXVBAFNRzq
         1nbXMok9+5ZrtfngzrLBXIBKbhjYH4f7OGisdvpUqiJkx+1hZKgFWY070B7WoILzdrKR
         1Wptu41mz51L1e3HCgk6L2JPhYbNNylJNkWt6w7vqookHBKL3Kp/QuPU/TBQsGtN61nO
         M+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=+lqdI/WJohYsXT4fAKdlVv1XEuod0Vv/50s+N9toB0c=;
        b=Lib7vVl8Qkyi0VtrzyuB6qWVsR4qV53CSdq9hkkz1D4gVPZhMOu2bQMhnhWxV+Kur9
         ptH1HQEU/DPmpLU0gMOv48h0vuP9p9GmF4MztYc7OQYdNkRSfMpt3TZvfIKTh2s1/xFd
         v9bFJKytzM0E37oDfDkte0hk/bc7s1FRA0v5hY9FKqvam7hxmNE5EDyixScGJJcpzTot
         WiCrruDUMwTWmCZySVYi9ehxBIHw570bSJWYGDZ3q7jxyyXi39v/ip1Qn601tQVffymd
         tmNClpf+FZuLoT3C7js/IFXMzffCvDPBEm5n1bIPjZCji+9C1h+lFVPU9f7msWTAYwig
         jiHQ==
X-Gm-Message-State: AOAM531YFqo1vVXqPn8Tm7BXdl0v/xfK4xVDvmjvjTGOvksI23WpqqXm
        CfjZAPjizOrLJshshxGP5K326cFbz2k=
X-Google-Smtp-Source: ABdhPJxoj+59eoqxAXbZHQZMLx3WFB/35qEWK8k2EPaqedVf2PijkScnf5dSCeswK9gFNRJVMnV/PA==
X-Received: by 2002:a17:90b:17c7:: with SMTP id me7mr2853612pjb.205.1613634668443;
        Wed, 17 Feb 2021 23:51:08 -0800 (PST)
Received: from garuda ([122.171.191.50])
        by smtp.gmail.com with ESMTPSA id n1sm4899916pgn.94.2021.02.17.23.51.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Feb 2021 23:51:08 -0800 (PST)
References: <20210217132339.651020-1-bfoster@redhat.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set aside allocation btree blocks from block reservation
In-reply-to: <20210217132339.651020-1-bfoster@redhat.com>
Date:   Thu, 18 Feb 2021 13:21:05 +0530
Message-ID: <87eehd95li.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17 Feb 2021 at 18:53, Brian Foster wrote:
> The blocks used for allocation btrees (bnobt and countbt) are
> technically considered free space. This is because as free space is
> used, allocbt blocks are removed and naturally become available for
> traditional allocation. However, this means that a significant
> portion of free space may consist of in-use btree blocks if free
> space is severely fragmented.
>
> On large filesystems with large perag reservations, this can lead to
> a rare but nasty condition where a significant amount of physical
> free space is available, but the majority of actual usable blocks
> consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> blocks tracked across ~300 total allocbt blocks, but effectively at
> 100% full because the the free space is entirely consumed by
> refcountbt perag reservation.
>
> Such a large perag reservation is by design on large filesystems.
> The problem is that because the free space is so fragmented, this AG
> contributes the 300 or so allocbt blocks to the global counters as
> free space. If this pattern repeats across enough AGs, the
> filesystem lands in a state where global block reservation can
> outrun physical block availability. For example, a streaming
> buffered write on the affected filesystem continues to allow delayed
> allocation beyond the point where writeback starts to fail due to
> physical block allocation failures. The expected behavior is for the
> delalloc block reservation to fail gracefully with -ENOSPC before
> physical block allocation failure is a possibility.
>
> To address this problem, introduce a percpu counter to track the sum
> of the allocbt block counters already tracked in the AGF. Use the
> new counter to set these blocks aside at reservation time and thus
> ensure they cannot be allocated until truly available. Since this is
> only necessary when large reflink perag reservations are in place
> and the counter requires a read of each AGF to fully populate, only
> enforce on reflink enabled filesystems. This allows initialization
> of the counter at ->pagf_init time because the refcountbt perag
> reservation init code reads each AGF at mount time.
>
> Note that the counter uses a small percpu batch size to allow the
> allocation paths to keep the primary count accurate enough that the
> reservation path doesn't ever need to lock and sum the counter.
> Absolute accuracy is not required here, just that the counter
> reflects the majority of unavailable blocks so the reservation path
> fails first.
>

The changes look good to me from the perspective of logical correctness.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
