Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FF82D781B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871342; cv=none; b=r4jCM3WXWWzm3VD/nLGDG8i/fX8tKLSGif/do+ekKjODdJTo3fTNNbcFaGnCWhhcORTkFJAR2K4dxAsEBCUe2XHFoUEvKk8SvEwCstxMR1H/CqPupMTlgttqWDkYRkJAzRhopywVfsXyy06/NPcNJrTZIa0dgoCJuW/rbKl7lMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871342; c=relaxed/simple;
	bh=dSbptXX7cAnBn2WLQLSOKQrAL4aWMPb6fMINVyJydUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaiyCQjt/kKTPeT9QV4WZZKxyDdOtL3DK4GxifhJnXJHZPmzW5vX4KLxsao+JIDlJ59UVqBGBQtrPcw/0w22ZLB54/qwYoM3BEbXGbSroZEzwhORS/qVcmSW/9B5S/zx+XthFJgfwI0NSYR1wvr+SUjXFyZ7TVfaeCg/HGlS54s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmBwTK+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmBwTK+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B15C1F00898;
	Tue, 13 Oct 2026 06:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871340;
	bh=cBf4N/0JRzU/lXLoQPGdhacR2gknMr3kJHC0Ppun+gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmBwTK+OJaEEeUNm6VUt52Cp62YpnndJYTbQUgk0hi5IBhDCpzrfThGzU1JUkKSXS
	 m+rAlWRB6KBHO74Xfu4zx6jZS8q+47JE9xbe8Bq9gjVYvw25wQU95wRtPwLY8srIjW
	 OJmOUuXRzAedHhxgxmkFDWedjGfYmfC4qTSOivaGz7ZEPeyMzmLAXTl74G4HYKKtk5
	 t9uT5zvKIekKysjPNABPOoDuaaohpw8PCiVfy6IlLVkteYpLeIv8GSDcBfeEctK+ez
	 rjPFGV8H7JnxFDdZ00tURCBE4JqvE9PC+forKRAPPMX4WG0oNkC4+jh4BDTwiwLh3P
	 NuCc85MUPQcrA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 09/48] xfs: factor out xlog_recover_validate_ophdr()
Date: Tue, 13 Oct 2026 17:00:59 +1100
Message-ID: <20261013060204.3138690-10-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor the existing operation header checks out of
xlog_recover_process_ophdr() into a dedicated helper to centralise ophdr
validation. Later patches add validation of the remaining ophdr fields here.
The ASSERT(0) and WARN_ON(1) are dropped as they add nothing over the logged
message and returned error, and they fire on expected corrupt input.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 55 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f2c814f1e78e..1e0b8f2affe3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2638,39 +2638,56 @@ xlog_recover_ophdr_to_trans(
 	return NULL;
 }
 
+/*
+ * Validate an operation header decoded from the journal before it is used to
+ * drive transaction recovery. The ophdr and its data region come straight from
+ * the on-disk log and cannot be trusted, so check the fields for known values
+ * and obvious corruption here, in one place, before anything acts on them.
+ */
 STATIC int
-xlog_recover_process_ophdr(
+xlog_recover_validate_ophdr(
 	struct xlog		*log,
-	struct hlist_head	rhash[],
-	struct xlog_rec_header	*rhead,
 	struct xlog_op_header	*ohead,
 	char			*dp,
-	char			*end,
-	int			pass,
-	struct list_head	*buffer_list)
+	char			*end)
 {
-	struct xlog_recover	*trans;
-	unsigned int		len;
-	int			error;
+	unsigned int		len = be32_to_cpu(ohead->oh_len);
+
+	/* Check the ophdr contains all the data it is supposed to contain. */
+	if (dp + len > end) {
+		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
+		return -EFSCORRUPTED;
+	}
 
 	/* Do we understand who wrote this op? */
 	if (ohead->oh_clientid != XFS_TRANSACTION &&
 	    ohead->oh_clientid != XFS_LOG) {
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
-		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 
-	/*
-	 * Check the ophdr contains all the data it is supposed to contain.
-	 */
-	len = be32_to_cpu(ohead->oh_len);
-	if (dp + len > end) {
-		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
-		WARN_ON(1);
-		return -EFSCORRUPTED;
-	}
+	return 0;
+}
+
+STATIC int
+xlog_recover_process_ophdr(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead,
+	char			*dp,
+	char			*end,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	struct xlog_recover	*trans;
+	unsigned int		len = be32_to_cpu(ohead->oh_len);
+	int			error;
+
+	error = xlog_recover_validate_ophdr(log, ohead, dp, end);
+	if (error)
+		return error;
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
 	if (!trans) {
-- 
2.55.0

