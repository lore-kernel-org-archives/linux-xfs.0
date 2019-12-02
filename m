Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F85DC432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10BA020848
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RBGIDMhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLBRgQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:36:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfLBRgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:36:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZDtL042976;
        Mon, 2 Dec 2019 17:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Tf/pZ87vyN7IEPeW28XoKJocGtIEn/CM2zjCYJjgVUE=;
 b=RBGIDMhu4EhSkZlFh5GhsdmjBqVF/CHfLWLhrIIvoE1oGbtZ7fIj0khH7tJc+g/BgF3g
 5ItcqPqE7JkMh00COZR3BCq+WzfDpQDpjpWjzrGXwQx+bNbSpPDzFRMPtC3eODG0ArqL
 afFnqZZ5nbpeUMz6wR9uOfTuO8tXkghbbjZHG6m1bD4JAOr4XowVa1ih/ZT9uVpV1VG7
 YBvYvXFDymPVjgo5+Ubs157Ecca/TxRDsQSN46ELhmJ4qZyWtat6nPhTxIzWg+OTbFMr
 k34/aP83G85eZi3U8u6CMr8vXqk+iytWvQFEB3J98o5zLTVm6KRZkkQxC2Z5SPVDoaA3 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wkgcq1m5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYPCG102605;
        Mon, 2 Dec 2019 17:36:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wm2jw9ygf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2HaC5L010710;
        Mon, 2 Dec 2019 17:36:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:36:12 -0800
Subject: [PATCH 2/4] mkfs: check root inode location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Mon, 02 Dec 2019 09:36:11 -0800
Message-ID: <157530817131.126767.4542572453231190489.stgit@magnolia>
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

Make sure the root inode gets created where repair thinks it should be
created.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 645c9b1b..8f6b9fc2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -156,5 +156,6 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_ialloc_find_prealloc	libxfs_ialloc_find_prealloc
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 18338a61..5143d9b4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3521,6 +3521,28 @@ rewrite_secondary_superblocks(
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 }
 
+static void
+check_root_ino(
+	struct xfs_mount	*mp)
+{
+	xfs_agino_t		first, last;
+
+	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) != 0) {
+		fprintf(stderr,
+			_("%s: root inode created in AG %u, not AG 0\n"),
+			progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
+		exit(1);
+	}
+
+	libxfs_ialloc_find_prealloc(mp, &first, &last);
+	if (mp->m_sb.sb_rootino != XFS_AGINO_TO_INO(mp, 0, first)) {
+		fprintf(stderr,
+			_("%s: root inode (%llu) not created in first chunk\n"),
+			progname, (unsigned long long)mp->m_sb.sb_rootino);
+		exit(1);
+	}
+}
+
 int
 main(
 	int			argc,
@@ -3807,12 +3829,7 @@ main(
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

