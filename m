Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5837 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751049AbeFEGY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 02:24:29 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-00022d-To
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-0001JQ-Su
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: push corruption -> ESTALE conversion to xfs_nfs_get_inode()
Date: Tue,  5 Jun 2018 16:24:23 +1000
Message-Id: <20180605062423.4877-7-david@fromorbit.com>
In-Reply-To: <20180605062423.4877-1-david@fromorbit.com>
References: <20180605062423.4877-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In xfs_imap_to_bp(), we convert a -EFSCORRUPTED error to -EINVAL if
we are doing an untrusted lookup. This is done because we need
failed filehandle lookups to report -ESTALE to the caller, and it
does this by converting -EINVAL and -ENOENT errors to -ESTALE.

The squashing of EFSCORRUPTED in imap_to_bp makes it impossible for
for xfs_iget(UNTRUSTED) callers to determine the difference between
"inode does not exist" and "corruption detected during lookup". We
realy need that distinction in places calling xfS_iget(UNTRUSTED),
so move the filehandle error case handling all the way out to
xfs_nfs_get_inode() where it is needed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  5 -----
 fs/xfs/xfs_export.c           | 15 ++++++++++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ea64be7cbd98..0a22c39325cd 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -189,11 +189,6 @@ xfs_imap_to_bp(
 			ASSERT(buf_flags & XBF_TRYLOCK);
 			return error;
 		}
-
-		if (error == -EFSCORRUPTED &&
-		    (iget_flags & XFS_IGET_UNTRUSTED))
-			return -EINVAL;
-
 		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
 			__func__, error);
 		return error;
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 7af7d6faa709..3cf4682e2510 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -128,15 +128,24 @@ xfs_nfs_get_inode(
 	 */
 	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
 	if (error) {
+
 		/*
 		 * EINVAL means the inode cluster doesn't exist anymore.
-		 * This implies the filehandle is stale, so we should
-		 * translate it here.
+		 * EFSCORRUPTED means the metadata pointing to the inode cluster
+		 * or the inode cluster itself is corrupt.  This implies the
+		 * filehandle is stale, so we should translate it here.
 		 * We don't use ESTALE directly down the chain to not
 		 * confuse applications using bulkstat that expect EINVAL.
 		 */
-		if (error == -EINVAL || error == -ENOENT)
+		switch (error) {
+		case -EINVAL:
+		case -ENOENT:
+		case -EFSCORRUPTED:
 			error = -ESTALE;
+			break;
+		default:
+			break;
+		}
 		return ERR_PTR(error);
 	}
 
-- 
2.17.0

