Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2944AEE3F0C
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 18:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjILSBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjILSA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 14:00:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E8BE59
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:55 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-68fb7fb537dso2474699b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694541655; x=1695146455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A+VdHsUPFr99ByDdqV0KSloI0Hit73O3TeYel7NTiI=;
        b=Tt66zNY1UkMWVVQhuHTxizbyG3PNw/7/dbQWVywycgZdJWrtxFehGMxaOUrfXKt05M
         w0La8EX/QIviqcN7j4EEKDc+Sk/zO6ouexV1GWG6cCkqWmBfsrOcIxBeTFkg2Ayn8yDe
         v7LnBVM84QSAH+EN5vupWmBTDohPHjnqIpVnP3dfUp8AbjzxF1HB4UG+sPQekaSXQ1z9
         QLApPRa6DJ1lr1TLzd/yikNBLhDncCPGwESgW/tMZyLVFyWAU7Aw+m7bHpxuRsNezXfq
         Fe0nMW9MSbBMd5I43Dx+LxqZR274N0rgsiP7roE76ZkLlati0A06xw9IgJVvfZVLC65r
         7tGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694541655; x=1695146455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7A+VdHsUPFr99ByDdqV0KSloI0Hit73O3TeYel7NTiI=;
        b=K/bIF/hxReSWncX4oiXzp6gaiARO0rSnBWGCucmCgpTfPrrSMhhOg4pSp9+vsZVUs+
         PJ5G+Lz8oQ94IhyYYOLl+R/f8lMxQBKN14vCMIzA3xkV5VmkixrsrX4uLLe9HbyQjWNm
         BCcna/hpdczGsGj5lZ/hWBZJ+TKVNqWpYbAAnm0onrCPg5MwKhm8iY8Z1nDzEg7D+hdN
         ualD08FfOJI0hOExjeQ6nK74gniSYDSYLACK7H6DcFQN+FHBN2S/u1ft9eOCvTB3Ouhn
         mRwc1zIUu+QrzE2RZdNKvOAD4/EeKsG73UfYENwCJIWXOMKHrVLMERUyF8wZWZCG1bEX
         fyGw==
X-Gm-Message-State: AOJu0YwUXnbzm9UW2jw3RZvOOVSd4KixKBncMdwZA5B9ig5vyqrQtXpH
        QZKCpTVQRRxx/+cQPiBR8+qI0SPUkNo1cg==
X-Google-Smtp-Source: AGHT+IEHHJQL5CS73MPcf9ccoUH7YZmBemf9oIaaSS1HJl1efQKly8HA41WxpBuvaC5/qtUNz2Sr1Q==
X-Received: by 2002:a05:6a20:914e:b0:14c:6404:7c5e with SMTP id x14-20020a056a20914e00b0014c64047c5emr161532pzc.24.1694541655032;
        Tue, 12 Sep 2023 11:00:55 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:e951:d95c:9c79:d1b])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0068be7119c70sm3412246pfn.186.2023.09.12.11.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:00:54 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 3/6] xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
Date:   Tue, 12 Sep 2023 11:00:37 -0700
Message-ID: <20230912180040.3149181-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230912180040.3149181-1-leah.rumancik@gmail.com>
References: <20230912180040.3149181-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 03e0add80f4cf3f7393edb574eeb3a89a1db7758 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e9ebfe6f8015..ab8181f8d08a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2057,7 +2057,8 @@ xfs_inodegc_queue(
 		queue_delay = 0;
 
 	trace_xfs_inodegc_queue(mp, __return_address);
-	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
+	mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+			queue_delay);
 	put_cpu_ptr(gc);
 
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
@@ -2101,7 +2102,8 @@ xfs_inodegc_cpu_dead(
 
 	if (xfs_is_inodegc_enabled(mp)) {
 		trace_xfs_inodegc_queue(mp, __return_address);
-		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
+		mod_delayed_work_on(current_cpu(), mp->m_inodegc_wq, &gc->work,
+				0);
 	}
 	put_cpu_ptr(gc);
 }
-- 
2.42.0.283.g2d96d420d3-goog

