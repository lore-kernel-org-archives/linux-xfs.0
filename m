Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6372EC35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31AEC2071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jlfblQI3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgAXARi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAXARi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O09MsX183357;
        Fri, 24 Jan 2020 00:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=grYQK3PXfdhZe9HX4XjWffOEhxMbJCu5gI0+JOkVNnA=;
 b=jlfblQI3S+EzAZbtw4z9f9wVCigC1DdvIgxtUkhaEO7calqtKlGecAEy7ARHRqOGgaTY
 G/YlKNmV1Qn09oBnjwx36Qy0YH4Bv8QARynkFQRXZTNDqF8av+gVARlYMMBkkJh1hWfP
 2vrSjF9fu7AUwrjmgi603/MArMqSD6844Ml0jTSgKevxkSpLlgUjIiQXqFs1Wf+2aQgz
 6iin6/7/TdFtbKDD0s5ohanZb+biMu91ZmPWVBEHRvKpDb08uV9MYYyIETu2fvMFy5q2
 wE2ACZtgEgvdNe1sh8IBgF+S2Rfc3+wA8+6Q+aIXMC+WGPHwG9zZRBN5Dp9M3VX67QJT Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqns3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E6Ym111069;
        Fri, 24 Jan 2020 00:17:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1h5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:35 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0HZ9r020321;
        Fri, 24 Jan 2020 00:17:35 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:35 -0800
Subject: [PATCH 1/6] mkfs: check root inode location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Thu, 23 Jan 2020 16:17:32 -0800
Message-ID: <157982505230.2765631.2328249334657581135.stgit@magnolia>
In-Reply-To: <157982504556.2765631.630298760136626647.stgit@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the root inode gets created where repair thinks it should be
created.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   39 +++++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cc7304ad..9ede0125 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -172,6 +172,7 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 
 #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 784fe6a9..91a25bf5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3549,6 +3549,38 @@ rewrite_secondary_superblocks(
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 }
 
+static void
+check_root_ino(
+	struct xfs_mount	*mp)
+{
+	xfs_ino_t		ino;
+
+	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
+		fprintf(stderr,
+			_("%s: root inode created in AG %u, not AG 0\n"),
+			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
+		exit(1);
+	}
+
+	/*
+	 * The superblock points to the root directory inode, but xfs_repair
+	 * expects to find the root inode in a very specific location computed
+	 * from the filesystem geometry for an extra level of verification.
+	 *
+	 * Fail the format immediately if those assumptions ever break, because
+	 * repair will toss the root directory.
+	 */
+	ino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
+	if (mp->m_sb.sb_rootino != ino) {
+		fprintf(stderr,
+	_("%s: root inode (%llu) not allocated in expected location (%llu)\n"),
+			progname,
+			(unsigned long long)mp->m_sb.sb_rootino,
+			(unsigned long long)ino);
+		exit(1);
+	}
+}
+
 int
 main(
 	int			argc,
@@ -3835,12 +3867,7 @@ main(
 	/*
 	 * Protect ourselves against possible stupidity
 	 */
-	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
-		fprintf(stderr,
-			_("%s: root inode created in AG %u, not AG 0\n"),
-			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
-		exit(1);
-	}
+	check_root_ino(mp);
 
 	/*
 	 * Re-write multiple secondary superblocks with rootinode field set

