Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6057E494A1B
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435715; cv=none; b=ThsnLW0LzlSm6yqtY7MPMQspzb0pYoalF96ZgZVzFPTq0Dgm+ODubqqsFPJixDHr1oXlgl4MaLlV0aIcRRC3rmC5NTNVgfPn1d3s58S8icSFB3tcYK65zhKrl7QrorqjastcNuAw9o4HrXzdNXXJNGJXNxG4EyU3wIgOIwHOsvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435715; c=relaxed/simple;
	bh=BqeiBT19locunjL13E9JL1IZs7qUXDEbQINDAxKhZDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrQKUs0AznGbouIf/Tyh/gi5Bh4mZBxFLQPngRoxEZAnH1ZjxCh9Eb5kwQsLgWx3UYgIhy4iZjNcUohBiO1tu5mQ7DaxaKxvj/kv33xh0Nepf6yoSY/q10PoYvGMJVRwJJoe60Y6JNLdddLustmecDHw3txJx3ng5g3i29eMZo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSNzmzLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSNzmzLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3461F00A3D;
	Thu,  3 Sep 2026 11:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435708;
	bh=GPBdcTAtpQzASM8PLpeezWRkC1ccp1B3+Q2lb23wM20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSNzmzLwS27+e0vNC4ZLbycggIUatTZHcILbZfinvJVnG5+GsD9WUZWugen9SnGz4
	 PUawWLz8y75ka3aj6TZtlXQgjA+k4oiNNM/ESl1M4hjEa4Hy7YBypoKODBkXgOY/PU
	 Z+UBuDwAteA0vvjB/vqcjAYrCQ5ZVqIpgvoqrGoDuOWQqyi8jNKmFtLgSlGvgHWmHt
	 azRtpliQwez1XBFsFZ1CWzhKIWYK/rmdD9gWh08L7spJPhHBI6TRAZeL5yoTLBbBQf
	 OTGD9B3ocp3A6fCPrOAS3J8Wdf61sTolv2Pu03dkaINP6q4pekGbLkBSRp3aTMNAKj
	 BLVuwWn1glH0g==
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
Subject: [PATCH v2 18/23] xfs: move XFS_LSN_CMP to xfs_log_format.h
Date: Thu,  3 Sep 2026 13:40:00 +0200
Message-ID: <20260903114022.570210-19-aalbersh@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 202ff980a464198616e53e85e5276e68c00a1031

Because CYCLE_LSN/BLOCK_LSN are defined in xfs_log_format.h, XFS_LSN_CMP
forces a xfs_log_format.h dependency in xfs_log.h.  Move XFS_LSN_CMP
to xfs_log_format.h and drop the macro/inline indirection to clean up
our header mess a little bit.

This also helps xfsprogs, which doesn't have xfs_log.h, but needs
XFS_LSN_CMP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h     | 18 ------------------
 libxfs/xfs_log_format.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d4b546a0e3d0..9102bc6f5b27 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -164,22 +164,4 @@ libxfs_trans_read_buf(
 #define xfs_ail_get_push_target(ail)    \
 		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
 
-/* from xfs_log.h */
-/*
- * By comparing each component, we don't have to worry about extra
- * endian issues in treating two 32 bit numbers as one 64 bit number
- */
-static inline xfs_lsn_t _lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
-{
-	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
-		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
-
-	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
-		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
-
-	return 0;
-}
-
-#define XFS_LSN_CMP(a, b)			_lsn_cmp(a, b)
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3f5a24dda907..a4e1b3eb425c 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -52,6 +52,19 @@ typedef uint32_t xlog_tid_t;
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
+/*
+ * By comparing each component, we don't have to worry about extra endian issues
+ * in treating two 32 bit numbers as one 64 bit number
+ */
+static inline xfs_lsn_t XFS_LSN_CMP(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
+{
+	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
+		return CYCLE_LSN(lsn1) < CYCLE_LSN(lsn2) ? -999 : 999;
+	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
+		return BLOCK_LSN(lsn1) < BLOCK_LSN(lsn2) ? -999 : 999;
+	return 0;
+}
+
 /* this is used in a spot where we might otherwise double-endian-flip */
 #define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
 
-- 
2.55.0

