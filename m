Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0157459B4C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798809; cv=none; b=SgSBrUuln+5Ju35KyK70PRHSdxXVUw8v3vh0C41cvJsX3XsTCY3gE829BwLXwUke8tkqTBTRSr2HdM9jFGcHDI4DqZyZeU1gMcMO1a2sYDedhMGffXg7+roEFZx3YyednAP/z/vNO6DmOjwjx56YxLSYNmFndCgodyVcEinvJVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798809; c=relaxed/simple;
	bh=mf3yeAzU9Oud3POj12VdSmXoZhFZ/xPDoLsnuYl0GYY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqS4vgBxPyv4UL2wfNR1JVYYlTI1OWq1heJC+GK5LnslSUarplNtUrEfJTgEGky2PYxJYVzfvKNlniBbCWuG6qVF+lRvreY1Jck1D0aoT4zfwqzSAO7xDGy/JRwYaMOjoacmitDoVfmA+9Gje3SwcHbIExTlyjUYl2X3SlEhSuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H617PfDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H617PfDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6C9C433F1;
	Mon, 18 Mar 2024 21:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798808;
	bh=mf3yeAzU9Oud3POj12VdSmXoZhFZ/xPDoLsnuYl0GYY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H617PfDGd7GWII3m+etbaGRvmpliIcd8Ujn53TcWDwNwaRTrTdvwmmj2H5B7h3LCG
	 Y4ER/fnjq7b+SwXRJ/bpvK6PDHaoTZ9CEAH11I9/LQ3iYwUKbmeo//7CIR3CxHarVB
	 nnzQ2Qf0x5ps6ZLp7qsle3cSy6lwd2T1EwEb6XyfLrLTzpRKNfJL1/uS3Nu6JRSDa5
	 O7iz3p79A61Wg5RKLn/Ym07CVhoV8gfNY6/ODrfP2RPPUIs9few5Hm2EFaHbLdpQ2s
	 WhRYR9a9wHRsSc8c5s9eeMnql3G4GOHXzmrZetvNpoAvX2D5ZQqTyFDyvLuqCNixkp
	 dPupxV4mmOCyw==
Date: Mon, 18 Mar 2024 14:53:28 -0700
Subject: [PATCH 21/23] xfs: adapt the orphanage code to handle parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079803037.3808642.17066319298589816303.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

