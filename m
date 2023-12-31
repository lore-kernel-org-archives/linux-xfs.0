Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A40BBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j27Q/M0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F109BC433C8;
	Sun, 31 Dec 2023 21:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058167;
	bh=IMuCot++zVPmE/d+MomEk6mYdxl41Iz5DjmfsEoKVjU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j27Q/M0YMirvNk5cmFh6R+oQkryXKdyhwz6fsrWFqj2q1wx9PJiFOS+1uKeVipjPO
	 D7epOKQ6keVcV3WXIk1Tzv/edKZFYADFPRQliOB8IkCeUd4Mt0oPODvDtX0bO+44YD
	 pord731MhKVtPfCpdl7nGLEPVsTJ/rhQQrVV2blIkcR6qt1aFBNa+fbROE/Y90V9K8
	 fRXHuwuxlvH/YUXsGKh91ry/87xFYy3ZDyZPs1fkw+SqHRsy6GIvR+ibtQm83RkDEI
	 6Bp6iWY2BjQAKIastgk3222qzUapU2J2p2fAZwqSnizhGxg1r7mpd6eWpbxQew01Jz
	 Jmu3blMQ6DGnA==
Date: Sun, 31 Dec 2023 13:29:26 -0800
Subject: [PATCH 01/10] xfs: attach rtgroup objects to btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849250.1764703.17695155270151166894.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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

Make it so that we can attach realtime group objects to btree cursors.
This will be crucial for enabling rmap btrees in realtime groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    4 ++++
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 2 files changed, 6 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ddbe2d55a8077..5b4a2c6a3f2ac 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -31,6 +31,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfbtree.h"
 #include "xfs_btree_mem.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Btree magic numbers.
@@ -476,6 +477,9 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ino.rtg)
+		xfs_rtgroup_put(cur->bc_ino.rtg);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index bb6c2feecea7d..ce0bc5dfffe1c 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -12,6 +12,7 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_ifork;
 struct xfs_perag;
+struct xfs_rtgroup;
 
 /*
  * Generic key, ptr and record wrapper structures.
@@ -247,6 +248,7 @@ struct xfs_btree_cur_ag {
 /* Btree-in-inode cursor information */
 struct xfs_btree_cur_ino {
 	struct xfs_inode		*ip;
+	struct xfs_rtgroup		*rtg;	/* if realtime metadata */
 	struct xbtree_ifakeroot		*ifake;	/* for staging cursor */
 	int				allocated;
 	short				forksize;

