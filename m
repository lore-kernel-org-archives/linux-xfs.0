Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87139C001B0
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 09:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjGXJ4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 05:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjGXJzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 05:55:38 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA0B55A9
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 02:50:54 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-55acbe0c7e4so378329a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 02:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192207; x=1690797007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tyryk3a6lKy52HCDJ7LTSnMns1BMfalny9tATaKfF4=;
        b=amQ/RyxG43H24ZUKc8otE5jiO+PYmxLlS/jMlPB0P6LNf3YwKIyMMGT5x5GETrJzMq
         RUBPJl4XNLYJOZfW+4QQddSzJ1AOcHQOg+iS5NlIsw7P4JxkBKv7P6vm/OPtlqHKc3hY
         SLjp5JA2uLEQMXCeF85H9FjbP+u1neEShB4g/q4BDTYJUem7uHrE3aZx7t8/OvBixlxe
         PbLUlPG8K2MumMSz8pDMF7zGqwESYJNwxt0dJLhsSfALoKSzpnkM0Hd7rb9gY0+HtLOP
         61X4fPzjkMASXPftIRT+bLKVEY2jgFRxsHYQZDL2GJ8BmZMhp7tc/64KlMZKvh3Rfksj
         0TFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192207; x=1690797007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5tyryk3a6lKy52HCDJ7LTSnMns1BMfalny9tATaKfF4=;
        b=HAzAI6fbRUFLqgoNC8bGnuB3BxWzjuZ7rt+2y0FhLBsVJaTrOQON/a0mlg0jAPlFo9
         a3v7v/5fL8ZDsvwpI6v+E0YSoPzKno0r8Vx1BFchgcBRThGf/1AhE6LtK3gZWNzyPVRG
         y856TLmIQGwIREFHvDpM+k7Cs236GsHuK2h16kc0XAVxYdf2pqybVFOjpqlJOngbZqyB
         RUcbnzmy5/Ic0a5dbGWIDrJRRogoivbRrxIXKKgQ4Mh2W4WG4hoQtl2383hwjHRzw8qA
         Ny8l2P2iteh4epbEy7wDQ95qg2TC50QhWNrPcOeXenT6m+tflHnJtgd06GuuVeDGDPYI
         iaeA==
X-Gm-Message-State: ABy/qLYPQ9MMN6mzo2jlbjCkB8bHVAFkCvo42DnqXjN7mpL4V8OyqbMv
        lPTznqQU+CR13nfdkGd3iIs3Fw==
X-Google-Smtp-Source: APBJJlGNSrKSFiHfBgDCDwymx1T6XElAyTc+fmhNn0a9fde+MwuOtWNaHmnJx2SRiMlK6zefGJ37qA==
X-Received: by 2002:a17:902:f682:b0:1b3:ec39:f42c with SMTP id l2-20020a170902f68200b001b3ec39f42cmr12377411plg.5.1690192206827;
        Mon, 24 Jul 2023 02:50:06 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:50:06 -0700 (PDT)
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
Subject: [PATCH v2 25/47] dm: dynamically allocate the dm-bufio shrinker
Date:   Mon, 24 Jul 2023 17:43:32 +0800
Message-Id: <20230724094354.90817-26-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
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
---
 drivers/md/dm-bufio.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bc309e41d074..028e30a4b2d0 100644
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
@@ -2490,15 +2490,19 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
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
+	if (!c->shrinker)
 		goto bad;
 
+	c->shrinker->count_objects = dm_bufio_shrink_count;
+	c->shrinker->scan_objects = dm_bufio_shrink_scan;
+	c->shrinker->seeks = 1;
+	c->shrinker->batch = 0;
+	c->shrinker->private_data = c;
+
+	shrinker_register(c->shrinker);
+
 	mutex_lock(&dm_bufio_clients_lock);
 	dm_bufio_client_count++;
 	list_add(&c->client_list, &dm_bufio_all_clients);
@@ -2537,7 +2541,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 
 	drop_buffers(c);
 
-	unregister_shrinker(&c->shrinker);
+	shrinker_unregister(c->shrinker);
 	flush_work(&c->shrink_work);
 
 	mutex_lock(&dm_bufio_clients_lock);
-- 
2.30.2

