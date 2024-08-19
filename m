Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E341BDC8;
	Mon, 19 Aug 2024 00:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029076; cv=none; b=naFJfG7gZnTUsEWzxjsXWJ6KG1ElZ0twgB2ejwJDelPN/wuERVvNjJtTStFJahCyc4dxGgfTY1dMF9xZl//+B3kfIu61PCVkxkRgh8Peq6OC0+kQPjG9IzZhxa8XsorgXCH4mWL8ghsNMOw88UyUnjsOHiKY2CVNoBkjpalQ3uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029076; c=relaxed/simple;
	bh=VswoMa6/q8uxfd6GJxPzq1IB2NeWhuBVoTOwLQkkWhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rl6ZO7POv4N4hJa26ZyuVf9KnNc8zJbr0UK0RjTM0TkAZD8o8SwxqNdwZ6C8BZpwFJfk7oNFSefFQp9o64Q74Vhe2TurkLSoxxVdYnBDnef/d2Qt3ZlbmBWRQKMBaZVgVbEttZ5mqdxOF/IQESGz0MC+7Kt7nhMzHdmxZW6awa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WnDhW0PDyzyQ93;
	Mon, 19 Aug 2024 08:57:15 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E975180064;
	Mon, 19 Aug 2024 08:57:51 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Aug 2024 08:57:50 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH V4 2/2] xfs: Fix missing interval for missing_owner in xfs fsmap
Date: Mon, 19 Aug 2024 08:53:20 +0800
Message-ID: <20240819005320.304211-3-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240819005320.304211-1-wozizhi@huawei.com>
References: <20240819005320.304211-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf100017.china.huawei.com (7.202.181.16)

In the fsmap query of xfs, there is an interval missing problem:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
 EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
   0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
   1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
   2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
   3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
   4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
   5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
   6: 253:16 [104..127]:           free space                          0  (104..127)               24
   ......

BUG:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
[root@fedora ~]#
Normally, we should be able to get [104, 107), but we got nothing.

The problem is caused by shifting. The query for the problem-triggered
scenario is for the missing_owner interval (e.g. freespace in rmapbt/
unknown space in bnobt), which is obtained by subtraction (gap). For this
scenario, the interval is obtained by info->last. However, rec_daddr is
calculated based on the start_block recorded in key[1], which is converted
by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
<= info->next_daddr, no records will be displayed. In the above example,
104 >> (mp)->m_blkbb_log = 12 and 107 >> (mp)->m_blkbb_log = 12, so the two
are reduced to 0 and the gap is ignored:

 before calculate ----------------> after shifting
 104(st)  107(ed)		      12(st/ed)
  |---------|				  |
  sector size			      block size

Resolve this issue by introducing the "end_daddr" field in
xfs_getfsmap_info. This records key[1].fmr_physical at the granularity of
sector. If the current query is the last, the rec_daddr is end_daddr to
prevent missing interval problems caused by shifting. We only need to focus
on the last query, because xfs disks are internally aligned with disk
blocksize that are powers of two and minimum 512, so there is no problem
with shifting in previous queries.

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:16 [104..106]:      free space                        0  (104..106)           3

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_fsmap.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3a30b36779db..4734f8d6303c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -162,6 +162,7 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
+	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -294,6 +295,19 @@ xfs_getfsmap_helper(
 		return 0;
 	}
 
+	/*
+	 * For an info->last query, we're looking for a gap between the
+	 * last mapping emitted and the high key specified by userspace.
+	 * If the user's query spans less than 1 fsblock, then
+	 * info->high and info->low will have the same rm_startblock,
+	 * which causes rec_daddr and next_daddr to be the same.
+	 * Therefore, use the end_daddr that we calculated from
+	 * userspace's high key to synthesize the record.  Note that if
+	 * the btree query found a mapping, there won't be a gap.
+	 */
+	if (info->last && info->end_daddr != LLONG_MAX)
+		rec_daddr = info->end_daddr;
+
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
 		if (info->head->fmh_entries == UINT_MAX)
@@ -946,6 +960,7 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
+	info.end_daddr = LLONG_MAX;
 	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
@@ -966,8 +981,10 @@ xfs_getfsmap(
 		 * low key, zero out the low key so that we get
 		 * everything from the beginning.
 		 */
-		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
+		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
 			dkeys[1] = head->fmh_keys[1];
+			info.end_daddr = dkeys[1].fmr_physical;
+		}
 		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
 			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
 
-- 
2.39.2

