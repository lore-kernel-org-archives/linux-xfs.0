Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F79EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiLaCYW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLaCYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:24:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C49B1A23D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:24:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B8561CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F76EC433D2;
        Sat, 31 Dec 2022 02:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453460;
        bh=envFz4Xyr9C76L8PYjmvHgOzw8NoD3P76Vlob7m2utk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y2BiLz/hTa8jIdbNVxL8mEjYRyLj7HPgLSqloL9LHLQlUye0AAO6rG3GbTdfA8l32
         7QqyIYRBUev26uBdH5TEBP0iPgLQin4zqvHq3sjbHQl5lz1HKs39IBZosLoogffsJ4
         dVwv27mq+kcV+QIoyDDR2CnY/NXyri9uoTw/oF+5y7idG8/34skt48Rh+MTLxYBPhE
         pytlHHOTB0A+63MEqGceExFzgdKCu/k4fRusRbOsdSO5i5rj3y5Gecr/sbKlXyhedV
         mQeEWc92DvbmkwHvwMUpJcdxlUjXZdjEGTLwjKvbEV1qFEQP4CBP7djVw2EpiLnvoM
         n9wdsf2Jc/8oQ==
Subject: [PATCH 10/10] mkfs: convert utility to use new rt extent helpers and
 types
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:29 -0800
Message-ID: <167243876947.727509.11538531176959854902.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the repair program to use the new realtime extent types and
helper functions instead of open-coding them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 484b5deced8..21fe2c7f972 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -913,21 +913,22 @@ rtfreesp_init(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
-	xfs_fileoff_t		bno;
-	xfs_fileoff_t		ebno;
+	xfs_rtxnum_t		rtx;
+	xfs_rtxnum_t		ertx;
 	int			error;
 
-	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
+	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx = ertx) {
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 				0, 0, 0, &tp);
 		if (error)
 			res_failed(error);
 
 		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
-		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
-			bno + NBBY * mp->m_sb.sb_blocksize);
+		ertx = XFS_RTMIN(mp->m_sb.sb_rextents,
+			rtx + NBBY * mp->m_sb.sb_blocksize);
 
-		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
+		error = -libxfs_rtfree_extent(tp, rtx,
+				(xfs_rtxlen_t)(ertx - rtx));
 		if (error) {
 			fail(_("Error initializing the realtime space"),
 				error);

