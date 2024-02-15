Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8BA12BF12
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998991; cv=none; b=Q6nPZWc3oAa05HCAQ2WoHXy9tQCPfnUxXgw37LsUyCQ27wOMy+R7Fe2hqmQqktzHaYgu9a0+AD9Eqp7e4V+PrBlfnWk2vKiUQ+GTWg0VT2/TEeYn+JhUWBunBVuLxp5Ad+07qV/emQFsqh3fqi3osXaGdPVjkCiKFkoH2qEEJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998991; c=relaxed/simple;
	bh=werjl0WBtx1G1eMLbnvqIxKDJ9WZaOHzhv9BJSy7kOU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqeTKFAl1lUfP2QL+G7j8Sem+gynEOJcCCNRwtQvkNzbpbwkZNfiZMw7lGl8hVMJKbZSPBTw3yJsHzc0MZqaCK0H6RjCK3qomxRsMy505e9I0EPPnJqVrV0++xmKnyHrO0ZCUjCWvwkQ5CJtcTvRfSCMchhy2tkz1MwmNDn95kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovVQoUMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovVQoUMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E41C433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998991;
	bh=werjl0WBtx1G1eMLbnvqIxKDJ9WZaOHzhv9BJSy7kOU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ovVQoUMgJRSWnascLJZEyyV4chK+Pg4poqwme+tv1QcuuOqT9r15ZNch71lyMs2Zw
	 c2ECsjCO9kK0yQjbHsuTivCUmY5CzB+y8WMm16ujvXpq9EdIeJn1/bwJtEe0adavH4
	 CkTvK/mXAAlDWZ7e/FeJ1AZReGN21RPf4pmVn11UgM05EMsihqCrUozN9ycPc79aV1
	 OSzarCOsK6rR1GqemvfIYYVF71B5/qVpc0gywHRb7m1d85ypSLayYYnajmZANOisu0
	 Y2lgTZZCf8pyNYdo89wBoT2pHYI7X5M3kKJUJcwNSwCBHrAfCBy5bAhcVUvAVe4lrD
	 PuwgKuPScNrDg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 33/35] xfs: abort intent items when recovery intents fail
Date: Thu, 15 Feb 2024 13:08:45 +0100
Message-ID: <20240215120907.1542854-34-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: f8f9d952e42dd49ae534f61f2fa7ca0876cb9848

When recovering intents, we capture newly created intent items as part of
point, we forget to remove those newly created intent items from the AIL
and hang:

[root@localhost ~]# cat /proc/539/stack
[<0>] xfs_ail_push_all_sync+0x174/0x230
[<0>] xfs_unmount_flush_inodes+0x8d/0xd0
[<0>] xfs_mountfs+0x15f7/0x1e70
[<0>] xfs_fs_fill_super+0x10ec/0x1b20
[<0>] get_tree_bdev+0x3c8/0x730
[<0>] vfs_get_tree+0x89/0x2c0
[<0>] path_mount+0xecf/0x1800
[<0>] do_mount+0xf3/0x110
[<0>] __x64_sys_mount+0x154/0x1f0
[<0>] do_syscall_64+0x39/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

When newly created intent items fail to commit via transaction, intent
recovery hasn't created done items for these newly created intent items,
so the capture structure is the sole owner of the captured intent items.
We must release them explicitly or else they leak:

unreferenced object 0xffff888016719108 (size 432):
comm "mount", pid 529, jiffies 4294706839 (age 144.463s)
hex dump (first 32 bytes):
08 91 71 16 80 88 ff ff 08 91 71 16 80 88 ff ff  ..q.......q.....
18 91 71 16 80 88 ff ff 18 91 71 16 80 88 ff ff  ..q.......q.....
backtrace:
[<ffffffff8230c68f>] xfs_efi_init+0x18f/0x1d0
[<ffffffff8230c720>] xfs_extent_free_create_intent+0x50/0x150
[<ffffffff821b671a>] xfs_defer_create_intents+0x16a/0x340
[<ffffffff821bac3e>] xfs_defer_ops_capture_and_commit+0x8e/0xad0
[<ffffffff82322bb9>] xfs_cui_item_recover+0x819/0x980
[<ffffffff823289b6>] xlog_recover_process_intents+0x246/0xb70
[<ffffffff8233249a>] xlog_recover_finish+0x8a/0x9a0
[<ffffffff822eeafb>] xfs_log_mount_finish+0x2bb/0x4a0
[<ffffffff822c0f4f>] xfs_mountfs+0x14bf/0x1e70
[<ffffffff822d1f80>] xfs_fs_fill_super+0x10d0/0x1b20
[<ffffffff81a21fa2>] get_tree_bdev+0x3d2/0x6d0
[<ffffffff81a1ee09>] vfs_get_tree+0x89/0x2c0
[<ffffffff81a9f35f>] path_mount+0xecf/0x1800
[<ffffffff81a9fd83>] do_mount+0xf3/0x110
[<ffffffff81aa00e4>] __x64_sys_mount+0x154/0x1f0
[<ffffffff83968739>] do_syscall_64+0x39/0x80

Fix the problem above by abort intent items that don't have a done item
when recovery intents fail.

Fixes: e6fff81e4870 ("xfs: proper replay of deferred ops queued during log recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 5 +++--
 libxfs/xfs_defer.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 16060ef88..7ff125c5f 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -758,12 +758,13 @@ xfs_defer_ops_capture(
 
 /* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_ops_capture_free(
+xfs_defer_ops_capture_abort(
 	struct xfs_mount		*mp,
 	struct xfs_defer_capture	*dfc)
 {
 	unsigned short			i;
 
+	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
@@ -804,7 +805,7 @@ xfs_defer_ops_capture_and_commit(
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 		return error;
 	}
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 114a3a493..8788ad5f6 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -121,7 +121,7 @@ int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
 		struct list_head *capture_list);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
 		struct xfs_defer_resources *dres);
-void xfs_defer_ops_capture_free(struct xfs_mount *mp,
+void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
-- 
2.43.0

