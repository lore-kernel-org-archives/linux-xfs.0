Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B24524B4
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371236; cv=none; b=acIPwhbQV+DUgcfhsGEeqvy6MSyBjVXn8hHbnkc8fOtTtqXtNui563cg50DDwwfCX0FzDnIs7ZgAj0617WxxqG3dR27p26xDOnmNCcMn7Xh9OQzwYmMsnRAV8nZ8GS4qUz8y5+6t1TCsvvHObepfyUd15iIl+B1cp7EwcBSNJSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371236; c=relaxed/simple;
	bh=4yn7atkLY4VoR4yZSg8W1k7y4dGJkuMgymIGq2IYHO8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTuwSeBOk+FYXUJzIWObktVTH9fMlzhqMEpN1S18UUqYPNqbau2eC1SCOXmga9AlYFMibT34LL4UeoWon3x5dJZzMVt6UJBG/tiV2Z97nNGWalI15vqBtKLG+SCFXyDFS66CtscmvTzTsP39FoXDRFkgTSACD47wQ3fK2NkcFXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hyc2SyL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hyc2SyL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE31C4AF14;
	Fri, 23 Aug 2024 00:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371236;
	bh=4yn7atkLY4VoR4yZSg8W1k7y4dGJkuMgymIGq2IYHO8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hyc2SyL59CTvPLiIKpmvPQ2nr23ZUclaXDIuyWQ5e1dmQ5aDisXxz6wO5OIYQoAx7
	 5+X4JLvSwzvPSpF7tl5XSnDzE9Ol3zahjgf9X0UXBwOoNjp8vh0eD1VOh5pOxeNfnD
	 J/Ulxw3EtcFGy6hCJQVc+syt5VaahBtX17t20GV6q7wLi1AcD9pno3puBStWLDJyUS
	 SaT1hLjTYKR663W6WpagHtLeIPV1vs5g4tykL8afBNsruOUZdoWpdJh4cfn8Ob5G4E
	 VVjyUK48vQFiOLzY7nJ4j3qC9Ww2m9E3YVi68fetRHWPsAhOIiPsDc29lrX/kHb/iL
	 wrAr+r+HScbUA==
Date: Thu, 22 Aug 2024 17:00:35 -0700
Subject: [PATCH 7/9] xfs: Fix missing interval for missing_owner in xfs fsmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083870.56860.9286016304300766439.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zizhi Wo <wozizhi@huawei.com>

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
xfs_getfsmap_info. This records |key[1].fmr_physical + key[1].length| at
the granularity of sector. If the current query is the last, the rec_daddr
is end_daddr to prevent missing interval problems caused by shifting. We
only need to focus on the last query, because xfs disks are internally
aligned with disk blocksize that are powers of two and minimum 512, so
there is no problem with shifting in previous queries.

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:16 [104..106]:      free space                        0  (104..106)           3

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: limit the range of end_addr correctly]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 613a0ec204120..71f32354944e4 100644
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
@@ -182,6 +183,7 @@ struct xfs_getfsmap_dev {
 	int			(*fn)(struct xfs_trans *tp,
 				      const struct xfs_fsmap *keys,
 				      struct xfs_getfsmap_info *info);
+	sector_t		nr_sectors;
 };
 
 /* Compare two getfsmap device handlers. */
@@ -294,6 +296,18 @@ xfs_getfsmap_helper(
 		return 0;
 	}
 
+	/*
+	 * For an info->last query, we're looking for a gap between the last
+	 * mapping emitted and the high key specified by userspace.  If the
+	 * user's query spans less than 1 fsblock, then info->high and
+	 * info->low will have the same rm_startblock, which causes rec_daddr
+	 * and next_daddr to be the same.  Therefore, use the end_daddr that
+	 * we calculated from userspace's high key to synthesize the record.
+	 * Note that if the btree query found a mapping, there won't be a gap.
+	 */
+	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
+		rec_daddr = info->end_daddr;
+
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
 		if (info->head->fmh_entries == UINT_MAX)
@@ -904,17 +918,21 @@ xfs_getfsmap(
 
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
+	handlers[0].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
 	if (use_rmap)
 		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
 	else
 		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
+		handlers[1].nr_sectors = XFS_FSB_TO_BB(mp,
+						       mp->m_sb.sb_logblocks);
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
 #ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
+		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
 		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
@@ -946,6 +964,7 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
+	info.end_daddr = XFS_BUF_DADDR_NULL;
 	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
@@ -966,8 +985,11 @@ xfs_getfsmap(
 		 * low key, zero out the low key so that we get
 		 * everything from the beginning.
 		 */
-		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
+		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
 			dkeys[1] = head->fmh_keys[1];
+			info.end_daddr = min(handlers[i].nr_sectors - 1,
+					     dkeys[1].fmr_physical);
+		}
 		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
 			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
 

