Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1FH5QpA217139 for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 11:05:27 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C15791EB079C
	for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 09:08:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YugHeyUzhoDLqnuk for
	<xfs@oss.sgi.com>; Tue, 15 Feb 2011 09:08:05 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs: check if device support discard in xfs_ioc_trim()
Date: Tue, 15 Feb 2011 18:07:36 +0100
Message-Id: <1297789656-6088-1-git-send-email-lczerner@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, lczerner@redhat.com

Right now we, are relying on the fact that when we attempt to actually do
the discard, blkdev_issue_discar() returns -EOPNOTSUPP and the user is
informed that the device does not support discard.

However, in the case where the we do not hit any suitable free extent to
trim in FITRIM code, it will finish without any error. This is very
confusing, because it seems that FITRIM was successful even though the
device does not actually supports discard.

Solution: Check for the discard support before attempt to search for
free extents.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_discard.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_discard.c b/fs/xfs/linux-2.6/xfs_discard.c
index 05201ae..d61611c 100644
--- a/fs/xfs/linux-2.6/xfs_discard.c
+++ b/fs/xfs/linux-2.6/xfs_discard.c
@@ -152,6 +152,8 @@ xfs_ioc_trim(
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
+	if (!blk_queue_discard(q))
+		return -XFS_ERROR(EOPNOTSUPP);
 	if (copy_from_user(&range, urange, sizeof(range)))
 		return -XFS_ERROR(EFAULT);
 
-- 
1.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
