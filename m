Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF3EC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjEZCQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZCQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:16:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE213A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A500614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8EDC433D2;
        Fri, 26 May 2023 02:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067399;
        bh=14Ey3VVaOWUuMVFe9oJWmCEOsFjCn+d/2dkDrH03/gE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WFAW+3ZsUx8z5/p/H6UuoBYXHstnPdcVYIB1O7QjcNjMoyQi5UhuLyGffFmPnAvLw
         1JLN/weK3lCqcz5VcRWpFypngF3poHO5Hs6D+uITnigejazl6QwoyKktVs7n1ujS7T
         Q2V/suR1pODOPDg9Ec3aBCUlwmrUb9FIjsz5DVG6uQ5EzEqoc1kDHaH1Jsy3/RgCFn
         vMMI3R8xUI4ruL7JLl5P0FRo0fj+be1rDMeWWusjjpOOC08pY51PvgqvlOmqgSpqfi
         dMXk6DAXIVtrt9TQmso0sZnuiSluB9OyzxTLL70Iket+QDyt4uVE1LMjcxSLNjEy+p
         Nkgu0N+8ubPfw==
Date:   Thu, 25 May 2023 19:16:39 -0700
Subject: [PATCH 08/17] xfs: teach the adoption code about parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073410.3745075.12787706795487900676.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the online fsck file adoption code how to create parent pointers
for files that are moved to /lost+found.  In addition to the parent
pointer creation itself, we must also turn on logged xattrs during scrub
setup.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/orphanage.c |   66 +++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/orphanage.h |    2 +
 fs/xfs/scrub/scrub.c     |    6 ++++
 fs/xfs/scrub/scrub.h     |    8 +++---
 fs/xfs/scrub/trace.h     |    1 +
 5 files changed, 75 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 8285d129db9e..c574ae5a23ec 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -19,6 +19,10 @@
 #include "xfs_icache.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_parent.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_xattr.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -97,6 +101,31 @@ xrep_chown_orphanage(
 	return error;
 }
 
+/*
+ * Enable logged extended attributes for parent pointers.  This must get done
+ * before we create transactions and start making changes.
+ */
+STATIC int
+xrep_adoption_grab_log_assist(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!xfs_has_parent(sc->mp))
+		return 0;
+
+	ASSERT(!(sc->flags & XREP_FSGATES_LARP));
+
+	error = xfs_attr_grab_log_assist(sc->mp);
+	if (error)
+		return error;
+
+	trace_xchk_fsgates_enable(sc, XREP_FSGATES_LARP);
+
+	sc->flags |= XREP_FSGATES_LARP;
+	return 0;
+}
+
 #define ORPHANAGE	"lost+found"
 
 /* Create the orphanage directory, and set sc->orphanage to it. */
@@ -188,6 +217,12 @@ xrep_orphanage_create(
 out_dput_root:
 	dput(root_dentry);
 out:
+	/*
+	 * Turn on whatever log features are required for an adoption to be
+	 * committed correctly.
+	 */
+	if (!error)
+		error = xrep_adoption_grab_log_assist(sc);
 	return error;
 }
 
@@ -267,6 +302,14 @@ xrep_adoption_init(
 		child_blkres = xfs_rename_space_res(mp, 0, false,
 						xfs_name_dotdot.len, false);
 	adopt->child_blkres = child_blkres;
+
+	if (xfs_has_parent(mp)) {
+		ASSERT(sc->flags & XREP_FSGATES_LARP);
+		return xfs_parent_start_locked(mp, &adopt->parent);
+	} else {
+		adopt->parent = NULL;
+	}
+
 	return 0;
 }
 
@@ -466,7 +509,7 @@ xrep_adoption_commit(
 
 	error = xrep_orphanage_check_dcache(adopt);
 	if (error)
-		return error;
+		goto out_parent;
 
 	/*
 	 * Create the new name in the orphanage, and bump the link count of
@@ -475,7 +518,7 @@ xrep_adoption_commit(
 	error = xfs_dir_createname(sc->tp, sc->orphanage, xname, sc->ip->i_ino,
 			adopt->orphanage_blkres);
 	if (error)
-		return error;
+		goto out_parent;
 
 	xfs_trans_ichgtime(sc->tp, sc->orphanage,
 			XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -488,7 +531,15 @@ xrep_adoption_commit(
 		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
 				sc->orphanage->i_ino, adopt->child_blkres);
 		if (error)
-			return error;
+			goto out_parent;
+	}
+
+	/* Add a parent pointer from the file back to the lost+found. */
+	if (adopt->parent) {
+		error = xfs_parent_add(sc->tp, adopt->parent, sc->orphanage,
+				xname, sc->ip);
+		if (error)
+			goto out_parent;
 	}
 
 	/*
@@ -499,11 +550,14 @@ xrep_adoption_commit(
 	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, xname);
 	error = xrep_defer_finish(sc);
 	if (error)
-		return error;
+		goto out_parent;
 
 	/* Remove negative dentries from the lost+found's dcache */
 	xrep_orphanage_zap_dcache(adopt);
-	return 0;
+out_parent:
+	xfs_parent_finish(sc->mp, adopt->parent);
+	adopt->parent = NULL;
+	return error;
 }
 
 /* Cancel a proposed relocation of a file to the orphanage. */
@@ -521,6 +575,8 @@ xrep_adoption_cancel(
 	 * state to manage, we'll need to give that back.
 	 */
 	trace_xrep_adoption_cancel(sc->orphanage, sc->ip, error);
+	xfs_parent_finish(sc->mp, adopt->parent);
+	adopt->parent = NULL;
 }
 
 /* Release the orphanage. */
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
index 31f068198c8a..382c061e2fb6 100644
--- a/fs/xfs/scrub/orphanage.h
+++ b/fs/xfs/scrub/orphanage.h
@@ -47,6 +47,8 @@ struct xrep_adoption {
 
 	struct xfs_scrub	*sc;
 
+	struct xfs_parent_defer	*parent;
+
 	/* Block reservations for orphanage and child (if directory). */
 	unsigned int		orphanage_blkres;
 	unsigned int		child_blkres;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b5bd7125ca34..70010b111d9a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -21,6 +21,9 @@
 #include "xfs_rmap.h"
 #include "xfs_xchgrange.h"
 #include "xfs_swapext.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_xattr.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -177,6 +180,9 @@ xchk_fsgates_disable(
 	if (sc->flags & XREP_FSGATES_ATOMIC_XCHG)
 		xfs_xchg_range_rele_log_assist(sc->mp);
 
+	if (sc->flags & XREP_FSGATES_LARP)
+		xfs_attr_rele_log_assist(sc->mp);
+
 	sc->flags &= ~FSGATES_MASK;
 }
 #undef FSGATES_MASK
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 6f23edcac5cd..638c69e1fed9 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -135,6 +135,7 @@ struct xfs_scrub {
 #define XCHK_FSGATES_QUOTA	(1 << 4)  /* quota live update enabled */
 #define XCHK_FSGATES_DIRENTS	(1 << 5)  /* directory live update enabled */
 #define XCHK_FSGATES_RMAP	(1 << 6)  /* rmapbt live update enabled */
+#define XREP_FSGATES_LARP	(1 << 28) /* logged xattr updates */
 #define XREP_FSGATES_ATOMIC_XCHG (1 << 29) /* uses atomic file content exchange */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
@@ -151,10 +152,11 @@ struct xfs_scrub {
 				 XCHK_FSGATES_RMAP)
 
 /*
- * The sole XREP_FSGATES* flag reflects a log intent item that is protected
- * by a log-incompat feature flag.  No code patching in use here.
+ * The sole XREP_FSGATES* flag reflects log intent items protected by
+ * log-incompat feature flags.  No code patching in use here.
  */
-#define XREP_FSGATES_ALL	(XREP_FSGATES_ATOMIC_XCHG)
+#define XREP_FSGATES_ALL	(XREP_FSGATES_ATOMIC_XCHG | \
+				 XREP_FSGATES_LARP)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c64594f20f73..96c88f4419d7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -124,6 +124,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
+	{ XREP_FSGATES_LARP,			"fsgates_larp" }, \
 	{ XREP_FSGATES_ATOMIC_XCHG,		"fsgates_atomic_swapext" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }

