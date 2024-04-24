Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC90013D2A4
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929154; cv=none; b=GW7y0tiVQFtTMY06S8ftGivhtblel9iaSDr5ButZslljvA+NVClvlxTt8FqrXt9T8Alqu2eijhoEwql3DfyS30kxzBhlH6S8evnW8VaSYcPTsIjmCG7m8gnv427pXPRtd2PjaU//p8UCS2L2/tabJ5cq1tW3u9FjFcjzneucFf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929154; c=relaxed/simple;
	bh=yLy9/jrR7bFQy0SFzoEFHzB9OPpRaqn21NjKgpREtLU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oub82if83Hk1gIVrK4jvUSFqYYLdh6/4CYJHrhCn+bH8Ertop4l3wNHQPN61KfB9ZQHXjzWLeMUc7kTz9qcGo+Arv+haFR2W11fgPEmvzSU7APxAEqyUCrbecvT2h02Dyzp3iBEkzfecF3qol1gWgK/cRTTfuksvK6ezx5kW7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVuyxpOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVuyxpOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413C5C116B1;
	Wed, 24 Apr 2024 03:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929154;
	bh=yLy9/jrR7bFQy0SFzoEFHzB9OPpRaqn21NjKgpREtLU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SVuyxpOeCG6U/4lfFzo/505rm/klZCziXSGGFwlXFcf0ggkuDnddVZgp8JesSjWe1
	 0904rQ7xVKlds7Ww5aqXXTWB5UfWt2mR4aCTSdnlVP17qiwexGLgM1+LCEP2HLJonf
	 qBpwjXv+4mqvSCKXVcYHhQtlTDVd9A/Faoz5QGLhS5INdCMnTYnXw3a4hKpcLu7Vcj
	 CCu7D1DLVi7NPeZ0yT8LCEYFH2DTUBnFc83ozAmCuC7spcqjmwNOyMk+wYRk3CDCZ3
	 Jqc+JNTd8LLtHeSoAnR2vq0oczV2i7PfjPDEvgCzChaJtkodCpDFrdTvqzk2H0ZH2x
	 NsS5HVR4MKaIA==
Date: Tue, 23 Apr 2024 20:25:53 -0700
Subject: [PATCH 14/16] xfs: adapt the orphanage code to handle parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784890.1906420.14539819553713836465.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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
index 94bcc2799188..b2f905924d0d 100644
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
index 319179ab788d..beb6b686784e 100644
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
index ebb06838c31b..7b1f1abdc7a9 100644
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

