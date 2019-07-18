Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41336 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 19:06:28 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 7/9] xfs: fix reporting supported extra file attributes for statx()
Date: Thu, 18 Jul 2019 23:06:15 +0000
Message-Id: <20190718230617.7439-8-mcgrof@kernel.org>
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: "Luis R. Rodriguez" <mcgrof@kernel.org>

commit 1b9598c8fb9965fff901c4caa21fed9644c34df3 upstream.

statx(2) notes that any attribute that is not indicated as supported by
stx_attributes_mask has no usable value. Commit 5f955f26f3d42d ("xfs: report
crtime and attribute flags to statx") added support for informing userspace
of extra file attributes but forgot to list these flags as supported
making reporting them rather useless for the pedantic userspace author.

$ git describe --contains 5f955f26f3d42d04aba65590a32eb70eedb7f37d
v4.11-rc6~5^2^2~2

Fixes: 5f955f26f3d42d ("xfs: report crtime and attribute flags to statx")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: add a comment reminding people to keep attributes_mask up to date]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_iops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1efef69a7f1c..74047bd0c1ae 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -531,6 +531,10 @@ xfs_vn_getattr(
 		}
 	}
 
+	/*
+	 * Note: If you add another clause to set an attribute flag, please
+	 * update attributes_mask below.
+	 */
 	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
@@ -538,6 +542,10 @@ xfs_vn_getattr(
 	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
+	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
+				  STATX_ATTR_APPEND |
+				  STATX_ATTR_NODUMP);
+
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
 	case S_IFCHR:
-- 
2.20.1
