Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACnhc250537 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 347D21DB1139
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	eweYbzEe9rtdb3dU for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:45 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11632758-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:44 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMht-0007ro-Pl
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:37 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LQ-D9
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfsprogs: fix trivial warnings in xfs_fsr
Date: Thu, 14 Jan 2010 21:09:09 +1100
Message-Id: <1263463752-5052-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1263463752-5052-1-git-send-email-david@fromorbit.com>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
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

GCC complains about assignments between (unsigned long long *)
and (__u64 *) pointers. Just add a cast to shut it up.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fsr/xfs_fsr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 21f08c3..1f933c7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -133,7 +133,7 @@ xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
 {
     xfs_fsop_bulkreq_t  bulkreq;
 
-    bulkreq.lastip = lastip;
+    bulkreq.lastip = (__u64 *)lastip;
     bulkreq.icount = 1;
     bulkreq.ubuffer = ubuffer;
     bulkreq.ocount = NULL;
@@ -146,7 +146,7 @@ xfs_bulkstat(int fd, xfs_ino_t *lastip, int icount,
 {
     xfs_fsop_bulkreq_t  bulkreq;
 
-    bulkreq.lastip = lastip;
+    bulkreq.lastip = (__u64 *)lastip;
     bulkreq.icount = icount;
     bulkreq.ubuffer = ubuffer;
     bulkreq.ocount = ocount;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
