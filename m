Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E26AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBPUzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBPUzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:55:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACF0505E5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:55:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3173CB82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D88C433D2;
        Thu, 16 Feb 2023 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580904;
        bh=Z3Lw5ZvmezaF8bLXrPt3M56f9esv7E5Ds1nxUwDNbHw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Q02I7aw9EX7thmV2YPqg9B36vINv/8OcqUQoO3upRHnQTpsJ5GwIEPYDBx8//peIQ
         aQLTHODDUyy7kNfk4Sub51V/bw1OGgRcr0Yn4WXRPi8wH6EAdK07RZLQriN8MklU4H
         pPyjk0veycLfMsgjpRAP0e9UVlcKCBBZRdPyzyJl7dD2rnHHAPvwJMOqswXJqEPkzn
         tzPwM9XDJkkpmI/+oC607qC8HLCziCtFeu45t+8KKcoQ9eC1RhtQHrYgPS6uKvqVQW
         Z+BglZT/UVvIz6P5ng+DK/CuGqvpWBo10FRcgvgHcLcRi7HsxZ5RdZ4QYYqJq0X7Rs
         Aq5dawGuGdgWA==
Date:   Thu, 16 Feb 2023 12:55:04 -0800
Subject: [PATCH 06/25] xfsprogs: get directory offset when replacing a
 directory name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Mark Tinguely <tinguely@sgi.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657878979.3476112.559762145986643324.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c       |    8 ++++++--
 libxfs/xfs_dir2.h       |    2 +-
 libxfs/xfs_dir2_block.c |    4 ++--
 libxfs/xfs_dir2_leaf.c  |    1 +
 libxfs/xfs_dir2_node.c  |    1 +
 libxfs/xfs_dir2_sf.c    |    2 ++
 repair/phase6.c         |    2 +-
 7 files changed, 14 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 6aa1db0e..43b4e46b 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -481,7 +481,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -497,7 +497,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -545,6 +546,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 0c2d7c0a..ff59f009 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 43b9c18f..c743fa67 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -882,9 +882,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index ee9cfbe9..1be7773e 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1521,6 +1521,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index ac6a7089..621e8bf5 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2239,6 +2239,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 4dc74734..6a128748 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index d1e9c0d9..a347c390 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1122,7 +1122,7 @@ mv_orphanage(
 			if (entry_ino_num != orphanage_ino)  {
 				err = -libxfs_dir_replace(tp, ino_p,
 						&xfs_name_dotdot, orphanage_ino,
-						nres);
+						nres, NULL);
 				if (err)
 					do_error(
 	_("name replace op failed (%d)\n"), err);

