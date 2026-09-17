Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF24BCADD
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 10:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641409; cv=none; b=c/n3Mp/LxMaZC5zv1NBSUlyNY6ogXA83aKAIvLS+QpwmLqQQ5Q0nvwlcdG+bHa6MZNb7t91lbRiZXLBRp1GBfDNjNtp6anNe9dK1LmGXx0UMut5FLUPIpA+U5BVB6+gTK7j92V+QKznZ2AFjQR8zEsT/pN5ZkgCJOsUyZSdoV68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641409; c=relaxed/simple;
	bh=DZXrG6vaiIExvej99xase7qXpn6yhhWHd9yZoeMSThA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmP1obmKMOpuazN2zzfRIG/SpQ1wb1xov+qnDiN0ijE/IIYDgeQMz/6Fmz5MWUC0ISKSlmDSS3sGkJAz4dJLOq2hIIk3oEcx/QgpPmze8nFCc7mlaWSSLMwkMF6VsrCejEkrFwBLoXNkIiHR2rzP8K0V57C9KZMs5+nexl20fsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9nhvhBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9nhvhBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9925E1F00893;
	Thu, 17 Sep 2026 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789641403;
	bh=tU4fowP2QW4ompJAKsQsbmFJ9/JFRP4gVCWE3/dsT8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9nhvhBubU0EMfJ8oqHb6Ly6oXzke2DxwnFCybqzuK4/gND0bUCA3dRgf3sTgP4Ls
	 w7w6AP+N4sbhbT/n6HMYQjYw6Mj9aGeIF120nHMBRI5V5KD1caEjxCZCJQCVkw+4zg
	 1QsRdkG0dEYzvaHZEdDvS6x5cF3QtvDpHM472LKszZh+0hun7DoBsCFag2QsJSQC3K
	 qVq9YkX7JwRbyWe07e9WFzwGqjcMeZqskSJ/JbmjIpJbSbZKQU8LlGcnQlv8CVuFDD
	 tEI8GqjRgWsy+iavYIUrx2DIJqa0CXNTPVvVHIoJ6eeLWWIeYaQ5MIFOtZdK7kOJKY
	 FWZqbjkROYTfg==
From: cem@kernel.org
To: cem@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/3] xfs: add xfs_error_report the ability to display an error code
Date: Thu, 17 Sep 2026 12:35:46 +0200
Message-ID: <20260917103633.14703-2-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917103633.14703-1-cem@kernel.org>
References: <20260917103633.14703-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Users could opt to request an error code to be printed now.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V3:
	- Remove stale description aboutt ERRNAME
V2:
	- Fix commit description s/_NAME/_ERRNAME
	- xfs_corruption_error should call xfs_error_report with
	  -EFSCORRUPTED
	- Modify xfs_error_report to only print out the error number if
	  it received an error from the caller.
	- Don't use errname() anymore.

 fs/xfs/xfs_error.c         | 16 +++++++++++-----
 fs/xfs/xfs_error.h         |  9 +++++----
 fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
 fs/xfs/xfs_inode_item.c    |  3 ++-
 fs/xfs/xfs_log_recover.c   |  3 ++-
 fs/xfs/xfs_trans.c         |  2 +-
 6 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9ece70fd94ca..c943717f1dd7 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -241,16 +241,21 @@ void
 xfs_error_report(
 	const char		*tag,
 	int			level,
+	int			error,
 	struct xfs_mount	*mp,
 	const char		*filename,
 	int			linenum,
 	xfs_failaddr_t		failaddr)
 {
 	if (level <= xfs_error_level) {
-		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
-		"Internal error %s at line %d of file %s.  Caller %pS",
-			    tag, linenum, filename, failaddr);
-
+		if (error)
+			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
+"Internal error %s (%d) at line %d of file %s.  Caller %pS",
+				tag, error, linenum, filename, failaddr);
+		else
+			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
+"Internal error %s at line %d of file %s.  Caller %pS",
+				tag, linenum, filename, failaddr);
 		xfs_stack_trace();
 	}
 }
@@ -268,7 +273,8 @@ xfs_corruption_error(
 {
 	if (buf && level <= xfs_error_level)
 		xfs_hex_dump(buf, bufsize);
-	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
+	xfs_error_report(tag, level, -EFSCORRUPTED, mp,
+			 filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 05fc1d1cf521..3c76d0dad51c 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -8,8 +8,9 @@
 
 struct xfs_mount;
 
-void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
-		const char *filename, int linenum, xfs_failaddr_t failaddr);
+void xfs_error_report(const char *tag, int level, int error,
+		struct xfs_mount *mp, const char *filename,
+		int linenum, xfs_failaddr_t failaddr);
 void xfs_corruption_error(const char *tag, int level, struct xfs_mount *mp,
 		const void *buf, size_t bufsize, const char *filename,
 		int linenum, xfs_failaddr_t failaddr);
@@ -20,8 +21,8 @@ void xfs_verifier_error(struct xfs_buf *bp, int error, xfs_failaddr_t failaddr);
 void xfs_inode_verifier_error(struct xfs_inode *ip, int error, const char *name,
 		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
 
-#define	XFS_ERROR_REPORT(e, lvl, mp)	\
-	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
+#define	XFS_ERROR_REPORT(e, lvl, error, mp)	\
+	xfs_error_report(e, lvl, error, mp, __FILE__, __LINE__, __return_address)
 #define	XFS_CORRUPTION_ERROR(e, lvl, mp, buf, bufsize)	\
 	xfs_corruption_error(e, lvl, mp, buf, bufsize, \
 			     __FILE__, __LINE__, __return_address)
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index dd5d92ca1010..9f499a80038c 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -573,13 +573,15 @@ xlog_recover_xmi_commit_pass2(
 
 	len = sizeof(struct xfs_xmi_log_format);
 	if (item->ri_buf[0].iov_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+				 -EFSCORRUPTED, log->l_mp);
 		return -EFSCORRUPTED;
 	}
 
 	xmi_formatp = item->ri_buf[0].iov_base;
 	if (xmi_formatp->__pad != 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+				 -EFSCORRUPTED, log->l_mp);
 		return -EFSCORRUPTED;
 	}
 
@@ -614,7 +616,8 @@ xlog_recover_xmd_commit_pass2(
 
 	xmd_formatp = item->ri_buf[0].iov_base;
 	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+				 -EFSCORRUPTED, log->l_mp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 99d6ecccdaa7..a29c90f0650f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1229,7 +1229,8 @@ xfs_inode_item_format_convert(
 	struct xfs_inode_log_format_32	*in_f32 = buf->iov_base;
 
 	if (buf->iov_len != sizeof(*in_f32)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+				 -EFSCORRUPTED, NULL);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cf0d610265fe..457617979668 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2948,7 +2948,8 @@ xlog_recover_process(
 		 * fatal log corruption failure.
 		 */
 		if (xfs_has_crc(log->l_mp)) {
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					 -EFSCORRUPTED, log->l_mp);
 			return -EFSCORRUPTED;
 		}
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1b36cf12d4e3..5c522790e5be 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -971,7 +971,7 @@ xfs_trans_cancel(
 	 * here.
 	 */
 	if (dirty && !xfs_is_shutdown(mp)) {
-		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
+		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
-- 
2.55.0

