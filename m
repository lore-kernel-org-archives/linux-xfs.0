Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F9CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qntvqy3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F54C433C8;
	Sun, 31 Dec 2023 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054474;
	bh=k6i5+XNanwNsIOtkqdb6mB93IKUST7BrlcFQT68azOk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qntvqy3Ol5GeyhUev8TPvKAZLtOFVa8mriCp0YIELHfKE920EboNClMRXVb7Qgy5j
	 GEYtPZFwLrEVETnGQurei9nSbsKzQ9bOVsFz9F9TYsa0hDhBDNWBPyewJpfCGIK4ng
	 8O94OMBoVYNLDuFHWycDXLIEZ+3I5UuDau2FAoorJ8Qtfm4ij1rXhFcoBsSbNHGugr
	 0Id5+nOgEXwChWbIjfwkJw5ydDUQyIHRQRaY9ozEvLpzBafdzc5gPa0VM9GY4bRbkp
	 VVAgA1xY/KkIaKNeFhvTdR9NZAtvpT4iQIrnSPKmFmUEDeBMI5Ph6gkKCwOGCQFA+Z
	 RVoGHA+U4tMJA==
Date: Sun, 31 Dec 2023 12:27:53 -0800
Subject: [PATCH 14/25] xfs: add error injection to test swapext recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833366.1750288.14570267649204515325.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add an errortag so that we can test recovery of swapext log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_errortag.h |    4 +++-
 fs/xfs/libxfs/xfs_swapext.c  |    3 +++
 fs/xfs/xfs_error.c           |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 01a9e86b30379..263d62a8d70f8 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -63,7 +63,8 @@
 #define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
-#define XFS_ERRTAG_MAX					44
+#define XFS_ERRTAG_SWAPEXT_FINISH_ONE			44
+#define XFS_ERRTAG_MAX					45
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -111,5 +112,6 @@
 #define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
+#define XFS_RANDOM_SWAPEXT_FINISH_ONE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index f5dacd6f1ecb2..7e72b43f7b782 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -436,6 +436,9 @@ xfs_swapext_finish_one(
 			return error;
 	}
 
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_SWAPEXT_FINISH_ONE))
+		return -EIO;
+
 	/* If we still have work to do, ask for a new transaction. */
 	if (sxi_has_more_swap_work(sxi) || sxi_has_postop_work(sxi)) {
 		trace_xfs_swapext_defer(tp->t_mountp, sxi);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b2cbbba3e15a5..c3792ab41c271 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -62,6 +62,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_ATTR_LEAF_TO_NODE,
 	XFS_RANDOM_WB_DELAY_MS,
 	XFS_RANDOM_WRITE_DELAY_MS,
+	XFS_RANDOM_SWAPEXT_FINISH_ONE,
 };
 
 struct xfs_errortag_attr {
@@ -179,6 +180,7 @@ XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
+XFS_ERRORTAG_ATTR_RW(swapext_finish_one, XFS_ERRTAG_SWAPEXT_FINISH_ONE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -224,6 +226,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
 	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
+	XFS_ERRORTAG_ATTR_LIST(swapext_finish_one),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);

