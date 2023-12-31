Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322AEBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tEfVyhyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0313AC433C8;
	Sun, 31 Dec 2023 20:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056305;
	bh=S7VSA4CrBU009tt9ZgsQ+nOp1XmxH3qzjcafMRv6a9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tEfVyhyUvfxO64wLDgaNBoPoItRhqhJBpI0sCaJUL9c39ZTUd8t3lO79HqvkMbyJJ
	 VgbvCIVD/mXSp+VNWG18vDpbWKUtYXndO56YMJbwjeSRR/VgFywtNaVU9YiF5QbQk4
	 632jK4yJfuqgb5gQQdDpt8wdGpVaV5R8YyE/Jegiu/iWRFvNC3kgUjeWtcu54CkZVf
	 RjwOXbcxqUhfz/TWnvB86ihaUghmvMwK2Dr0t6U24Icjme5g8THfNzB9dudTGECMDt
	 TVdK0ohMwxMYZ0BLH2IuuuuJZLYE/D6Mymr5ayA/oGyVCjUJxon5+csx0WpRxLV7ha
	 qjUm2JrwSdpDA==
Date: Sun, 31 Dec 2023 12:58:24 -0800
Subject: [PATCH 20/22] xfs: adapt the orphanage code to handle parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404842069.1757392.18360146955036269056.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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

Adapt the orphanage's adoption code to update the child file's parent
pointers as part of the reparenting process.  Also ensure that the child
has an attr fork to receive the parent pointer update, since the runtime
code assumes one exists.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/orphanage.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h |    3 +++
 fs/xfs/scrub/scrub.c     |    2 ++
 3 files changed, 47 insertions(+)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index ace7a0f23e474..b894b807155a7 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -19,6 +19,8 @@
 #include "xfs_icache.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_parent.h"
+#include "xfs_attr_sf.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -330,8 +332,12 @@ xrep_adoption_trans_alloc(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		child_blkres = xfs_rename_space_res(mp, 0, false,
 						    xfs_name_dotdot.len, false);
+	if (xfs_has_parent(mp))
+		child_blkres += XFS_ADDAFORK_SPACE_RES(mp);
 	adopt->child_blkres = child_blkres;
 
+	xfs_parent_args_init(mp, &adopt->ppargs);
+
 	/*
 	 * Allocate a transaction to link the child into the parent, along with
 	 * enough disk space to handle expansion of both the orphanage and the
@@ -500,6 +506,21 @@ xrep_adoption_zap_dcache(
 	dput(d_orphanage);
 }
 
+/*
+ * If we have to add an attr fork ahead of a parent pointer update, how much
+ * space should we ask for?
+ */
+static inline int
+xrep_adoption_attr_sizeof(
+	const struct xrep_adoption	*adopt)
+{
+	size_t				res = sizeof(struct xfs_attr_sf_hdr);
+
+	res += xfs_attr_sf_entsize_byname(sizeof(struct xfs_parent_name_rec),
+			adopt->xname.len);
+	return res;
+}
+
 /*
  * Move the current file to the orphanage under the computed name.
  *
@@ -522,6 +543,19 @@ xrep_adoption_move(
 	if (error)
 		return error;
 
+	/*
+	 * If this filesystem has parent pointers, ensure that the file being
+	 * moved to the orphanage has an attribute fork.  This is required
+	 * because the parent pointer code does not itself add attr forks.
+	 */
+	if (!xfs_inode_has_attr_fork(sc->ip) && xfs_has_parent(sc->mp)) {
+		int sf_size = xrep_adoption_attr_sizeof(adopt);
+
+		error = xfs_bmap_add_attrfork(sc->tp, sc->ip, sf_size, true);
+		if (error)
+			return error;
+	}
+
 	/* Create the new name in the orphanage. */
 	error = xfs_dir_createname(sc->tp, sc->orphanage, xname, sc->ip->i_ino,
 			adopt->orphanage_blkres);
@@ -546,6 +580,14 @@ xrep_adoption_move(
 			return error;
 	}
 
+	/* Add a parent pointer from the file back to the lost+found. */
+	if (xfs_has_parent(sc->mp)) {
+		error = xfs_parent_addname(sc->tp, &adopt->ppargs,
+				sc->orphanage, xname, sc->ip);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Notify dirent hooks that we moved the file to /lost+found, and
 	 * finish all the deferred work so that we know the adoption is fully
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
index 9d40992583b24..74ce0bc05c6f1 100644
--- a/fs/xfs/scrub/orphanage.h
+++ b/fs/xfs/scrub/orphanage.h
@@ -54,6 +54,9 @@ struct xrep_adoption {
 
 	struct xfs_scrub	*sc;
 
+	/* Parent pointer context tracking */
+	struct xfs_parent_args	ppargs;
+
 	/* Block reservations for orphanage and child (if directory). */
 	unsigned int		orphanage_blkres;
 	unsigned int		child_blkres;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 440b8cb1957f4..d9c6d54ffad7f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -19,6 +19,8 @@
 #include "xfs_rmap.h"
 #include "xfs_xchgrange.h"
 #include "xfs_swapext.h"
+#include "xfs_dir2.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"

