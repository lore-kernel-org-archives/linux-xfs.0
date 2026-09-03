Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78B943B6F5
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435722; cv=none; b=LIzpAzlqP2psVjqxzGd8Q85xfLv4LHg7UF2/l6WFCX/F7TvBLxXRLsDDfFatkG5/uVMoTZoYaQMgR8KvIBCs5O+yRUOKuNlxC9twGtt8Sz+GBjSlqWOQ5CuSInKOeAKVsnVhtgCWTSFu09tiXB7+RDIGYYQ5zBFUnJvbxd7NcIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435722; c=relaxed/simple;
	bh=bxMZEbfuqLEVQiJsR7u14cMdN/fm0G7jCAPMwHmk84Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEuhtO5r3qpfJlAB0txdkWm+0UEtFJTqZOqjqerYQvm04MaMJ/rgM4zy4hmrPdj3Pk5p2JUGf5AfMCnBVnYuHDT+17LrCTM46DZV2IaOk6iS2WT2C9TzVULZ2gdl9pWGkhpbY1jdXPkSib6XcnXWxUsqnRK9Z+ZTKExtg4CDmE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEXACPA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEXACPA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80A51F00A3F;
	Thu,  3 Sep 2026 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435711;
	bh=9QEt/00h2qRvp7HjoN1u4az4fzd3/qsBky+Y0gPJeLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEXACPA2AL768LtyUGIWCwwQ4fwP+nSPUznUjKVrj/8/BjjyS3T/q3smpJRD7LXqw
	 mTciPAqfcBzXiXuKPeKnFErqitI78SbMFLOrSM+eLoqJF4A+IUUosogBLElwPdCI1f
	 0ekz5d3F3SCvhsYMWu+XOCdbuBnSzHFIXiwjdeC9FotB//AOZhPbVpWrcjEtY4A/Jv
	 N6eoCDU8Mk6ivJduqMPbyZSWX1dl3GDTBVp/b9zrQQQ26jYatn16XsVyXS8XsnOKsj
	 nJjhPsYif1+Z9Ig7FGrT4a+vkWDGMUsGwATix9/nlcl6B0vpznhY0eYqJDoyt786Fb
	 X9DDkWpG2pjzQ==
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
Subject: [PATCH v2 19/23] xfs: fix memory leak in xfs_dqinode_metadir_create()
Date: Thu,  3 Sep 2026 13:40:01 +0200
Message-ID: <20260903114022.570210-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
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

