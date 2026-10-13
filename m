Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3755C472094
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871348; cv=none; b=uXQjFGuVtIrKsdVgfbloF/UvkaMGW2amc9TJFjyFyLNPOlbkzz986qqgOLfnAruzcbnleQ7mOXrruIeOP+yUuYTUM/w2XuxWiZN1XBL4iDMLOqhTAsYdNb6Lwg3GVFjf/Yqi50qt99gakJ+phpd/O7IU27Js98VlGMzsoiAI47o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871348; c=relaxed/simple;
	bh=/C8HlYq7pt0BmfI5H2SXu2CjH4DImtT4Zt8N3+KPpX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY3GDVQAiuZtXQso76I+h545mownwzJZqZevmWb2OAicB+HSpCv1x6hXblohOXnce12kWBINwZARlZ1VNQCMNTnjhuNmAokuhGZDfBso9R1h4aP1ZQQ4C1Fph+qU/KRqPpOfS7RUCBYGctiiZtFZ3syFmjVpY0lOj1/FTtJZUWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTig8oQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTig8oQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA311F000FF;
	Tue, 13 Oct 2026 06:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871347;
	bh=5oAnZ4Y7BnnqcvjVQIWEO4/Xvt1qBF0d5A79h89BeNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTig8oQERHY7w39MYJio/ng7jS2XyOAB3QpSY2E2QZOldZ9C6ZuTr4Qc1/Rui2tSC
	 IamAw9SWgXhsldwj9WkSA4Y4aP4UKRinkKwRdIXhQE439xYhROAwUQlCyixLngQe+G
	 K1CYrWA4kERT5AgnZyUvEuQH0tJjoY4IxMyMtvk9Gf2fMl/JrL/MPYSfD2anJwyAxT
	 WvH8eKCfhPkZGH8sMt84idRqJy4/NTQhfMH5rarAn+8hkq0Bmt7TxicmPvl36mm8K8
	 6LruiLej6dv03xPsVjZngtIDKS5KWP9IKYOroo5CCknrV5AJsGhZMkweAeFoUq0DvZ
	 7rcLkLKc3eHnw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 14/48] xfs: validate the unmount record during recovery
Date: Tue, 13 Oct 2026 17:01:04 +1100
Message-ID: <20261013060204.3138690-15-dgc@kernel.org>
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

The unmount record is the only record the log writes itself rather than
through a transaction, and the log item processing loop skips it, so its
contents were never validated on recovery even though a clean unmount is
detected by inspecting it during the head and tail scan.

Add xlog_recover_validate_unmount_record() to check the record is written by
the log, is the expected length, and carries the expected magic and zeroed
padding. Call it from the operation header validation, and route the head and
tail scan through the operation header validation as well so a corrupt
unmount record is detected there rather than being mistaken for a clean
unmount.

The unmount record length was incorrectly written as zero for a period of time.
A zero length record has no payload to check, so accept it with a warning so
that filesystems written by those kernels still recover.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 70 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ba3f4409d28..37b5dbc3b239 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -42,6 +42,8 @@ xlog_clear_stale_blocks(
 STATIC int
 xlog_do_recovery_pass(
         struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
+STATIC struct xlog_op_header *
+xlog_recover_validate_ophdr(struct xlog *log, char *dp, char *end);
 
 /*
  * Sector aligned buffer routines for buffer create/read/write/access
@@ -1169,8 +1171,11 @@ xlog_check_unmount_rec(
 		if (error)
 			return error;
 
-		op_head = (struct xlog_op_header *)offset;
-		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
+		op_head = xlog_recover_validate_ophdr(log, offset,
+				offset + BBSIZE);
+		if (IS_ERR(op_head))
+			return PTR_ERR(op_head);
+		if (op_head->oh_flags == XLOG_UNMOUNT_TRANS) {
 			/*
 			 * Set tail and last sync so that newly written log
 			 * records will point recovery to after the current
@@ -2636,6 +2641,60 @@ xlog_recover_ophdr_to_trans(
 	return NULL;
 }
 
+/*
+ * Validate an unmount record. The unmount record is the only record written by
+ * the log itself rather than by a transaction, and the log item processing loop
+ * skips it, so it can only be validated here. It is a single fixed size region,
+ * written by the log with the XFS_LOG clientid, containing an unmount format
+ * structure with a known magic number and zeroed padding.
+ *
+ * The ophdr has already been validated, so oh_len is known to be within the
+ * record. The unmount format length was incorrectly written for a period of
+ * time as zero rather than the region length. Such a record has no payload to
+ * read, so accept it with a warning and stop, so that filesystems written by
+ * those kernels still recover.
+ */
+STATIC int
+xlog_recover_validate_unmount_record(
+	struct xlog			*log,
+	struct xlog_op_header		*ohead)
+{
+	struct xfs_unmount_log_format	*ulf;
+	unsigned int			len = be32_to_cpu(ohead->oh_len);
+
+	if (ohead->oh_clientid != XFS_LOG) {
+		xfs_warn(log->l_mp, "%s: bad unmount clientid 0x%x",
+			__func__, ohead->oh_clientid);
+		return -EFSCORRUPTED;
+	}
+
+	if (len == 0) {
+		xfs_warn(log->l_mp,
+			"%s: zero length unmount record recovered.", __func__);
+		return 0;
+	}
+
+	if (len != sizeof(*ulf)) {
+		xfs_warn(log->l_mp, "%s: bad unmount record length 0x%x",
+			__func__, len);
+		return -EFSCORRUPTED;
+	}
+
+	ulf = (struct xfs_unmount_log_format *)(ohead + 1);
+	if (ulf->magic != XLOG_UNMOUNT_TYPE) {
+		xfs_warn(log->l_mp, "%s: bad unmount magic 0x%x, expected 0x%x",
+			__func__, ulf->magic, XLOG_UNMOUNT_TYPE);
+		return -EFSCORRUPTED;
+	}
+
+	if (ulf->pad1 != 0 || ulf->pad2 != 0) {
+		xfs_warn(log->l_mp, "%s: bad unmount padding", __func__);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 /*
  * Decode and validate an operation header from the journal. dp points at the
  * ophdr within the log record and end is the end of the record data. The ophdr
@@ -2653,6 +2712,7 @@ xlog_recover_validate_ophdr(
 {
 	struct xlog_op_header	*ohead;
 	unsigned int		len;
+	int			error;
 
 	/*
 	 * All log regions are 32 bit aligned, so the ophdr must be too. A
@@ -2736,11 +2796,15 @@ xlog_recover_validate_ophdr(
 			return ERR_PTR(-EFSCORRUPTED);
 		}
 		break;
+	case XLOG_UNMOUNT_TRANS:
+		error = xlog_recover_validate_unmount_record(log, ohead);
+		if (error)
+			return ERR_PTR(error);
+		break;
 	case 0:
 	case XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_END_TRANS:
-	case XLOG_UNMOUNT_TRANS:
 		break;
 	default:
 		xfs_warn(log->l_mp, "%s: bad flags 0x%x",
-- 
2.55.0

