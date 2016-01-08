Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FA6A7F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:57:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 030EF8F8035
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 10:57:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DaFSVG7agK1iEDm8 for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2016 10:57:04 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 50B1161AC509
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:57:04 -0600 (CST)
Subject: [PATCH 1/3] xfs_quota: define Q_XGETQUOTA2
References: <56900640.1050200@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5690067F.3060707@sandeen.net>
Date: Fri, 8 Jan 2016 12:57:03 -0600
MIME-Version: 1.0
In-Reply-To: <56900640.1050200@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This simply defines the Q_XGETQUOTA2 quotactl in xfsprogs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xqm.h |    1 +
 quota/linux.c |    2 ++
 quota/quota.h |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/xqm.h b/include/xqm.h
index 47f58a0..2cf4311 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -32,6 +32,7 @@
 #define Q_XGETQSTAT	XQM_CMD(5)	/* get quota subsystem status */
 #define Q_XQUOTARM	XQM_CMD(6)	/* free disk space used by dquots */
 #define Q_XQUOTASYNC	XQM_CMD(7)	/* delalloc flush, updates dquots */
+#define Q_XGETQUOTA2	XQM_CMD(9)	/* get disk limits and usage */
 
 /*
  * fs_disk_quota structure:
diff --git a/quota/linux.c b/quota/linux.c
index 8a73922..84ac674 100644
--- a/quota/linux.c
+++ b/quota/linux.c
@@ -49,6 +49,8 @@ xcommand_to_qcommand(
 		return Q_XQUOTAOFF;
 	case XFS_GETQUOTA:
 		return Q_XGETQUOTA;
+	case XFS_GETQUOTA2:
+		return Q_XGETQUOTA2;
 	case XFS_SETQLIM:
 		return Q_XSETQLIM;
 	case XFS_GETQSTAT:
diff --git a/quota/quota.h b/quota/quota.h
index 416f335..8b80029 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -43,6 +43,8 @@ enum {
 	XFS_GETQSTAT,	/* get quota subsystem status */
 	XFS_QUOTARM,	/* free disk space used by dquots */
 	XFS_QSYNC,	/* flush delayed allocate space */
+	XFS_GETQSTATV,	/* newer version of quota stats */
+	XFS_GETQUOTA2,	/* get disk limits and usage */
 };
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
