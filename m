Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28563 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdCGAG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 19:06:56 -0500
Date: Mon, 6 Mar 2017 16:06:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: report crtime and attribute flags to statx
Message-ID: <20170307000609.GG5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

statx has the ability to report inode creation times and inode flags, so
hook up di_crtime and di_flags to that functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 229cc6a..ebfc133 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -516,6 +516,20 @@ xfs_vn_getattr(
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
+	if (ip->i_d.di_version == 3) {
+		if (request_mask & STATX_BTIME) {
+			stat->result_mask |= STATX_BTIME;
+			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
+			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
+		}
+	}
+
+	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
+		stat->attributes |= STATX_ATTR_NODUMP;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
