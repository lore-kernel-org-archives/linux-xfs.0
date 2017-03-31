Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933302AbdCaRcQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:32:16 -0400
Subject: [PATCH 6/8] xfs: report crtime and attribute flags to statx
From: David Howells <dhowells@redhat.com>
Date: Fri, 31 Mar 2017 18:32:03 +0100
Message-ID: <149098152354.28108.5554947968416644187.stgit@warthog.procyon.org.uk>
In-Reply-To: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

statx has the ability to report inode creation times and inode flags, so
hook up di_crtime and di_flags to that functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/xfs/xfs_iops.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 229cc6a6d8ef..ebfc13350f9a 100644
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

