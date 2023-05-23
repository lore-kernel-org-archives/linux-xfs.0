Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF249C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbjEWJBR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjEWJBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE0A109
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6E87j018838;
        Tue, 23 May 2023 09:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=sUdgl5UAhQH+c06U7m1qU0bIy/BRWiheyrHyGx1gbDY=;
 b=uJdQaY1q1B4OKYQaLZOXTwQqYFQxSWo/POgXy3Tw19lsVUnmccOEYaeBGq4oeh2cbEm9
 xv8IzoPU5KWiaoO+tjoi3sc6Ma456hNBk8UpjYhtE4Dq7CngDF/KzYWEGZJPr1gR8z5A
 a4dDQJIa2usJSqkXWIPDS07DhNmzryZufXC1eUaCSS62MHE1NMqVUgTFk0G6I93t8A8o
 YjIKf+Mx9HFYrOP6gvkdeYB2xBtUDT6eXZZK9IqVQyPQuohWacMFR9Kd5+qnyAMK75W4
 nSnu5kkWRXF/7tFKYp9KqaFtkfLed5E9Qy5jJ54JT9wNpYOVIllnsd7kGDHI9LedLdIJ Tw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3qmku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8KSV8029007;
        Tue, 23 May 2023 09:01:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:08 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrX007681;
        Tue, 23 May 2023 09:01:07 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-6;
        Tue, 23 May 2023 09:01:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 05/24] set_cur: Add support to read from external log device
Date:   Tue, 23 May 2023 14:30:31 +0530
Message-Id: <20230523090050.373545-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-GUID: hEak6Q2aiE-12P52W-GRczpbfVz7VXV_
X-Proofpoint-ORIG-GUID: hEak6Q2aiE-12P52W-GRczpbfVz7VXV_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes set_cur() to be able to read from external log
devices. This is required by a future commit which will add the ability to
dump metadata from external log devices.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.c   | 22 +++++++++++++++-------
 db/type.c |  2 ++
 db/type.h |  2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/db/io.c b/db/io.c
index 3d2572364..e8c8f57e2 100644
--- a/db/io.c
+++ b/db/io.c
@@ -516,12 +516,13 @@ set_cur(
 	int		ring_flag,
 	bbmap_t		*bbmap)
 {
-	struct xfs_buf	*bp;
-	xfs_ino_t	dirino;
-	xfs_ino_t	ino;
-	uint16_t	mode;
+	struct xfs_buftarg	*btargp;
+	struct xfs_buf		*bp;
+	xfs_ino_t		dirino;
+	xfs_ino_t		ino;
+	uint16_t		mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
-	int		error;
+	int			error;
 
 	if (iocur_sp < 0) {
 		dbprintf(_("set_cur no stack element to set\n"));
@@ -534,7 +535,14 @@ set_cur(
 	pop_cur();
 	push_cur();
 
+	btargp = mp->m_ddev_targp;
+	if (type->typnm == TYP_ELOG) {
+		ASSERT(mp->m_ddev_targp != mp->m_logdev_targp);
+		btargp = mp->m_logdev_targp;
+	}
+
 	if (bbmap) {
+		ASSERT(btargp == mp->m_ddev_targp);
 #ifdef DEBUG_BBMAP
 		int i;
 		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
@@ -548,11 +556,11 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+		error = -libxfs_buf_read_map(btargp, bbmap->b,
 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
 				ops);
 	} else {
-		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(btargp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
diff --git a/db/type.c b/db/type.c
index efe704456..cc406ae4c 100644
--- a/db/type.c
+++ b/db/type.c
@@ -100,6 +100,7 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
 		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
@@ -144,6 +145,7 @@ static const typ_t	__typtab_spcrc[] = {
 	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
 		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
 	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
+	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTBITMAP, "rtbitmap", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_RTSUMMARY, "rtsummary", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
 	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
diff --git a/db/type.h b/db/type.h
index 411bfe90d..feb5c8219 100644
--- a/db/type.h
+++ b/db/type.h
@@ -14,7 +14,7 @@ typedef enum typnm
 	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
 	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
 	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
-	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
+	TYP_LOG, TYP_ELOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
 	TYP_TEXT, TYP_FINOBT, TYP_NONE
 } typnm_t;
 
-- 
2.39.1

