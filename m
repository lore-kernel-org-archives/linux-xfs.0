Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9034384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u44ayiPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519BBC433C8;
	Mon,  1 Jan 2024 00:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067706;
	bh=pEvOO33gUEhbQq7rSpMI+jyAam78/ZFSg/l5+FXG9fs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u44ayiPD7ia5BKUa1kaFj3oCpPNj/U0JTft1PnpV3+qs/UV6x3u4ayTT6HFvEvdY4
	 d5C1+Z9NsUn2DoOvI/RbG+cQWBfP/ISJhUv3Nd9wrWv7YhXXpF4tGqcWbTeeyguVxC
	 YnrhM6D3Qxce4JcsUzQAmB01yd1r1/qYLmGcgolLT+/0+XB+TxCSgZ4BGh42ADRjVs
	 wPPKZJi/nXxJ/PMQFBLQyB4uDCRLZAj9N8ZsQ0gJKu0IflO5QjULNI1gi0WQ6n96z4
	 +wGXQYAgTDZbAiDBBK4NJk0t3Ycvqeyqn5eVKWYx6IOu8keqCfLF3VXbb/5BI7LvUe
	 P4oLPwvFyXZWQ==
Date: Sun, 31 Dec 2023 16:08:25 +9900
Subject: [PATCH 1/9] xfs: attach rtgroup objects to btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014833.1815232.13061250777423956598.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_btree.c |    4 ++++
 libxfs/xfs_btree.h |    2 ++
 2 files changed, 6 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 165ce251376..e0276ad655a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -28,6 +28,7 @@
 #include "xfile.h"
 #include "xfbtree.h"
 #include "xfs_btree_mem.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Btree magic numbers.
@@ -473,6 +474,9 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ino.rtg)
+		xfs_rtgroup_put(cur->bc_ino.rtg);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index bb6c2feecea..ce0bc5dfffe 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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

