Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0aFd0142323 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:36:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B89111F797F
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:37:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	GciyH9BjozFi3D6D for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:37:13 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11543018-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:07:12 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX25e-0003Ed-4G
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX25d-0003aV-Ff
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfsprogs: fix trivial warnings in xfs_fsr
Date: Tue, 19 Jan 2010 11:36:50 +1100
Message-Id: <1263861413-13729-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861413-13729-1-git-send-email-david@fromorbit.com>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
