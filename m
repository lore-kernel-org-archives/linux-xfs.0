Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6131CD2B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505028; cv=none; b=Qi6O3ak0skcKyP0flolahdzf5Lx7yvkDJowjYn5tASKDVErX24uDE/POQKkimajo5QD5vowHX18N1wXIxKoA0oeJQQYqaW4izZIR6RxA4Cz4FHOPWwNR/WqTLLcl9TxcjFsAjOeF4k2jUQ3j7X60N1J20DqVmNCWRmAZ8EDifEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505028; c=relaxed/simple;
	bh=JPmv4N3mKtXrrupw4rZHm9GMdYhhXprQDPOd6V52Jbk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAIyIYAIbApf8R6IaGvH2WzAn90TiPUPswGxrk4quHxt7RnUghnj37PqfUay+rLdrCGgfH6rnfAYUZgEnjGJ56/fVXrnVqsO7UF9ppdD0gO2T1cJJl7rt8DxGUCv/+9AvsUWJFAT781hdVYc1AT2kVxd/x6YpClcmQnaIAs8v18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDwPimFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDwPimFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21563C43390;
	Wed, 27 Mar 2024 02:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505028;
	bh=JPmv4N3mKtXrrupw4rZHm9GMdYhhXprQDPOd6V52Jbk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SDwPimFjDjkoj7Votk20P15SEpkQFpQZwRhEs8JEs2kHNt1x0cFfL17rMwoTrCr7q
	 TNW9nv8aX7PqoiDffan4y4QlowG5YCujHmxdCEkiflG/YZq7EkzCI7Mwg6v13TmLhA
	 UtqPqlbPrUrbtM2Ad55e7o+IFIeRNbxfgePxtUfrOYy6ZSKP5r68K0ZKFAADJoMUCw
	 CcGC5mDD6yX7oBik8s4+u7S+4W+6tMLjMlFqBch3XXvJO6NI4SnA/j4D4MQoUHqXEY
	 X8Y4etbDRMhpHqNBN0QalcSzmXbDIHazaMt2n+scwkafZdreCZ2SmcyC47yjzB5Yhj
	 ZHy3Xgpd3ImrA==
Date: Tue, 26 Mar 2024 19:03:47 -0700
Subject: [PATCH 1/5] xfs: inactivate directory data blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383544.3217994.7825601287133408330.stgit@frogsfrogsfrogs>
In-Reply-To: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach inode inactivation to delete all the incore buffers backing a
directory.  In normal runtime this should never happen because the VFS
forbids rmdir on a non-empty directory.

In the next patch, online directory repair stands up a new directory,
exchanges it with the broken directory, and then drops the private
temporary directory.  If we cancel the repair just prior to exchanging
the directory contents, the new directory will need to be torn down.
Note: If we commit the repair, reaping will take care of all the ondisk
space allocations and incore buffers for the old corrupt directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 98a01a490adcc..e49cbb1c75fb2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_attr.h"
+#include "xfs_bit.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
@@ -1540,6 +1541,51 @@ xfs_release(
 	return error;
 }
 
+/*
+ * Mark all the buffers attached to this directory stale.  In theory we should
+ * never be freeing a directory with any blocks at all, but this covers the
+ * case where we've recovered a directory swap with a "temporary" directory
+ * created by online repair and now need to dump it.
+ */
+STATIC void
+xfs_inactive_dir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
+	xfs_fileoff_t		off;
+
+	/*
+	 * Invalidate each directory block.  All directory blocks are of
+	 * fsbcount length and alignment, so we only need to walk those same
+	 * offsets.  We hold the only reference to this inode, so we must wait
+	 * for the buffer locks.
+	 */
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for (off = round_up(got.br_startoff, geo->fsbcount);
+		     off < got.br_startoff + got.br_blockcount;
+		     off += geo->fsbcount) {
+			struct xfs_buf	*bp = NULL;
+			xfs_fsblock_t	fsbno;
+			int		error;
+
+			fsbno = (off - got.br_startoff) + got.br_startblock;
+			error = xfs_buf_incore(mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(mp, fsbno),
+					XFS_FSB_TO_BB(mp, geo->fsbcount),
+					XBF_LIVESCAN, &bp);
+			if (error)
+				continue;
+
+			xfs_buf_stale(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+}
+
 /*
  * xfs_inactive_truncate
  *
@@ -1850,6 +1896,11 @@ xfs_inactive(
 			goto out;
 	}
 
+	if (S_ISDIR(VFS_I(ip)->i_mode) && ip->i_df.if_nextents > 0) {
+		xfs_inactive_dir(ip);
+		truncate = 1;
+	}
+
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)

