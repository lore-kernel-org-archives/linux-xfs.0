Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6161AC8D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULUHAK8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF146C433C8;
	Sun, 31 Dec 2023 23:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063735;
	bh=fM/s8d/OrPJe39IUKhVctEGl/2WMiC/x6y5EDFrO8pQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ULUHAK8A6QM/wXTkPl71Jaysy4iUnlFuZ+hKHuIuur32orZEgZ7ANoJr+p5Kif8rZ
	 DZBV1JRa7wX2sRdFUlJz+iaPXpcGeGIPAyVnGwf+SUYGH7i7Dl51YWU7ctPzubiVjc
	 iDTLExVxsNJO+KkkXgMGZsg4KFmqpv7IjtxJRUett2iCHSgOGnaNHvAeF0vPWFyLVQ
	 EGus2MMg0IurefS8+pz57xs2Vbtpw6pnP5Nhdh8O2TxDZy/SlwZuV0JgQvf9cAznuO
	 ClAc/95/PJwsQCCIztzkHy0UKm5wpalsnC/PPZlDWToNEXst0VzMWzuNN1oIWoaBs6
	 yhxGyFWXr1w7Q==
Date: Sun, 31 Dec 2023 15:02:14 -0800
Subject: [PATCH 1/1] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Message-ID: <170405005275.1804292.4695991725944079372.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005262.1804292.14741989148602077637.stgit@frogsfrogsfrogs>
References: <170405005262.1804292.14741989148602077637.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
[djwong: have one sorting function]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_defer.c   |    6 +++++-
 libxfs/xfs_defer.h   |    8 +++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ef29d7e5eb7..45cfe4408a9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -437,6 +437,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 	__mode = __mode; /* no set-but-unused warning */	\
 })
 #define xfs_lock_two_inodes(ip0,mode0,ip1,mode1)	((void) 0)
+#define xfs_lock_inodes(i_tab, nr, mode)		((void) 0)
+#define xfs_sort_inodes(i_tab, nr)			((void) 0)
 
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 7782eea458e..41e607d55f0 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -1090,7 +1090,11 @@ xfs_defer_ops_continue(
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		xfs_sort_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos);
+		xfs_lock_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos,
+				XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index e3cf81bafca..c9a1fe3fe36 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -77,7 +77,13 @@ extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */

