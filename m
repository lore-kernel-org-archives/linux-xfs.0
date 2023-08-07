Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FE0EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 11:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjHGL2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjHGL1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 07:27:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539C4EF7
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 04:24:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-564670fad4bso391897a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 04:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407435; x=1692012235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Rfav5Nxe+GtybemfHCRLQWJ1Wm1Jr8phC3oTaQ6f/s=;
        b=bNTs8yivxltIO7DJ3B3EtySGY85qxClDVPeU8hdCJt/J+3Yrr1a40zWuRVYq/xaB6n
         MnzGl0ZuCe4Chjp3s+XWACy5LPzHyv28+BOr7vY2PrStA9aYCSuPEBHQcVLdFQYIfKvm
         HTPPZl5wZUWf3A7tq/JoIsgWOxAx6m74D/+tB7B+FWCuzAZrbCdizz0pEKW5dlemCXTn
         y1m7HKMFSx5CJHoNjkLfa5SZqcgjrkyKmw4S63LIh5XxZssy4eFgU6JTqBdya+wTT2PM
         /uFGLO/FBJojFBQ7tQfK7Ev40PppjHnFht5c+IUsFX0ij4kad/4b9CTpv3NKCBhRRYi2
         oFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407435; x=1692012235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Rfav5Nxe+GtybemfHCRLQWJ1Wm1Jr8phC3oTaQ6f/s=;
        b=VZVMMjgWabXxrk5Xx8Yyimiryl7XucQiV2WvV8sYMsOEnE70nZS4/vdUUfhpOwk1MC
         GeCviD+x5Fxvg43dbNiYUmoX1hCaL6fbRTsRlrh00b8qpD8bKAgwfRPqTLTEFYZE/nqL
         QqOG3NYvIm7DYfd5bmOUcn3CbuZdnOlmoS5a37tmVlwC1wztXyXrL5GPujTMiOxCF3Pc
         HkSHypAYBCahW3HNyW06G3A3tZhK1G8M6Wnl2EOT1o2G4hlDWBZYUAXXqrI6NjNX9078
         dyjvCEMgHtnjgLW9I6i/suplonl0jFybJN6uWnQ7u3BwJ1DQNcRbGc9isCIXPzUHZe4T
         2x+g==
X-Gm-Message-State: ABy/qLYOGRSPIFdwsCfQ0JX8TKXGvWJAc1KL1BNvbRw95OKHjJaYmp1E
        hYUwgSVuFMF5xSp/ypqzkWbzxaxQRKUP1l7jXPI=
X-Google-Smtp-Source: AGHT+IFWvaKty2qg3Zp4xukmaRzjC+XhBT002dXZP422OqSqCh0qrR2HTT2eLu1rJ18Y9R5+7t84vA==
X-Received: by 2002:a92:6408:0:b0:349:5c87:e712 with SMTP id y8-20020a926408000000b003495c87e712mr5356429ilb.1.1691406930655;
        Mon, 07 Aug 2023 04:15:30 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:15:30 -0700 (PDT)
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
Subject: [PATCH v4 26/48] dm: dynamically allocate the dm-bufio shrinker
Date:   Mon,  7 Aug 2023 19:09:14 +0800
Message-Id: <20230807110936.21819-27-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the dm-bufio shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct dm_bufio_client.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/md/dm-bufio.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bc309e41d074..62eb27639c9b 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -963,7 +963,7 @@ struct dm_bufio_client {
 
 	sector_t start;
 
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 	struct work_struct shrink_work;
 	atomic_long_t need_shrink;
 
@@ -2368,7 +2368,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
 {
 	struct dm_bufio_client *c;
 
-	c = container_of(shrink, struct dm_bufio_client, shrinker);
+	c = shrink->private_data;
 	atomic_long_add(sc->nr_to_scan, &c->need_shrink);
 	queue_work(dm_bufio_wq, &c->shrink_work);
 
@@ -2377,7 +2377,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
 
 static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
+	struct dm_bufio_client *c = shrink->private_data;
 	unsigned long count = cache_total(&c->cache);
 	unsigned long retain_target = get_retain_buffers(c);
 	unsigned long queued_for_cleanup = atomic_long_read(&c->need_shrink);
@@ -2490,14 +2490,20 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	INIT_WORK(&c->shrink_work, shrink_work);
 	atomic_long_set(&c->need_shrink, 0);
 
-	c->shrinker.count_objects = dm_bufio_shrink_count;
-	c->shrinker.scan_objects = dm_bufio_shrink_scan;
-	c->shrinker.seeks = 1;
-	c->shrinker.batch = 0;
-	r = register_shrinker(&c->shrinker, "dm-bufio:(%u:%u)",
-			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
-	if (r)
+	c->shrinker = shrinker_alloc(0, "dm-bufio:(%u:%u)",
+				     MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+	if (!c->shrinker) {
+		r = -ENOMEM;
 		goto bad;
+	}
+
+	c->shrinker->count_objects = dm_bufio_shrink_count;
+	c->shrinker->scan_objects = dm_bufio_shrink_scan;
+	c->shrinker->seeks = 1;
+	c->shrinker->batch = 0;
+	c->shrinker->private_data = c;
+
+	shrinker_register(c->shrinker);
 
 	mutex_lock(&dm_bufio_clients_lock);
 	dm_bufio_client_count++;
@@ -2537,7 +2543,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 
 	drop_buffers(c);
 
-	unregister_shrinker(&c->shrinker);
+	shrinker_free(c->shrinker);
 	flush_work(&c->shrink_work);
 
 	mutex_lock(&dm_bufio_clients_lock);
-- 
2.30.2

