Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0F6C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BAFE60FF3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhD0KbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbhD0KaC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 06:30:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7975CC06138C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 03:29:18 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p17so2741772pjz.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 03:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jMZYZABrfr7OGNt0s/rW+IqsS+L+pSbx7V+Z+SN+IjA=;
        b=JqFzX3stztiNTGoMnHTuufqoBZMkZObwml6/tUtXurzHQu61+2r1koz/AWOAP3FDbx
         V0l6i8zD+b71IOU7cqQmQ0MyRuzadgf0Xjaa4V+DLP4CyeQKsyohEFwfxITjCkGbTWaq
         xUOgZC+T0ulTLX+ggQctpZe+4cjz1YRJfgUKhdeXcKk2PvPvnZoUKGuzIi7IUzjba6ze
         1p2rFUWX2hZ04dnZRhmX0Q6wVfKU4N/qwAaAdkobDxVJokrd2H0aYr6cXdKAYH0EmWGg
         8WOmYXNQnCEs5H6LgIKqcNXfDK5cTYDh3mron/ZJnxhdZcgQ8mgcFhT+ukFgMLjDA9XZ
         dIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jMZYZABrfr7OGNt0s/rW+IqsS+L+pSbx7V+Z+SN+IjA=;
        b=QJAgvwYRMKLeL0sQYuQjs2OOxOvlkY8eklJYrgpA6QFSSKlHaDKSJvSBF3o7BnUiVg
         Z+JqsBq2rlSZyvYGlcufLxO+B1sIhCthJVHodL9ImtF0M1yTGmp0bEG/QtS3xRbJzUC4
         nSmv8EtIM/T/CZ7We+Q3LzC5jt+artR8BtEdI82SKY2dgKu1z/ESX8nsK8FiA7FewTOb
         ECAsEuT4YDTdtE6cVysjZITwRWQnOu7a8XtXHw1PGgyt/ufvKwgIzWlgLOeq94zp4sQ1
         lRFkxp6BLwon5KjOQVuPIOyc2pIKoXD2OIEuSi/6zQEJ7UJHgHA1XpXxhcV4UFkhMPkp
         frew==
X-Gm-Message-State: AOAM531gG43JWntqxfnFG16jtW25R40oxrVZ9In03ktKD8anQSU8ln1L
        Q39o00/p+Iw7WjGrkJyE6WMSW59VDdA=
X-Google-Smtp-Source: ABdhPJxh6hMDz2iTOYKWdMAe6EtQmR0aNXAr/gEFuaYFrSC/fhX5y+CoN9qG9MJ53nMbY/rNUsbpBg==
X-Received: by 2002:a17:902:ed52:b029:ed:2f0e:eac with SMTP id y18-20020a170902ed52b02900ed2f0e0eacmr10317262plb.47.1619519357977;
        Tue, 27 Apr 2021 03:29:17 -0700 (PDT)
Received: from garuda ([122.171.173.111])
        by smtp.gmail.com with ESMTPSA id f20sm13471166pgb.47.2021.04.27.03.29.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Apr 2021 03:29:17 -0700 (PDT)
References: <20210423131050.141140-1-bfoster@redhat.com> <20210423131050.141140-4-bfoster@redhat.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] xfs: set aside allocation btree blocks from block reservation
In-reply-to: <20210423131050.141140-4-bfoster@redhat.com>
Date:   Tue, 27 Apr 2021 15:59:15 +0530
Message-ID: <871rawm35w.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Apr 2021 at 18:40, Brian Foster wrote:
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
> To address this problem, set aside in-use allocbt blocks at
> reservation time and thus ensure they cannot be reserved until truly
> available for physical allocation. This allows alloc btree metadata
> to continue to reside in free space, but dynamically adjusts
> reservation availability based on internal state. Note that the
> logic requires that the allocbt counter is fully populated at
> reservation time before it is fully effective. We currently rely on
> the mount time AGF scan in the perag reservation initialization code
> for this dependency on filesystems where it's most important (i.e.
> with active perag reservations).
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
