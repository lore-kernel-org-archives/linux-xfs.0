Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3650CEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 08:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjFVIzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 04:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjFVIy5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 04:54:57 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA71738
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:54:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b52418c25bso12030775ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424067; x=1690016067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIt8zXdDCaGLXCE6rKF2JMKvp8G2AK8nuTQphjV73ms=;
        b=cC13yiK2b2HqEC2WYanx92tTHG9ibgrmYLbrgzYcUarLdydxeypI53cwuyYhjaQzJp
         onJq4vBBmMajr1poWh86FQTLq2y1xSvoknQDzCFUhqc78tS5eFxPwQt8ueUiPUlQcGJ1
         NoUMAyqrL7rvWv1XaJ4CPnN6K7xK1sRx+XiYPW8paVbE3vb5Wkc4IFamUXhI7GXmfwho
         QPeLUm4YlUE0P3+vsMp1UZZv6g44Pla+Jp2DOFJOg6O2qS7xw748UZa1YIoXHuTtcdry
         A4esVq8CH+pV+6r7bJr/mBJgAfFPjM5J1TM9ToGnDJSCePlm9yunBGrnuwbojkh7OG6q
         rFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424067; x=1690016067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qIt8zXdDCaGLXCE6rKF2JMKvp8G2AK8nuTQphjV73ms=;
        b=OelVzCiTdWCE6eNVsogqOiLxNsdGdUhkFDQBHOp8OU0NNSyWjPEj679IdS+dGJHts/
         G4E8lD1E8Ozbq9uL5PbOyK1M0tpGmJdd8tpbnrFQWoiLLH2cLl8w+T4Gpd7stSK6nzSk
         gGYYNsW8nIGMG8Go77sZBV+LjbdSZedKjWaargbzNSYsoVpAWOWPlXCfYFWfENfDYlmd
         ih2C23ghepPATTD3+V9n3414pWbDUp412CwxU/BpZVZmGAptfd81kD1goOL2Gt2Mp/+V
         4FLV31qLu6BN8CXoBDx6fba/mQZ5IabS/9uwmXLPT0VNF22vPSZ/o8fwkZB0JqlUb7sC
         uLTg==
X-Gm-Message-State: AC+VfDwAIqwDQqWLaFQhZqbGikd7GHswdE99l/BK21PTcpYKjRWEsyU1
        lKvvW3RBKPSfCxeTbH4cNx+GJw==
X-Google-Smtp-Source: ACHHUZ68xppE2OzenI0HziNaJw5pBbhsLnOSkDmr33RiuwGHaNU1efiGcJgTbt3uCyHHsLierWgKoQ==
X-Received: by 2002:a17:902:d489:b0:1ae:4567:2737 with SMTP id c9-20020a170902d48900b001ae45672737mr21909019plg.2.1687424067136;
        Thu, 22 Jun 2023 01:54:27 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:54:26 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 03/29] drm/i915: dynamically allocate the i915_gem_mm shrinker
Date:   Thu, 22 Jun 2023 16:53:09 +0800
Message-Id: <20230622085335.77010-4-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the i915_gem_mm shrinker,
so that it can be freed asynchronously by using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct drm_i915_private.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c | 27 ++++++++++----------
 drivers/gpu/drm/i915/i915_drv.h              |  3 ++-
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
index 214763942aa2..4dcdace26a08 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
@@ -284,8 +284,7 @@ unsigned long i915_gem_shrink_all(struct drm_i915_private *i915)
 static unsigned long
 i915_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
 {
-	struct drm_i915_private *i915 =
-		container_of(shrinker, struct drm_i915_private, mm.shrinker);
+	struct drm_i915_private *i915 = shrinker->private_data;
 	unsigned long num_objects;
 	unsigned long count;
 
@@ -302,8 +301,8 @@ i915_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
 	if (num_objects) {
 		unsigned long avg = 2 * count / num_objects;
 
-		i915->mm.shrinker.batch =
-			max((i915->mm.shrinker.batch + avg) >> 1,
+		i915->mm.shrinker->batch =
+			max((i915->mm.shrinker->batch + avg) >> 1,
 			    128ul /* default SHRINK_BATCH */);
 	}
 
@@ -313,8 +312,7 @@ i915_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
 static unsigned long
 i915_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 {
-	struct drm_i915_private *i915 =
-		container_of(shrinker, struct drm_i915_private, mm.shrinker);
+	struct drm_i915_private *i915 = shrinker->private_data;
 	unsigned long freed;
 
 	sc->nr_scanned = 0;
@@ -422,12 +420,15 @@ i915_gem_shrinker_vmap(struct notifier_block *nb, unsigned long event, void *ptr
 
 void i915_gem_driver_register__shrinker(struct drm_i915_private *i915)
 {
-	i915->mm.shrinker.scan_objects = i915_gem_shrinker_scan;
-	i915->mm.shrinker.count_objects = i915_gem_shrinker_count;
-	i915->mm.shrinker.seeks = DEFAULT_SEEKS;
-	i915->mm.shrinker.batch = 4096;
-	drm_WARN_ON(&i915->drm, register_shrinker(&i915->mm.shrinker,
-						  "drm-i915_gem"));
+	i915->mm.shrinker = shrinker_alloc_and_init(i915_gem_shrinker_count,
+						    i915_gem_shrinker_scan,
+						    4096, DEFAULT_SEEKS, 0,
+						    i915);
+	if (i915->mm.shrinker &&
+	    register_shrinker(i915->mm.shrinker, "drm-i915_gem")) {
+		shrinker_free(i915->mm.shrinker);
+		drm_WARN_ON(&i915->drm, 1);
+	}
 
 	i915->mm.oom_notifier.notifier_call = i915_gem_shrinker_oom;
 	drm_WARN_ON(&i915->drm, register_oom_notifier(&i915->mm.oom_notifier));
@@ -443,7 +444,7 @@ void i915_gem_driver_unregister__shrinker(struct drm_i915_private *i915)
 		    unregister_vmap_purge_notifier(&i915->mm.vmap_notifier));
 	drm_WARN_ON(&i915->drm,
 		    unregister_oom_notifier(&i915->mm.oom_notifier));
-	unregister_shrinker(&i915->mm.shrinker);
+	unregister_and_free_shrinker(i915->mm.shrinker);
 }
 
 void i915_gem_shrinker_taints_mutex(struct drm_i915_private *i915,
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b4cf6f0f636d..06b04428596d 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -163,7 +163,8 @@ struct i915_gem_mm {
 
 	struct notifier_block oom_notifier;
 	struct notifier_block vmap_notifier;
-	struct shrinker shrinker;
+
+	struct shrinker *shrinker;
 
 #ifdef CONFIG_MMU_NOTIFIER
 	/**
-- 
2.30.2

