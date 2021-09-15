Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB0EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F6B600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhIOXKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhIOXKV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BA2610A4;
        Wed, 15 Sep 2021 23:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747342;
        bh=IJY4VSKU/c1XjznWOK2gBGv+4sv640X02iYuXmsrf5U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wfxz5I9zGBF2wmR2cq3aFFrIHnW3B2lISC5lkUa07sFY8hkGXdONPgUmtpgRR3OB2
         HYKUdq1Pm2fCxf5H91txmgsFSDSJsfJghOJfHcMXNhkA7QLIltV6MKKNCYmyy3xEvX
         jwzbyIJAp3ZDLqI5SJWZLElK7e9K5SYyKXUffZtQWf5Spu7mzIRbo9nhpKXBA1eeps
         dQt+7IDy6urR02LH60cwSqFW+cooxB60QRDbWXLIHUcQKtRehKWSIOPnDaKnIdl5Vq
         lBVnWDbJ+1h7iWgz19fRzJiXxJ6M3Ye+Nyj5RPhjLwBZcmM/bxhRDMcMToomEQUthO
         xKJGi2/dQd3tw==
Subject: [PATCH 27/61] xfs: convert secondary superblock walk to use perags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:02 -0700
Message-ID: <163174734210.350433.12989090066989669635.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 7f8d3b3ca6fe9269b3c5deee0dcea38499288e06

Clean up the last external manual AG walk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_sb.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ec08fd13..b2e214ee 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_health.h"
+#include "xfs_ag.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -853,17 +854,18 @@ int
 xfs_update_secondary_sbs(
 	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = 1;
 	int			saved_error = 0;
 	int			error = 0;
 	LIST_HEAD		(buffer_list);
 
 	/* update secondary superblocks. */
-	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag_from(mp, agno, pag) {
 		struct xfs_buf		*bp;
 
 		error = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
 				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
@@ -875,7 +877,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
-				agno);
+				pag->pag_agno);
 			if (!saved_error)
 				saved_error = error;
 			continue;
@@ -896,7 +898,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"write error %d updating a secondary superblock near ag %d",
-				error, agno);
+				error, pag->pag_agno);
 			if (!saved_error)
 				saved_error = error;
 			continue;

