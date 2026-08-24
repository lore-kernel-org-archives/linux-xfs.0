Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD823A6F10
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572014; cv=none; b=YA78Nbkgt0HvPk7QGQ47eM+ZFRAkx+V2QI7naNDG2pWns8t64tKBpu1qVMwEBt6OIrh0bK0eYArrCf4b+wUng5ooGMJUg5W8pt+blBIosBjsBTWwbm7xURZ0YXAwTReadf+EdY5X28W6GV1GWKJK9fI/mWdEQjKfKk/H8zvi4vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572014; c=relaxed/simple;
	bh=bxMZEbfuqLEVQiJsR7u14cMdN/fm0G7jCAPMwHmk84Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r11Q/AgR2cHN7vp+U0aGm+zuw+Qvj6BCxgSZXrnDmWz7jcRKa0j51jQDLXnKy0wbNEzEGqs2SWIFuh7pZ8u0awU4j0eYCMtMP422xHmBwi+Za08+YNPHkN/1Kv8hhxjgKY3pkAN9gfmHy+oo9JrPCF5PrcZWyombvxRgPRxrIZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ztx2GPA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ztx2GPA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21A81F000E9;
	Mon, 24 Aug 2026 11:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572013;
	bh=9QEt/00h2qRvp7HjoN1u4az4fzd3/qsBky+Y0gPJeLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ztx2GPA1W8LjVuFOoO9dS+lMwvZWQEUyv/FW1S1WievTRiTodbezHyOZYcjhopSM6
	 11VG0TbzJgAfekKO1XcnXfUwEpgw1ZjhrTaIJc0GAG3FbdWyIWh0uzuX3SCGkpKzUW
	 gISAvby5R6PoaEWYTRfI1sH5xkny9xx+v09a1thB7/EHDwaI4+L8u1UWHMtzYI675d
	 Bh0c6Auf7R0R7ohlR74zZAfnKgZNlzU8PSrGDz6gT2ZlFH0m2Atcb2Jy9ayzRl1+Uj
	 PxLqTRitgNpTf8trGq4BGz52xTDLm7E8HKLH6/ukFrA07xEVBQqb7J0P3CWetWZeBp
	 RbTJY+WqM0kLA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 17/21] xfs: fix memory leak in xfs_dqinode_metadir_create()
Date: Mon, 24 Aug 2026 12:40:15 +0200
Message-ID: <20260824104022.420566-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dawei Feng <dawei.feng@seu.edu.cn>

Source kernel commit: 45de375b25060edf46e20abb36521ba530336ceb

If xfs_metadir_create() fails in xfs_dqinode_metadir_create(), the current
code returns directly, leaking the allocated update and transaction state.
If the subsequent commit fails, the caller-owned inode reference is left
behind.

Fix this memory leak by routing the create failure path through
xfs_metadir_cancel().  For both create and commit failures, finish and
release any inode returned to the caller, mirroring the unwind pattern in
xfs_metadir_mkdir().

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. Runtime validation
used kprobe fault injection during `mount -o uquota` on a metadir XFS
image. Injecting xfs_metadir_create() reproduced the old active-update path
that left mount stuck later in mount setup; after this change, the same
injection reported cancel_hits=1 and irele_hits=1. Injecting
xfs_metadir_commit() exercised the old inode-reference leak path; after
this change, it reported irele_hits=1.

Fixes: e80fbe1ad8ef ("xfs: use metadir for quota inodes")
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dquot_buf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 329aceca005d..5022073e0c4a 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -434,17 +434,27 @@ xfs_dqinode_metadir_create(
 
 	error = xfs_metadir_create(&upd, S_IFREG);
 	if (error)
-		return error;
+		goto out_cancel;
 
 	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
 
 	error = xfs_metadir_commit(&upd);
 	if (error)
-		return error;
+		goto out_irele;
 
 	xfs_finish_inode_setup(upd.ip);
 	*ipp = upd.ip;
 	return 0;
+
+out_cancel:
+	xfs_metadir_cancel(&upd, error);
+out_irele:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (upd.ip) {
+		xfs_finish_inode_setup(upd.ip);
+		xfs_irele(upd.ip);
+	}
+	return error;
 }
 
 #ifndef __KERNEL__
-- 
2.55.0

