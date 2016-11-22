Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33850 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932355AbcKVSVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 13:21:33 -0500
Date: Tue, 22 Nov 2016 10:21:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 05/16] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
Message-ID: <20161122182126.GM16813@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Eric Sandeen <sandeen@redhat.com>

Source kernel commit: c400ee3ed1b13d45adde68e12254dc6ab6977b59

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
