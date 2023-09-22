Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A78BE7D0BD
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Sep 2023 01:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjIVBCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjIVBCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 21:02:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989BB191;
        Thu, 21 Sep 2023 18:02:04 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so1154617a12.1;
        Thu, 21 Sep 2023 18:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695344524; x=1695949324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4RpEijZkHhrZhok0AVAG9y8sjWcEhatG6TrQcYg+Rk=;
        b=VE8DJYTchENIckpeTkz0DjpTLxInLx8u7B4g1Kow99Epn36D+uUT2cfe3gesYWIUgS
         4IeCivuUnGql+Q3bIbXmJFxdsHLPj5Vo4TiRL7+C1uGEb/dOkeCJ0vcOc9dYjSqAgc0W
         V0flqUilDn+dEhFKDdyZjlSkhXUVEBRLGM6cDLovizDA0IfR3+S0Q0zwXPykSXiyCwXn
         9dJELxJFh9i/qey7aaM+WonR3bIMiMzD1Yzx+qt2+Xkgf2TujIxJOJAsq0FB4rYgJZc+
         sY1o8xq1qE2w7OPHHGWnsnhuqXJ/CB0X6KWky83ay1pc2hWsjujbhqYN4VqjfK6MZjwU
         yqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695344524; x=1695949324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4RpEijZkHhrZhok0AVAG9y8sjWcEhatG6TrQcYg+Rk=;
        b=L3qmB2Lkr/yMHfrjAHJkDYJaElKO5NwqNWCkDMPeCNF3IKvB+1gEEr0+SpHSCGcZnO
         /+jwtqr0FsGvbIvzaClr3NVrMdiYRbBX/JQPamrTqQxMeuWLNHiumAgU2tXXx02UkbxO
         JCvbn8m5w5LHFSaFChhblDPEPwD1rX5MDb0Vxty/2JKIDAbugwwFkqBiMLy5+mbEmmop
         Wf54vtghlD34KmsWcV8xNCAMZwe9DmU3EzU3AugxA9Ftsp4f0CkO93XOg2+F9XD/YywG
         W/zjn5aNcN6/Ec4H0ZGkGBGygd3eYoYTnah3yoc5CWIG0v4uE2AfGTVSglcIVIyMfKJt
         beaA==
X-Gm-Message-State: AOJu0YxHl05l58CishRnUDmScMlwuiaqm1oAAVyV4zw7AT18K15TGeyd
        e+YLCOZcNdTePC2UPOfVdTLOPwevw6Uxtg==
X-Google-Smtp-Source: AGHT+IEPdUDx33rJnEJYgcT1KfTEkHAsW96L9CiCvIMYSUMYhtq99kFMe1fRhDkmm4Q9Z/tOUCigtg==
X-Received: by 2002:a05:6a21:a5a3:b0:153:40c3:aa71 with SMTP id gd35-20020a056a21a5a300b0015340c3aa71mr9188349pzc.43.1695344523834;
        Thu, 21 Sep 2023 18:02:03 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d5ff:b7b0:7028:8af6])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001bc445e2497sm2178815plz.79.2023.09.21.18.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 18:02:03 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 3/6] xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
Date:   Thu, 21 Sep 2023 18:01:53 -0700
Message-ID: <20230922010156.1718782-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230922010156.1718782-1-leah.rumancik@gmail.com>
References: <20230922010156.1718782-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.42.0.515.g380fc7ccd1-goog

