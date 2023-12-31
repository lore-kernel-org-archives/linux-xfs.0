Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A14C12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqBpCtUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B712C433C8;
	Sun, 31 Dec 2023 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060795;
	bh=bI+4+z07ADkihF/Dnk5FvakE8WIY57ES4E5UJ59U1JU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AqBpCtUe8narsVNf9dxUi1bgNOl5wHhZNrC7zVWWmW6akIhzlJuVZOp7upH2oSbvJ
	 RNNAEdc1TdRDbelW18+E7TCjRPZmYM7Ur1Q5XKzELF9V9OtD6XrM2Vj5ie4YCG266N
	 Tsatwsh2FNh/kLMR+PbsvCIjb3jQUZlI+WNBd73tvt4sBbJNGB6rAFr5SeSIt184gw
	 J1ggjjwstYhMuq5jQ0lwV+k6bEh8mbPO9LQ10r+1uneZse12yO5xU69KAdGe6bKtJt
	 1c9ObYRViYjJTVmXEbnAo6QR9mnaVZuJbSI6/k3JMvLTtosmCL4C12mNxd38In8vWZ
	 RS9kW/m2CMFag==
Date: Sun, 31 Dec 2023 14:13:15 -0800
Subject: [PATCH 8/9] xfs: report realtime metadata corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992062.1794070.6089763105860969829.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
References: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c         |    1 +
 libxfs/xfs_rtbitmap.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index ddb98141210..097362d488d 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -737,3 +737,4 @@ void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
+void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 726543abb51..b4da1b07c73 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -15,6 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -113,13 +114,19 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map)))
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map))) {
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 

