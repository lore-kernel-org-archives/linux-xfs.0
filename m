Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A38B47F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72BBC8F8052
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9i7DtBCC5f2dtBQQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:51 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 69B1D351E6E
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1p2V001468
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 10/13] xfs: clean up root inode properly on mount failure
Date: Mon, 10 Aug 2015 15:01:46 -0400
Message-Id: <1439233309-19959-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
