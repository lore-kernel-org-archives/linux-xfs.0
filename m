Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039CCC001DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 09:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjGXJ7r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 05:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjGXJ7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 05:59:22 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3076346BB
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 02:53:24 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-682eef7d752so1028576b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 02:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192278; x=1690797078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xAp7xgO7HdkgEPthzXwizc0Cva5ED0l1RHYipwvkRG8=;
        b=fRZXTeDPI05cJ99onG6DHJxkfUMlRPnq7Rn/QLZ0is9nue6C7hI7NNrzzE1XiOtAsL
         jxaHqrHBeq2Kf9jVwHj0j/XI9pIc497j4STLT+aC4pqDVI/sTYYX/yRdxwUotEPFTVId
         GY6yzphCUZ5+EFCVJ7JaghU1AWJbzYCjuDnxJCswtZl+SwAhy4mi16E/MR1hRCsGjB+T
         cO99YDds8K867Aux+2jYQKZaNAhIQlxOtUrunaQPHSUBJtgcDiwvPSTxsjcEQk1O8lD+
         xr5m1LPO8Me4hvXm4e3bCHxSQGeRnDCDrCn2S6Pyj7qX4IByYBH740sUkYoEJ/i3i/6k
         qY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192278; x=1690797078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xAp7xgO7HdkgEPthzXwizc0Cva5ED0l1RHYipwvkRG8=;
        b=HTXqmyGDIb5UpcAJrlvtu0w8xiS8QL3VIP+VNcnu6cC85/o0iHtVo6QNbzw2vxnJpv
         yt8HrDR7JpLm2yjAvz2t/9pTPK/F3Z/iTSu1HA7FDe/0xBPTAPeffUFCNm7ONYACJLsp
         Q4Ccso918G9a5u+L4VLG1ZLH1p21XSWGH0oMHVeYMpRetBVN64mZF5/00LxrI+gwFub3
         rb4WDO/z7GC01xXT4cK/Q35wuND2rLMMwxy7j0P0XqvzKhNT6DkTIx6QTpYdMiD2RcFn
         k5oNyQV/tpTsf9HycmsGCmHcbS3leMc4Z0HXKXE9WZiOgGNqK35BIwkR36FgD3XIrVA+
         QAhg==
X-Gm-Message-State: ABy/qLaznE3eeEVJjLJIGc6/1hYoeM29dmF6tOD/AD2wrlcZCFteT36d
        hXXO/fD+mkHaZ6R5z788OhpFWg==
X-Google-Smtp-Source: APBJJlHQq2D/WuDC+k4NqN86HhNTJ9MoR7Y5JtfL6V1jvtKqTGYGB1+jpVAvGxo9g3eH8SGsNzYhlw==
X-Received: by 2002:a17:902:f681:b0:1b8:a469:53d8 with SMTP id l1-20020a170902f68100b001b8a46953d8mr12728311plg.0.1690192278196;
        Mon, 24 Jul 2023 02:51:18 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:51:17 -0700 (PDT)
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
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 31/47] mbcache: dynamically allocate the mbcache shrinker
Date:   Mon, 24 Jul 2023 17:43:38 +0800
Message-Id: <20230724094354.90817-32-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the mbcache shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct mb_cache.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/mbcache.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 2a4b8b549e93..bfecebeec828 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -37,7 +37,7 @@ struct mb_cache {
 	struct list_head	c_list;
 	/* Number of entries in cache */
 	unsigned long		c_entry_count;
-	struct shrinker		c_shrink;
+	struct shrinker		*c_shrink;
 	/* Work for shrinking when the cache has too many entries */
 	struct work_struct	c_shrink_work;
 };
@@ -293,8 +293,7 @@ EXPORT_SYMBOL(mb_cache_entry_touch);
 static unsigned long mb_cache_count(struct shrinker *shrink,
 				    struct shrink_control *sc)
 {
-	struct mb_cache *cache = container_of(shrink, struct mb_cache,
-					      c_shrink);
+	struct mb_cache *cache = shrink->private_data;
 
 	return cache->c_entry_count;
 }
@@ -333,8 +332,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 static unsigned long mb_cache_scan(struct shrinker *shrink,
 				   struct shrink_control *sc)
 {
-	struct mb_cache *cache = container_of(shrink, struct mb_cache,
-					      c_shrink);
+	struct mb_cache *cache = shrink->private_data;
 	return mb_cache_shrink(cache, sc->nr_to_scan);
 }
 
@@ -377,15 +375,20 @@ struct mb_cache *mb_cache_create(int bucket_bits)
 	for (i = 0; i < bucket_count; i++)
 		INIT_HLIST_BL_HEAD(&cache->c_hash[i]);
 
-	cache->c_shrink.count_objects = mb_cache_count;
-	cache->c_shrink.scan_objects = mb_cache_scan;
-	cache->c_shrink.seeks = DEFAULT_SEEKS;
-	if (register_shrinker(&cache->c_shrink, "mbcache-shrinker")) {
+	cache->c_shrink = shrinker_alloc(0, "mbcache-shrinker");
+	if (!cache->c_shrink) {
 		kfree(cache->c_hash);
 		kfree(cache);
 		goto err_out;
 	}
 
+	cache->c_shrink->count_objects = mb_cache_count;
+	cache->c_shrink->scan_objects = mb_cache_scan;
+	cache->c_shrink->seeks = DEFAULT_SEEKS;
+	cache->c_shrink->private_data = cache;
+
+	shrinker_register(cache->c_shrink);
+
 	INIT_WORK(&cache->c_shrink_work, mb_cache_shrink_worker);
 
 	return cache;
@@ -406,7 +409,7 @@ void mb_cache_destroy(struct mb_cache *cache)
 {
 	struct mb_cache_entry *entry, *next;
 
-	unregister_shrinker(&cache->c_shrink);
+	shrinker_unregister(cache->c_shrink);
 
 	/*
 	 * We don't bother with any locking. Cache must not be used at this
-- 
2.30.2

