Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F13925570;
	Thu,  8 Aug 2024 14:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723128717; cv=none; b=OicCy4lEsdWFs9wmCQvtEedKeC417MSBSm2nrVZhF/9toDidbQrPNhYs4T3t69GfdNq0cu/C4umwd1+8YG3j4ub5y/zbKGg719D6VkerpIVCmsL7KFITYyudFSSH0H+COJNkgMvRpPgOcRo8lKWEG+Eq8cwn0B+3sF/zhNlfAcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723128717; c=relaxed/simple;
	bh=+OwJImL4HqYe67YQNsVit4UhYCn3hCx3i+TxtpzuguY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DMrg2GWoRYSmcD1ycSZiZVa2jQU+id0t0vCpwCFL5BpSTXllB5sapGPxO0EFJ3pKf04DzHDU0vSRN5raP5IKcRzM1g/Sz8AtqkboO7rKz+W3El4L+BMVn4X60lOvaWZAYNkTX2C8UpGBoC2kfHDjb1KsNwhMr9fG7mKrd3xGulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WfqjC1rwSzpTBq;
	Thu,  8 Aug 2024 22:50:39 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 2387A18005F;
	Thu,  8 Aug 2024 22:51:51 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Aug 2024 22:51:50 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH V2] xfs: Make the fsmap more precise
Date: Thu, 8 Aug 2024 22:47:59 +0800
Message-ID: <20240808144759.1330237-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemf100017.china.huawei.com (7.202.181.16)

In commit 63ef7a35912d ("xfs: fix interval filtering in multi-step fsmap
queries"), Darrick has solved a fsmap bug about incorrect filter condition.
But I still notice two problems in fsmap:

[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
 EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
   0: 253:32 [0..7]:               static fs metadata                  0  (0..7)                    8
   1: 253:32 [8..23]:              per-AG metadata                     0  (8..23)                  16
   2: 253:32 [24..39]:             inode btree                         0  (24..39)                 16
   ......

Bug 1:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 3 7' /mnt
[root@fedora ~]#
Normally, we should be able to get [3, 7), but we got nothing.

Bug 2:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 15 20' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:32 [8..23]:         per-AG metadata                   0  (8..23)             16
Normally, we should be able to get [15, 20), but we obtained a whole
segment of extent.

The first problem is caused by shifting. When the query interval is before
the first extent which can be find in btree, no records can meet the
requirement. And the gap will be obtained in the last query. However,
rec_daddr is calculated based on the start_block recorded in key[1], which
is converted by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
<= info->next_daddr, no records will be displayed. In the above example,
3 >> (mp)->m_blkbb_log = 0 and 7 >> (mp)->m_blkbb_log = 0, so the two are
reduced to 0 and the gap is ignored:

before calculate ----------------> after shifting
 3(st)    7(ed)                       0(st/ed)
  |---------|                            |
  sector size                        block size

Resolve this issue by introducing the "tail_daddr" field in
xfs_getfsmap_info. This records |key[1].fmr_physical + key[1].length| at
the granularity of sector. If the current query is the last, the rec_daddr
is tail_daddr to prevent missing interval problems caused by shifting. We
only need to focus on the last query, because xfs disks are internally
aligned with disk blocksize that are powers of two and minimum 512, so
there is no problem with shifting in previous queries.

The second problem is that the resulting range is not truncated precisely
according to the boundary. Currently, the query display mechanism for owner
and missing_owner is different. The query of missing_owner (e.g. freespace
in rmapbt/ unknown space in bnobt) is obtained by subtraction (gap), which
can accurately lock the range. In the query of owner which almostly finded
by btree, as long as certain conditions met, the entire interval is
recorded, regardless of the starting address of the key[0] and key[1]
incoming from the user state. Focus on the following scenario:

                    a       b
                    |-------|
	              query
                 c             d
|----------------|-------------|----------------|
  missing owner1      owner      missing owner2

Currently query is directly displayed as [c, d), the correct display should
be [a, b). This problem is solved by calculating max(a, c) and min(b, d) to
identify the head and tail of the range. To be able to determine the bounds
of the low key, "start_daddr" is introduced in xfs_getfsmap_info. Although
in some scenarios, similar results can be achieved without introducing
"start_daddr" and relying solely on info->next_daddr (e.g. in bnobt), it is
ineffective for overlapping scenarios in rmapbt.

After applying this patch, both of the above issues have been fixed (the
same applies to boundary queries for the log device and realtime device):
1)
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 3 7' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:32 [3..6]:          static fs metadata                  0  (3..6)               4
2)
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 15 20' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:32 [15..19]:        per-AG metadata                   0  (15..19)             5

Note that due to the current query range being more precise, high.rm_owner
needs to be handled carefully. When it is 0, set it to the maximum value to
prevent missing intervals in rmapbt.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_fsmap.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 85dbb46452ca..e7bb21497e5c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -162,6 +162,8 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
+	xfs_daddr_t		start_daddr;	/* daddr of low fsmap key */
+	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -276,6 +278,7 @@ xfs_getfsmap_helper(
 	struct xfs_mount		*mp = tp->t_mountp;
 	bool				shared;
 	int				error;
+	int				trunc_len;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
@@ -283,6 +286,13 @@ xfs_getfsmap_helper(
 	if (len_daddr == 0)
 		len_daddr = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 
+	/*
+	 * Determine the maximum boundary of the query to prepare for
+	 * subsequent truncation.
+	 */
+	if (info->last && info->end_daddr)
+		rec_daddr = info->end_daddr;
+
 	/*
 	 * Filter out records that start before our startpoint, if the
 	 * caller requested that.
@@ -348,6 +358,21 @@ xfs_getfsmap_helper(
 		return error;
 	fmr.fmr_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
 	fmr.fmr_length = len_daddr;
+	/*  If the start address of the record is before the low key, truncate left. */
+	if (info->start_daddr > rec_daddr) {
+		trunc_len = info->start_daddr - rec_daddr;
+		fmr.fmr_physical += trunc_len;
+		fmr.fmr_length -= trunc_len;
+		/* need to update the offset in rmapbt. */
+		if (info->missing_owner == XFS_FMR_OWN_FREE)
+			fmr.fmr_offset += trunc_len;
+	}
+	/* If the end address of the record exceeds the high key, truncate right. */
+	if (info->end_daddr) {
+		fmr.fmr_length = umin(fmr.fmr_length, info->end_daddr - fmr.fmr_physical);
+		if (fmr.fmr_length == 0)
+			goto out;
+	}
 	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
 		fmr.fmr_flags |= FMR_OF_PREALLOC;
 	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
@@ -364,7 +389,7 @@ xfs_getfsmap_helper(
 
 	xfs_getfsmap_format(mp, &fmr, info);
 out:
-	rec_daddr += len_daddr;
+	rec_daddr = fmr.fmr_physical + fmr.fmr_length;
 	if (info->next_daddr < rec_daddr)
 		info->next_daddr = rec_daddr;
 	return 0;
@@ -655,6 +680,13 @@ __xfs_getfsmap_datadev(
 			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
 			if (error)
 				break;
+			/*
+			 * Set the owner of high_key to the maximum again to
+			 * prevent missing intervals during the query.
+			 */
+			if (info->high.rm_owner == 0 &&
+			    info->missing_owner == XFS_FMR_OWN_FREE)
+			    info->high.rm_owner = ULLONG_MAX;
 			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
 		}
 
@@ -946,6 +978,9 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
+	/* Assignment is performed only for the first time. */
+	if (head->fmh_keys[0].fmr_length == 0)
+		info.start_daddr = info.next_daddr;
 	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
@@ -966,8 +1001,10 @@ xfs_getfsmap(
 		 * low key, zero out the low key so that we get
 		 * everything from the beginning.
 		 */
-		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
+		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
 			dkeys[1] = head->fmh_keys[1];
+			info.end_daddr = dkeys[1].fmr_physical + dkeys[1].fmr_length;
+		}
 		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
 			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
 
@@ -991,6 +1028,7 @@ xfs_getfsmap(
 		xfs_trans_cancel(tp);
 		tp = NULL;
 		info.next_daddr = 0;
+		info.start_daddr = 0;
 	}
 
 	if (tp)
-- 
2.39.2

