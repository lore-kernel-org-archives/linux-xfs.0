Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E014C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 23:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356067AbiDZXsH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 19:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244233AbiDZXsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 19:48:07 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 355BC286EF
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 16:44:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6527B10E5D84
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 09:44:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njUrY-004wJj-Ax
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 09:44:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njUrY-002rVq-9h
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 09:44:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] metadump: be careful zeroing corrupt inode forks
Date:   Wed, 27 Apr 2022 09:44:51 +1000
Message-Id: <20220426234453.682296-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426234453.682296-1-david@fromorbit.com>
References: <20220426234453.682296-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=626883f9
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=DwZukzHEvXsYz4mduZ0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When a corrupt inode fork is encountered, we can zero beyond the end
of the inode if the fork pointers are sufficiently trashed. We
should not trust the fork pointers when corruption is detected and
skip the zeroing in this case. We want metadump to capture the
corruption and so skipping the zeroing will give us the best chance
of preserving the corruption in a meaningful state for diagnosis.

Reported-by: Sean Caron <scaron@umich.edu>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index a21baa2070d9..3948d36e4d5c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2308,18 +2308,34 @@ process_inode_data(
 {
 	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			if (obfuscate || zero_stale_data)
-				switch (itype) {
-					case TYP_DIR2:
-						process_sf_dir(dip);
-						break;
+			if (!(obfuscate || zero_stale_data))
+				break;
+
+			/*
+			 * If the fork size is invalid, we can't safely do
+			 * anything with this fork. Leave it alone to preserve
+			 * the information for diagnostic purposes.
+			 */
+			if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
+				print_warning(
+"Invalid data fork size (%d) in inode %llu, preserving contents!",
+						XFS_DFORK_DSIZE(dip, mp),
+						(long long)cur_ino);
+				break;
+			}
 
-					case TYP_SYMLINK:
-						process_sf_symlink(dip);
-						break;
+			switch (itype) {
+				case TYP_DIR2:
+					process_sf_dir(dip);
+					break;
 
-					default: ;
-				}
+				case TYP_SYMLINK:
+					process_sf_symlink(dip);
+					break;
+
+				default:
+					break;
+			}
 			break;
 
 		case XFS_DINODE_FMT_EXTENTS:
@@ -2341,6 +2357,19 @@ process_dev_inode(
 				      (unsigned long long)cur_ino);
 		return;
 	}
+
+	/*
+	 * If the fork size is invalid, we can't safely do anything with
+	 * this fork. Leave it alone to preserve the information for diagnostic
+	 * purposes.
+	 */
+	if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
+		print_warning(
+"Invalid data fork size (%d) in inode %llu, preserving contents!",
+				XFS_DFORK_DSIZE(dip, mp), (long long)cur_ino);
+		return;
+	}
+
 	if (zero_stale_data) {
 		unsigned int	size = sizeof(xfs_dev_t);
 
-- 
2.35.1

