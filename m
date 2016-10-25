Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45914 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbcJYXEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:25 -0400
Subject: [PATCH 07/39] xfs: introduce the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:21 -0700
Message-ID: <147743666109.11035.5850104676966406279.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Introduce a new in-core fork for storing copy-on-write delalloc
reservations and allocated extents that are in the process of being
written out.

[Clean up the CoW fork, should there ever be one.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix up bmapi_read so that we can query the CoW fork, and have it
return a "hole" extent if there's no CoW fork.
---
 libxfs/rdwr.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 526bc62..8b22eb4 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1372,6 +1372,8 @@ libxfs_idestroy(xfs_inode_t *ip)
 	}
 	if (ip->i_afp)
 		libxfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	if (ip->i_cowfp)
+		xfs_idestroy_fork(ip, XFS_COW_FORK);
 }
 
 void

