Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8238C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjBPVAi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjBPVAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:00:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D357D505D9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37225CE2BC8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D20C4339B;
        Thu, 16 Feb 2023 21:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581232;
        bh=ywFQWDjqmWCgkZ2p0AZ5qIPBFt5uC8TIBbmnpDqkSqs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CDyqnJX+wzLL0jJbh7g3UHnJWZ/CbPNFKmBpFiikAkbD+Ne4H3qnURTOx9lgDWeRa
         dfUQlOe+0tXnvd+VjIJkE/FgkhVMOR4TrDD1uswJk1ywBYNx07d9rGv32pSjnRR9me
         CGDLVrGvAXFGQyngOg66kI/WTXu6EO5evHXVYOtfVvSIG2vTk0juozZerLUgxE7Ye9
         GvuoM4t/uN5NNLFafPxZGqO1renzeODlH4TsdXbrEsZqWz/7RZxPhAwnWiCs1ctbat
         72mvkTagkp7KvQYey+ehLpqpowzz3/QGnbr8nVkZgXBl7uqCrU/RZAY/NCUVzNTnug
         Vz5zmj1uepoUA==
Date:   Thu, 16 Feb 2023 13:00:32 -0800
Subject: [PATCH 2/6] xfs: directory lookups should return diroffsets too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879560.3476725.3323720669075001986.stgit@magnolia>
In-Reply-To: <167657879533.3476725.4672667573997149436.stgit@magnolia>
References: <167657879533.3476725.4672667573997149436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the directory lookup functions to return the dir offset of the
dirent that it finds.  Online fsck will use this when checking and
repairing filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2_block.c |    2 ++
 libxfs/xfs_dir2_leaf.c  |    2 ++
 libxfs/xfs_dir2_node.c  |    2 ++
 libxfs/xfs_dir2_sf.c    |    4 ++++
 4 files changed, 10 insertions(+)


diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index c743fa67..1ed3c974 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -746,6 +746,8 @@ xfs_dir2_block_lookup_int(
 		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
+			args->offset = xfs_dir2_byte_to_dataptr(
+					(char *)dep - (char *)hdr);
 			*bpp = bp;
 			*entno = mid;
 			if (cmp == XFS_CMP_EXACT)
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 1be7773e..9ec01d02 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1298,6 +1298,8 @@ xfs_dir2_leaf_lookup_int(
 		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
+			args->offset = xfs_dir2_db_off_to_dataptr(args->geo,
+					newdb, (char *)dep - (char *)dbp->b_addr);
 			*indexp = index;
 			/* case exact match: return the current buffer. */
 			if (cmp == XFS_CMP_EXACT) {
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 621e8bf5..b00fb3cf 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -884,6 +884,8 @@ xfs_dir2_leafn_lookup_for_entry(
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
 			args->filetype = xfs_dir2_data_get_ftype(mp, dep);
+			args->offset = xfs_dir2_db_off_to_dataptr(args->geo,
++					newdb, (char *)dep - (char *)curbp->b_addr);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 6a128748..9356bf62 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -889,6 +889,7 @@ xfs_dir2_sf_lookup(
 		args->inumber = dp->i_ino;
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
+		args->offset = 1;
 		return -EEXIST;
 	}
 	/*
@@ -899,6 +900,7 @@ xfs_dir2_sf_lookup(
 		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
+		args->offset = 2;
 		return -EEXIST;
 	}
 	/*
@@ -917,6 +919,8 @@ xfs_dir2_sf_lookup(
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 			args->filetype = xfs_dir2_sf_get_ftype(mp, sfep);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			if (cmp == XFS_CMP_EXACT)
 				return -EEXIST;
 			ci_sfep = sfep;

