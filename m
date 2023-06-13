Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B96C7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 03:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjFMDYZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 23:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbjFMDYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 23:24:24 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39733129
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 20:24:23 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgD1L3bdDz4f3jYk
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2023 11:04:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgBnVuTC3IdkRFP8LQ--.37435S5;
        Tue, 13 Jun 2023 11:04:39 +0800 (CST)
From:   Zhang Yi <yi.zhang@huaweicloud.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, dchinner@redhat.com, yi.zhang@huawei.com,
        yi.zhang@huaweicloud.com, leo.lilong@huawei.com, yukuai3@huawei.com
Subject: [PATCH 1/2] xfs: factor out __xfs_da3_node_read()
Date:   Tue, 13 Jun 2023 11:04:33 +0800
Message-Id: <20230613030434.2944173-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
References: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgBnVuTC3IdkRFP8LQ--.37435S5
X-Coremail-Antispam: 1UD129KBjvJXoW7KrWxuFyftw43ur1rZryDtrb_yoW8uF1rpF
        1kGayUCrs8tw1xuF1kt3yjq3y3tw1xCr40y397Jw4fXa1qqr1YqFnYyryrG3W5GF4UZ3W7
        Wr15Ar1qga1rKFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9v14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM2
        8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
        r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxC20s
        026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
        JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
        v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
        j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
        W8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbec_DUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

Factor out a wrapper __xfs_da3_node_read() from xfs_da3_node_read()
which could pass flags parameter.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |  5 +++--
 fs/xfs/libxfs/xfs_da_btree.h | 15 +++++++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..2e4e5aa22403 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -378,16 +378,17 @@ xfs_da3_node_set_type(
 }
 
 int
-xfs_da3_node_read(
+__xfs_da3_node_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
+	unsigned int		flags,
 	struct xfs_buf		**bpp,
 	int			whichfork)
 {
 	int			error;
 
-	error = xfs_da_read_buf(tp, dp, bno, 0, bpp, whichfork,
+	error = xfs_da_read_buf(tp, dp, bno, flags, bpp, whichfork,
 			&xfs_da3_node_buf_ops);
 	if (error || !*bpp || !tp)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..6d1da641f4f0 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -194,11 +194,22 @@ int	xfs_da3_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
  */
 int	xfs_da3_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 				       xfs_da_state_blk_t *new_blk);
-int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			xfs_dablk_t bno, struct xfs_buf **bpp, int whichfork);
+int	__xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
+			xfs_dablk_t bno, unsigned int flags,
+			struct xfs_buf **bpp, int whichfork);
 int	xfs_da3_node_read_mapped(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_daddr_t mappedbno, struct xfs_buf **bpp,
 			int whichfork);
+static inline int
+xfs_da3_node_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	struct xfs_buf		**bpp,
+	int			whichfork)
+{
+	return __xfs_da3_node_read(tp, dp, bno, 0, bpp, whichfork);
+}
 
 /*
  * Utility routines.
-- 
2.31.1

