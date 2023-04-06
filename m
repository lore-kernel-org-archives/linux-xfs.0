Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87881C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjDFT1N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFT1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:27:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4096D5FC8
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04D564B3D
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCA1C4339B;
        Thu,  6 Apr 2023 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809230;
        bh=9Xy4JOf5xOh8/BpbVJ2Z0+Pib711HFf7U1hlYFH8Bp8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NHBjT7BRJ9Kmq4a3OL0oix+LErt2Db0CTOfW5rHni3F9rJNzYVWNGgheQBvMBogd8
         gXpyLTXUcNa/N1V2r41DkjmwVTJK+Dlvz57BEffl+1OXM4wQssaCqCI2wQkY06G+SN
         5JbXXfWfaPh7r4i5FFgp89ixuyLKBqeo2+7KMuwpcRW2QH5SLhJMl7g0zQni+rQaq1
         GeI018nWkMrRpZqLPcp86tqt2YFfHpSn1WeEUyPXz6GK546J8UL87SPg5ndR6I7ixB
         qANY8tYm8UREt0cgaR9CdQGQQS5GNCjZgROedySa2Mj/MrSxoNn4hwRR3hcNPTixxQ
         ecdaF7PNhAB5g==
Date:   Thu, 06 Apr 2023 12:27:09 -0700
Subject: [PATCH 3/3] xfs: compare generated and existing dirents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825323.615785.1816381633759007236.stgit@frogsfrogsfrogs>
In-Reply-To: <168080825278.615785.11418750801629760336.stgit@frogsfrogsfrogs>
References: <168080825278.615785.11418750801629760336.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check our work to make sure we found all the dirents that the original
directory had.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |   75 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h      |    1 +
 2 files changed, 74 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index c484e6f36ca0..1e253feaa15d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -746,7 +746,10 @@ xrep_dir_scan_dirtree(
 	return 0;
 }
 
-/* Dump a dirent from the temporary dir. */
+/*
+ * Dump a dirent from the temporary dir and check it against the dir we're
+ * rebuilding.  We are not committing any of this.
+ */
 STATIC int
 xrep_dir_dump_tempdir(
 	struct xfs_scrub	*sc,
@@ -757,8 +760,10 @@ xrep_dir_dump_tempdir(
 	void			*priv)
 {
 	struct xrep_dir		*rd = priv;
+	xfs_ino_t		child_ino;
 	bool			child_dirent = true;
-	int			error = 0;
+	bool			compare_dirent = true;
+	int			error;
 
 	/*
 	 * The tempdir was created with a dotdot entry pointing to the root
@@ -781,11 +786,30 @@ xrep_dir_dump_tempdir(
 	}
 	if (xrep_dir_samename(name, &xfs_name_dot)) {
 		child_dirent = false;
+		compare_dirent = false;
 		ino = sc->ip->i_ino;
 	}
 
 	trace_xrep_dir_dumpname(sc->tempip, name, ino);
 
+	/* Check that the dir being repaired has the same entry. */
+	if (compare_dirent) {
+		error = xchk_dir_lookup(sc, sc->ip, name, &child_ino);
+		if (error == -ENOENT) {
+			trace_xrep_dir_checkname(sc->ip, name, NULLFSINO);
+			ASSERT(error != -ENOENT);
+			return -EFSCORRUPTED;
+		}
+		if (error)
+			return error;
+
+		if (ino != child_ino) {
+			trace_xrep_dir_checkname(sc->ip, name, child_ino);
+			ASSERT(ino == child_ino);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	/*
 	 * Set ourselves up to free every dirent in the tempdir because
 	 * directory inactivation won't do it for us.  The rest of the online
@@ -801,6 +825,49 @@ xrep_dir_dump_tempdir(
 	return error;
 }
 
+/*
+ * Dump a dirent from the dir we're rebuilding and check it against the
+ * temporary dir.  This assumes that the directory wasn't really corrupt to
+ * begin with.
+ */
+STATIC int
+xrep_dir_dump_baddir(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	xfs_ino_t		child_ino;
+	int			error;
+
+	/* Ignore the directory's dot and dotdot entries. */
+	if (xrep_dir_samename(name, &xfs_name_dotdot) ||
+	    xrep_dir_samename(name, &xfs_name_dot))
+		return 0;
+
+	trace_xrep_dir_dumpname(sc->ip, name, ino);
+
+	/* Check that the tempdir has the same entry. */
+	error = xchk_dir_lookup(sc, sc->tempip, name, &child_ino);
+	if (error == -ENOENT) {
+		trace_xrep_dir_checkname(sc->tempip, name, NULLFSINO);
+		ASSERT(error != -ENOENT);
+		return -EFSCORRUPTED;
+	}
+	if (error)
+		return error;
+
+	if (ino != child_ino) {
+		trace_xrep_dir_checkname(sc->tempip, name, child_ino);
+		ASSERT(ino == child_ino);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 /*
  * "Commit" the new directory structure to the file that we're repairing.
  *
@@ -886,6 +953,10 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
+	error = xchk_dir_walk(sc, sc->ip, xrep_dir_dump_baddir, rd);
+	if (error)
+		return error;
+
 	error = xchk_dir_walk(sc, sc->tempip, xrep_dir_dump_tempdir, rd);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index af5b5cd6d55b..d97a6bab9a4a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1279,6 +1279,7 @@ DEFINE_XREP_DIRENT_CLASS(xrep_dir_createname);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_removename);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_replacename);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_dumpname);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_checkname);
 
 DECLARE_EVENT_CLASS(xrep_dir_class,
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino),

