Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAC1C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiLaCvj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCvi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:51:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9331928C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:51:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC86DB81E71
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7915DC433EF;
        Sat, 31 Dec 2022 02:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455094;
        bh=bZtO5j5ajdc5lWxAccdPuyj4y27rvFW8DwS6gp8pd+k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UkjtvaM9yVpTOZDrlgwvKLdpJ3kZ8PRH04myu1V2RKvyROJzTxj6liaefS3+F1TEF
         Nofjd90vShmtxDgQTEkgJI5PH8FPTBQaFr1aBXKLYYUVc2Jl8zs+HXpMA4RMo6jyBo
         6iHCVoC0AEUr/+Zwrn6c9FDuXNSIEv8usfZ/bFFur+N5ewa8Sw5F7YDxmEl/sNtDQu
         xBjJQUtIYfIibGOlgly0IWiqB8F5cJis966IzHNkYSoQWwsRyViwKAiasft7rUx6f/
         5T8s7LYNSUdHdFMPERplVyKO5Iv9m3MKiaZEfMhMzbUew3oDVim9oTM5l6szAmvpmh
         r963qJ7kICU5A==
Subject: [PATCH 35/41] xfs_repair: always check realtime file mappings against
 incore info
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880058.732820.6595131423616289459.stgit@magnolia>
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

Curiously, the xfs_repair code that processes data fork mappings of
realtime files doesn't actually compare the mappings against the incore
state map during the !check_dups phase (aka phase 3).  As a result, we
lose the opportunity to clear damaged realtime data forks before we get
to crosslinked file checking in phase 4, which results in ondisk
metadata errors calling do_error, which aborts repair.

Split the process_rt_rec_state code into two functions: one to check the
mapping, and another to update the incore state.  The first one can be
called to help us decide if we're going to zap the fork, and the second
one updates the incore state if we decide to keep the fork.  We already
do this for regular data files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 8 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 782a36172ad..b2c27984671 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -219,7 +219,7 @@ _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
 	return 0;
 }
 
-static int
+static void
 process_rt_rec_state(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -263,11 +263,78 @@ _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d
 			set_rtbmap(ext, zap_metadata ? XR_E_METADATA :
 						       XR_E_INUSE);
 			break;
+		case XR_E_BAD_STATE:
+			do_error(
+_("bad state in rt extent map %" PRIu64 "\n"),
+				ext);
 		case XR_E_METADATA:
+		case XR_E_FS_MAP:
+		case XR_E_INO:
+		case XR_E_INUSE_FS:
+			break;
+		case XR_E_INUSE:
+		case XR_E_MULT:
+			set_rtbmap(ext, XR_E_MULT);
+			break;
+		case XR_E_FREE1:
+		default:
 			do_error(
+_("illegal state %d in rt extent %" PRIu64 "\n"),
+				state, ext);
+		}
+		b += mp->m_sb.sb_rextsize;
+	} while (b < irec->br_startblock + irec->br_blockcount);
+}
+
+/*
+ * Checks the realtime file's data mapping against in-core extent info, and
+ * complains if there are discrepancies.  Returns 0 if good, 1 if bad.
+ */
+static int
+check_rt_rec_state(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_fsblock_t		b = irec->br_startblock;
+	xfs_rtblock_t		ext;
+	int			state;
+
+	do {
+		ext = (xfs_rtblock_t)b / mp->m_sb.sb_rextsize;
+		state = get_rtbmap(ext);
+
+		if ((b % mp->m_sb.sb_rextsize) != 0) {
+			/*
+			 * We are midway through a partially written extent.
+			 * If we don't find the state that gets set in the
+			 * other clause of this loop body, then we have a
+			 * partially *mapped* rt extent and should complain.
+			 */
+			if (state != XR_E_INUSE && state != XR_E_FREE) {
+				do_warn(
+_("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
+					ino, ext, state, b);
+				return 1;
+			}
+
+			b = roundup(b, mp->m_sb.sb_rextsize);
+			continue;
+		}
+
+		/*
+		 * This is the start of an rt extent.  Complain if there are
+		 * conflicting states.  We'll set the state elsewhere.
+		 */
+		switch (state)  {
+		case XR_E_FREE:
+		case XR_E_UNKNOWN:
+			break;
+		case XR_E_METADATA:
+			do_warn(
 _("data fork in rt inode %" PRIu64 " found metadata file block %" PRIu64 " in rt bmap\n"),
 				ino, ext);
-			break;
+			return 1;
 		case XR_E_BAD_STATE:
 			do_error(
 _("bad state in rt extent map %" PRIu64 "\n"),
@@ -275,12 +342,12 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 		case XR_E_FS_MAP:
 		case XR_E_INO:
 		case XR_E_INUSE_FS:
-			do_error(
+			do_warn(
 _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt bmap\n"),
 				ino, ext);
+			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			set_rtbmap(ext, XR_E_MULT);
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -341,13 +408,18 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 		return 1;
 	}
 
-	if (check_dups)
-		bad = process_rt_rec_dups(mp, ino, irec);
-	else
-		bad = process_rt_rec_state(mp, ino, zap_metadata, irec);
+	bad = check_rt_rec_state(mp, ino, irec);
 	if (bad)
 		return bad;
 
+	if (check_dups) {
+		bad = process_rt_rec_dups(mp, ino, irec);
+		if (bad)
+			return bad;
+	} else {
+		process_rt_rec_state(mp, ino, zap_metadata, irec);
+	}
+
 	/*
 	 * bump up the block counter
 	 */

