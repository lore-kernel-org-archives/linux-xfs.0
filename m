Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB6AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353302AbiEEQJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381647AbiEEQJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:09:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011F35C641
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:06:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 682CBB82C77
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C5FC385A4;
        Thu,  5 May 2022 16:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766763;
        bh=Cd6mxD+dGh/k+eAcAqlMYDFwXWanxxwEMfuqx8FvjmU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kAVUE6iTqfdnD0rztRYHG/hQanhyY0HP8Vvu7sNZ2IcRbYlD9LBVU0Ks59wtJCwal
         q2Cr/iwy2U5+pYbR8wAjj5eBnsz2OICx3GqF8SYmZHBkOEl5CI/eBwM0cQfR4hDDHJ
         ZCNX7rh53hylHN3uDxYD8MJzg+yTkABAhCI8AU2DEvzb9Le/+RfqsQLChfst1aCgsu
         6dKrT98gLWhOBuUSU7TJf4GoLVJkLuq30BYeCXWV1umy2gObKWqoyJJmDLk5LFViiz
         7Df+R7AQS2mN2gXFKLPW7+4g8ZrxDTzJDwBzUvEvgFA2bERGCzOji/iXUp6NyU2ldQ
         WXCuwVIUi+/1w==
Subject: [PATCH 3/3] xfs_repair: check the ftype of dot and dotdot directory
 entries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:06:02 -0700
Message-ID: <165176676265.248791.9813054389307375890.stgit@magnolia>
In-Reply-To: <165176674590.248791.17672675617466150793.stgit@magnolia>
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The long-format directory block checking code skips the filetype check
for the '.' and '..' entries, even though they're part of the ondisk
format.  This leads to repair failing to catch subtle corruption at the
start of a directory.

Found by fuzzing bu[0].filetype = zeroes in xfs/386.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   79 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 25 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 8fcd4d36..c04b2e09 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1400,6 +1400,48 @@ dir2_kill_block(
 _("directory shrink failed (%d)\n"), error);
 }
 
+static inline void
+check_longform_ftype(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	xfs_dir2_data_entry_t	*dep,
+	ino_tree_node_t		*irec,
+	int			ino_offset,
+	struct dir_hash_tab	*hashtab,
+	xfs_dir2_dataptr_t	addr,
+	struct xfs_da_args	*da,
+	struct xfs_buf		*bp)
+{
+	xfs_ino_t		inum = be64_to_cpu(dep->inumber);
+	uint8_t			dir_ftype;
+	uint8_t			ino_ftype;
+
+	if (!xfs_has_ftype(mp))
+		return;
+
+	dir_ftype = libxfs_dir2_data_get_ftype(mp, dep);
+	ino_ftype = get_inode_ftype(irec, ino_offset);
+
+	if (dir_ftype == ino_ftype)
+		return;
+
+	if (no_modify) {
+		do_warn(
+_("would fix ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
+			dir_ftype, ino_ftype,
+			ip->i_ino, inum);
+		return;
+	}
+
+	do_warn(
+_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
+		dir_ftype, ino_ftype,
+		ip->i_ino, inum);
+	libxfs_dir2_data_put_ftype(mp, dep, ino_ftype);
+	libxfs_dir2_data_log_entry(da, bp, dep);
+	dir_hash_update_ftype(hashtab, addr, ino_ftype);
+}
+
 /*
  * process a data block, also checks for .. entry
  * and corrects it to match what we think .. should be
@@ -1737,6 +1779,11 @@ longform_dir2_entry_check_data(
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
 			}
+
+			if (!nbad)
+				check_longform_ftype(mp, ip, dep, irec,
+						ino_offset, hashtab, addr, &da,
+						bp);
 			continue;
 		}
 		ASSERT(no_modify || libxfs_verify_dir_ino(mp, inum));
@@ -1765,6 +1812,11 @@ longform_dir2_entry_check_data(
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
 			}
+
+			if (!nbad)
+				check_longform_ftype(mp, ip, dep, irec,
+						ino_offset, hashtab, addr, &da,
+						bp);
 			*need_dot = 0;
 			continue;
 		}
@@ -1775,31 +1827,8 @@ longform_dir2_entry_check_data(
 			continue;
 
 		/* validate ftype field if supported */
-		if (xfs_has_ftype(mp)) {
-			uint8_t dir_ftype;
-			uint8_t ino_ftype;
-
-			dir_ftype = libxfs_dir2_data_get_ftype(mp, dep);
-			ino_ftype = get_inode_ftype(irec, ino_offset);
-
-			if (dir_ftype != ino_ftype) {
-				if (no_modify) {
-					do_warn(
-	_("would fix ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
-						dir_ftype, ino_ftype,
-						ip->i_ino, inum);
-				} else {
-					do_warn(
-	_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
-						dir_ftype, ino_ftype,
-						ip->i_ino, inum);
-					libxfs_dir2_data_put_ftype(mp, dep, ino_ftype);
-					libxfs_dir2_data_log_entry(&da, bp, dep);
-					dir_hash_update_ftype(hashtab, addr,
-							      ino_ftype);
-				}
-			}
-		}
+		check_longform_ftype(mp, ip, dep, irec, ino_offset, hashtab,
+				addr, &da, bp);
 
 		/*
 		 * check easy case first, regular inode, just bump

