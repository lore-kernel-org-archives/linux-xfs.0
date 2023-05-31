Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D63CC7EE32
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 10:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbjEaKEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 06:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbjEaKEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 06:04:23 -0400
X-Greylist: delayed 362 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 03:04:19 PDT
Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A4B11C
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 03:04:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685527125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNetM4XBa/Gbuqkaq6l+2vD89eQsIgmLTdtu3cv7dk8=;
        b=lvO7SWW0g6amQil27w7Ch1WvlKqI4Syaj9ZKVX28hbNP7t8j4/5bAKuiTPnmEYRwcznnpM
        FC4tcITydxIA3hqHO31xf6p70DR7WKVF4bsUNWyhiAhBcj85YqAuj7QvPpCBdGQUEYFJeW
        8/DXDI12VzN61sf4+h1P/9MfcFO1sIc=
From:   Qi Zheng <qi.zheng@linux.dev>
To:     akpm@linux-foundation.org, tkhai@ya.ru, roman.gushchin@linux.dev,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, brauner@kernel.org,
        djwong@kernel.org, hughd@google.com, paulmck@kernel.org,
        muchun.song@linux.dev
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 7/8] shmem: implement shmem_destroy_super()
Date:   Wed, 31 May 2023 09:57:41 +0000
Message-Id: <20230531095742.2480623-8-qi.zheng@linux.dev>
In-Reply-To: <20230531095742.2480623-1-qi.zheng@linux.dev>
References: <20230531095742.2480623-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kirill Tkhai <tkhai@ya.ru>

Similar to xfs_fs_destroy_super() implement the method
for shmem.

shmem_unused_huge_count() just touches sb->s_fs_info.
After such the later freeing it will be safe for
unregister_shrinker() splitting (which is made in next
patch).

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 71e6c9855770..a4c3fdf23838 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3930,6 +3930,12 @@ static void shmem_put_super(struct super_block *sb)
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
 	mpol_put(sbinfo->mpol);
+}
+
+static void shmem_destroy_super(struct super_block *sb)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
 	kfree(sbinfo);
 	sb->s_fs_info = NULL;
 }
@@ -4018,6 +4024,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 failed:
 	shmem_put_super(sb);
+	shmem_destroy_super(sb);
 	return -ENOMEM;
 }
 
@@ -4182,6 +4189,7 @@ static const struct super_operations shmem_ops = {
 	.evict_inode	= shmem_evict_inode,
 	.drop_inode	= generic_delete_inode,
 	.put_super	= shmem_put_super,
+	.destroy_super	= shmem_destroy_super,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	.nr_cached_objects	= shmem_unused_huge_count,
 	.free_cached_objects	= shmem_unused_huge_scan,
-- 
2.30.2

