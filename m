Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D06115532C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804016; cv=none; b=CKBikns+t2xUrjczcPX/h3MVpVnmu9l2UPh2uBh2Laxra7wfQONrSmfKIb1Rqipbl2+NdC7zsgrrBdEso56r5K6H3TWZyhOvifxkvDMY4id/zitq7DN+gGrUjebHijMyhniaKxNeozxGt5aUllI8qQaITwjfHVPD9Xab26kiwvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804016; c=relaxed/simple;
	bh=etCbGVxQf0Sx64up78GHdAXT/fIstmZ/FJLURz1MJvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWBkGf2YYLgsOr1iqwRqLYaZvTVaQatf9V1SEouBQ/uw4TqxkGlDoh0tjLgMfUxCPLQGBoJhKthhtpnFk0gsJzsNBHDmdzEx9l978OMtBLGxtvMF8QpWXwnPiq1CCCNw4EgR0KyTSjNLQg2eoPSlG4qTOil4vsuu2oEiUBxhCPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYO3EX1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYO3EX1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE9FC116B1;
	Mon, 22 Apr 2024 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804016;
	bh=etCbGVxQf0Sx64up78GHdAXT/fIstmZ/FJLURz1MJvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYO3EX1jmc59EfWH7ntQSXRfgjFwxP0CHx90V61us8Te9zRiRGDFP+nuZ0GPXu85x
	 jhvwkPMYWqZp89eqk51ncrOYjDnUFmphFtywUEwbQobSKFBYxtnnn75fe2GKal1JrZ
	 Q9vXQ/fPdlu14Jgio0am81RTTN1Bo9vSe7WjlKPmnkVcU8YwsP/plC29cLqiTCpoIQ
	 lakv4LvUYfxTV3Gi2RIvFxq7eYDPswReJfmpGB6Bg82eIEpDM8vS34PxNCfeJtOWp8
	 sGaGT3WPKe7nt34w0K0sEQDHv4AiT69eHi5+qeiCxyiZTvCnlc4YERm9Nu8egbAbfo
	 Y2klocaxXsaDA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 45/67] xfs: fix perag leak when growfs fails
Date: Mon, 22 Apr 2024 18:26:07 +0200
Message-ID: <20240422163832.858420-47-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.c | 36 ++++++++++++++++++++++++++----------
 libxfs/xfs_ag.h |  2 ++
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1dbc01b97..0556d5547 100644
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
@@ -429,16 +454,7 @@ out_free_pag:
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
index 67c3260ee..4b343c4fa 100644
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
-- 
2.44.0

