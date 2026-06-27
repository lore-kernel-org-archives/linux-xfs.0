Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C48023395E;
	Sat, 27 Jun 2026 06:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782540556; cv=none; b=saglSWzpx18H94yHmRzW/jlNoDxfkN0FTjgzip3OeSTjxYVPA0lB40fEbUSgrPq+WAjzCrTcv2Um+fbrMwQDAdomM+WDbuIlx5lkn28ZvKLjNZvA+B/H20yU0Wt+mRoIR57PkqvDuKRq9DV+nAEUt5+hohnPlCPgrdloysltIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782540556; c=relaxed/simple;
	bh=L/h3eCvaNijmhaUKvmpTZ1EZPQCHHRoyEFg9LgQKLKw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nbjv8muqunk+Nx+U/UVU0tUczhS2FRn5mK8rrhStGpZ4ffbMDhHZBkE9HbN6QZmEHU/MZwrIS0TudTUfHis5JA6KiGn6Yfw0FSaw8uchqFDIykSY0U1MMzWk3ym2tnGJfCuDIMRXBPTC28t0NEUNP1IUifZKDU2izwuj9vCl5y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=RyJ4+vXr; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="RyJ4+vXr"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 43fb57368;
	Sat, 27 Jun 2026 14:04:02 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	zilin@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>
Subject: [PATCH] xfs: fix memory leak in xfs_dqinode_metadir_create()
Date: Sat, 27 Jun 2026 14:04:02 +0800
Message-Id: <20260627060402.2544349-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f07ad8ee603a2kunm966b7559ec02b
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGBlIVhkaHUpOHRodHk1NTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=RyJ4+vXrUVgBRukD0kTL9T4N8H/Hb+UUoya8/kKguj1dPjJUa2EW2Rz8urr1jGAukU41OViNCcc98O412Ia+pZAL8d1IsUX6Yxd5k0bzAxG7U2MWH7ZF7HS2afJquDSICVk2TctqmGRaRj4DhQSVfAWpTA1FtW1kKXPFrGzF+os=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=sBwTUtwOKbOC/YM1jzeYDlqTozkaxam0O+Ww/vzscmk=;
	h=date:mime-version:subject:message-id:from;

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
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 fs/xfs/libxfs/xfs_dquot_buf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index ce767b40482f..bbada0d3cc08 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -436,17 +436,27 @@ xfs_dqinode_metadir_create(
 
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
2.34.1

