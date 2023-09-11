Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E4CCA0ECB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Sep 2023 21:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345562AbjIKVVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbjIKJux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 05:50:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068EAE50
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 02:50:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bf7b5e1f06so7713675ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 02:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1694425829; x=1695030629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zo3gwSlnAgdCIAM8+Km1Wnkr2Sb5aG/GGOSO40v1R40=;
        b=BQD5OtD6i2VCJsdXDF0rg+UlzHrNCkTD/EB7rlWBA80e2X1ZtPWe1dTUw2t8ORUE88
         ZRrArDr+ja0YexFsRPrm+A0XWTivxqi+rxdAy0PBH/OzS0xOhgW1Zq16wQfntnbKHlJD
         U8ksf4v8e6sOJpJ8djrnpjwyXbB8yOfB0F2i0MtiPOp63Arz8cNxNDsJ8E56782lcmRx
         TFCCuJ2YDgZleLtrN9bzMhVnzMThdiDabnPuV4hXBc5VyCBIfdkd/lwOyLvbDFItWggH
         RHxNiqgAgmbGEjnkIbvhivD/Tvk4MZoJ4EGXHV7BBQVTiIUPbuwDD7Gz4CjROViW/+s9
         q7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694425829; x=1695030629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zo3gwSlnAgdCIAM8+Km1Wnkr2Sb5aG/GGOSO40v1R40=;
        b=CkB6yPrF2G3HI61SIYrXQXm8uxZphYldQgs8vMfnuXv5sakl7z0QtF43DmFfXl2cnw
         wbMZmjncXvJJ8PlkoFa1lR4r8wJlkApVwbQgfOUkot7cAmXuhUSogcKvnMXj/loWysaQ
         IGEHtWtlMK9FvPqNFkuI5scu0Bu2avjfoN/fJJwZbrvixRKI3I/UnO+l8+yeT7VxXszm
         ETGsYIcmcfPazeMP+3RNgIPZpmckE6Mc19iFNTDJwN/oKwoMjtsdo+xjgVF5tGKJDio8
         C80ZygMznrGLwKjD9n0yKP2Sc2SYvVmBEfjXHEO1MrrP9eIbUJNAqqHqUxek+lzSpOMC
         Vheg==
X-Gm-Message-State: AOJu0YzjqtnLW4L6/Em0wnX07FbAIH+FJ5jo24Li4uhnWw30eiQDEtvp
        ZUSIMeYMXDsO2BuVr7qah0yVdA==
X-Google-Smtp-Source: AGHT+IFNoTrjJm+fp4U1vSlQVTleS+unGs/tsdGogu2eeyLNoBUX0+IqdGoKEJL6WqzJ7IldBIpdvg==
X-Received: by 2002:a17:902:e849:b0:1bb:83ec:832 with SMTP id t9-20020a170902e84900b001bb83ec0832mr11264528plg.2.1694425829510;
        Mon, 11 Sep 2023 02:50:29 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id az7-20020a170902a58700b001bdc2fdcf7esm5988188plb.129.2023.09.11.02.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 02:50:29 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH v6 35/45] xfs: dynamically allocate the xfs-inodegc shrinker
Date:   Mon, 11 Sep 2023 17:44:34 +0800
Message-Id: <20230911094444.68966-36-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230911094444.68966-1-zhengqi.arch@bytedance.com>
References: <20230911094444.68966-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the xfs-inodegc shrinker, so that it can be freed
asynchronously via RCU. Then it doesn't need to wait for RCU read-side
critical section when releasing the struct xfs_mount.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
CC: Chandan Babu R <chandan.babu@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>
CC: linux-xfs@vger.kernel.org
---
 fs/xfs/xfs_icache.c | 26 +++++++++++++++-----------
 fs/xfs/xfs_mount.c  |  4 ++--
 fs/xfs/xfs_mount.h  |  2 +-
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e541f5c0bc25..aacc7eec2497 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2187,8 +2187,7 @@ xfs_inodegc_shrinker_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
-						   m_inodegc_shrinker);
+	struct xfs_mount	*mp = shrink->private_data;
 	struct xfs_inodegc	*gc;
 	int			cpu;
 
@@ -2209,8 +2208,7 @@ xfs_inodegc_shrinker_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
-						   m_inodegc_shrinker);
+	struct xfs_mount	*mp = shrink->private_data;
 	struct xfs_inodegc	*gc;
 	int			cpu;
 	bool			no_items = true;
@@ -2246,13 +2244,19 @@ int
 xfs_inodegc_register_shrinker(
 	struct xfs_mount	*mp)
 {
-	struct shrinker		*shrink = &mp->m_inodegc_shrinker;
+	mp->m_inodegc_shrinker = shrinker_alloc(SHRINKER_NONSLAB,
+						"xfs-inodegc:%s",
+						mp->m_super->s_id);
+	if (!mp->m_inodegc_shrinker)
+		return -ENOMEM;
+
+	mp->m_inodegc_shrinker->count_objects = xfs_inodegc_shrinker_count;
+	mp->m_inodegc_shrinker->scan_objects = xfs_inodegc_shrinker_scan;
+	mp->m_inodegc_shrinker->seeks = 0;
+	mp->m_inodegc_shrinker->batch = XFS_INODEGC_SHRINKER_BATCH;
+	mp->m_inodegc_shrinker->private_data = mp;
 
-	shrink->count_objects = xfs_inodegc_shrinker_count;
-	shrink->scan_objects = xfs_inodegc_shrinker_scan;
-	shrink->seeks = 0;
-	shrink->flags = SHRINKER_NONSLAB;
-	shrink->batch = XFS_INODEGC_SHRINKER_BATCH;
+	shrinker_register(mp->m_inodegc_shrinker);
 
-	return register_shrinker(shrink, "xfs-inodegc:%s", mp->m_super->s_id);
+	return 0;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0a0fd19573d8..aed5be5508fe 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1021,7 +1021,7 @@ xfs_mountfs(
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
-	unregister_shrinker(&mp->m_inodegc_shrinker);
+	shrinker_free(mp->m_inodegc_shrinker);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
@@ -1104,7 +1104,7 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp);
 #endif
-	unregister_shrinker(&mp->m_inodegc_shrinker);
+	shrinker_free(mp->m_inodegc_shrinker);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a25eece3be2b..b8796bfc9ba4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -221,7 +221,7 @@ typedef struct xfs_mount {
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
-	struct shrinker		m_inodegc_shrinker;
+	struct shrinker		*m_inodegc_shrinker;
 	/*
 	 * Workqueue item so that we can coalesce multiple inode flush attempts
 	 * into a single flush.
-- 
2.30.2

