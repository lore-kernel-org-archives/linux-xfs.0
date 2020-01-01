Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47291C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B2A206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kA4FtYtl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:11:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50000 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABLj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:11:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xeu091223
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=W8JKF9t7k5KBFBNYVhoscYbkLA2KOHUroxLK+7/t1NY=;
 b=kA4FtYtlVrq87EeSVAZQm7iq32l4CeWbrcAhPoPk1KAT9H0sUc5BzNNqEf7mQmTK/ITB
 UO+DnWMR0brkKqUNsL92DQVUVfXZ3tVg1b/fSlB9GkcxaGSk0GkJDkbn8cF51psdL/4p
 bAsPbApfxuScrzo4lmYz4mZhMWJ5fUXIufFE5ppupdZfd+mMspHB9xhboGYBBn4pxO6C
 G8zkpi8R2N9PI/T528Y1gDSWHLXuDH/M/agkwH4ZEch/Z43QO5KYSN0unnwPliTKlYO4
 Ux7cetgXBj9GLWdKigOrvxDocNK/Hx2Vrlxrq32UqtQkMf+FCR/2uqUTQLcagN+1Xoxs 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xHi012453
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8gueev7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011BaP5006607
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:36 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:11:36 -0800
Subject: [PATCH 05/14] xfs: refactor quota expiration timer modification
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:33 -0800
Message-ID: <157784109369.1364230.637677553755124721.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define explicit limits on the range of quota grace period expiration
timeouts and refactor the code that modifies the timeouts into helpers
that clamp the values appropriately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
 fs/xfs/xfs_dquot.c         |   42 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_ondisk.h        |    2 ++
 3 files changed, 60 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 82b15832ba32..95761b38fe86 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1180,6 +1180,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
+/*
+ * XFS Quota Timers
+ * ================
+ *
+ * Quota grace period expiration timers are an unsigned 32-bit seconds counter;
+ * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
+ * of zero means that the quota limit has not been reached, and therefore no
+ * expiration has been set.
+ */
+
+/*
+ * Smallest possible quota expiration with traditional timestamps, which is
+ * Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_TIMEOUT_MIN	((int64_t)1)
+
+/*
+ * Largest possible quota expiration with traditional timestamps, which is
+ * Feb  7 06:28:15 UTC 2106.
+ */
+#define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota
  * information for a user. This is the q_core of the struct xfs_dquot that
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ae7bb6361a99..44bae5f16b55 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -113,6 +113,36 @@ xfs_quota_exceeded(
 	return *hardlimit && count > be64_to_cpup(hardlimit);
 }
 
+/*
+ * Clamp a quota grace period expiration timer to the range that we support.
+ */
+static inline time64_t
+xfs_dquot_clamp_timer(
+	time64_t			timer)
+{
+	return clamp_t(time64_t, timer, XFS_DQ_TIMEOUT_MIN, XFS_DQ_TIMEOUT_MAX);
+}
+
+/* Set a quota grace period expiration timer. */
+static inline void
+xfs_quota_set_timer(
+	__be32			*dtimer,
+	time_t			limit)
+{
+	time64_t		new_timeout;
+
+	new_timeout = xfs_dquot_clamp_timer(get_seconds() + limit);
+	*dtimer = cpu_to_be32(new_timeout);
+}
+
+/* Clear a quota grace period expiration timer. */
+static inline void
+xfs_quota_clear_timer(
+	__be32			*dtimer)
+{
+	*dtimer = cpu_to_be32(0);
+}
+
 /*
  * Check the limits and timers of a dquot and start or reset timers
  * if necessary.
@@ -152,14 +182,14 @@ xfs_qm_adjust_dqtimers(
 			&d->d_blk_softlimit, &d->d_blk_hardlimit);
 	if (!d->d_btimer) {
 		if (over) {
-			d->d_btimer = cpu_to_be32(get_seconds() +
+			xfs_quota_set_timer(&d->d_btimer,
 					mp->m_quotainfo->qi_btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
 	} else {
 		if (!over) {
-			d->d_btimer = 0;
+			xfs_quota_clear_timer(&d->d_btimer);
 		}
 	}
 
@@ -167,14 +197,14 @@ xfs_qm_adjust_dqtimers(
 			&d->d_ino_softlimit, &d->d_ino_hardlimit);
 	if (!d->d_itimer) {
 		if (over) {
-			d->d_itimer = cpu_to_be32(get_seconds() +
+			xfs_quota_set_timer(&d->d_itimer,
 					mp->m_quotainfo->qi_itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
 	} else {
 		if (!over) {
-			d->d_itimer = 0;
+			xfs_quota_clear_timer(&d->d_itimer);
 		}
 	}
 
@@ -182,14 +212,14 @@ xfs_qm_adjust_dqtimers(
 			&d->d_rtb_softlimit, &d->d_rtb_hardlimit);
 	if (!d->d_rtbtimer) {
 		if (over) {
-			d->d_rtbtimer = cpu_to_be32(get_seconds() +
+			xfs_quota_set_timer(&d->d_rtbtimer,
 					mp->m_quotainfo->qi_rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
 	} else {
 		if (!over) {
-			d->d_rtbtimer = 0;
+			xfs_quota_clear_timer(&d->d_rtbtimer);
 		}
 	}
 }
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index f67f3645efcd..52dc5326b7bf 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -25,6 +25,8 @@ xfs_check_ondisk_structs(void)
 	/* make sure timestamp limits are correct */
 	XFS_CHECK_VALUE(XFS_INO_TIME_MIN, 			-2147483648LL);
 	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
+	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
+	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
 
 	/* ag/file structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);

