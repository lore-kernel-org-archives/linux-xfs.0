Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D04BC8F0;
	Sun,  1 Mar 2026 01:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328218; cv=none; b=gPuXyVLt1forPdTtCUr91kqbj/QCUnH/rb3HnL63fiNENgnY+50K3xJrffkOFwOIDEEFskATnHCtJCtqG53bjojHXjWhxAy0vZdrIMrvILsluoU0EwwIIzP327xPo6vUFRKQgrg3xEGyOkMgPyxCpw5Q2rcHfaeSNQNIPMD1CzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328218; c=relaxed/simple;
	bh=V+Hio7RgjLJ59j/LAZ5NxGw19FHqfZ0Zr6NsTbFr/D8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=utzwDLh/tkqogzmgRn0q/1dDLOIkSBLtQkjHXaP1V8kMVcUwZnCLxt06c2vZNV4Xhiz9EuL8c+m1fEHpbROZEI0MPWd171cIiEOqEh5aUXKUyi8viL6FnJI5xSE76rtzvHIzZIiuNhKrmLVjvOrbglJNU6lUnX5YgHilFi+QGtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FL2LEGa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FL2LEGa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A02C19421;
	Sun,  1 Mar 2026 01:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328217;
	bh=V+Hio7RgjLJ59j/LAZ5NxGw19FHqfZ0Zr6NsTbFr/D8=;
	h=From:To:Cc:Subject:Date:From;
	b=FL2LEGa8BhNQwtwcz8sbtLNjyC2dm8HTVb4cmaQmhS7/Q1JQ/yA7MMYAqShTzXlfC
	 v5z28OYTP5fz/x165SlaIb9G5oiNLCoUtW7U/nF/M1S86XpJT+PLnaFxwBFxhCdg0r
	 SUIWFP2oPgjRnKhJgzhZQvHHOpKxJAjA3X7f5na0iGoDz59/68JzZ7ZSCvU44hFIXd
	 vmbZok6VBDpea0Id9Ef7LNYYNOdIvWp9CrjBMrN8rdba60+njJoE4QGO3pICbliMDK
	 fUmy+RS0bP1vVTcSjvhtPwzYv0KXzPjhbFNrCVL6pEUoZsI8Zb5fRTKUI/mJLFENUF
	 yJnHNrHWEEawQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: r772577952@gmail.com,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: check for deleted cursors when revalidating two btrees" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:35 -0500
Message-ID: <20260301012336.1680350-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 55e03b8cbe2783ec9acfb88e8adb946ed504e117 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:40 -0800
Subject: [PATCH] xfs: check for deleted cursors when revalidating two btrees

The free space and inode btree repair functions will rebuild both btrees
at the same time, after which it needs to evaluate both btrees to
confirm that the corruptions are gone.

However, Jiaming Zhang ran syzbot and produced a crash in the second
xchk_allocbt call.  His root-cause analysis is as follows (with minor
corrections):

 In xrep_revalidate_allocbt(), xchk_allocbt() is called twice (first
 for BNOBT, second for CNTBT). The cause of this issue is that the
 first call nullified the cursor required by the second call.

 Let's first enter xrep_revalidate_allocbt() via following call chain:

 xfs_file_ioctl() ->
 xfs_ioc_scrubv_metadata() ->
 xfs_scrub_metadata() ->
 `sc->ops->repair_eval(sc)` ->
 xrep_revalidate_allocbt()

 xchk_allocbt() is called twice in this function. In the first call:

 /* Note that sc->sm->sm_type is XFS_SCRUB_TYPE_BNOPT now */
 xchk_allocbt() ->
 xchk_btree() ->
 `bs->scrub_rec(bs, recp)` ->
 xchk_allocbt_rec() ->
 xchk_allocbt_xref() ->
 xchk_allocbt_xref_other()

 since sm_type is XFS_SCRUB_TYPE_BNOBT, pur is set to &sc->sa.cnt_cur.
 Kernel called xfs_alloc_get_rec() and returned -EFSCORRUPTED. Call
 chain:

 xfs_alloc_get_rec() ->
 xfs_btree_get_rec() ->
 xfs_btree_check_block() ->
 (XFS_IS_CORRUPT || XFS_TEST_ERROR), the former is false and the latter
 is true, return -EFSCORRUPTED. This should be caused by
 ioctl$XFS_IOC_ERROR_INJECTION I guess.

 Back to xchk_allocbt_xref_other(), after receiving -EFSCORRUPTED from
 xfs_alloc_get_rec(), kernel called xchk_should_check_xref(). In this
 function, *curpp (points to sc->sa.cnt_cur) is nullified.

 Back to xrep_revalidate_allocbt(), since sc->sa.cnt_cur has been
 nullified, it then triggered null-ptr-deref via xchk_allocbt() (second
 call) -> xchk_btree().

So.  The bnobt revalidation failed on a cross-reference attempt, so we
deleted the cntbt cursor, and then crashed when we tried to revalidate
the cntbt.  Therefore, check for a null cntbt cursor before that
revalidation, and mark the repair incomplete.  Also we can ignore the
second tree entirely if the first tree was rebuilt but is already
corrupt.

Apply the same fix to xrep_revalidate_iallocbt because it has the same
problem.

Cc: r772577952@gmail.com
Link: https://lore.kernel.org/linux-xfs/CANypQFYU5rRPkTy=iG5m1Lp4RWasSgrHXAh3p8YJojxV0X15dQ@mail.gmail.com/T/#m520c7835fad637eccf843c7936c200589427cc7e
Cc: <stable@vger.kernel.org> # v6.8
Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/xfs/scrub/alloc_repair.c  | 15 +++++++++++++++
 fs/xfs/scrub/ialloc_repair.c | 20 +++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index f9a9b43271897..5b4c2a39a1558 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -923,7 +923,22 @@ xrep_revalidate_allocbt(
 	if (error)
 		goto out;
 
+	/*
+	 * If the bnobt is still corrupt, we've failed to repair the filesystem
+	 * and should just bail out.
+	 *
+	 * If the bnobt fails cross-examination with the cntbt, the scan will
+	 * free the cntbt cursor, so we need to mark the repair incomplete
+	 * and avoid walking off the end of the NULL cntbt cursor.
+	 */
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	sc->sm->sm_type = XFS_SCRUB_TYPE_CNTBT;
+	if (!sc->sa.cnt_cur) {
+		xchk_set_incomplete(sc);
+		goto out;
+	}
 	error = xchk_allocbt(sc);
 out:
 	sc->sm->sm_type = old_type;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index d206054c1ae3b..9b63b9d19e1b6 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -863,10 +863,24 @@ xrep_revalidate_iallocbt(
 	if (error)
 		goto out;
 
-	if (xfs_has_finobt(sc->mp)) {
-		sc->sm->sm_type = XFS_SCRUB_TYPE_FINOBT;
-		error = xchk_iallocbt(sc);
+	/*
+	 * If the inobt is still corrupt, we've failed to repair the filesystem
+	 * and should just bail out.
+	 *
+	 * If the inobt fails cross-examination with the finobt, the scan will
+	 * free the finobt cursor, so we need to mark the repair incomplete
+	 * and avoid walking off the end of the NULL finobt cursor.
+	 */
+	if (!xfs_has_finobt(sc->mp) ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		goto out;
+
+	sc->sm->sm_type = XFS_SCRUB_TYPE_FINOBT;
+	if (!sc->sa.fino_cur) {
+		xchk_set_incomplete(sc);
+		goto out;
 	}
+	error = xchk_iallocbt(sc);
 
 out:
 	sc->sm->sm_type = old_type;
-- 
2.51.0




