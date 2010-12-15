Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF1NVGF159560 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 19:23:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FCC21CC7782
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 17:25:23 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	yFpTkjoMbtgfUYRu for <xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 17:25:23 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49873093-1927428
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 11:55:22 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PSg7H-00064G-SJ
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:25:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PSg5d-0004H9-JU
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:23:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfs: ensure sync write errors are returned
Date: Wed, 15 Dec 2010 12:23:22 +1100
Message-Id: <1292376208-16282-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1292376208-16282-1-git-send-email-david@fromorbit.com>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_file_aio_write() only returns the error from synchronous
flushing of the data and inode if error == 0. At the point where
error is being checked, it is guaranteed to be > 0. Therefore any
errors returned by the data or fsync flush will never be returned.
Fix the checks so we overwrite the current error once and only if an
error really occurred.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index ba8ad42..e1eaec2 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -769,7 +769,7 @@ write_retry:
 			mutex_unlock(&inode->i_mutex);
 
 		error2 = filemap_write_and_wait_range(mapping, pos, end);
-		if (!error)
+		if (error2)
 			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
@@ -777,7 +777,7 @@ write_retry:
 
 		error2 = -xfs_file_fsync(file,
 					 (file->f_flags & __O_SYNC) ? 0 : 1);
-		if (!error)
+		if (error2 && error >= 0)
 			error = error2;
 	}
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
