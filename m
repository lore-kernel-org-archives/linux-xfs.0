Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DA1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiLaCts (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:49:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C15D12D0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AB7761BC8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878A5C433EF;
        Sat, 31 Dec 2022 02:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454985;
        bh=lIxgmdWv55Ls7ROZ5r1HeLl7zc5GhBy93ziAqFiFk+4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b8o0mBRs9Nsx7C2jBvN+FdDjjyvzWKWgZrBsLW6pgFjr3ydGHDUij7HRD8o0JxSdN
         2xhCNC6G+6NmSW6QUAPsbPCrLg7pWHv/XWcqO3RSBqD5ABFNQ5v29NyVsbn6rctEWc
         +8ezQdyBFx5ILVcRZoOZCr2iOsh2V8172N0pt0VkasPdYLbSbakTCTlLRuI77F0Syd
         OwzWcU0QWl7rC4XN9vg2ziTJapPKmfUH9YnBUig+VPtJXfEu7cuAnqQk+mylQEdtdj
         mK6A8imxChdTpUuan8/54xsacClctryVxpFaHvUDbCMOsq1zmFzacBgehq5imcjs3l
         9zHIDMk5Fym1Q==
Subject: [PATCH 28/41] xfs_repair: flag suspect long-format btree blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879965.732820.15407131984794375398.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass a "suspect" counter through scan_lbtree just like we do for
short-format btree blocks, and increment its value when we encounter
blocks with bad CRCs or outright corruption.  This makes it so that
repair actually catches bmbt blocks with bad crcs or other verifier
errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    2 +-
 repair/scan.c   |   15 ++++++++++++---
 repair/scan.h   |    3 +++
 3 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 2674dac605e..36cb5cfcc70 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -872,7 +872,7 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic,
+				&cursor, 0, 1, check_dups, magic,
 				(void *)zap_metadata, &xfs_bmbt_buf_ops))
 			return(1);
 		/*
diff --git a/repair/scan.c b/repair/scan.c
index 7a377222c91..4573c25a577 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -136,6 +136,7 @@ scan_lbtree(
 				xfs_extnum_t		*nex,
 				blkmap_t		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
+				int			suspect,
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
@@ -148,6 +149,7 @@ scan_lbtree(
 	xfs_extnum_t	*nex,
 	blkmap_t	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
+	int		suspect,
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
@@ -167,6 +169,12 @@ scan_lbtree(
 			XFS_FSB_TO_AGBNO(mp, root));
 		return(1);
 	}
+	if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
+		do_warn(_("btree block %d/%d is suspect, error %d\n"),
+			XFS_FSB_TO_AGNO(mp, root),
+			XFS_FSB_TO_AGBNO(mp, root), bp->b_error);
+		suspect++;
+	}
 
 	/*
 	 * only check for bad CRC here - caller will determine if there
@@ -182,7 +190,7 @@ scan_lbtree(
 
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
-			bm_cursor, isroot, check_dups, &dirty,
+			bm_cursor, suspect, isroot, check_dups, &dirty,
 			magic, priv);
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
@@ -209,6 +217,7 @@ scan_bmapbt(
 	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
+	int			suspect,
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
@@ -514,7 +523,7 @@ _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 		err = scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt,
 				type, whichfork, ino, tot, nex, blkmapp,
-				bm_cursor, 0, check_dups, magic, priv,
+				bm_cursor, suspect, 0, check_dups, magic, priv,
 				&xfs_bmbt_buf_ops);
 		if (err)
 			return(1);
@@ -582,7 +591,7 @@ _("bad fwd (right) sibling pointer (saw %" PRIu64 " should be NULLFSBLOCK)\n"
 				be64_to_cpu(pkey[numrecs - 1].br_startoff);
 	}
 
-	return(0);
+	return suspect > 0 ? 1 : 0;
 }
 
 static void
diff --git a/repair/scan.h b/repair/scan.h
index 4da788becbe..aeaf9f1a7f4 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -23,6 +23,7 @@ int scan_lbtree(
 				xfs_extnum_t		*nex,
 				struct blkmap		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
+				int			suspect,
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
@@ -35,6 +36,7 @@ int scan_lbtree(
 	xfs_extnum_t	*nex,
 	struct blkmap	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
+	int		suspect,
 	int		isroot,
 	int		check_dups,
 	uint64_t	magic,
@@ -52,6 +54,7 @@ int scan_bmapbt(
 	xfs_extnum_t		*nex,
 	struct blkmap		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
+	int			suspect,
 	int			isroot,
 	int			check_dups,
 	int			*dirty,

