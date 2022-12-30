Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60ECC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiLaCT3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiLaCT2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:19:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EF213F7E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 363E7B81DEE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00597C433EF;
        Sat, 31 Dec 2022 02:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453165;
        bh=TdzREApLQdBiYKfgFuSm3Tcx6ce7qxjkNKGTn4kMRhA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bOHIg5HRWom7uit+H/G4kwhq7ttQ1Wu9fTOFXZw1kQ3ceaeO4g+LS69uYhlnBds78
         G2C7ESQ0NzJCJ9HP3xGd48j+rgyAHxdCTKz2WJceEzQL45t8h1UgKvocsQrdXMO595
         /LYvg5Bkr8DCD/x1m/HSdoc+WVUPgvlQIlAPgWROjY+YMgyx9eBlpzjALPfeg1/ebH
         B4jn6UN+BmhQHGvcTl0xs8eWLp2kSS0AdwOpiGfOm0og2AX38vQt9mtFkh1L29oeiV
         PccptqHF5ckZ09NoV693wEeyJO2Y84+jSZfUUk2Vwz1NsC+7MoVBwlvjX8ixV47t8I
         x1ycJeFbV6Cbg==
Subject: [PATCH 37/46] xfs_repair: pass private data pointer to scan_lbtree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876417.725900.8741153554130772958.stgit@magnolia>
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

Pass a private data pointer through scan_lbtree.  We'll use this
later when scanning the rtrmapbt to keep track of scan state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   11 +++++++----
 repair/scan.h   |    7 +++++--
 3 files changed, 13 insertions(+), 7 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index eae64a0556f..4e402d1bd59 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -836,7 +836,7 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic,
+				&cursor, 1, check_dups, magic, NULL,
 				&xfs_bmbt_buf_ops))
 			return(1);
 		/*
diff --git a/repair/scan.c b/repair/scan.c
index ff51eb0a602..42b37dd22ec 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -139,7 +139,8 @@ scan_lbtree(
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				uint64_t		magic),
+				uint64_t		magic,
+				void			*priv),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -150,6 +151,7 @@ scan_lbtree(
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
+	void		*priv,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf	*bp;
@@ -181,7 +183,7 @@ scan_lbtree(
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
 			bm_cursor, isroot, check_dups, &dirty,
-			magic);
+			magic, priv);
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
@@ -210,7 +212,8 @@ scan_bmapbt(
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	uint64_t		magic)
+	uint64_t		magic,
+	void			*priv)
 {
 	int			i;
 	int			err;
@@ -495,7 +498,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic,
+				bm_cursor, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
diff --git a/repair/scan.h b/repair/scan.h
index ee16362b6d3..4da788becbe 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -26,7 +26,8 @@ int scan_lbtree(
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				uint64_t		magic),
+				uint64_t		magic,
+				void			*priv),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
@@ -37,6 +38,7 @@ int scan_lbtree(
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
+	void		*priv,
 	const struct xfs_buf_ops *ops);
 
 int scan_bmapbt(
@@ -53,7 +55,8 @@ int scan_bmapbt(
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	uint64_t		magic);
+	uint64_t		magic,
+	void			*priv);
 
 void
 scan_ags(

