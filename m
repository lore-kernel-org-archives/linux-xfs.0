Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE972C04E69
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 11:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjHGLYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjHGLXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 07:23:38 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307A31BFA
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 04:21:27 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-4053d203c07so8357571cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 04:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407230; x=1692012030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VJlLpDqVGiuvI83ez+3bl7yR5bVuWalBgtTU2vfBLE=;
        b=hIKzx2RP3kMajThdhFOnDyX01BJur5f88HD9sMC6ePDuU8r9BygYE0eb08x7/qISXK
         0Diri0IzHQgcFfJVmp8ONyitj+hWeYYCK8mXSdEulKH2RCdHXE1/vTVwMwSG/lOTIe43
         O558hw3r/zvHwCxVaO22oOJ6Qv6rQUsub7KCFOx5zYWIeEjJyBfBxgFCdyF7Lpec0dkR
         2DaV3z4PL4g/dj/gQBiOQ6XVihQIzRAQo6g3UY2tmi87CJ6vWP1AUuAita7+8ft/H/4e
         XsLwkfzEU/7lIjM3oroHUV/7De+btOLx2lJaYWfJPXklr+PS5SYNxcUdjmJVy32GeSVb
         +BpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407230; x=1692012030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4VJlLpDqVGiuvI83ez+3bl7yR5bVuWalBgtTU2vfBLE=;
        b=B9yJdIUa5QXFEKwdclfa4sfQPrvP9GKxDD+ZtCOUVrWjscal+YWx8xJrIkHXqtaaua
         shVds3dag1i3wtMYUOi2sDtfVwX8Sw8Mow77NEJ9bTHZDEoslW/48cYQGF2STES0br6l
         OcZyr67zedJMW7xUXO6hpzZAzT/Mj5GhfP5ly6t8twkiTtI1I+sA9px5aunzrwU14Krd
         G1Ci9rRCsGe/ccKmCAI9E9w/X5pq9xsAdXlwzNrRFUULDexRzGDQHdppBTicbLaac8pG
         HgpXYeyedpcMrvzAhMOt0muzIfS4VV5cJhcDzzbPUI/SWBApJyW2oj1b86pRNIXnVCHP
         wLsw==
X-Gm-Message-State: ABy/qLY1d6X+VjlGk0PaCZ5mFFpyFRf05bXffHd1zUO3vv3vRV61IBk3
        AZqzXrRJuT1AbpnMFVp6FExGefE3wx4LGkCdm/c=
X-Google-Smtp-Source: APBJJlG6KxjpSP18cuDMGPLwCal+2Q6XOYkRmOlR+93TSEU+QOz0TNU1VRvfHZPrdEq648UTFq+gsw==
X-Received: by 2002:a92:d944:0:b0:349:3c78:fd14 with SMTP id l4-20020a92d944000000b003493c78fd14mr13499018ilq.1.1691406803912;
        Mon, 07 Aug 2023 04:13:23 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:13:23 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev, simon.horman@corigine.com,
        dlemoal@kernel.org
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
Subject: [PATCH v4 16/48] quota: dynamically allocate the dquota-cache shrinker
Date:   Mon,  7 Aug 2023 19:09:04 +0800
Message-Id: <20230807110936.21819-17-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use new APIs to dynamically allocate the dquota-cache shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/quota/dquot.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9e72bfe8bbad..c303cffdf433 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -791,12 +791,6 @@ dqcache_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 	percpu_counter_read_positive(&dqstats.counter[DQST_FREE_DQUOTS]));
 }
 
-static struct shrinker dqcache_shrinker = {
-	.count_objects = dqcache_shrink_count,
-	.scan_objects = dqcache_shrink_scan,
-	.seeks = DEFAULT_SEEKS,
-};
-
 /*
  * Safely release dquot and put reference to dquot.
  */
@@ -2956,6 +2950,7 @@ static int __init dquot_init(void)
 {
 	int i, ret;
 	unsigned long nr_hash, order;
+	struct shrinker *dqcache_shrinker;
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
@@ -2990,8 +2985,15 @@ static int __init dquot_init(void)
 	pr_info("VFS: Dquot-cache hash table entries: %ld (order %ld,"
 		" %ld bytes)\n", nr_hash, order, (PAGE_SIZE << order));
 
-	if (register_shrinker(&dqcache_shrinker, "dquota-cache"))
-		panic("Cannot register dquot shrinker");
+	dqcache_shrinker = shrinker_alloc(0, "dquota-cache");
+	if (!dqcache_shrinker)
+		panic("Cannot allocate dquot shrinker");
+
+	dqcache_shrinker->count_objects = dqcache_shrink_count;
+	dqcache_shrinker->scan_objects = dqcache_shrink_scan;
+	dqcache_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(dqcache_shrinker);
 
 	return 0;
 }
-- 
2.30.2

