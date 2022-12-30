Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499F8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbiLaCfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiLaCfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:35:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF87DEC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:35:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81EA761CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF12C433D2;
        Sat, 31 Dec 2022 02:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454144;
        bh=unpgNZfxjEoyvL5ZlWrJgvV6Ich17jWYciJwAYB2OOc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HyWy/1LCmIJOnl9RqLo6x9td5RKtoK3OiJnUQU1NgDsmM8XVJWu+14nXuZsYA5qbg
         stGenVHawskMSEL/SL5t+stXhPsU/Vka2FF56x4qT13f4qs0XqKu6D3E5lLpNeurSW
         a51Mdhag4s2FtOdam8WgSqEaIvjX3BbZqGpHr/TWf47ee+x0ycge+q4Rg3/oHpxNji
         mvl8BovDfFSVdnGQdYgFdw2uO+6fQyLwPL2xMqlMzTETsGsSy3wHD47/0H4ywFuXe6
         pqxQPW9gufVDbFSPxJNXSIdVFocAk0FxcEGvgSmqFwwQIlWrA2TVx4K0i7agxRUJzd
         1oGANpqGgDQoA==
Subject: [PATCH 22/45] xfs_repair: improve rtbitmap discrepancy reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878653.731133.7580105112892217687.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Improve the reporting of discrepancies in the realtime bitmap and
summary files by creating a separate helper function that will pinpoint
the exact (word) locations of mismatches.  This will help developers to
diagnose problems with the rtgroups feature and users to figure out
exactly what's bad in a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/rt.c |   42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)


diff --git a/repair/rt.c b/repair/rt.c
index 33bc6836f71..ed0f744cb9f 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -124,6 +124,44 @@ generate_rtinfo(
 	return(0);
 }
 
+static void
+check_rtwords(
+	struct xfs_mount	*mp,
+	const char		*filename,
+	unsigned long long	bno,
+	void			*ondisk,
+	void			*incore)
+{
+	unsigned int		wordcnt = mp->m_blockwsize;
+	union xfs_rtword_ondisk	*o = ondisk, *i = incore;
+	int			badstart = -1;
+	unsigned int		j;
+
+	if (memcmp(ondisk, incore, wordcnt << XFS_WORDLOG) == 0)
+		return;
+
+	for (j = 0; j < wordcnt; j++, o++, i++) {
+		if (o->raw == i->raw) {
+			/* Report a range of inconsistency that just ended. */
+			if (badstart >= 0)
+				do_warn(
+ _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, bno, badstart, j - 1, wordcnt);
+			badstart = -1;
+			continue;
+		}
+
+		if (badstart == -1)
+			badstart = j;
+	}
+
+	if (badstart >= 0)
+		do_warn(
+ _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, bno, badstart, wordcnt,
+					wordcnt);
+}
+
 static void
 check_rtfile_contents(
 	struct xfs_mount	*mp,
@@ -180,9 +218,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
-			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
-					filename, (unsigned long long)bno);
+		check_rtwords(mp, filename, bno, bp->b_addr, buf);
 
 		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
 		bno += map.br_blockcount;

