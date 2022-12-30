Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20BBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiLaDDT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaDDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:03:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857715816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2649DB81E5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D795BC433EF;
        Sat, 31 Dec 2022 03:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455794;
        bh=tEkjRm4ku7NPXuaX8jwNJBiR0+K2uSDSZGn26ttWfdg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ULqNhMoOgS1YUdKsnj/vLiapCZiU6s06PLTduPemnnbTH/Z572bffOy+q07tfaC55
         MkJMU0ygY55V7AsOWAzaPxQElKF1pU89KZRfWLgWLZxKjIBxTtnwXSlSdL2G0S4TsA
         S/cXtP77QeBD85NxMufs3ZxeDcbDdFwNrZwfIvDXswdJfBKOX1aAUy/lmyjoZ1qlOQ
         4dlsM5fNmpncBIfU/PC1e2bsRmzoSRDQg7gY3hY3xanQPAVAdHzXxdwLPtw4lJcKxa
         1WaxDEX4hIu5gJ6HoOjFOJa6WRIEwpmvEWrMqtyos5+s/CJjoEVXwjypOJGBAtnvD+
         E9r0E6dfDY3Gg==
Subject: [PATCH 35/41] xfs_repair: reject unwritten shared extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881232.734096.17583818311876691089.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We don't allow sharing of unwritten extents, which means that repair
should reject an unwritten extent if someone else has already claimed
the space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 1322f31d47e..1ef93d7aa8e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -277,7 +277,8 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 			break;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			if (xfs_has_rtreflink(mp))
+			if (xfs_has_rtreflink(mp) &&
+			    irec->br_state == XFS_EXT_NORM)
 				break;
 			set_rtbmap(ext, XR_E_MULT);
 			break;
@@ -353,8 +354,14 @@ _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt
 			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			if (xfs_has_rtreflink(mp))
-				break;
+			if (xfs_has_rtreflink(mp)) {
+				if (irec->br_state == XFS_EXT_NORM)
+					break;
+				do_warn(
+_("data fork in rt inode %" PRIu64 " claims shared unwritten rt extent %" PRIu64 "\n"),
+					ino, b);
+				return 1;
+			}
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -671,8 +678,14 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				if (type == XR_INO_DATA &&
-				    xfs_has_reflink(mp))
-					break;
+				    xfs_has_reflink(mp)) {
+					if (irec.br_state == XFS_EXT_NORM)
+						break;
+					do_warn(
+_("%s fork in %s inode %" PRIu64 " claims shared unwritten block %" PRIu64 "\n"),
+						forkname, ftype, ino, b);
+					goto done;
+				}
 				do_warn(
 _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);

