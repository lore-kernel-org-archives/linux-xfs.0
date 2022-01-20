Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78FCC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345162AbiATAWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59360 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiATAWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D089361514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31423C004E1;
        Thu, 20 Jan 2022 00:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638150;
        bh=N5QwqzsogWuI15WXZH6vwTEM/gRoWQTi55XYmLqUNxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n4obiMIh8B1SSidNMH3a34aQ/c8Z6NOhHYZ1hdar3pFYblKw6yp1bs/BlJfb+Sh2p
         af6mP9NfoBrpoTaBn6DVwwYmdVKff3FnPGKY4WPgl6n+o1BFu+HheFUItvLQoka81k
         Y5KgAy4JjDIMiaTIMpClhYyAanYYwAm2QnN7OhmlkOnRLOdHSoaDzDoWO6XDN/ZChY
         g7rOUwXmQUo9j/WEMYJ0F0SxLSM0o8DFz2bYjnkb2dUphb+d2iID/sFbWnKLUyTDj3
         xVJyKS6PC28vj0X3sOIKznaMu84paBpezf1j2batiM1yPWJEF498ujNsBTquFIE/c5
         Go3iZ3Sb5Om3g==
Subject: [PATCH 10/17] xfs_repair: fix indentation problems in
 upgrade_filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:29 -0800
Message-ID: <164263814991.863810.4734076377218643681.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Indentation is supposed to be tabs, not spaces.  Fix that, and unindent
the bwrite clause because do_error aborts the program.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase2.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)


diff --git a/repair/phase2.c b/repair/phase2.c
index bda834de..cfba649a 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -196,29 +196,28 @@ upgrade_filesystem(
 		return;
 
 	mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
-        if (no_modify)
-                return;
+	if (no_modify)
+		return;
 
-        bp = libxfs_getsb(mp);
-        if (!bp || bp->b_error) {
-                do_error(
+	bp = libxfs_getsb(mp);
+	if (!bp || bp->b_error)
+		do_error(
 	_("couldn't get superblock for feature upgrade, err=%d\n"),
-                                bp ? bp->b_error : ENOMEM);
-        } else {
-                libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+				bp ? bp->b_error : ENOMEM);
 
-                /*
-		 * Write the primary super to disk immediately so that
-		 * needsrepair will be set if repair doesn't complete.
-		 */
-                error = -libxfs_bwrite(bp);
-                if (error)
-                        do_error(
+	libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+
+	/*
+	 * Write the primary super to disk immediately so that needsrepair will
+	 * be set if repair doesn't complete.
+	 */
+	error = -libxfs_bwrite(bp);
+	if (error)
+		do_error(
 	_("filesystem feature upgrade failed, err=%d\n"),
-                                        error);
-        }
-        if (bp)
-                libxfs_buf_relse(bp);
+				error);
+
+	libxfs_buf_relse(bp);
 }
 
 /*

