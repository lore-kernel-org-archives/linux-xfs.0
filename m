Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6159DC001DF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 11:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjHGL1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjHGL07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 07:26:59 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C876C3C0E
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 04:24:07 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-56d0deeca09so673352eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 04:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407381; x=1692012181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0ijFA9s9bGVMHT4vLgTYS12L8yx2Rc7o6TjM9ZoJx8=;
        b=F1pHhRxNAVBoI5yH45MtgRyfVzzDBvPtFDO6hl9cPqwzJ1y84WH+UjaM+RP80SYzYl
         +zTVi7H9gLzpdV9Cbj8QUAHAA1XUQXjnCuNQpyIG3t2nEyhNDlZBbywk2bD1CZfkuXO1
         4Z8DuNJ3jrN5ib/5IvSip2aROfsrcj3r3i7Km/5O7Li2OPVE7gZKWGCqzEhxCBAqeL5y
         0G2u7792NkpcLSApCyBxhXSa9dRxe8zJbw6gA2C1yqCsWz7/tU7TFaXPbZyQcVDHAJC/
         T1EUFttjWX8Ay7aq75XEfuRXT3BWUJUHfRocgal1auh9nDXBH192y4zKcygyaw6jVqYl
         9FTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407381; x=1692012181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0ijFA9s9bGVMHT4vLgTYS12L8yx2Rc7o6TjM9ZoJx8=;
        b=l3J/tr25hgIec5izc6v7t/orqPpP7pLtVbaUbkttYo0xUQ1nPsZ9ASD4fqt4ozd690
         N9IhPO5mf3rUpXpf/T1gxdAbDZRIeYhjOiU7L5YAK2H3heRx+aFU52CErvWCE4gZI1sF
         OsPxL1el03GJFHiS6ZZiUUqoS3hclTAoJFlLwUUOmEhyWzcPIn9IriyDzlhvz3Vvgj8e
         U/tN9ShZ2se3kynCXABK1CyCndIfXPiU6YM5bg+Z9NAgX1GDCirjYD/VF5Pcb7Y78kSu
         1hnpg/oMzUXCDYUQAS0/0fISJo+EIJESYxj1I50brmco7El4XSpjstKCiySeiSgSMdEE
         Y1mQ==
X-Gm-Message-State: AOJu0YywaQBv7YdPrpsMSL/HH4JLtvANV7r+9yPJD5OeHRwocpKvF2pr
        C5aMJFl9iocMuMz/yzCdIA7IRg==
X-Google-Smtp-Source: AGHT+IELWLhV4Bj40lkko/D2F7gtSRcHKPclt9k8JlXsq8dyT7OdoG/0VZRRAUzfMJnehzLNwTS/oA==
X-Received: by 2002:a17:90a:2909:b0:269:5bf7:d79c with SMTP id g9-20020a17090a290900b002695bf7d79cmr2214416pjd.1.1691406841328;
        Mon, 07 Aug 2023 04:14:01 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:14:01 -0700 (PDT)
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
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 19/48] rcu: dynamically allocate the rcu-kfree shrinker
Date:   Mon,  7 Aug 2023 19:09:07 +0800
Message-Id: <20230807110936.21819-20-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use new APIs to dynamically allocate the rcu-kfree shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 kernel/rcu/tree.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7c79480bfaa0..3b20fc46c514 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3449,13 +3449,6 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return freed == 0 ? SHRINK_STOP : freed;
 }
 
-static struct shrinker kfree_rcu_shrinker = {
-	.count_objects = kfree_rcu_shrink_count,
-	.scan_objects = kfree_rcu_shrink_scan,
-	.batch = 0,
-	.seeks = DEFAULT_SEEKS,
-};
-
 void __init kfree_rcu_scheduler_running(void)
 {
 	int cpu;
@@ -4931,6 +4924,7 @@ static void __init kfree_rcu_batch_init(void)
 {
 	int cpu;
 	int i, j;
+	struct shrinker *kfree_rcu_shrinker;
 
 	/* Clamp it to [0:100] seconds interval. */
 	if (rcu_delay_page_cache_fill_msec < 0 ||
@@ -4962,8 +4956,18 @@ static void __init kfree_rcu_batch_init(void)
 		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
 		krcp->initialized = true;
 	}
-	if (register_shrinker(&kfree_rcu_shrinker, "rcu-kfree"))
-		pr_err("Failed to register kfree_rcu() shrinker!\n");
+
+	kfree_rcu_shrinker = shrinker_alloc(0, "rcu-kfree");
+	if (!kfree_rcu_shrinker) {
+		pr_err("Failed to allocate kfree_rcu() shrinker!\n");
+		return;
+	}
+
+	kfree_rcu_shrinker->count_objects = kfree_rcu_shrink_count;
+	kfree_rcu_shrinker->scan_objects = kfree_rcu_shrink_scan;
+	kfree_rcu_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(kfree_rcu_shrinker);
 }
 
 void __init rcu_init(void)
-- 
2.30.2

