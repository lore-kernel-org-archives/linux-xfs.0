Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4935CC001DF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 11:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjHGLZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjHGLZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 07:25:35 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F2149E0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 04:22:25 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6b9cd6876bbso754672a34.1
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 04:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407292; x=1692012092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXZOOFmuwv6/pQ9jzhgVENlSQpZ5agnqrhquB4Bsoao=;
        b=W2uOmhPnd0rzWTZ+r+C3k2eVRiWgPNI37ATU9G1Ge1PTzaudDp/jgZ6O+X8yC/jfcN
         b4YgxThFfNj2vUbnJOfDuzceZnmqdnv98LMMwARy8w1C5Jd9J+NnnoeWBOTmaQtZFulk
         e1WnFz8WiDz9ccB23X8D/MLtSngiBn++oUHFoLpLgPSjDoIEFEJgoe42HZzl/n8cNOf5
         Auf0/tbF+6CotTx2crMsQitk/1FGX26apyN4ST2YFMTqo/YvB8qCHONbuSsPeUdMpyJM
         04rGU9W28FsiZCv1ruDObu4Uu6rT1bAcSbqI72vCwyfRzlDrlRBsVGHdB8w1GySNI2EU
         KKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407292; x=1692012092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXZOOFmuwv6/pQ9jzhgVENlSQpZ5agnqrhquB4Bsoao=;
        b=EmHLv4WkImG3iNmov90hivkDkTz02n2vU8hTDPQxCG5VCVjSZeFtkrlsqoO1JLDAbK
         /lLoMrfd0XWwQatYwhQoO0T44eW7TqJnAsV/Mc1bCoHn+MZAJvizdMmARIwitqkrUoVj
         vGlELUep6Sf7i8xJrqBibzvxiLz7bUFR7palws5r1mK5dwJfqqqYy7U2EvHFT2RbCjZc
         qVgZ47kLv8ZnmqYrseU7kL8lS7AVUKufeG0QbUK4jZb5uEpFvzqN0VHLukt9PVVd9a+k
         rUfvN9MeE3rMMypEU+f0BSs8xJJPc5mH25/7z8NEkkX675t4HT15wyNpWoeZ3m3FC5qT
         kTHw==
X-Gm-Message-State: AOJu0YxkNaBEBtpdryNkSXyk8lLb5FvGBgG393WRg7VMkBpauFOmSP9p
        EK6Rn9844855pwxkuO0vVy0UOGoQIIHY9eCktdM=
X-Google-Smtp-Source: APBJJlFDSvCAq9gTdHkFF7Bzn2YL0W/qaEPzJ7AdGJ/zjCXgG1JFMDLiaFr2l43qqes0mOglkhZu9g==
X-Received: by 2002:a17:902:f688:b0:1bb:d7d4:e2b with SMTP id l8-20020a170902f68800b001bbd7d40e2bmr33138766plg.0.1691406778592;
        Mon, 07 Aug 2023 04:12:58 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:12:58 -0700 (PDT)
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
Subject: [PATCH v4 14/48] nfs: dynamically allocate the nfs-acl shrinker
Date:   Mon,  7 Aug 2023 19:09:02 +0800
Message-Id: <20230807110936.21819-15-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use new APIs to dynamically allocate the nfs-acl shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/nfs/super.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 2284f749d892..1b5cd0444dda 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -129,11 +129,7 @@ static void nfs_ssc_unregister_ops(void)
 }
 #endif /* CONFIG_NFS_V4_2 */
 
-static struct shrinker acl_shrinker = {
-	.count_objects	= nfs_access_cache_count,
-	.scan_objects	= nfs_access_cache_scan,
-	.seeks		= DEFAULT_SEEKS,
-};
+static struct shrinker *acl_shrinker;
 
 /*
  * Register the NFS filesystems
@@ -153,9 +149,19 @@ int __init register_nfs_fs(void)
 	ret = nfs_register_sysctl();
 	if (ret < 0)
 		goto error_2;
-	ret = register_shrinker(&acl_shrinker, "nfs-acl");
-	if (ret < 0)
+
+	acl_shrinker = shrinker_alloc(0, "nfs-acl");
+	if (!acl_shrinker) {
+		ret = -ENOMEM;
 		goto error_3;
+	}
+
+	acl_shrinker->count_objects = nfs_access_cache_count;
+	acl_shrinker->scan_objects = nfs_access_cache_scan;
+	acl_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(acl_shrinker);
+
 #ifdef CONFIG_NFS_V4_2
 	nfs_ssc_register_ops();
 #endif
@@ -175,7 +181,7 @@ int __init register_nfs_fs(void)
  */
 void __exit unregister_nfs_fs(void)
 {
-	unregister_shrinker(&acl_shrinker);
+	shrinker_free(acl_shrinker);
 	nfs_unregister_sysctl();
 	unregister_nfs4_fs();
 #ifdef CONFIG_NFS_V4_2
-- 
2.30.2

