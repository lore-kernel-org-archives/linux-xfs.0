Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEB3C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 468BC20640
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F6Xv45h9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfLBRia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:38:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfLBRia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:38:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZFXw043007;
        Mon, 2 Dec 2019 17:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yTqZQ1GWCwDgLpkxADLhONC6RSHkpvSLRDSrHLBePfk=;
 b=F6Xv45h9Q9yT4Dn/KYg/UD0cXqdC2IjgwCm4PSjIH+6XN8VjbIc1HiFrSN0dj2vjiBgm
 Irz5neN9mevNzVxWHpZEz+hy3LKxsRbQHVt49IoQZrRlU6hZDSzd6kHuGnD//z870gJB
 a7XaEb/44zUdYA6GJZf2fABkiYT19yz6pvZkv9igN0kY64MRxys+sXpLHZ1bYCQEdwQ9
 BgxeDlGM1tIRX8M5BV4fEeJ0Qlqpfu0z5mXNx7IV7ckE3zFlO3wKYL+KPgVzWsNJS04g
 p2FaP7NR/SfFIC/+qobyb1qRReYQWmumpuR1VgTLp2Py58w8/Man4kl58TgfhoeE3Ne1 vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcq1mm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:38:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYRX5169774;
        Mon, 2 Dec 2019 17:36:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wm1xp7543-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:27 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB2HaQIJ012372;
        Mon, 2 Dec 2019 17:36:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:36:26 -0800
Subject: [PATCH 4/4] xfs_repair: check plausiblitiy of root dir pointer
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Mon, 02 Dec 2019 09:36:25 -0800
Message-ID: <157530818573.126767.13434243816626977089.stgit@magnolia>
In-Reply-To: <157530815855.126767.7523979488668040754.stgit@magnolia>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If sb_rootino doesn't point to where we think mkfs was supposed to have
preallocated an inode chunk, check to see if the alleged root directory
actually looks like a root directory.  If so, we'll let it go because
someone could have changed sunit since formatting time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 6798b88c..f6134cca 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -395,12 +395,60 @@ do_log(char const *msg, ...)
 	va_end(args);
 }
 
+/*
+ * If sb_rootino points to a different inode than we were expecting, try
+ * loading the alleged root inode to see if it's a plausibly a root directory.
+ * If so, we'll readjust the computations.
+ */
+static void
+check_misaligned_root(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	int			error;
+
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
+			&xfs_default_ifork_ops);
+	if (error)
+		return;
+	if (!S_ISDIR(VFS_I(ip)->i_mode))
+		goto out_rele;
+
+	error = -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
+	if (error)
+		goto out_rele;
+
+	if (ino == mp->m_sb.sb_rootino) {
+		do_warn(
+_("sb root inode value %" PRIu64 " inconsistent with calculated value %u but looks like a root directory\n"),
+			mp->m_sb.sb_rootino, first_prealloc_ino);
+		last_prealloc_ino += (int)ino - first_prealloc_ino;
+		first_prealloc_ino = ino;
+	}
+
+out_rele:
+	libxfs_irele(ip);
+}
+
 static void
-calc_mkfs(xfs_mount_t *mp)
+calc_mkfs(
+	struct xfs_mount	*mp)
 {
 	libxfs_ialloc_find_prealloc(mp, &first_prealloc_ino,
 			&last_prealloc_ino);
 
+	/*
+	 * If the root inode isn't where we think it is, check its plausibility
+	 * as a root directory.  It's possible that somebody changed sunit since
+	 * the filesystem was created, which can change the value of the above
+	 * computation.  Try to avoid blowing up the filesystem if this is the
+	 * case.
+	 */
+	if (mp->m_sb.sb_rootino != NULLFSINO &&
+	    mp->m_sb.sb_rootino != first_prealloc_ino)
+		check_misaligned_root(mp);
+
 	/*
 	 * now the first 3 inodes in the system
 	 */

