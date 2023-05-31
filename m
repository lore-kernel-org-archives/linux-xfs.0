Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48677C77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 10:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbjEaKEX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 06:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbjEaKEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 06:04:20 -0400
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 03:04:18 PDT
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [IPv6:2001:41d0:1004:224b::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A8B9F
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 03:04:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685527104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzyzkXd70pYEdWJhGutN+U1hmZmD/p5d/wpcM6Ajy+8=;
        b=ZihWgnR2scrQOnB2k5nDPiR/oFSAGcE5oxTl8DJZlC6c35SkDHP860/TT0nEoqYq/lrcq1
        d6CKRaCpb2dkgODgBX/qkpML3eCN0n5h1kziLNHv4ErGYZOVxBG6L8XG40g2Y8QxSO+u0s
        Pr9f8hmxkoCyCfWi4RAZ5pmhxQ/yWCA=
From:   Qi Zheng <qi.zheng@linux.dev>
To:     akpm@linux-foundation.org, tkhai@ya.ru, roman.gushchin@linux.dev,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, brauner@kernel.org,
        djwong@kernel.org, hughd@google.com, paulmck@kernel.org,
        muchun.song@linux.dev
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 2/8] mm: vmscan: split unregister_shrinker()
Date:   Wed, 31 May 2023 09:57:36 +0000
Message-Id: <20230531095742.2480623-3-qi.zheng@linux.dev>
In-Reply-To: <20230531095742.2480623-1-qi.zheng@linux.dev>
References: <20230531095742.2480623-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kirill Tkhai <tkhai@ya.ru>

This and the next patches in this series aim to make
time effect of synchronize_srcu() invisible for user.
The patch splits unregister_shrinker() in two functions:

	unregister_shrinker_delayed_initiate()
	unregister_shrinker_delayed_finalize()

and shrinker users may make the second of them to be called
asynchronous (e.g., from workqueue). Next patches make
superblock shrinker to follow this way, so user-visible
umount() time won't contain delays from synchronize_srcu().

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/shrinker.h |  2 ++
 mm/vmscan.c              | 22 ++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 224293b2dd06..e9d5a19d83fe 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -102,6 +102,8 @@ extern void register_shrinker_prepared(struct shrinker *shrinker);
 extern int __printf(2, 3) register_shrinker(struct shrinker *shrinker,
 					    const char *fmt, ...);
 extern void unregister_shrinker(struct shrinker *shrinker);
+extern void unregister_shrinker_delayed_initiate(struct shrinker *shrinker);
+extern void unregister_shrinker_delayed_finalize(struct shrinker *shrinker);
 extern void free_prealloced_shrinker(struct shrinker *shrinker);
 extern void synchronize_shrinkers(void);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a773e97e152e..baf8d2327d70 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -799,10 +799,7 @@ int register_shrinker(struct shrinker *shrinker, const char *fmt, ...)
 #endif
 EXPORT_SYMBOL(register_shrinker);
 
-/*
- * Remove one
- */
-void unregister_shrinker(struct shrinker *shrinker)
+void unregister_shrinker_delayed_initiate(struct shrinker *shrinker)
 {
 	struct dentry *debugfs_entry;
 	int debugfs_id;
@@ -819,6 +816,13 @@ void unregister_shrinker(struct shrinker *shrinker)
 	mutex_unlock(&shrinker_mutex);
 
 	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
+}
+EXPORT_SYMBOL(unregister_shrinker_delayed_initiate);
+
+void unregister_shrinker_delayed_finalize(struct shrinker *shrinker)
+{
+	if (!shrinker->nr_deferred)
+		return;
 
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
@@ -826,6 +830,16 @@ void unregister_shrinker(struct shrinker *shrinker)
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
+EXPORT_SYMBOL(unregister_shrinker_delayed_finalize);
+
+/*
+ * Remove one
+ */
+void unregister_shrinker(struct shrinker *shrinker)
+{
+	unregister_shrinker_delayed_initiate(shrinker);
+	unregister_shrinker_delayed_finalize(shrinker);
+}
 EXPORT_SYMBOL(unregister_shrinker);
 
 /**
-- 
2.30.2

