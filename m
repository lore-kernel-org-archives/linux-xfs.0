Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E678E6AB9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231592; cv=none; b=LQRgo9ybp0sgn7f1pG6UY272d+XpM1CdQJk98ejixo2hBU+u2c6ZFjKJUi1hQYVM7aF8ft8HRFM/aCCKaUOzPDrpwkmGZIDyDZegMamZ5yrZ2BtZEJL5KP/bjfBJMuwRcYtkPNQ4vj6sSx/+OqsPLPWoMsaE9c03CC0lSn4+8vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231592; c=relaxed/simple;
	bh=1fBwwpPeAMkgpISWM/e1oUSJlZrc987LpxKoEc6AI6g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+tAR+EoL1LUZMDTfYNKWb8h7V5vCVkN+3r51EnG9IDS1HQEIjgNOjehdPjxNl6vQFeXzkatLshLHSZBhZzHRAM0L8RskEQoNerccEgJS9+ydHl/nE+r7ekm+9UZ/qaCcfIzRat1fpm3V/gpGrvaMe+2Jh9dA2bJeKl7ayg28OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajn3+Tqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajn3+Tqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD643C113CC;
	Tue, 16 Apr 2024 01:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231591;
	bh=1fBwwpPeAMkgpISWM/e1oUSJlZrc987LpxKoEc6AI6g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ajn3+TqzTeYPrtMoD8BSNdqg6EFAWvx5IJUN4iM7qg4lJ/7lXPk0/TZlJimtXP0fw
	 IzO3Q9jTCgmgJ/p1/IhCkdJdiSRrzbOqjvLyI+bRSmqRf6zdnzIMqcx04ouUl1Ogwg
	 e5sXjnhNgNpWYc8PYwzhOVpUeYm9MS/8c0PI3zuJEpEWXpZu86bYecWWgCMneHdkoO
	 E/SKwYKxCDSDrF0tQCG0apQJNR8mc9oFN/YDB2c+1if3KgXSZQ0bAEacqXmCsmjE6j
	 tlWTVm2FGty4ipq2HdTe5nnhRhNo5DUJOWbZbXz58mXMiF6ICcDKzGR32L3vcvfRNB
	 XU41gBBkAX8iA==
Date: Mon, 15 Apr 2024 18:39:51 -0700
Subject: [PATCH 15/17] xfs: adapt the orphanage code to handle parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029428.253068.10744719763665946711.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/orphanage.c |   38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h |    3 +++
 fs/xfs/scrub/scrub.c     |    2 ++
 3 files changed, 43 insertions(+)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 94bcc2799188f..b2f905924d0d8 100644
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
@@ -330,6 +332,8 @@ xrep_adoption_trans_alloc(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		child_blkres = xfs_rename_space_res(mp, 0, false,
 						    xfs_name_dotdot.len, false);
+	if (xfs_has_parent(mp))
+		child_blkres += XFS_ADDAFORK_SPACE_RES(mp);
 	adopt->child_blkres = child_blkres;
 
 	/*
@@ -503,6 +507,19 @@ xrep_adoption_zap_dcache(
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
+	return sizeof(struct xfs_attr_sf_hdr) +
+		xfs_attr_sf_entsize_byname(sizeof(struct xfs_parent_rec),
+					   adopt->xname->len);
+}
+
 /*
  * Move the current file to the orphanage under the computed name.
  *
@@ -524,6 +541,19 @@ xrep_adoption_move(
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
 	error = xfs_dir_createname(sc->tp, sc->orphanage, adopt->xname,
 			sc->ip->i_ino, adopt->orphanage_blkres);
@@ -548,6 +578,14 @@ xrep_adoption_move(
 			return error;
 	}
 
+	/* Add a parent pointer from the file back to the lost+found. */
+	if (xfs_has_parent(sc->mp)) {
+		error = xfs_parent_addname(sc->tp, &adopt->ppargs,
+				sc->orphanage, adopt->xname, sc->ip);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Notify dirent hooks that we moved the file to /lost+found, and
 	 * finish all the deferred work so that we know the adoption is fully
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
index 319179ab788d3..beb6b686784e6 100644
--- a/fs/xfs/scrub/orphanage.h
+++ b/fs/xfs/scrub/orphanage.h
@@ -54,6 +54,9 @@ struct xrep_adoption {
 	/* Name used for the adoption. */
 	struct xfs_name		*xname;
 
+	/* Parent pointer context tracking */
+	struct xfs_parent_args	ppargs;
+
 	/* Block reservations for orphanage and child (if directory). */
 	unsigned int		orphanage_blkres;
 	unsigned int		child_blkres;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ebb06838c31be..7b1f1abdc7a98 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -19,6 +19,8 @@
 #include "xfs_rmap.h"
 #include "xfs_exchrange.h"
 #include "xfs_exchmaps.h"
+#include "xfs_dir2.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"

