Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB08EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 11:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjHGLVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 07:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjHGLVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 07:21:09 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87F33ABC
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 04:19:07 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1bb6334fec5so671208fac.1
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 04:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407092; x=1692011892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaqVlo27zysQOw4inLaa7RWYi61naAqQm5GJ5upJpN4=;
        b=F2dBtaLMPYM2ToJXU1mkPUSKJnvz3jfEMRyDAFfDZ8S6h3fSzvc3WNda5LKwBIoURD
         Jr50wJHNKdy+DSfGQa2xoTg9v2KwBfO5YuYRmBXHOzO0j80Z7QMGm6OPUlvDJajKkq+p
         adG8Hq8bxaUwUPvgMPCBvVx3k7j4d2RBwx/4s1Ew4HD+tBs8vMyj60pkTU5V3zvgxT73
         /ZEUKmKMGM/kHeJZbuSDVfsiHWrumNrjux0pJLE/aLEXZPacqu0fP4ZAzwKZBQLmYyqY
         KMz3iNRbKCW9Szw/642JyTUoMfRrWTZiCVYpSafieZfqK/b0mMVTh8cSU5p5S49i+fbH
         4nsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407092; x=1692011892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaqVlo27zysQOw4inLaa7RWYi61naAqQm5GJ5upJpN4=;
        b=lXwqFQMstHLk0AA5wy8wP/MfIy2AoLS3FHWvaVad76bEQRw/KsO/GZGhWofyUp003z
         qbSonkSD/EscCHXAiQ3QAcSL/rZS+/dAWL0QTVIWDKktwI3H5CIU3mFbVa1dj516U35b
         l0wYqK3LB+ATehuwNSWOjVAAE5g0DRoiAoG28uplhgaKTooWOrK44Xqpiecb0vncJvyr
         NcpvPKsahEBsPa0y78BYGljhp3TOZq75920Ru/gOy+tkUkMNrWfA9jKBv39UURyhQ3Z3
         6sfE2ZTVcqWg+6yIb1zDw0hZrpnuSx29lVklSlGRZyujp6gpUS5Cchk90XPUiIm0xj/q
         MqZQ==
X-Gm-Message-State: ABy/qLbypLJtQ7Fi0x70vOUZbP8F3aQkWgEpWV0SbzqZwa/pcbIN3ERf
        +XTCU2msmN7BReX/I34+x60BFITsl3qND/BMMyQ=
X-Google-Smtp-Source: AGHT+IHBSjfm4qMxfKY1o30DsQrf62j+YLyyzQgOSjZX7MvZKQZkongUtrzUOFN5xrnWaoCKIehpOA==
X-Received: by 2002:a17:90a:9c3:b0:269:41cf:7212 with SMTP id 61-20020a17090a09c300b0026941cf7212mr4969668pjo.4.1691407071669;
        Mon, 07 Aug 2023 04:17:51 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:17:51 -0700 (PDT)
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
Subject: [PATCH v4 37/48] xfs: dynamically allocate the xfs-buf shrinker
Date:   Mon,  7 Aug 2023 19:09:25 +0800
Message-Id: <20230807110936.21819-38-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the xfs-buf shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct xfs_buftarg.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/xfs/xfs_buf.c | 25 ++++++++++++++-----------
 fs/xfs/xfs_buf.h |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15d1e5a7c2d3..715730fc91cb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1906,8 +1906,7 @@ xfs_buftarg_shrink_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buftarg	*btp = shrink->private_data;
 	LIST_HEAD(dispose);
 	unsigned long		freed;
 
@@ -1929,8 +1928,7 @@ xfs_buftarg_shrink_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buftarg	*btp = shrink->private_data;
 	return list_lru_shrink_count(&btp->bt_lru, sc);
 }
 
@@ -1938,7 +1936,7 @@ void
 xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
-	unregister_shrinker(&btp->bt_shrinker);
+	shrinker_free(btp->bt_shrinker);
 	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
@@ -2021,13 +2019,18 @@ xfs_alloc_buftarg(
 	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
 		goto error_lru;
 
-	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
-	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
-	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
-	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
-	if (register_shrinker(&btp->bt_shrinker, "xfs-buf:%s",
-			      mp->m_super->s_id))
+	btp->bt_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-buf:%s",
+					  mp->m_super->s_id);
+	if (!btp->bt_shrinker)
 		goto error_pcpu;
+
+	btp->bt_shrinker->count_objects = xfs_buftarg_shrink_count;
+	btp->bt_shrinker->scan_objects = xfs_buftarg_shrink_scan;
+	btp->bt_shrinker->seeks = DEFAULT_SEEKS;
+	btp->bt_shrinker->private_data = btp;
+
+	shrinker_register(btp->bt_shrinker);
+
 	return btp;
 
 error_pcpu:
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..4e6969a675f7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -102,7 +102,7 @@ typedef struct xfs_buftarg {
 	size_t			bt_logical_sectormask;
 
 	/* LRU control structures */
-	struct shrinker		bt_shrinker;
+	struct shrinker		*bt_shrinker;
 	struct list_lru		bt_lru;
 
 	struct percpu_counter	bt_io_count;
-- 
2.30.2

