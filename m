Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F6DEB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbjGNGqU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjGNGqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:46:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509F13AA8
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3fbc5d5742eso15108115e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689317117; x=1691909117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPSDIbaxTNh3TAqtA4XCx0bfvfZiTomjp6ixjsSsxD0=;
        b=bv/yKV2QJ6KV8SbknD5fNEKr1xx/VsE+9/itsFkNrrvuueCaiNjmsBbuA6hcCIs+M7
         YSo6oLiToAZGQhZ2yR6i8ikuhl2qBVwie5rzUM0BA57JpSCifexgj9SSkwi95057tWgQ
         989vpSqU62EkzJNPQvB8HNoIw4mXf0Dtyk/PO2egpNjCxwxq/HlO5vYtLdisZKgfoS3x
         bgzTE094yJZW2pVR12zyI3osI12zioic7hVbkPUJ0Ur4AqmyHu3+U2f3iu4/Mx7O/PAk
         miyAsFOC6pxAAT9Vru+TeWLFu3odakyfnaj2lux9ozUpOmzL8Wr2SH/T72vd3RugeHOm
         +AHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689317117; x=1691909117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPSDIbaxTNh3TAqtA4XCx0bfvfZiTomjp6ixjsSsxD0=;
        b=S3q1y+1MyBt59fOzKIoC3gNWdH9xxmkv3gYzfGqTWW7frj4pMcEzxcWfGPhq3ki45n
         RNTMx2BJEgraOo9Jst/EEHixzREjs6IE09WRZiOR7xR0Rsq97KPGSzs5yrZIwrHG9rdg
         g9Lhzj8f+tUOQYzmHkJok9sUP1v5r01BkeHOedJQsgE3gB7AlY98AwpimLd2P9nazWHy
         /byTDNOKp6JCfoxTeWB1AzEUcvhRbCnRBQn3WwRMxWxTX3pyojfGebn1RabvkOzny3/D
         D75dPeg6FjXvzYm11UCRPrrkJuxa82n7vecLu2umr1OK9dk7vBIrnRZ91l9HnkBkaPkn
         vLmg==
X-Gm-Message-State: ABy/qLawunWqApxOOI5xa71LmlLJnRixGJYldq/bAN0cONyAxposSlx0
        PWkj2zRe1hWZG+E5okheCJw=
X-Google-Smtp-Source: APBJJlHwclFOABkAAgcMmXqdV9aAK7Mjax2S5r6Z5TpfCagTRY93xzw15kMTSOIfTHI90q2H6v6S/g==
X-Received: by 2002:a05:600c:21c4:b0:3fb:b3f8:506b with SMTP id x4-20020a05600c21c400b003fbb3f8506bmr3215998wmj.24.1689317116747;
        Thu, 13 Jul 2023 23:45:16 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c234300b003fc04d13242sm709574wmq.0.2023.07.13.23.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 23:45:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE v2 1/4] xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
Date:   Fri, 14 Jul 2023 09:45:06 +0300
Message-Id: <20230714064509.1451122-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714064509.1451122-1-amir73il@gmail.com>
References: <20230714064509.1451122-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 03e0add80f4cf3f7393edb574eeb3a89a1db7758 upstream.

I've been noticing odd racing behavior in the inodegc code that could
only be explained by one cpu adding an inode to its inactivation llist
at the same time that another cpu is processing that cpu's llist.
Preemption is disabled between get/put_cpu_ptr, so the only explanation
is scheduler mayhem.  I inserted the following debug code into
xfs_inodegc_worker (see the next patch):

	ASSERT(gc->cpu == smp_processor_id());

This assertion tripped during overnight tests on the arm64 machines, but
curiously not on x86_64.  I think we haven't observed any resource leaks
here because the lockfree list code can handle simultaneous llist_add
and llist_del_all functions operating on the same list.  However, the
whole point of having percpu inodegc lists is to take advantage of warm
memory caches by inactivating inodes on the last processor to touch the
inode.

The incorrect scheduling seems to occur after an inodegc worker is
subjected to mod_delayed_work().  This wraps mod_delayed_work_on with
WORK_CPU_UNBOUND specified as the cpu number.  Unbound allows for
scheduling on any cpu, not necessarily the same one that scheduled the
work.

Because preemption is disabled for as long as we have the gc pointer, I
think it's safe to use current_cpu() (aka smp_processor_id) to queue the
delayed work item on the correct cpu.

Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_icache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index eae7427062cf..536885f8b8a8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2052,7 +2052,8 @@ xfs_inodegc_queue(
 		queue_delay = 0;
 
 	trace_xfs_inodegc_queue(mp, __return_address);
-	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
+	mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+			queue_delay);
 	put_cpu_ptr(gc);
 
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
@@ -2096,7 +2097,8 @@ xfs_inodegc_cpu_dead(
 
 	if (xfs_is_inodegc_enabled(mp)) {
 		trace_xfs_inodegc_queue(mp, __return_address);
-		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
+		mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+				0);
 	}
 	put_cpu_ptr(gc);
 }
-- 
2.34.1

