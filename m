Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA996C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ECBE214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BSq28NGy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgBEAq5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:46:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbgBEAq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:46:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150eM9n103863;
        Wed, 5 Feb 2020 00:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RFCf/t+rnDm8sEvpwuW3IGQ2dOZidV0SqRh+7RMw4e4=;
 b=BSq28NGyY5YIdBJvw+uDWYwGCCfDNmyHREtfh72lCvYNLqj+fr7mBdnG41dceZyrmvDu
 oC/hItfC1jery5Rau3Lu50GFwg5SdsJe9IghtoashfBvukMWoupUK8m8wMPzWTgiJaM4
 3kittzditELZfvUziL8X0yqs7iSGYjdEjtPtfg3VRVFQFWE1U3ks1HuLJcKFjJMpH4iz
 iau0dCfhyPcBzjgd6tjwlmIAE7hMZ/kJ+sl3WjZsfSi7dQQrp8p/DAO4L0NCOhnwugTK
 hYgkXnHvM+cp52MvA40lYg+I+cygFjlbT+5cxvw7NWEnfCkwZvtjLemqqSX6Pc8XcBSB rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xykbp00mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150d4NI166192;
        Wed, 5 Feb 2020 00:46:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xykbqgdbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150kprY010307;
        Wed, 5 Feb 2020 00:46:51 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:51 -0800
Subject: [PATCH 2/7] mkfs: check root inode location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        alex@zadara.com
Date:   Tue, 04 Feb 2020 16:46:50 -0800
Message-ID: <158086361042.2079685.15091609361190214982.stgit@magnolia>
In-Reply-To: <158086359783.2079685.9581209719946834913.stgit@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the root inode gets created where repair thinks it should be
created.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   39 +++++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9daf2635..7c629c62 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -98,6 +98,7 @@
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
+#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 606f79da..cc71fd39 100644
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

