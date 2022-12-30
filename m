Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A181C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiLaCbj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaCbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:31:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0222326D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9263061D07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D9C433EF;
        Sat, 31 Dec 2022 02:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453896;
        bh=Kucd/I1s2XDOfv2bkCm+nhzsIDA/wiQxRVD46iVhwNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dcx7352OL/7DuENqwXiJcedHBl0SQ3lFY6R1z3bHEKlNKyK4WwzagRzTUfQvvl27E
         1jrdZ4+wXq2JeMYJFPCwNo/nNdMdaylAuf2WDrxbImL5DxL8KfGqy8mUNHToxDT8dS
         g4Wfred/YC9Lf/nnvQ8u5MCmqyzfxhuAbN49CFxUs/TDb1SUSVy1+9cOkeQQtccKai
         HODidxBU8CAeZJ3Hf11T9eP5EYyljqqR0CXJL5xWsEO33OCwYpjSO6BI1t7xmE2ecN
         Vw8ensTM6n7eMxNAXAxlf0P1pQrUiBhruR72tZuOwcq1wCecNcIz0FxfMGKwhxGLZo
         G/J93ahM2ogLQ==
Subject: [PATCH 06/45] xfs: export realtime group geometry via XFS_FSOP_GEOM
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878445.731133.15326238046958531774.stgit@magnolia>
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

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |    4 +++-
 libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c4995f6557d..ba90649c54e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -186,7 +186,9 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	__u32		rgblocks;	/* rtblocks in a realtime group	*/
+	__u32		rgcount;	/* number of realtime groups	*/
+	__u64		reserved[16];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7b8baf64e82..0ba9143e7c5 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1346,6 +1346,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgblocks = sbp->sb_rgblocks;
+	}
 }
 
 /* Read a secondary superblock. */

