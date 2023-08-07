Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02AAC001DF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 11:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjHGLWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjHGLV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 07:21:26 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6A44B9
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 04:19:38 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4053d203c07so8349381cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 04:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691406811; x=1692011611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urGrhHBCGKwKuhIkQmOHRuysXuy1mToQA+AaHWoY6PY=;
        b=kNfQ5GhxJlRJJvElVIkEFxqLQgwyNFhBjcjZK1U13l21sF6mTs0b987h+r8k7TyrI+
         56Wbs1w+n0IKHwwg/TrUHOUo7Ss6/JKDP1bUgklpD1sBN6sTcC+7aY/rovpXGa2QF3AV
         rzPPXivKNefYBbUszsYFcYDbgJ6WqmQN2/j1pSdd9OldbHGnSuudg7eKcXEWFwocKLMv
         1AK6flaSVkPnxdWDXbfrL/Sn/JCcmeOLRldGTgeO9XrwEHb6wiXdJfymEfDjkpHsgRbK
         vLzgkUkMrnjHgh9Y/8svep9fhBFylbntKXEk+aiaKIErJiAu1NvIKD511Hi9ZVDxS1Qm
         xOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691406811; x=1692011611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=urGrhHBCGKwKuhIkQmOHRuysXuy1mToQA+AaHWoY6PY=;
        b=juw9kyo7Feq7kRtgVYhHElQDm4TmtCGSzglvxKEqdOyJf/b1seLHz29NX+TPFdPUOX
         dxY1DGcfi0IjBZaTdvC9quFhDBVEX5ZAR1eauMQp3iK5tOdwRI54eJY1cK9YH6lupSta
         HAxbi+3hK/FwZOzrTD+3kRgHaWAQmpYfSOa8byW2qi4XwmZaHLl8XtOGF7awQZkK9MGg
         Mf/YCvL2rIxO3ytbwlA5llIeRpzOtE/t3v2aYAaiik/3/IqPcmV3kIcqYoBLb0LLZsh0
         RYg9hMENk2HBcF7X98siIC3sTKLFjtb8RiO/9cAY/AgL20cZunhyrJktOjzUizHACXx0
         Jang==
X-Gm-Message-State: ABy/qLbhZwZlEw7w36alOf1JTRzuJTKCGQUbkpeoGb2nUnZ8N9eiNJ4k
        pv2Dw8Pl9hL7/MwNQXprLlHpegn2zsF652dwH6Q=
X-Google-Smtp-Source: APBJJlGG9fl/KZM7Wu/aB3nA3qPBXzAgCls0ii/X4UboFM2rQSd7zbDq190u8vBbdPOZ8QFUsdy1lw==
X-Received: by 2002:a17:90a:faf:b0:268:abc:83d5 with SMTP id 44-20020a17090a0faf00b002680abc83d5mr23478200pjz.4.1691406791204;
        Mon, 07 Aug 2023 04:13:11 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:13:10 -0700 (PDT)
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
Subject: [PATCH v4 15/48] nfsd: dynamically allocate the nfsd-filecache shrinker
Date:   Mon,  7 Aug 2023 19:09:03 +0800
Message-Id: <20230807110936.21819-16-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use new APIs to dynamically allocate the nfsd-filecache shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/nfsd/filecache.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ee9c923192e0..9c62b4502539 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -521,11 +521,7 @@ nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 	return ret;
 }
 
-static struct shrinker	nfsd_file_shrinker = {
-	.scan_objects = nfsd_file_lru_scan,
-	.count_objects = nfsd_file_lru_count,
-	.seeks = 1,
-};
+static struct shrinker *nfsd_file_shrinker;
 
 /**
  * nfsd_file_cond_queue - conditionally unhash and queue a nfsd_file
@@ -746,12 +742,19 @@ nfsd_file_cache_init(void)
 		goto out_err;
 	}
 
-	ret = register_shrinker(&nfsd_file_shrinker, "nfsd-filecache");
-	if (ret) {
-		pr_err("nfsd: failed to register nfsd_file_shrinker: %d\n", ret);
+	nfsd_file_shrinker = shrinker_alloc(0, "nfsd-filecache");
+	if (!nfsd_file_shrinker) {
+		ret = -ENOMEM;
+		pr_err("nfsd: failed to allocate nfsd_file_shrinker\n");
 		goto out_lru;
 	}
 
+	nfsd_file_shrinker->count_objects = nfsd_file_lru_count;
+	nfsd_file_shrinker->scan_objects = nfsd_file_lru_scan;
+	nfsd_file_shrinker->seeks = 1;
+
+	shrinker_register(nfsd_file_shrinker);
+
 	ret = lease_register_notifier(&nfsd_file_lease_notifier);
 	if (ret) {
 		pr_err("nfsd: unable to register lease notifier: %d\n", ret);
@@ -774,7 +777,7 @@ nfsd_file_cache_init(void)
 out_notifier:
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
 out_shrinker:
-	unregister_shrinker(&nfsd_file_shrinker);
+	shrinker_free(nfsd_file_shrinker);
 out_lru:
 	list_lru_destroy(&nfsd_file_lru);
 out_err:
@@ -891,7 +894,7 @@ nfsd_file_cache_shutdown(void)
 		return;
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
-	unregister_shrinker(&nfsd_file_shrinker);
+	shrinker_free(nfsd_file_shrinker);
 	/*
 	 * make sure all callers of nfsd_file_lru_cb are done before
 	 * calling nfsd_file_cache_purge
-- 
2.30.2

