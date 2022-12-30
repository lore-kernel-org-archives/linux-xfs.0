Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC09C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiLaCiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiLaChh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:37:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE57BC95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B370B81C22
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB14C433EF;
        Sat, 31 Dec 2022 02:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454253;
        bh=aFf6OOBBrcWaH38lfwNi3I8sVBAnhW0EqEZV6yZVj7E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ey1Ao4yQ9mqPAkiZDFDm3XcL0e4WAEtSoSbKI40SObW2DMVwPnjv5VoT2JnlgAYas
         J+JobLARB54UXw4gv/pjEhZJpSQ+/YIJwSzC5GN9fVrLPp3LzUyVWt1caTru8iyPMv
         CDV2PHjqqnwSUMIYvT2KSNw7ACMU/OG+GYEaT2QEvHETFJm3EGNcq2KyPxK6YMZCd8
         YOU5+z7iKbBVCFLxgq2fklZPGZbInG4Vk+YPaING8Cu64ffIxwtTgnhEb2PgclOraM
         M2EkY+V6SlpSYYq8VM4OdT5KZnMz4ejjqz5gONlE5C2VAg3LLnG09kel83UIBGa0Yp
         sRXacHABSwy+g==
Subject: [PATCH 29/45] xfs_db: implement check for rt superblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878744.731133.5132949239718266830.stgit@magnolia>
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

Implement the bare minimum needed to avoid xfs_check regressions when
realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/db/check.c b/db/check.c
index 4f4bff58e22..d3d22f0531c 100644
--- a/db/check.c
+++ b/db/check.c
@@ -56,6 +56,7 @@ typedef enum {
 	DBM_BTREFC,
 	DBM_RLDATA,
 	DBM_COWDATA,
+	DBM_RTSB,
 	DBM_NDBM
 } dbm_t;
 
@@ -187,6 +188,7 @@ static const char	*typename[] = {
 	"btrefcnt",
 	"rldata",
 	"cowdata",
+	"rtsb",
 	NULL
 };
 
@@ -809,6 +811,23 @@ blockfree_f(
 	return 0;
 }
 
+static void
+rtgroups_init(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		xfs_rtblock_t	rtbno;
+
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+		set_rdbmap(rtbno, mp->m_sb.sb_rextsize, DBM_RTSB);
+	}
+}
+
 /*
  * Check consistency of xfs filesystem contents.
  */
@@ -843,6 +862,7 @@ blockget_f(
 				 "filesystem.\n"));
 		}
 	}
+	rtgroups_init(mp);
 	if (blist_size) {
 		xfree(blist);
 		blist = NULL;

