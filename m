Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC430ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871350; cv=none; b=jn5FS1A8+//2kJWjvQ3SZvto3B7WwrErk8ASmI3LqQmSoR3dUhcp7rqJr/T9I91g31zTcjuQJHSiwI3gWfya2QHg+45k5MmzqKRi+M5EMvOYpL88uxkq99EBwgHp7xicLLGqmNVm7bg2vLToMCNKeEB1tIJx5i3QFkMmkYp4KuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871350; c=relaxed/simple;
	bh=PIFmVOhvS87sF/l9lEEwAJDgpUi4rgDYUAWDvVNIcuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPJoWOdagPIG3IYZ95jL8oS3tkdR3Rmqhy6e8VychoqhT5ZFkcfGrgVvZTlluJEq9VJpBAeGLo1+gGugmZ1uqh/UB0Drtr/FzXgHOmJ/EqlVH4MFmG30J7SD5UaEJQeBj4uA/yaEaW7AWYlBj0QYri9fFNm+t0TLvO4fDhpjC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guTzjA8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guTzjA8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7921F000FF;
	Tue, 13 Oct 2026 06:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871349;
	bh=/6bt6jE9lbmv9GMxzdSn7Jff0qfW6V/7bS/NjXTp0FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guTzjA8YnJ8uZZRVozCa+cSJCyehEdSKKkXFpp+4B69RreheUeO/n9bsOEjOJY6iw
	 s3eCfeROZXmcDAKI4bepRwwEj+sp0cB258lWXiF6zhFDvkwPyQKf7PmUl3RwNN+WqN
	 WmAv/JCSygC4NdirfnCYkHOCO5w2TMLmnL5tI+NocMA402ReFEmf7JMsvtq+BVMmoq
	 HVjeukl6cWaaLzFpTPUNPi2tp5aBqWUuckITWiNy/wlx6gPnY4NE7aVhcEPTSk8RQn
	 w1w0ScInGrHXO+kwdBpYL23hfLCH5wLvAU9xQsDzrp7HroQrdry+Da1L0QLKlvEd5K
	 igtAEU/hcr1eg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 16/48] xfs: bound the assembled region size during recovery
Date: Tue, 13 Oct 2026 17:01:06 +1100
Message-ID: <20261013060204.3138690-17-dgc@kernel.org>
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

A region split across continuation op headers is grown one fragment at a time
with no limit on the total size, so a corrupt continuation stream can drive an
unbounded allocation during recovery.

Add XLOG_MAX_REGION_SIZE - the largest object logged in a single region - as a
format level bound usable by both the log write and recovery paths, and reject
a continuation once the assembled region would exceed it. Use the same constant
for the existing per-op-header length check.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |  8 ++++++++
 fs/xfs/xfs_log_recover.c       | 21 ++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 6e620380d5dc..6d49cb831d73 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -38,6 +38,14 @@ typedef uint32_t xlog_tid_t;
 
 #define XLOG_HEADER_SIZE	512
 
+/*
+ * The largest object that is logged in a single region: a whole buffer in a
+ * buffer log item, or a remote attribute value. This bounds the size of any
+ * single log region both when writing the log and when reassembling regions
+ * during recovery.
+ */
+#define XLOG_MAX_REGION_SIZE	max(XFS_MAX_BLOCKSIZE, XFS_XATTR_SIZE_MAX)
+
 /* Minimum number of transactions that must fit in the log (defined by mkfs) */
 #define XFS_MIN_LOG_FACTOR	3
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 90f841bf0aa5..c35bb0fb3249 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2408,6 +2408,16 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
+	/*
+	 * Bound the assembled region size before growing the buffer so a corrupt
+	 * continuation stream cannot drive an unbounded allocation.
+	 */
+	if (old_len + len > XLOG_MAX_REGION_SIZE) {
+		xfs_warn(log->l_mp, "%s: region too large (0x%x)",
+			__func__, old_len + len);
+		return -EFSCORRUPTED;
+	}
+
 	ptr = kvrealloc(old_ptr, len + old_len, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
@@ -2781,15 +2791,8 @@ xlog_recover_validate_ophdr(
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	/*
-	 * A single region cannot be larger than the largest object we log in
-	 * one region. That is a whole buffer in a buffer log item (up to
-	 * XFS_MAX_BLOCKSIZE, e.g. a 64k directory block on a 4k block size
-	 * filesystem) or a remote attribute value (up to XFS_XATTR_SIZE_MAX,
-	 * logged in its own region); both are 64k.
-	 */
-	BUILD_BUG_ON(XFS_XATTR_SIZE_MAX > XFS_MAX_BLOCKSIZE);
-	if (len > XFS_MAX_BLOCKSIZE) {
+	/* A single region cannot be larger than the largest object we log. */
+	if (len > XLOG_MAX_REGION_SIZE) {
 		xfs_warn(log->l_mp, "%s: length 0x%x too large", __func__, len);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
-- 
2.55.0

