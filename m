Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25112 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934946AbcKDSam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:30:42 -0400
Subject: [PATCH 05/11] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
From: Eric Sandeen <sandeen@redhat.com>
Date: Fri, 04 Nov 2016 11:30:36 -0700
Message-ID: <147828423671.31492.10920798285495163593.stgit@birch.djwong.org>
In-Reply-To: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
References: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

>From c400ee3ed1b13d45adde68e12254dc6ab6977b59 Mon Sep 17 00:00:00 2001

It's entirely possible for userspace to ask for an xattr which
does not exist.

Normally, there is no problem whatsoever when we ask for such
a thing, but when we look at an obfuscated metadump image
on a debug kernel with selinux, we trip over this ASSERT in
xfs_da3_path_shift():

        *result = -ENOENT;      /* we're out of our tree */
        ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);

It (more or less) only shows up in the above scenario, because
xfs_metadump obfuscates attr names, but chooses names which
keep the same hash value - and xfs_da3_node_lookup_int does:

        if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
            (blk->hashval == args->hashval)) {
                error = xfs_da3_path_shift(state, &state->path, 1, 1,
                                                 &retval);

IOWS, we only get down to the xfs_da3_path_shift() ASSERT
if we are looking for an xattr which doesn't exist, but we
find xattrs on disk which have the same hash, and so might be
a hash collision, so we try the path shift.  When *that*
fails to find what we're looking for, we hit the assert about
XFS_DA_OP_OKNOENT.

Simply setting XFS_DA_OP_OKNOENT in xfs_attr_get solves this
rather corner-case problem with no ill side effects.  It's
fine for an attr name lookup to fail.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_attr.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c7f0afa..60513f9 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -135,6 +135,8 @@ xfs_attr_get(
 
 	args.value = value;
 	args.valuelen = *valuelenp;
+	/* Entirely possible to look up a name which doesn't exist */
+	args.op_flags = XFS_DA_OP_OKNOENT;
 
 	lock_mode = xfs_ilock_attr_map_shared(ip);
 	if (!xfs_inode_hasattr(ip))

