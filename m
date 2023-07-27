Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B968C07E8C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 08:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjG0Ia2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbjG0I17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 04:27:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714E983E7
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 01:14:46 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6862d4a1376so189781b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 01:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690445649; x=1691050449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPvPF+4cfnCSPpn5pwfgQmnhLHHD8eUNQAmayNodhE0=;
        b=YUtSHImzHFhUVx7c3A38/9eSWP8Y2UYGj1FAohSpraRjdigKG79oH7xXGVv/st6Oxo
         VyXpyLT7a2poDQM1BLbe2YZ2f+F4NjGwYTjXKgOmjtdNRT3EltoPRUERX0NGCPGwABx/
         guLbSxl8SczSn7UsZFsKIT2jSYiALWPELONV4dGxl+BgYW8LTo4BMAXY89ObnQ5bwB+z
         TeqwZ6TJLFD7PjgbTEQMgvSuaTCzQbN9MksnEsjGQ7GcxsQYflnPZl/UkK6mnnTiCX+x
         HfuT7U9+62kKpSnlvuoFhz2dd+gEGZ79L6Z5RTD7Q/dArvGRObCoRNap6LnHLL+kySjl
         YAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445649; x=1691050449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sPvPF+4cfnCSPpn5pwfgQmnhLHHD8eUNQAmayNodhE0=;
        b=PjJqSPuIikQXk9ZAW8S9oMzBL9+WyJCBitrxfy9Xa2oRqFKxQxOPoOIVvgZxjJMDPy
         T6OBIvRefQWRrOi+ZSY299qpxeUgSss1xCDmevzwEdjNQKRY4dbpuWFbK2f3vdYLAAks
         BxAPYxBdHSKQqF2wg0r3Ms2eHQm6qTqtwq5TBrUHi4Zrg4FooK7bbtiEAeJT5nkt6msK
         DYpFAfiw6v/zwzaI6RdSsUXXv3LzCiRDUOuNQCBzVtO8wc7yQRCgiOj+nVsdwRrHHjw4
         9z30s3uOFU1BRs59Eb1p6/lODkdaWlGs36uJTyveL9xJVyHnz3aSt0wH/ZS1ZCbHzCym
         rTog==
X-Gm-Message-State: ABy/qLZLKqa/lkTTO4hbGVq+TjxsxOUeBWvXSDKjuFZoDa5TFCVEkXui
        AsXLWzW4H/cO1m+e/KqTSeNhMA==
X-Google-Smtp-Source: APBJJlHWG/nG8cYGh+bA6ihiUuY1h+OmDGzY+AfGFIW0cwXlJC7qa3aS8ftT4KQ6i8EuYK6gaQtAEg==
X-Received: by 2002:a05:6a20:918e:b0:11a:dbb3:703b with SMTP id v14-20020a056a20918e00b0011adbb3703bmr5557054pzd.6.1690445649366;
        Thu, 27 Jul 2023 01:14:09 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:14:08 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 41/49] zsmalloc: dynamically allocate the mm-zspool shrinker
Date:   Thu, 27 Jul 2023 16:04:54 +0800
Message-Id: <20230727080502.77895-42-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the mm-zspool shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct zs_pool.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/zsmalloc.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b96230402a8d..e63302e07c97 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -229,7 +229,7 @@ struct zs_pool {
 	struct zs_pool_stats stats;
 
 	/* Compact classes */
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
@@ -2086,8 +2086,7 @@ static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
 	unsigned long pages_freed;
-	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
-			shrinker);
+	struct zs_pool *pool = shrinker->private_data;
 
 	/*
 	 * Compact classes and calculate compaction delta.
@@ -2105,8 +2104,7 @@ static unsigned long zs_shrinker_count(struct shrinker *shrinker,
 	int i;
 	struct size_class *class;
 	unsigned long pages_to_free = 0;
-	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
-			shrinker);
+	struct zs_pool *pool = shrinker->private_data;
 
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
@@ -2121,18 +2119,24 @@ static unsigned long zs_shrinker_count(struct shrinker *shrinker,
 
 static void zs_unregister_shrinker(struct zs_pool *pool)
 {
-	unregister_shrinker(&pool->shrinker);
+	shrinker_free(pool->shrinker);
 }
 
 static int zs_register_shrinker(struct zs_pool *pool)
 {
-	pool->shrinker.scan_objects = zs_shrinker_scan;
-	pool->shrinker.count_objects = zs_shrinker_count;
-	pool->shrinker.batch = 0;
-	pool->shrinker.seeks = DEFAULT_SEEKS;
+	pool->shrinker = shrinker_alloc(0, "mm-zspool:%s", pool->name);
+	if (!pool->shrinker)
+		return -ENOMEM;
+
+	pool->shrinker->scan_objects = zs_shrinker_scan;
+	pool->shrinker->count_objects = zs_shrinker_count;
+	pool->shrinker->batch = 0;
+	pool->shrinker->seeks = DEFAULT_SEEKS;
+	pool->shrinker->private_data = pool;
 
-	return register_shrinker(&pool->shrinker, "mm-zspool:%s",
-				 pool->name);
+	shrinker_register(pool->shrinker);
+
+	return 0;
 }
 
 static int calculate_zspage_chain_size(int class_size)
-- 
2.30.2

