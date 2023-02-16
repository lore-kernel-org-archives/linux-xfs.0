Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA38C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBPUfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBPUfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:35:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B6E4AFD3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:35:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F9CDB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386CFC433EF;
        Thu, 16 Feb 2023 20:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579701;
        bh=BtOLDm4HxIdB1HRsNu+7D42qER5e/a2S4t94XvAss9U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EETjdDZgdvicvmO705P+kACo4gM3lGSIhnbXWM5bhSvUOnhhRQLhjVru3Rvc63vTu
         EZF5J4ZloIRk0VDzR4DIEBd6IyFZrwnkKoWbW0ES2T2qRbyrotPog9gA0ORkv7MtkW
         BZ8QJRLCRuf2ftvXQIu32AfFaIocThCwzSJuPKBUTQ3AAV4GjareLqo6kJFmvI2PuP
         dfJY3Lyiyjdz/rk0N4ejamMZh/oc7XFb8Y52AreEZONW2YrI6iUJryNUP8jkRV7l1k
         FdX6yVX6n2Ra3frx5wn5xxrg9X0cDKDbObH+YQ1W+ZBArbYbbIeQyXxiNYa+w+PJ/o
         Q4wfJntX05h1g==
Date:   Thu, 16 Feb 2023 12:35:00 -0800
Subject: [PATCH 09/28] xfs: get directory offset when removing directory name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Mark Tinguely <tinguely@sgi.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872502.3473407.9632936076429548132.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       |    6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       |    3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c |    4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  |    5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    |    2 ++
 fs/xfs/xfs_inode.c             |    4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 69a6561c22cc..891c1f701f53 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d96954478696..0c2d7c0af78f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 143de4202cf4..e5ed8bdef9fe 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2508,7 +2508,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3098,7 +3098,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;

