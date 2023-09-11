Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AC2CA0EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Sep 2023 21:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345590AbjIKVV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbjIKJuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 05:50:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC675E52
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 02:50:39 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c3c4eafe95so470425ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 02:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1694425839; x=1695030639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAoYQHmeR0aUipRnti9MSoo1QhYW8B305NLCegCj2mc=;
        b=fYk8n2ptg0Wx/+gpfRqceuJRmPy8mShZYDOSwno63oFF19RCniY4YaZfgJPoRB25iH
         OUsYIURU035J1A4dSFr7qhi0yMhSs7acetZSXSDdCbaU1U7cTwt1GP3XP7nehU0HoF7a
         V18H46a1GpD6ST1judHIZNNhslbnDTdZaTWYEIBQo0RsMlqV3U5V82eappmxZVkjJVL2
         Dv5Jd9O7q6/qg26GrxcTa0qvNQuxws2Pj+sXnkJm6SAyDMiMDLZr+tktgZ7m+mlE5gGi
         DfviBqjSDUmc8keyC9h+JqSfjuA2onmjNjic0z2zTBSSqArCJfWDkAnc0FThKJHpl5Lj
         bocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694425839; x=1695030639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAoYQHmeR0aUipRnti9MSoo1QhYW8B305NLCegCj2mc=;
        b=X0ekQ2qx7/E3AV7HnLtD4iEhdNe9HOyYuBVCQwh4ukPuRFdFIDTwXTMjXI1mmgYNlN
         enWLpvnzPSqJmtfbzsh9UNKEwI6kfcxQXSCcGZDuaKde79FhYd3T/DaxWqYuiuE/xSLQ
         7WRlXXz5V+FbYiwlmuH4wFJ4uA5lyRoy8ZJSK2tkqUq8jhXcH7ipANTKpo+2oSu1uhCk
         dWOv6/wrYlGRFSv/DkM/luEVLismp6PHTpWbc3X/HrfwczaP+O1v5pOjuSRDSjFWVKQ0
         9V8YJsATU/ytHxflJ5sfilwTLe9n1KjMvmeYeZru+8+R+wfBLMLQu09GqeJa+ceYYfiK
         u3Cg==
X-Gm-Message-State: AOJu0Yy3B/6ZClZJymSdRs0w0PhSEzmh2WU6cKZ/MMJKVMWiSGaJKjMo
        UlYoRdxZFPnzKLcgczn3JkSSZg==
X-Google-Smtp-Source: AGHT+IFT+86I6bu5GOdEzWlfUK8qBkCzz3enuPKZPjEpOf5YfG0XONb6VNSqG6hacK72QD8znouzTg==
X-Received: by 2002:a17:903:2843:b0:1c3:a4f2:7cc1 with SMTP id kq3-20020a170903284300b001c3a4f27cc1mr5320660plb.5.1694425839278;
        Mon, 11 Sep 2023 02:50:39 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id az7-20020a170902a58700b001bdc2fdcf7esm5988188plb.129.2023.09.11.02.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 02:50:38 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH v6 36/45] xfs: dynamically allocate the xfs-qm shrinker
Date:   Mon, 11 Sep 2023 17:44:35 +0800
Message-Id: <20230911094444.68966-37-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230911094444.68966-1-zhengqi.arch@bytedance.com>
References: <20230911094444.68966-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the xfs-qm shrinker, so that it can be freed
asynchronously via RCU. Then it doesn't need to wait for RCU read-side
critical section when releasing the struct xfs_quotainfo.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
CC: Chandan Babu R <chandan.babu@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>
CC: linux-xfs@vger.kernel.org
---
 fs/xfs/xfs_qm.c | 27 ++++++++++++++-------------
 fs/xfs/xfs_qm.h |  2 +-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6abcc34fafd8..f45de01013ba 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -504,8 +504,7 @@ xfs_qm_shrink_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_quotainfo	*qi = container_of(shrink,
-					struct xfs_quotainfo, qi_shrinker);
+	struct xfs_quotainfo	*qi = shrink->private_data;
 	struct xfs_qm_isolate	isol;
 	unsigned long		freed;
 	int			error;
@@ -539,8 +538,7 @@ xfs_qm_shrink_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_quotainfo	*qi = container_of(shrink,
-					struct xfs_quotainfo, qi_shrinker);
+	struct xfs_quotainfo	*qi = shrink->private_data;
 
 	return list_lru_shrink_count(&qi->qi_lru, sc);
 }
@@ -680,15 +678,18 @@ xfs_qm_init_quotainfo(
 	if (XFS_IS_PQUOTA_ON(mp))
 		xfs_qm_set_defquota(mp, XFS_DQTYPE_PROJ, qinf);
 
-	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
-	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
-	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
-	qinf->qi_shrinker.flags = SHRINKER_NUMA_AWARE;
-
-	error = register_shrinker(&qinf->qi_shrinker, "xfs-qm:%s",
-				  mp->m_super->s_id);
-	if (error)
+	qinf->qi_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-qm:%s",
+					   mp->m_super->s_id);
+	if (!qinf->qi_shrinker) {
+		error = -ENOMEM;
 		goto out_free_inos;
+	}
+
+	qinf->qi_shrinker->count_objects = xfs_qm_shrink_count;
+	qinf->qi_shrinker->scan_objects = xfs_qm_shrink_scan;
+	qinf->qi_shrinker->private_data = qinf;
+
+	shrinker_register(qinf->qi_shrinker);
 
 	return 0;
 
@@ -718,7 +719,7 @@ xfs_qm_destroy_quotainfo(
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
 
-	unregister_shrinker(&qi->qi_shrinker);
+	shrinker_free(qi->qi_shrinker);
 	list_lru_destroy(&qi->qi_lru);
 	xfs_qm_destroy_quotainos(qi);
 	mutex_destroy(&qi->qi_tree_lock);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9683f0457d19..d5c9fc4ba591 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -63,7 +63,7 @@ struct xfs_quotainfo {
 	struct xfs_def_quota	qi_usr_default;
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
-	struct shrinker		qi_shrinker;
+	struct shrinker		*qi_shrinker;
 
 	/* Minimum and maximum quota expiration timestamp values. */
 	time64_t		qi_expiry_min;
-- 
2.30.2

