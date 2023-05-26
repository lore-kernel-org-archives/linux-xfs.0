Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A70C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZCbP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjEZCbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E29BB2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B2A164C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F47DC433EF;
        Fri, 26 May 2023 02:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068272;
        bh=RwCKgV6kvtM46hxvdaG1qQlW1bB1z+//Q2Hup/JiCEg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uNJMsLmdKZ+lVF66pm/SdDP2HeO65p09GbQc8rrw9G0nuve/+8yWeErjaqk+GAu89
         JD4NHLjDs3uXNz+XHomOYAcAmls0ve1Mu+SxeZ89Dk7026G3tEj6byeXEjiBb4yq6i
         EFfwFRvAImE4Sq/HBebVqndVWpXnTBjYpGx0Z6PCVHayxt3Q73QawmcELNxhtm+D2E
         X8tEYNEEnnLLWLCL4dZTnKf3zoNgkKbuB2fod7B2JSaIyp0V/LYQfbofFHyEUlF3aM
         wGW6YULqe2ekuqOAWckfbye3SAMX/GTqloEgzPdBxlm9dqnTp7/QH3PQVjQ0cTZ5Q3
         58qI4H48i/Wpg==
Date:   Thu, 25 May 2023 19:31:12 -0700
Subject: [PATCH 06/14] xfs_repair: add parent pointers when messing with
 /lost+found
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078677.3750196.5500351292542155135.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the /lost+found gets created with parent pointers, and
that lost children being put in there get new parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/phase6.c          |   75 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7d1d1ddf624..795df630d76 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -182,6 +182,8 @@
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_irec_hashname	libxfs_parent_irec_hashname
+#define xfs_parent_lookup		libxfs_parent_lookup
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_namecheck		libxfs_parent_namecheck
 #define xfs_parent_valuecheck		libxfs_parent_valuecheck
diff --git a/repair/phase6.c b/repair/phase6.c
index b99ce4c2aa4..3e2436130f4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -886,6 +886,12 @@ mk_orphanage(xfs_mount_t *mp)
 	const int	mode = 0755;
 	int		nres;
 	struct xfs_name	xname;
+	struct xfs_parent_defer *parent = NULL;
+
+	i = -libxfs_parent_start(mp, &parent);
+	if (i)
+		do_error(_("%d - couldn't allocate parent pointer for %s\n"),
+			i, ORPHANAGE);
 
 	/*
 	 * check for an existing lost+found first, if it exists, return
@@ -975,6 +981,14 @@ mk_orphanage(xfs_mount_t *mp)
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
 
+	if (parent) {
+		error = -libxfs_parent_add(tp, parent, pip, &xname, ip);
+		if (error)
+			do_error(
+ _("committing %s parent pointer failed, error %d.\n"),
+					ORPHANAGE, error);
+	}
+
 	/*
 	 * bump up the link count in the root directory to account
 	 * for .. in the new directory, and update the irec copy of the
@@ -996,10 +1010,51 @@ mk_orphanage(xfs_mount_t *mp)
 	}
 	libxfs_irele(ip);
 	libxfs_irele(pip);
+	libxfs_parent_finish(mp, parent);
 
 	return(ino);
 }
 
+/*
+ * Add a parent pointer back to the orphanage for any file we're moving into
+ * the orphanage, being careful not to trip over any existing parent pointer.
+ * You never know when the orphanage might get corrupted.
+ */
+static void
+add_orphan_pptr(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*orphanage_ip,
+	const struct xfs_name	*xname,
+	struct xfs_inode	*ip,
+	struct xfs_parent_defer	*parent)
+{
+	struct xfs_parent_name_irec	pptr = {
+		.p_ino		= orphanage_ip->i_ino,
+		.p_gen		= VFS_I(orphanage_ip)->i_generation,
+		.p_namelen	= xname->len,
+	};
+	struct xfs_parent_scratch	scr = { };
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	memcpy(pptr.p_name, xname->name, xname->len);
+	libxfs_parent_irec_hashname(mp, &pptr);
+
+	error = -libxfs_parent_lookup(tp, ip, &pptr, &scr);
+	if (!error)
+		return;
+	if (error != ENOATTR)
+		do_log(
+ _("cannot look up parent pointer for '%.*s', err %d\n"),
+				xname->len, xname->name, error);
+
+	error = -libxfs_parent_add(tp, parent, orphanage_ip, xname, ip);
+	if (error)
+		do_error(
+ _("adding '%.*s' parent pointer failed, error %d.\n"),
+				xname->len, xname->name, error);
+}
+
 /*
  * move a file to the orphange.
  */
@@ -1020,6 +1075,13 @@ mv_orphanage(
 	ino_tree_node_t		*irec;
 	int			ino_offset = 0;
 	struct xfs_name		xname;
+	struct xfs_parent_defer	*parent = NULL;
+
+	err = -libxfs_parent_start(mp, &parent);
+	if (err)
+		do_error(
+ _("%d - couldn't allocate parent pointer for lost inode\n"),
+			err);
 
 	xname.name = fname;
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
@@ -1071,6 +1133,10 @@ mv_orphanage(
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
+			if (parent)
+				add_orphan_pptr(tp, orphanage_ip, &xname,
+						ino_p, parent);
+
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
@@ -1105,6 +1171,10 @@ mv_orphanage(
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
+			if (parent)
+				add_orphan_pptr(tp, orphanage_ip, &xname,
+						ino_p, parent);
+
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
@@ -1153,6 +1223,10 @@ mv_orphanage(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 		ASSERT(err == 0);
 
+		if (parent)
+			add_orphan_pptr(tp, orphanage_ip, &xname, ino_p,
+					parent);
+
 		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 		err = -libxfs_trans_commit(tp);
@@ -1162,6 +1236,7 @@ mv_orphanage(
 	}
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
+	libxfs_parent_finish(mp, parent);
 }
 
 static int

