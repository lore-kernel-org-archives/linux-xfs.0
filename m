Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AA2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiLaCPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:15:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1598F1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB3C7B81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78281C433EF;
        Sat, 31 Dec 2022 02:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452900;
        bh=z8iBhG84YzLrOHNH7LJIhlMEoq6WDc5Tfi0seC1kojM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DarKwyxvYQyclj8ZEACS5VozALIURtR3Fcq0n4xy2oHTK38AFPgu3jnIM6cZBY7qA
         HdAznfianZ5GArEdgO03y2h3hvjlBXlrFdj7Wp7IgJ5sHJL0m/m9U1q7K2EdbfXHmg
         QqKQcBiG7V9sqGnLIQe8xZ6DQtkMOQsrlHWp3HJanpMDpbCvcCROhlkPW2OazZeWri
         k8ahUTVwcSCVcGf+PZbWxkJzuYLC72LlG16GTGPCW2OE3g9FXvh8VBmoYnWz4fgzHK
         mDTmIUmMENP+dBk+CwWg6hg92isc2pyd812hk/t6C75BohZNpB1NiRgecrVNsXBs7l
         A01jSyu4b1TRQ==
Subject: [PATCH 20/46] xfs_db: basic xfs_check support for metadir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876197.725900.17317482254140518183.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support metadata directories in xfs_check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/db/check.c b/db/check.c
index 964756d0ae5..5297ea25459 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2649,7 +2649,9 @@ process_dir(
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_("no .. entry for directory %lld\n"), id->ino);
 		error++;
-	} else if (parent == id->ino && id->ino != mp->m_sb.sb_rootino) {
+	} else if (parent == id->ino &&
+		   id->ino != mp->m_sb.sb_rootino &&
+		   id->ino != mp->m_sb.sb_metadirino) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_(". and .. same for non-root directory %lld\n"),
 				id->ino);
@@ -2659,6 +2661,11 @@ process_dir(
 			dbprintf(_("root directory %lld has .. %lld\n"), id->ino,
 				parent);
 		error++;
+	} else if (id->ino == mp->m_sb.sb_metadirino && id->ino != parent) {
+		if (!sflag || id->ilist || CHECK_BLIST(bno))
+			dbprintf(_("metadata directory %lld has .. %lld\n"),
+				id->ino, parent);
+		error++;
 	} else if (parent != NULLFSINO && id->ino != parent)
 		addparent_inode(id, parent);
 }
@@ -2902,6 +2909,9 @@ process_inode(
 		type = DBM_DIR;
 		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
+		if (xfs_has_metadir(mp) &&
+		    id->ino == mp->m_sb.sb_metadirino)
+			addlink_inode(id);
 		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
@@ -2910,18 +2920,21 @@ process_inode(
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
 			blkmap = blkmap_alloc(dnextents);
-			addlink_inode(id);
+			if (!xfs_has_metadir(mp))
+				addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
 			blkmap = blkmap_alloc(dnextents);
-			addlink_inode(id);
+			if (!xfs_has_metadir(mp))
+				addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
 			blkmap = blkmap_alloc(dnextents);
-			addlink_inode(id);
+			if (!xfs_has_metadir(mp))
+				addlink_inode(id);
 		}
 		else
 			type = DBM_DATA;

