Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560598;
	b=biIjQ+KlztBmULln4XXhnIQhiAHupIroKw/mQp0R7XCdHF/zRjvYTL5yVrn2f5jydPWr
	 Gi8x9uufGjZp9IFbkd9jq8xoETKL1USaTxHrvM5+O4uxzyavdlqQPyyKfEOWAud0eYYco
	 ejjmINnq/BsLAGz5pmMun8jVXhG8QOJUn2rPvgGlloNTGsT9XhxuUzlydQG+Z5XZgMam/
	 GIs7ezXUWdT3eaZyUPacG6DVPDP0lTvbPXMy8mEprFnU/1g7v2uu2A2wpOLD3Pgcb8Bkg
	 IPI8RiKkf22cIcu3raFK04c3IGonMpy1sySadKLZuubSvx6gaKRtSg2srEhSV0avKLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560598;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GcdHDZpy9xXRzbmNMsYdRGlLeHjsja+683bQohKV+fQ=;
	b=YF499lzWuWh36P/ScQBdvvpaToJ+3k/fXQcaCBAzsGL9LClf+pvceLAedVkQq/leARsM
	 S7Fhsedb61oXBQg8bNzFzs5GsRql9qEAtgHgsPBcfEMs59QWFyIVDQcXQBDBcJh8mtz+Y
	 A8sDK9h/3VW9t1nGMcS1X/1GR3xeP62pBClEPtMiOYM6evULs5dEul0hx2IX9akLRFkjm
	 +Tyrm05I6zjWkAI6hLJyDmnJRvpA8+RqUx1FCZSbpsidYg9V/DGMQ+7Ii3iFvlcUVQQmY
	 pU8rFp8+T9Uk345XZf2kRk/07rPPA6z4II1UsldbgIEicNiiTNbtB89FWBu93Ord99A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZskN1es5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AB4606A329;
	Tue, 24 Nov 2026 22:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZskN1es5
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560597;
	b=jEunJgJ3Vl6/REBukKcQRxs1ibVPuWPC5807h7s5QeNkEjcEfoXO7DcNbWZtD8cHy7P4
	 prFuFy8W7bvzty2BxOKaAX6fXBukJ8KDUIedbgLTpIvzCNmGbWY4DR2EyIjMGveuFeLyA
	 Vkt0fj3QJfu9gnY/UJnBLTVrBTPEbekJjgrPNgkgznlEUzSVKF/4QJtDWixw9jql5BkfS
	 o8hwJll+deD4GsQa7TUQQ7UN4NY2KVzCDF6ol0KePspww/icshOVvi8//sd2qrk34+9Qw
	 bjjNCsuV+fSKuFR9Yh15RBHGcZi1Th8hhfuF7MX1ntPBKfE0DyILES17hul38uIkSlQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560597;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GcdHDZpy9xXRzbmNMsYdRGlLeHjsja+683bQohKV+fQ=;
	b=Ab/IPwUJQ/l3Af4Pv95jTjHM6RaheP9HjpPhrk8DqweS5AWr2UAuNGtyiVJXi4A547Se
	 BnVNafHjgDylL9MDCSqJCxJ5qf8h0O1HTxKN7IDmghrUgYenKcOhhMP3+9f05Ydsk9NKU
	 nUqitC/CR0CH7ZE4gijo+PnB2NL6/eW/Qj/tUGv6BVHm/Sb50at025H6GBf5n+YbKCxzD
	 xX4Kf0tZhfKj5ZogQlxnE3WfmrmBJSoy6ob+OTMBz9Qpu4uBs7ZhAaXMofT6I4A7Df0ra
	 MkYq2JGftv3yRJnScVnXsWIA8BAzwBG8pKV2tkPSATGiY46hjafnnKv+92+lV7EWVbA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DEE931F000E1;
	Tue, 24 Nov 2026 22:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560597;
	bh=GcdHDZpy9xXRzbmNMsYdRGlLeHjsja+683bQohKV+fQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZskN1es5kuIn2Imm4jbCDfpc5+4fiY+hxcFabzDv7ycWwGr/sry9Sh7+1k8w288VC
	 6ApUOTfYRs6LHvAew7TtaA03rgDcIusYFz/22cL6xhQfrlJ5Oxgr9Cd9hvJbcwLSD0
	 hb0atGx38KYRPKo8pvMMglqJXmi045g/YW3AAjmrhY+gdLLD/a3wHzJvr1YLvqCu8n
	 7JkVMA/R4Kirtq1O/JUYw4JSLZtuI4LEWHaAXwz8qS/X9+LKnbJoVGSU191BrdyL6X
	 E++4VUhyNLLRX9eIQ8/uKMmqZ1AS+i4gDFU46VEzjEnvfo7CpBghRu3GRwAtkE4biv
	 dY6lktM/RGBmA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6A68D4CC24;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:39 +0100
Subject: [PATCH v2 05/11] ntfs: keep delalloc reservations when a cluster
 allocation fails
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-5-f394c800ec03@proton.me>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
To: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Baolin Liu <liubaolin12138@163.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 "Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng1024@gmail.com>, 
 stable@vger.kernel.org, Ernest Borowski <ernest.borowski.git@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5991;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=Ll5q/lv6mMUy3lMMuep0U4+NJtbPAmPZTKcpeMqtKPc=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kfoba1KnFa+w/vw9kO3FYpuqyPK+74v33u06bHLe4
 P9k2cs6HaUsDGJcDLJiiiwd/2+E+IR8+7QsTqsPZg4rE8gQBi5OAZjIR1VGhn2C3VLbni4SvVt9
 97vqmdrV625mZlc6l/Y2L+SoMT9Qq8Hwz0omTKHd8eenW2uL2a/0ljncPZ/Xlnvs7/r6IC7OH7x
 fuQA=
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

ntfs_cluster_alloc() sets vol->dirty_clusters to 0 when it fails after
the free space check, which in practice means -ENOMEM or -EIO while it
scans the bitmap.  vol->dirty_clusters is the sum of the reservations
of every delalloc run on the volume, and those runs are still there, so
the reset makes statfs() and the next allocations treat the reserved
clusters as free.  Buffered writes then reserve the same clusters a
second time, and writeback of the delayed data later fails with ENOSPC
and loses it.

ntfs_attr_map_cluster() has the converse problem on its own error
paths: once the allocator succeeded for a delalloc run it has taken
that run's reservation, but when the runlist copy, the runlist merge or
the mapping pairs update fails afterwards, the clusters are freed and
the run stays delalloc without a reservation.

Reproducer (fault injection): write 4 MiB to file A without syncing,
then fsync another file with /proc/thread-self/fail-nth set so that the
kvzalloc() in ntfs_cluster_alloc() fails.  statfs() free space jumps
back up by 1025 of the 1028 clusters A holds (4 KiB clusters). Writing a
file of the size statfs() then reports and syncing loses about 4 MiB of
that file's data; on 512 byte, 4 KiB and 64 KiB clusters alike.  Fault
sites after the allocation (the runlist copy in ntfs_attr_map_cluster())
raise the free space by the clusters of the failed request.

Leave vol->dirty_clusters alone when the allocation fails, and hold the
reservation again when ntfs_attr_map_cluster() puts a delalloc run back
after the allocator consumed it, before the clusters are freed, so that
no other writer can reserve them in between.  If freeing them fails too,
the run keeps the clusters and the hold is dropped again.  The error
path after a failed mapping pairs update now returns the error without
also reporting the freed clusters as allocated.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/ntfs/attrib.c   | 24 +++++++++++++++++++++++-
 fs/ntfs/lcnalloc.c |  1 -
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index cdac846f37..7711b9df89 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5428,6 +5428,19 @@ int ntfs_attr_truncate(struct ntfs_inode *ni, const s64 newsize)
 				    HOLES_NO : HOLES_OK);
 }
 
+/*
+ * The allocator has taken the reservation of a delalloc run whose clusters
+ * are about to be freed again, the run staying delalloc: hold the
+ * reservation again first, so that no other writer can reserve the freed
+ * clusters in between.
+ */
+static void ntfs_map_cluster_rehold(struct ntfs_volume *vol, bool was_delalloc,
+				    s64 clu_count)
+{
+	if (was_delalloc)
+		ntfs_hold_dirty_clusters(vol, clu_count);
+}
+
 int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 		s64 *lcn_count, s64 max_clu_count, bool *balloc, bool update_mp,
 		bool skip_holes)
@@ -5439,6 +5452,7 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 	struct runlist_element *old_rl = NULL;
 	s64 vcn = vcn_start, lcn, clu_count;
 	s64 lcn_seek_from = -1;
+	bool was_delalloc;
 	int err = 0;
 	size_t new_rl_count, old_rl_count;
 
@@ -5526,8 +5540,9 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 	 * fallocate(), direct I/O or page_mkwrite() have none and must leave
 	 * the reservations of other writers alone.
 	 */
+	was_delalloc = lcn == LCN_DELALLOC;
 	rlc = ntfs_cluster_alloc(vol, vcn, clu_count, lcn_seek_from, DATA_ZONE,
-			false, true, lcn == LCN_DELALLOC);
+			false, true, was_delalloc);
 	if (IS_ERR(rlc)) {
 		err = PTR_ERR(rlc);
 		goto out;
@@ -5541,6 +5556,7 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 			 old_rl_count * sizeof(*old_rl), GFP_NOFS);
 	if (!old_rl) {
 		err = -ENOMEM;
+		ntfs_map_cluster_rehold(vol, was_delalloc, clu_count);
 		if (ntfs_cluster_free_from_rl(vol, rlc)) {
 			ntfs_error(vol->sb,
 				   "Failed to free cluster allocation after runlist backup failure.");
@@ -5554,6 +5570,7 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 	if (IS_ERR(rl)) {
 		ntfs_error(vol->sb, "Failed to merge runlists");
 		err = PTR_ERR(rl);
+		ntfs_map_cluster_rehold(vol, was_delalloc, clu_count);
 		if (ntfs_cluster_free_from_rl(vol, rlc))
 			ntfs_error(vol->sb, "Failed to free hot clusters.");
 		kvfree(rlc);
@@ -5576,11 +5593,15 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 		if (err) {
 			s64 freed;
 
+			ntfs_map_cluster_rehold(vol, was_delalloc, clu_count);
 			freed = ntfs_cluster_free(ni, vcn, clu_count, ctx);
 			if (freed < 0 || freed != clu_count) {
 				ntfs_error(vol->sb,
 					   "Failed to free cluster allocation. Leaving inconsistent metadata.\n");
 				NVolSetErrors(vol);
+				/* The run keeps its clusters: drop the hold again. */
+				if (was_delalloc)
+					ntfs_release_dirty_clusters(vol, clu_count);
 				goto out;
 			}
 
@@ -5598,6 +5619,7 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 					   "Failed to restore mapping pairs after allocation rollback.\n");
 				NVolSetErrors(vol);
 			}
+			goto out;
 		}
 	} else {
 		VFS_I(ni)->i_blocks += clu_count << (vol->cluster_size_bits - 9);
diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index 7e00016f42..2fbc24e4c6 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -799,7 +799,6 @@ switch_to_data1_zone:		search_zone = 2;
 	} else if (err == -ENOSPC)
 		ntfs_debug("No space left at all, err = -ENOSPC, first free lcn = 0x%llx.",
 				vol->data1_zone_pos);
-	atomic64_set(&vol->dirty_clusters, 0);
 
 out_restore:
 	up_write(&vol->lcnbmp_lock);

-- 
2.56.1


