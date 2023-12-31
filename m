Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F80C12D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6Z6Vwj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6E5C433C8;
	Sun, 31 Dec 2023 22:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061733;
	bh=tsvnwEVO/QXbM70MZomi3i2wTBN/R5pxNAGsM0x+awg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l6Z6Vwj6r+J3aJ8k5DedddjNBacG6SNjaZD/AVZZV0UXIzqt4zvXnCcAmzpE8KhTM
	 +dsmgHloVVRbziAriMMrL5UUm/K06mu7gDddehVYwKg3I5B4roCxj79xMLCZahWRYK
	 wQVJb3ymm8OutPPvYeJbgLWPc6Sisrm3g+dbn2i6EQQMvjvcI1bDijMik4Qou5jZNk
	 1KYsxSXMDs0Fi3kkebnA+vg4QM9RhXk/e6uoObEOglDQYR1SpHcK/eR4P1b6c5Saiu
	 fYjSpgtpxsolrovp+fs8cfFwgOKYzWvv3zOscpF3gEuTVYkBL9PltG82pcYV4dSXyY
	 N+AIxHZa42NDA==
Date: Sun, 31 Dec 2023 14:28:52 -0800
Subject: [PATCH 07/20] xfs: add error injection to test swapext recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996368.1796128.5472649324233917879.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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
 io/inject.c           |    1 +
 libxfs/xfs_errortag.h |    4 +++-
 libxfs/xfs_swapext.c  |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 6ef1fc8d2f4..4b0cd76005c 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -63,6 +63,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
 		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
 		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
+		{ XFS_ERRTAG_SWAPEXT_FINISH_ONE,	"swapext_finish_one" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 01a9e86b303..263d62a8d70 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
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
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 2462657c1f4..5de586c6816 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -21,6 +21,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_errortag.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -433,6 +434,9 @@ xfs_swapext_finish_one(
 			return error;
 	}
 
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_SWAPEXT_FINISH_ONE))
+		return -EIO;
+
 	/* If we still have work to do, ask for a new transaction. */
 	if (sxi_has_more_swap_work(sxi) || sxi_has_postop_work(sxi)) {
 		trace_xfs_swapext_defer(tp->t_mountp, sxi);

