Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5B4071F3
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521566; cv=none; b=WfaLl7VlqMZpWvriUh1zEBg9gdQGnK+gicmOIrLvPK6q2xK5GpOPezDedaJvIkdJGYmXEmx7em6Uq2h/yETLAiroKZhOVnmkPDmEIjpY0Fqld4W51M7bEUf/LIPZTkmC5dzaPwbWVV/XagAeIcnnVFDI7SYBdsDfVi9EYjriF3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521566; c=relaxed/simple;
	bh=M7PdjDfcNwZNbcF+tSvmSHQnC9CCTss3LY49pf7WJAk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlmO8xiI3sl8zMmh4gZoJb/iC/xJn3Htgc5pSTDl5VNrQqmkBY7ZYHKWoIWkRxusv28YPH7pMtfbGD2cfJoLzsrSQDPQOvwZUtPfMPGIpVrDwBu5k2lr0wgtpvHSrvVw7Ec+qT0n/cfeGEjwer20mdPP9+i16SzSgsGPLRaseUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hi0CTxTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hi0CTxTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E041F00A3F
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521564;
	bh=5zW3ypeb6HDbdvtXIWje6F8EGLhYSQflm4WJZ1leydY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hi0CTxTDO8/gOuKcp4EBBS585Uz5ATqk4DhkFlGOIBAWpFtf8iVYtroZ1JimT+uK6
	 oaGkC5/u/z3lblzEPVXpyR07BU3jKMKHkjqfFhEmFy6oYnPFMCTbVjnP92wUsjAti8
	 gmZsc2uXMri++Y3laHBXGc+XHmdxOZH9ZqzNnv0ddUCirytvOiHq8r7VZu+61Zndk/
	 EQdPJ9hj8VypdGgSRk79z+x66yBfHXpdsPWjBIaDjUHVc82R6yBlx/4qldjNXiRIs9
	 0L1aHyA/pe7GAMPTiV3UO43VzayVKE7YpPqjQdxmOoaQPVjeEmVxv08GCIglSY8AFA
	 Lu5rzTlfpNSsA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH 2/3] xfs: enable xfs_trans_cancel() to report and error code
Date: Fri,  4 Sep 2026 13:32:22 +0200
Message-ID: <20260904113231.1408890-3-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904113231.1408890-1-cem@kernel.org>
References: <20260904113231.1408890-1-cem@kernel.org>
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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/xfs_trans.c | 12 +++++++++---
 fs/xfs/xfs_trans.h |  8 +++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c6657072361a..f6004590565b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -971,12 +971,18 @@ xfs_trans_commit(
  * xfs_trans_commit().
  */
 void
-xfs_trans_cancel(
-	struct xfs_trans	*tp)
+_xfs_trans_cancel(
+	struct xfs_trans	*tp, ...)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xlog		*log = mp->m_log;
 	bool			dirty = (tp->t_flags & XFS_TRANS_DIRTY);
+	int			error = 0;
+	va_list			args;
+
+	va_start(args, tp);
+	error = va_arg(args, int);
+	va_end(args);
 
 	trace_xfs_trans_cancel(tp, _RET_IP_);
 
@@ -999,7 +1005,7 @@ xfs_trans_cancel(
 	 * here.
 	 */
 	if (dirty && !xfs_is_shutdown(mp)) {
-		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
+		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, error, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2b366851e9a4..05cc7464eb3b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -213,6 +213,13 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+void _xfs_trans_cancel(xfs_trans_t *, ...);
+
+#define xfs_trans_cancel(tp, ...)		\
+({						\
+	_xfs_trans_cancel(tp, ##__VA_ARGS__);	\
+})
+
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
@@ -237,7 +244,6 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
-void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
-- 
2.55.0

