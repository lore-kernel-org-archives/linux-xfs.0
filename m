Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB08C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219C2206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bwnyDUP9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:20:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:20:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FsnO113342;
        Wed, 1 Jan 2020 01:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kTJFFE3aSkyExhoJRN+MDWUYfnizpLgP0vBd4vzFJpM=;
 b=bwnyDUP9jDok3eWq+t+WQYzSpWQPdft17JDuM3QThahoPqX+aP50Vk0oTC5+XiIPG3jB
 LGb5AfkQOqvs//uoYWJ+WfAEnntSYZDq2gme7x0PWZbjaWPLmUhJRzjoleFGPLCuoqDr
 M0ytAiNeOy8AkAsRWQ1YvGtsxyCdJr6INfDnr7EpiFFx0k/j/bxWfm8mW32Zdlw7njF0
 GLhR28Zaj3PldxpkDp7e+sxhjO1F+cRKntLk+13BVLbPD6SNCD2G5yKzlcC3YoVZwl8u
 DDFtO7NOZYDyR8rLBSHwu4uRsVTSCPwt4RApvVbLRmmSGXsmF/HAV2OyO92ctN/gmGdV yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011I7c2056878;
        Wed, 1 Jan 2020 01:20:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfj0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Kpfa030843;
        Wed, 1 Jan 2020 01:20:51 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:20:50 -0800
Subject: [PATCH 1/6] mkfs: check root inode location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 31 Dec 2019 17:20:48 -0800
Message-ID: <157784164821.1371066.13806897497760939622.stgit@magnolia>
In-Reply-To: <157784164200.1371066.15490825981810186191.stgit@magnolia>
References: <157784164200.1371066.15490825981810186191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
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
index 99d12c34..b042f0a2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -173,5 +173,6 @@
 #define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
 #define xfs_dir2_data_get_ftype		libxfs_dir2_data_get_ftype
 #define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
+#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 
 #endif /* __LIBXFS_API_DEFS_H__ */
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

