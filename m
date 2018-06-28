Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933925AbeF1R3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 13:29:51 -0400
Date: Thu, 28 Jun 2018 10:29:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/10] xfs_repair: clear extent size hints when clearing
 inode core
Message-ID: <20180628172937.GI5711@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153006766483.20121.9285982017465570544.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In kernel 4.18 we become more strict about what can be in the extent
size hint fields, even for freed inodes.  Therefore, if repair decides
to clear out an inode core, zero the hint fields and clear the flags so
that the kernel won't trip over the cleared inode if and when it tries
to read the chunk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/repair/dinode.c b/repair/dinode.c
index f9b2bac0..4118db7c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -194,6 +194,11 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_anextents = 0;
 	}
 
+	if (be32_to_cpu(dinoc->di_extsize) != 0)  {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_extsize = 0;
+	}
+
 	if (dinoc->di_version > 1 &&
 			be32_to_cpu(dinoc->di_nlink) != 0)  {
 		__dirty_no_modify_ret(dirty);
@@ -237,6 +242,11 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_changecount = 0;
 	}
 
+	if (be32_to_cpu(dinoc->di_cowextsize) != 0)  {
+		__dirty_no_modify_ret(dirty);
+		dinoc->di_cowextsize = 0;
+	}
+
 	return dirty;
 }
 
