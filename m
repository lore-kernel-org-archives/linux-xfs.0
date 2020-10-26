Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3970EC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6DF20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="robakn1D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407255AbgJZXij (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407243AbgJZXij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXV4164621;
        Mon, 26 Oct 2020 23:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pKzxnciog0z9E0H0JVaHdXbFEFEUWFlSHyBURI9Ej5o=;
 b=robakn1DRYW0RaNLZq8KqbWNOlFkMaGMLC3rVOEOe7uWElc2UGJHE3uFxDIXBy6r4iuC
 SVJiFsUSjBW4wlqUbG7jWXoZXaWqeDInBIhSfOwluRznJKKFFdu/jtm3GbkScafzITgN
 4SYhG36OCuCbMrnrKgAGhTekfnYXYUfoyAoTJeRtlaJb5bsk7l68w6cjoWimB4KKJRvx
 +oOigWzKwxFeUTcI9AvO5gyQJecfOTcxNnJAW9Vem9Yszjjiz69P60qD3xzYcXmPVtaY
 F0nLnAvAeyQXqb02LKaYHDeaQwXkYe/P2h4ekrae0eVt2SEyz9E5jvc5H3mwQIlXEFxG gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3vuxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGLj121126;
        Mon, 26 Oct 2020 23:36:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6va6vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNaZH4029640;
        Mon, 26 Oct 2020 23:36:35 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:35 -0700
Subject: [PATCH 23/26] xfs_quota: support editing and reporting quotas with
 bigtime
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:34 -0700
Message-ID: <160375539460.881414.16375144747744518990.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enhance xfs_quota to detect and report grace period expirations past
2038.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xqm.h  |   20 ++++++++++++++++-
 quota/edit.c   |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 quota/quota.c  |    6 +++--
 quota/quota.h  |    7 ++++++
 quota/report.c |    6 +++--
 5 files changed, 91 insertions(+), 13 deletions(-)


diff --git a/include/xqm.h b/include/xqm.h
index 8ab19072656e..573441db9860 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -47,7 +47,10 @@ typedef struct fs_disk_quota {
 	__s32		d_btimer;	/* similar to above; for disk blocks */
 	__u16		d_iwarns;	/* # warnings issued wrt num inodes */
 	__u16		d_bwarns;	/* # warnings issued wrt disk blocks */
-	__s32		d_padding2;	/* padding2 - for future use */
+	__s8		d_itimer_hi;	/* upper 8 bits of timer values */
+	__s8		d_btimer_hi;
+	__s8		d_rtbtimer_hi;
+	__s8		d_padding2;	/* padding2 - for future use */
 	__u64		d_rtb_hardlimit;/* absolute limit on realtime blks */
 	__u64		d_rtb_softlimit;/* preferred limit on RT disk blks */
 	__u64		d_rtbcount;	/* # realtime blocks owned */
@@ -93,6 +96,21 @@ typedef struct fs_disk_quota {
 #define FS_DQ_RTBWARNS	(1<<11)
 #define FS_DQ_WARNS_MASK	(FS_DQ_BWARNS | FS_DQ_IWARNS | FS_DQ_RTBWARNS)
 
+/*
+ * Accounting values.  These can only be set for filesystem with
+ * non-transactional quotas that require quotacheck(8) in userspace.
+ */
+#define FS_DQ_BCOUNT		(1<<12)
+#define FS_DQ_ICOUNT		(1<<13)
+#define FS_DQ_RTBCOUNT		(1<<14)
+#define FS_DQ_ACCT_MASK		(FS_DQ_BCOUNT | FS_DQ_ICOUNT | FS_DQ_RTBCOUNT)
+
+/*
+ * Quota expiration timestamps are 40-bit signed integers, with the upper 8
+ * bits encoded in the _hi fields.
+ */
+#define FS_DQ_BIGTIME		(1<<15)
+
 /*
  * Various flags related to quotactl(2).  Only relevant to XFS filesystems.
  */
diff --git a/quota/edit.c b/quota/edit.c
index b3cad024b1f1..1a3b2d9f959b 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -417,6 +417,53 @@ restore_f(
 	return 0;
 }
 
+time64_t
+decode_timer(
+	const struct fs_disk_quota *d,
+	__s32			timer_lo,
+	__s8			timer_hi)
+{
+	if (d->d_fieldmask & FS_DQ_BIGTIME)
+		return (uint32_t)timer_lo | (int64_t)timer_hi << 32;
+	return timer_lo;
+}
+
+static inline void
+encode_timer(
+	const struct fs_disk_quota *d,
+	__s32			*timer_lo,
+	__s8			*timer_hi,
+	time64_t		timer)
+{
+	*timer_lo = timer;
+	if (d->d_fieldmask & FS_DQ_BIGTIME)
+		*timer_hi = timer >> 32;
+	else
+		*timer_hi = 0;
+}
+
+static inline bool want_bigtime(time64_t timer)
+{
+	return timer > INT32_MAX || timer < INT32_MIN;
+}
+
+static void
+encode_timers(
+	struct fs_disk_quota	*d,
+	time64_t		btimer,
+	time64_t		itimer,
+	time64_t		rtbtimer)
+{
+	d->d_fieldmask &= ~FS_DQ_BIGTIME;
+	if (want_bigtime(btimer) || want_bigtime(itimer) ||
+	    want_bigtime(rtbtimer))
+		d->d_fieldmask |= FS_DQ_BIGTIME;
+
+	encode_timer(d, &d->d_btimer, &d->d_btimer_hi, btimer);
+	encode_timer(d, &d->d_itimer, &d->d_itimer_hi, itimer);
+	encode_timer(d, &d->d_rtbtimer, &d->d_rtbtimer_hi, rtbtimer);
+}
+
 static void
 set_timer(
 	uint32_t		id,
@@ -426,6 +473,7 @@ set_timer(
 	time64_t		value)
 {
 	struct fs_disk_quota	d;
+	time64_t		btimer, itimer, rtbtimer;
 
 	memset(&d, 0, sizeof(d));
 
@@ -446,23 +494,28 @@ set_timer(
 
 		time(&now);
 
+		btimer = decode_timer(&d, d.d_btimer, d.d_btimer_hi);
+		itimer = decode_timer(&d, d.d_itimer, d.d_itimer_hi);
+		rtbtimer = decode_timer(&d, d.d_rtbtimer, d.d_rtbtimer_hi);
+
 		/* Only set grace time if user is already past soft limit */
 		if (d.d_blk_softlimit && d.d_bcount > d.d_blk_softlimit)
-			d.d_btimer = now + value;
+			btimer = now + value;
 		if (d.d_ino_softlimit && d.d_icount > d.d_ino_softlimit)
-			d.d_itimer = now + value;
+			itimer = now + value;
 		if (d.d_rtb_softlimit && d.d_rtbcount > d.d_rtb_softlimit)
-			d.d_rtbtimer = now + value;
+			rtbtimer = now + value;
 	} else {
-		d.d_btimer = value;
-		d.d_itimer = value;
-		d.d_rtbtimer = value;
+		btimer = value;
+		itimer = value;
+		rtbtimer = value;
 	}
 
 	d.d_version = FS_DQUOT_VERSION;
 	d.d_flags = type;
 	d.d_fieldmask = mask;
 	d.d_id = id;
+	encode_timers(&d, btimer, itimer, rtbtimer);
 
 	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
 		exitcode = 1;
diff --git a/quota/quota.c b/quota/quota.c
index 8ba0995d9174..0747cedcb8c2 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -101,7 +101,7 @@ quota_mount(
 	}
 
 	if (form & XFS_BLOCK_QUOTA) {
-		timer = d.d_btimer;
+		timer = decode_timer(&d, d.d_btimer, d.d_btimer_hi);
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -123,7 +123,7 @@ quota_mount(
 				time_to_string(timer, qflags));
 	}
 	if (form & XFS_INODE_QUOTA) {
-		timer = d.d_itimer;
+		timer = decode_timer(&d, d.d_itimer, d.d_itimer_hi);
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_ino_hardlimit && d.d_icount > d.d_ino_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -145,7 +145,7 @@ quota_mount(
 				time_to_string(timer, qflags));
 	}
 	if (form & XFS_RTBLOCK_QUOTA) {
-		timer = d.d_rtbtimer;
+		timer = decode_timer(&d, d.d_rtbtimer, d.d_rtbtimer_hi);
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_rtb_hardlimit && d.d_rtbcount > d.d_rtb_hardlimit)
 			qflags |= LIMIT_FLAG;
diff --git a/quota/quota.h b/quota/quota.h
index 11f62b208e6a..78b0d66d2a4f 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -3,6 +3,8 @@
  * Copyright (c) 2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef XFS_QUOTA_QUOTA_H_
+#define XFS_QUOTA_QUOTA_H_
 
 #include "xqm.h"
 #include "libfrog/paths.h"
@@ -73,3 +75,8 @@ extern char *uid_to_name(uint32_t __uid);
 extern char *gid_to_name(uint32_t __gid);
 extern char *prid_to_name(uint32_t __prid);
 extern bool isdigits_only(const char *);
+
+time64_t decode_timer(const struct fs_disk_quota *d, __s32 timer_lo,
+		__s8 timer_hi);
+
+#endif /* XFS_QUOTA_QUOTA_H_ */
diff --git a/quota/report.c b/quota/report.c
index 2d5024e95177..6ac5549097b7 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -398,7 +398,7 @@ report_mount(
 	}
 
 	if (form & XFS_BLOCK_QUOTA) {
-		timer = d.d_btimer;
+		timer = decode_timer(&d, d.d_btimer, d.d_btimer_hi);
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -420,7 +420,7 @@ report_mount(
 				time_to_string(timer, qflags));
 	}
 	if (form & XFS_INODE_QUOTA) {
-		timer = d.d_itimer;
+		timer = decode_timer(&d, d.d_itimer, d.d_itimer_hi);
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_ino_hardlimit && d.d_icount > d.d_ino_hardlimit)
 			qflags |= LIMIT_FLAG;
@@ -442,7 +442,7 @@ report_mount(
 				time_to_string(timer, qflags));
 	}
 	if (form & XFS_RTBLOCK_QUOTA) {
-		timer = d.d_rtbtimer;
+		timer = decode_timer(&d, d.d_rtbtimer, d.d_rtbtimer_hi);
 		qflags = (flags & HUMAN_FLAG);
 		if (d.d_rtb_hardlimit && d.d_rtbcount > d.d_rtb_hardlimit)
 			qflags |= LIMIT_FLAG;

