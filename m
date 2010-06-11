Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BM6lnr164829 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 17:06:47 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8238012A8B21
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 15:12:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yoNmTWtiL8UaLvaJ for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 15:12:34 -0700 (PDT)
Message-ID: <4C12B40A.2070405@redhat.com>
Date: Fri, 11 Jun 2010 17:09:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] quota: don't disable accounting with quotaoff
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs-oss <xfs@oss.sgi.com>

The quotaon(8) man page says:

NOTES ON XFS FILESYSTEMS
...
       To turn off quota limit enforcement on any XFS filesys-
       tem, first make sure that quota accounting and enforce-
       ment  are  both turned on using repquota -v filesystem.
       Then, use  quotaoff  -v  filesystem  to  disable  limit
       enforcement.   This may be done while the filesystem is
       mounted.

       Turning on quota limit enforcement on an XFS filesystem
       is  achieved  using quotaon -v filesystem.  This may be
       done while the filesystem is mounted

however, quotaoff turns off both enforcement -and- accounting,
and then quotaon fails.

If the manpage describes the intended behavior, then I think the
following patch is needed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

--- quota-tools/quotaon_xfs.c	2010-01-05 10:39:54.000000000 -0500
+++ quota-tools-mine/quotaon_xfs.c	2010-06-11 17:45:12.000000000 -0400
@@ -208,10 +208,9 @@
 	}
 #endif /* XFS_ROOTHACK */
 
-	if (xarg == NULL) {	/* both acct & enfd on/off */
-		xopts |= (type == USRQUOTA) ?
-			(XFS_QUOTA_UDQ_ACCT | XFS_QUOTA_UDQ_ENFD) :
-			(XFS_QUOTA_GDQ_ACCT | XFS_QUOTA_GDQ_ENFD);
+	if (xarg == NULL) {	/* only enfd on/off */
+		xopts |= (type == USRQUOTA) ? XFS_QUOTA_UDQ_ENFD :
+			XFS_QUOTA_GDQ_ENFD;
 		err = xfs_onoff((char *)dev, type, flags, roothack, xopts);
 	}
 	else if (strcmp(xarg, "account") == 0) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
