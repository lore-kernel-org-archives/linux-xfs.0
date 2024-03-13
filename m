Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEBAB67D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295487; cv=none; b=Bzn/ihwcQg1gceUoAw05PM64OTNejI9PEQTymmzSvr2djjzrIi9DpzzM9cAEqq/dP7qfvIOEm3Qmhf11dFl/irZ0N7F9Ue919h69TNZXUIfCUakEyHKsuruSb12WmCaIQRS0eJeYHBEqNX/IfiYz6PYAHalkkvwjnenGPO6pQwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295487; c=relaxed/simple;
	bh=dD/5ABscXpA4fNy/ly0nuQ4mqf6qtgX/OYohk1K9Qqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9UxNwNhg7uLcOV3pDyTWSnaxrmH2+rTPf0UIjv23O3s4o496PyZ8y/KzC8/vYibNhDBpIMD4+Duc7EDRuEHmjZaojTGzRbB8gzqJNwRSwTqgI9zxWE62U8J8nugfBUM3+ZvDZ68IUcNdZnhytosJtuZI0noTQH1ftwCEgYN6Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvRzlGOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvRzlGOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6B2C433C7;
	Wed, 13 Mar 2024 02:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295486;
	bh=dD/5ABscXpA4fNy/ly0nuQ4mqf6qtgX/OYohk1K9Qqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UvRzlGOmR9oqzEQeg0y27CRiGQLZ1FZgOQRBg6OjfbjwoozS8ZI5BJ5Tid37zNChv
	 uwte0Xlhsipae+JKB6ewAc+NctqBQNJg6Ewf4CqR06tLc5DgOm6LfGVELG1s9sKnFO
	 TRgw06sUywlwlhH7KBGmbnBZlySkOSaAdbj+33JwJA34Qk6TNAvp5402nOeTi3O1fT
	 qSxyV2Pv6ax6qrABULLpDc9bPZc+wCx9HWdLCvU4rPt1e4sWwcumxvBr5Kl/alhPlt
	 rJOTG5p2Z3vM+AE0qyAwdELg0ncjm91fwQ+buw/MpjL5UkjZUsmX1FaiiJMaklYtfF
	 vtnmLEiSFaasg==
Date: Tue, 12 Mar 2024 19:04:46 -0700
Subject: [PATCH 45/67] xfs: fix perag leak when growfs fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431842.2061787.9951895152503197518.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 7823921887750b39d02e6b44faafdd1cc617c651

During growfs, if new ag in memory has been initialized, however
sb_agcount has not been updated, if an error occurs at this time it
will cause perag leaks as follows, these new AGs will not been freed
during umount , because of these new AGs are not visible(that is
included in mp->m_sb.sb_agcount).

unreferenced object 0xffff88810be40200 (size 512):
comm "xfs_growfs", pid 857, jiffies 4294909093
hex dump (first 32 bytes):
00 c0 c1 05 81 88 ff ff 04 00 00 00 00 00 00 00  ................
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
backtrace (crc 381741e2):
[<ffffffff8191aef6>] __kmalloc+0x386/0x4f0
[<ffffffff82553e65>] kmem_alloc+0xb5/0x2f0
[<ffffffff8238dac5>] xfs_initialize_perag+0xc5/0x810
[<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
[<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
[<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
[<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
[<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
unreferenced object 0xffff88810be40800 (size 512):
comm "xfs_growfs", pid 857, jiffies 4294909093
hex dump (first 32 bytes):
20 00 00 00 00 00 00 00 57 ef be dc 00 00 00 00   .......W.......
10 08 e4 0b 81 88 ff ff 10 08 e4 0b 81 88 ff ff  ................
backtrace (crc bde50e2d):
[<ffffffff8191b43a>] __kmalloc_node+0x3da/0x540
[<ffffffff81814489>] kvmalloc_node+0x99/0x160
[<ffffffff8286acff>] bucket_table_alloc.isra.0+0x5f/0x400
[<ffffffff8286bdc5>] rhashtable_init+0x405/0x760
[<ffffffff8238dda3>] xfs_initialize_perag+0x3a3/0x810
[<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
[<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
[<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
[<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
[<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a

Factor out xfs_free_unused_perag_range() from xfs_initialize_perag(),
used for freeing unused perag within a specified range in error handling,
included in the error path of the growfs failure.

Fixes: 1c1c6ebcf528 ("xfs: Replace per-ag array with a radix tree")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag.c |   36 ++++++++++++++++++++++++++----------
 libxfs/xfs_ag.h |    2 ++
 2 files changed, 28 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1dbc01b97366..0556d5547059 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -330,6 +330,31 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+/*
+ * Free perag within the specified AG range, it is only used to free unused
+ * perags under the error handling path.
+ */
+void
+xfs_free_unused_perag_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agstart,
+	xfs_agnumber_t		agend)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		index;
+
+	for (index = agstart; index < agend; index++) {
+		spin_lock(&mp->m_perag_lock);
+		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
+		if (!pag)
+			break;
+		xfs_buf_hash_destroy(pag);
+		xfs_defer_drain_free(&pag->pag_intents_drain);
+		kmem_free(pag);
+	}
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -429,16 +454,7 @@ xfs_initialize_perag(
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
-	for (index = first_initialised; index < agcount; index++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		spin_unlock(&mp->m_perag_lock);
-		if (!pag)
-			break;
-		xfs_buf_hash_destroy(pag);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-		kmem_free(pag);
-	}
+	xfs_free_unused_perag_range(mp, first_initialised, agcount);
 	return error;
 }
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 67c3260ee789..4b343c4fac28 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -143,6 +143,8 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
+void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
+			xfs_agnumber_t agend);
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);

