Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E56C83013
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6ECD2067C
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="gwqmqFyS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbgKYQZ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731491AbgKYQZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 11:25:41 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8087AC0613D4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:39 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id x22so2503457wmc.5
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uUxbRrS9MFqXGOvk/ieUK3bhzkS/VSko486/NfxYD1w=;
        b=gwqmqFySnTT8wFc9pyNO08a05EtFio6skO3VOfMb8mdBj6W1qBPu6+VRr2k1XCh6kl
         Q/nUJzrA1+98qaJuJmEx9Yj8Xp0Qz4KncxaIhz/aDBFojKu7G5YnfJs/2YEnSNGH2lKf
         sVR6MQzcank3A6sMNUPe9nWSpOoUBv2+cAY+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uUxbRrS9MFqXGOvk/ieUK3bhzkS/VSko486/NfxYD1w=;
        b=s8fpPIaKIXiU0lwRjN6VbJEsKEnbP0nyHnEphBeW5y98j9BRRsbvy7fh5aoQ5sEJMw
         lmeJ/O3DWVvOpSZRlwJpj5+lmcGlwzvxXoIcLJWpQFIo4JYSYJ+nIAHhBFkyc+RVHiBc
         RvMonNkIJTPUKooAyryip02ITzmtL2W8W95KjfXfGEaYVDHCdp8n/J+SojbsOFG8iUV3
         kVM0TEmNCfr/pTe93F4bho/dpQSUPqQifrQEsTk66AuRMzTaBGDBUb8CSzHb2tnwv6nW
         LfK/wU13KxW9NOWT8i16ivN+ZHAXIapbh9+RM/ukt3CRWuV1nFRvBr5p3g4n015F2IV1
         Lnyg==
X-Gm-Message-State: AOAM532WbSeRjB2IBGJnHn1rwosSStuGvGTRBAaz82HYlbIpnIJ6Oxd4
        vIQbFwdE1OKqPRFFgCGOoyXYZA==
X-Google-Smtp-Source: ABdhPJwU55boKQUargCwj7uABbDFGkLI6m5Shju4RIwPqnobg7pzset1RPYMkQXjIR0a2azRJHembg==
X-Received: by 2002:a1c:1b06:: with SMTP id b6mr3649998wmb.101.1606321538289;
        Wed, 25 Nov 2020 08:25:38 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id a21sm4855187wmb.38.2020.11.25.08.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 08:25:37 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v4 0/3] mmu_notifier vs fs_reclaim lockdep annotations
Date:   Wed, 25 Nov 2020 17:25:28 +0100
Message-Id: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Just resending with the polish applied, no functional changes at all.

Previous versions.

v3: https://lore.kernel.org/dri-devel/20201120095445.1195585-1-daniel.vetter@ffwll.ch/
v2: https://lore.kernel.org/dri-devel/20200610194101.1668038-1-daniel.vetter@ffwll.ch/

Changes since v3:
- more acks/r-b
- typos in the kerneldoc fixed

Changes since v2:
- Now hopefully the bug that bombed xfs fixed.
- With unit-tests (that's the part I really wanted and never got to)
- might_alloc() helper thrown in for good.

I think if we have an ack/review from fs-devel this should be good to
land. Last version that landed in -mm (v2) broke xfs pretty badly.

Unfortuantely I don't have a working email from Qian anymore, who reported
the xfs issue. Maybe Dave Chinner instead?

Cheers, Daniel

Daniel Vetter (3):
  mm: Track mmu notifiers in fs_reclaim_acquire/release
  mm: Extract might_alloc() debug check
  locking/selftests: Add testcases for fs_reclaim

 include/linux/sched/mm.h | 16 ++++++++++++++
 lib/locking-selftest.c   | 47 ++++++++++++++++++++++++++++++++++++++++
 mm/mmu_notifier.c        |  7 ------
 mm/page_alloc.c          | 31 ++++++++++++++++----------
 mm/slab.h                |  5 +----
 mm/slob.c                |  6 ++---
 6 files changed, 86 insertions(+), 26 deletions(-)

-- 
2.29.2

