Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A031B7F5A
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BF808F804B
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WYdVKkeQJZWyjyOE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 12EDFA7579
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFVLO020051
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 10/12] xfs: clean up root inode properly on mount failure
Date: Fri,  7 Aug 2015 17:15:26 -0400
Message-Id: <1438982128-38618-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The root inode is read as part of the xfs_mountfs() sequence and the
reference is dropped in the event of failure after we grab the inode.
The reference drop doesn't necessarily free the inode, however. It marks
it for reclaim and potentially kicks off the reclaim workqueue.  The
workqueue is destroyed further up the error path, which means we are
subject to crash if the workqueue job runs after this point or a memory
leak which is identified if the xfs_inode_zone is destroyed (e.g., on
module removal). Both of these outcomes are reproducible via manual
instrumentation of a mount error after the root inode xfs_iget() call in
xfs_mountfs().

Update the xfs_mountfs() error path to cancel any potential reclaim work
items and to run a synchronous inode reclaim if the root inode is marked
for reclaim. This ensures that no jobs remain on the queue before it is
destroyed and that the root inode is freed before the reclaim mechanism
is torn down.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4825a8a..bf92e0c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -957,6 +957,8 @@ xfs_mountfs(
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
