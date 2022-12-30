Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875CAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbiLaCR0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiLaCRZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:17:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C434E13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:17:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D968CE1A06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFB9C433EF;
        Sat, 31 Dec 2022 02:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453040;
        bh=9AsNmcLAr1aa9ABPuoatAfK32DLxPSLfaLObXfRf/dc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MhKXzDVPJSw7r/8n2+Vw0pENYTiBbIfCsy8Yvq6qjKjpGsZYMme1GMxTffNH/sw/Z
         Z86U9H1jVuCxfzXJaj+dGZOFP0LkG3JPqBeu1uF5HD5W8CrYrKC0lbqv0WyFOBQx49
         s6vWr5izpFsM/zdDiB3xKqYMa4/RBJwD5QdI7qfpHOm42tq5okSZt8sXWNPzseYyj4
         /dAfUieHQAS0RAF4nPKLFh+Is6lGyKsQOWj9DGi2dF7G+/oGaRHAl6MhEg6tk7uwqv
         XEtFytnw0q3k0UxL8QRp8wKKBs9DFNipvdMT4fVXAKMVZaHrFuXiRn3FHEVMX52121
         40AyKYqsHCFbg==
Subject: [PATCH 29/46] xfs_repair: refactor fixing dotdot
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876316.725900.11799175747461001056.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pull the code that fixes a directory's dot-dot entry into a separate
helper function so that we can call it on the rootdir and (later) the
metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   96 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 39 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 90413251b56..053e3ace8ee 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2711,6 +2711,62 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 	}
 }
 
+/*
+ * If we have to create a .. for /, do it now *before* we delete the bogus
+ * entries, otherwise the directory could transform into a shortform dir which
+ * would probably cause the simulation to choke.  Even if the illegal entries
+ * get shifted around, it's ok because the entries are structurally intact and
+ * in in hash-value order so the simulation won't get confused if it has to
+ * move them around.
+ */
+static void
+fix_dotdot(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	*ip,
+	xfs_ino_t		rootino,
+	const char		*tag,
+	int			*need_dotdot)
+{
+	struct xfs_trans	*tp;
+	int			nres;
+	int			error;
+
+	if (ino != rootino || !*need_dotdot)
+		return;
+
+	if (no_modify) {
+		do_warn(_("would recreate %s directory .. entry\n"), tag);
+		return;
+	}
+
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
+
+	do_warn(_("recreating %s directory .. entry\n"), tag);
+
+	nres = XFS_MKDIR_SPACE_RES(mp, 2);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+
+	error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot, ip->i_ino,
+			nres);
+	if (error)
+		do_error(
+_("can't make \"..\" entry in %s inode %" PRIu64 ", createname error %d\n"),
+			tag ,ino, error);
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("%s inode \"..\" entry recreation failed (%d)\n"), tag, error);
+
+	*need_dotdot = 0;
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -2839,45 +2895,7 @@ _("error %d fixing shortform directory %llu\n"),
 	}
 	dir_hash_done(hashtab);
 
-	/*
-	 * if we have to create a .. for /, do it now *before*
-	 * we delete the bogus entries, otherwise the directory
-	 * could transform into a shortform dir which would
-	 * probably cause the simulation to choke.  Even
-	 * if the illegal entries get shifted around, it's ok
-	 * because the entries are structurally intact and in
-	 * in hash-value order so the simulation won't get confused
-	 * if it has to move them around.
-	 */
-	if (!no_modify && need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
-		ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
-
-		do_warn(_("recreating root directory .. entry\n"));
-
-		nres = XFS_MKDIR_SPACE_RES(mp, 2);
-		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
-					    nres, 0, 0, &tp);
-		if (error)
-			res_failed(error);
-
-		libxfs_trans_ijoin(tp, ip, 0);
-
-		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, nres);
-		if (error)
-			do_error(
-	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
-
-		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		error = -libxfs_trans_commit(tp);
-		if (error)
-			do_error(
-	_("root inode \"..\" entry recreation failed (%d)\n"), error);
-
-		need_root_dotdot = 0;
-	} else if (need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
-		do_warn(_("would recreate root directory .. entry\n"));
-	}
+	fix_dotdot(mp, ino, ip, mp->m_sb.sb_rootino, "root", &need_root_dotdot);
 
 	/*
 	 * if we need to create the '.' entry, do so only if

