Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63DF67F37
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 04:46:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54020304032
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 02:46:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EgexISHtVBWZGtCQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2016 02:46:15 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id CDE8DC0BF2B0
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 10:46:14 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u0JAkDSr017092
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 05:46:14 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Minor whitespace cleanups
Date: Tue, 19 Jan 2016 11:46:09 +0100
Message-Id: <1453200369-20171-1-git-send-email-cmaiolino@redhat.com>
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

While investigating a quota issue, I fixed a few whitespaces.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/xqm.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/xqm.h b/include/xqm.h
index 47f58a0..697cad4 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -55,14 +55,14 @@ typedef struct fs_disk_quota {
 	__s32		d_itimer;	/* zero if within inode limits */
 					/* if not, we refuse service */
 	__s32		d_btimer;	/* similar to above; for disk blocks */
-	__u16	  	d_iwarns;       /* # warnings issued wrt num inodes */
-	__u16	  	d_bwarns;       /* # warnings issued wrt disk blocks */
+	__u16		d_iwarns;       /* # warnings issued wrt num inodes */
+	__u16		d_bwarns;       /* # warnings issued wrt disk blocks */
 	__s32		d_padding2;	/* padding2 - for future use */
 	__u64		d_rtb_hardlimit;/* absolute limit on realtime blks */
 	__u64		d_rtb_softlimit;/* preferred limit on RT disk blks */
 	__u64		d_rtbcount;	/* # realtime blocks owned */
 	__s32		d_rtbtimer;	/* similar to above; for RT disk blks */
-	__u16	  	d_rtbwarns;     /* # warnings issued wrt RT disk blks */
+	__u16		d_rtbwarns;     /* # warnings issued wrt RT disk blks */
 	__s16		d_padding3;	/* padding3 - for future use */
 	char		d_padding4[8];	/* yet more padding */
 } fs_disk_quota_t;
@@ -73,7 +73,7 @@ typedef struct fs_disk_quota {
 #define FS_DQ_ISOFT	(1<<0)
 #define FS_DQ_IHARD	(1<<1)
 #define FS_DQ_BSOFT	(1<<2)
-#define FS_DQ_BHARD 	(1<<3)
+#define FS_DQ_BHARD	(1<<3)
 #define FS_DQ_RTBSOFT	(1<<4)
 #define FS_DQ_RTBHARD	(1<<5)
 #define FS_DQ_LIMIT_MASK	(FS_DQ_ISOFT | FS_DQ_IHARD | FS_DQ_BSOFT | \
@@ -87,7 +87,7 @@ typedef struct fs_disk_quota {
  */
 #define FS_DQ_BTIMER	(1<<6)
 #define FS_DQ_ITIMER	(1<<7)
-#define FS_DQ_RTBTIMER 	(1<<8)
+#define FS_DQ_RTBTIMER	(1<<8)
 #define FS_DQ_TIMER_MASK	(FS_DQ_BTIMER | FS_DQ_ITIMER | FS_DQ_RTBTIMER)
 
 /*
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
