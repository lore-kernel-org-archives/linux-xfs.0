Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE6556B81
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879288; cv=none; b=ktHVvKDMDUm29ThG6/pd+bUccuO7174MBV0TR3A8eSgmDxIXdVg4HjfdW1eumN7MnKSz4YpdQ8QNBmatiCBgwCpxA4hnAlR3taHwPtqS6QEca6/wkDFZ88R4qzvmK+wLg0dRN33BLkEBgoyELJ5o7WpshFBNkFNp61yZ3jg7LoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879288; c=relaxed/simple;
	bh=vAR64SGRIHINCTTnix9Gr/SidXFgOEX/roDnN4XBQlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGYh0J6AVNo7onj5WNEyf54oxZTK76AxqbpTdG1AAJPLZHdH+5ZfE2cgQtskINM+xMq8/Is5dl1MDpNLEwDGFyYmngrUzZfuCFiRSOAOvDYltSAnhGGJ9+EzyfUqXfnr8uXPslK3+ozjhZsQgBuRF13GZh5okxqjMx+vQEBnux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjs4LOML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjs4LOML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BC51F00AC4;
	Tue,  8 Sep 2026 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788879273;
	bh=5HjtX4CTvN0Dm0oZBP6NCKFt9ypqgUFmS/RInv6LgLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjs4LOMLyhwg5hQUeM2//um4C95kCcOXI97e5nuPvU3RDZRTFFRnkRRPWSfV+V0Za
	 H9yOy3nIqQpCvzmYuh+7Y3LY+i7ehttivDev2G7IPzMng5eNoSm34JBHQnOacIYpaJ
	 t1X0ViGv6gAoTwQDkDKEqWZP76n2Y56uiKF6iMgS9CgH+LXvbUxdyyIUR/aDeXCjyJ
	 bxtrTgr52WJXizOQp9E0WBbkQ664x2qgV/JqlTzA6+3cvIMFWAhLTkqFY3ZY5gui+R
	 pXqw/zLPQBc9rEyYAmKtM4/+7IMZ4CczbQcmTE/wIHvHAWrplyQamQ012mTGyt84Qi
	 UnGP8darYM4JQ==
From: cem@kernel.org
To: cem@kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: enable xfs_trans_cancel() to report and error code
Date: Tue,  8 Sep 2026 16:54:15 +0200
Message-ID: <20260908145422.232985-3-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908145422.232985-1-cem@kernel.org>
References: <20260908145422.232985-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Once in a while it's useful to know exactly what kind of error caused a
transaction to be cancelled.
Enable xfs_trans_cancel() to receive an error code to be reported.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_trans.c | 8 +++++---
 fs/xfs/xfs_trans.h | 6 +++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 792a67a7ec28..5bbbb9226864 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -971,8 +971,9 @@ xfs_trans_commit(
  * xfs_trans_commit().
  */
 void
-xfs_trans_cancel(
-	struct xfs_trans	*tp)
+__xfs_trans_cancel(
+	struct xfs_trans	*tp,
+	int			error)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xlog		*log = mp->m_log;
@@ -999,7 +1000,8 @@ xfs_trans_cancel(
 	 * here.
 	 */
 	if (dirty && !xfs_is_shutdown(mp)) {
-		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
+		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
+				 error, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2b366851e9a4..30135152d043 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -213,6 +213,11 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+void __xfs_trans_cancel(xfs_trans_t *, int);
+
+#define xfs_trans_cancel(tp) __xfs_trans_cancel(tp, 0)
+#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel(tp, error)
+
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
@@ -237,7 +242,6 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
-void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
-- 
2.55.0

