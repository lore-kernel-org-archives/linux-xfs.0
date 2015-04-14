Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A4657F3F
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 02:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2796BAC004
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 00:27:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Pe8BuQL8MEaCJ2Fv for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 00:26:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YhvFE-0000qf-Vy
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:53 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YhvFE-0000Vy-V9
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: direct IO EOF zeroing needs to drain AIO
Date: Tue, 14 Apr 2015 17:26:50 +1000
Message-Id: <1428996411-1507-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1428996411-1507-1-git-send-email-david@fromorbit.com>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we are doing AIO DIO writes, the IOLOCK only provides an IO
submission barrier. When we need to do EOF zeroing, we need to ensure
that no other IO is in progress and all pending in-core EOF updates
have been completed. This requires us to wait for all outstanding
AIO DIO writes to the inode to complete and, if necessary, run their
EOF updates.

Once all the EOF updates are complete, we can then restart
xfs_file_aio_write_checks() while holding the IOLOCK_EXCL, knowing
that EOF is up to date and we have exclusive IO access to the file
so we can run EOF block zeroing if we need to without interference.
This gives EOF zeroing the same exclusivity against other IO as we
provide truncate operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5d5b4ba..c398ec7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -587,6 +587,16 @@ restart:
 			xfs_rw_iunlock(ip, *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
 			xfs_rw_ilock(ip, *iolock);
+
+			/*
+			 * We now have an IO submission barrier in place, but
+			 * AIO can do EOF updates during IO completion and hence
+			 * we now need to wait for all of them to drain. Non-AIO
+			 * DIO will have drained before we are given the
+			 * XFS_IOLOCK_EXCL, and so for most cases this wait is a
+			 * no-op.
+			 */
+			inode_dio_wait(inode);
 			goto restart;
 		}
 		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
