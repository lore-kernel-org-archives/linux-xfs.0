Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E8m5DU243078 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:48:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7112B15141CB
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 00:49:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	4dGXfAC6xgO59MDe for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 00:49:00 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11391075-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 19:18:59 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVLNy-0007mS-16
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 19:48:58 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVLJu-0005YF-Iz
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 19:44:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix missing error check in xfs_rtfree_range
Date: Thu, 14 Jan 2010 19:44:46 +1100
Message-Id: <1263458686-21308-1-git-send-email-david@fromorbit.com>
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

When xfs_rtfind_forw() returns an error, the block is returned
uninitialised.  xfs_rtfree_range() is not checking the error return,
so could be using an uninitialised block number for modifying bitmap
summary info.

The problem was found by gcc when compiling the *userspace* libxfs
code - it is an copy of the kernel code with the exact same bug.
gcc gives an uninitialised variable warning on the userspace code
but not on the kernel code. You gotta love the consistency (Mmmm,
slightly chewy today!).

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_rtalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9e15a11..6be05f7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1517,6 +1517,8 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
 		&postblock);
+	if (error)
+		return error;
 	/*
 	 * If there are blocks not being freed at the front of the
 	 * old extent, add summary data for them to be allocated.
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
