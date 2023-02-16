Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01823C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBPUkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBPUkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:40:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440161ADE1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3D5B60A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E53C433EF;
        Thu, 16 Feb 2023 20:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580013;
        bh=xlH/6AtMMhy+NbcyAHu+BhDPGi0MOcdzdlgyIvQduQk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EU9aIRojgiuBRpJ6ktkjCWCQnZi2oO+0L+qwGIk7bO1E7FyW761fMy6++XdZrpEUw
         smMRp6yJrfs7mcxtOqDWK63xlqwovaIubVfnnXw4s18JQxHU7g8Rc/LZTxdRv88nAZ
         0fJTAaZKFaR1N9nO/fd11dR5cydzBj8k2Nn+c4NTya9yUXHoIPEZ61iyGJpRLcz+H6
         nTfxK1MtMXnrOrtNN4cWjPM+eIiKygsvo+Vu5RS9U3O12vp0mvylinaK/6idTjI630
         L0+laN29SNYz0V7mkCMysujt84BfIkR4iioVhUOkv0ONFeFVPy1NbpZcjjINbIhhp2
         T49b9DfyWtJ1Q==
Date:   Thu, 16 Feb 2023 12:40:12 -0800
Subject: [PATCH 1/3] xfs: directory lookups should return diroffsets too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873107.3474076.14790811015593279205.stgit@magnolia>
In-Reply-To: <167657873091.3474076.6801004934386808232.stgit@magnolia>
References: <167657873091.3474076.6801004934386808232.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_dir2_block.c |    2 ++
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  |    2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    |    4 ++++
 4 files changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0f3a03e87278..24467e1a0d6f 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -749,6 +749,8 @@ xfs_dir2_block_lookup_int(
 		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
+			args->offset = xfs_dir2_byte_to_dataptr(
+					(char *)dep - (char *)hdr);
 			*bpp = bp;
 			*entno = mid;
 			if (cmp == XFS_CMP_EXACT)
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index fe75ffadace9..b7ea73b4f592 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1300,6 +1300,8 @@ xfs_dir2_leaf_lookup_int(
 		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
+			args->offset = xfs_dir2_db_off_to_dataptr(args->geo,
+					newdb, (char *)dep - (char *)dbp->b_addr);
 			*indexp = index;
 			/* case exact match: return the current buffer. */
 			if (cmp == XFS_CMP_EXACT) {
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 53cd0d5d94f7..f8c01e8d885c 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -887,6 +887,8 @@ xfs_dir2_leafn_lookup_for_entry(
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
 			args->filetype = xfs_dir2_data_get_ftype(mp, dep);
+			args->offset = xfs_dir2_db_off_to_dataptr(args->geo,
++					newdb, (char *)dep - (char *)curbp->b_addr);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 032c65804610..f8670c56c7a6 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
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

