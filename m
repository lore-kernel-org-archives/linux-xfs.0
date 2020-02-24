Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759F1C35641
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F11920828
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgBXD60 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:58:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727221AbgBXD6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:58:25 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3tCVR074261;
        Sun, 23 Feb 2020 22:58:22 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb12a93sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:22 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3vTVk078522;
        Sun, 23 Feb 2020 22:58:22 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb12a93se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:22 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3v7k1030694;
        Mon, 24 Feb 2020 03:58:21 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 2yaux5vaua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:21 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3wKVX39911710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:58:20 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E996F6A04D;
        Mon, 24 Feb 2020 03:58:19 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDF626A057;
        Mon, 24 Feb 2020 03:58:16 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:58:16 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 6/7] xfs: Make xfs_attr_calc_size() non-static
Date:   Mon, 24 Feb 2020 09:30:43 +0530
Message-Id: <20200224040044.30923-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040044.30923-1-chandanrlinux@gmail.com>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1034 priorityscore=1501 lowpriorityscore=0 suspectscore=1
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will cause xfs_attr_calc_size() to be invoked from a function
defined in another file. Hence this commit makes xfs_attr_calc_size() as
non-static.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f781724bf85ce..1d62ce80d7949 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -133,10 +133,38 @@ xfs_attr_get(
 	return error;
 }
 
+STATIC int
+xfs_attr_try_sf_addname(
+	struct xfs_inode	*dp,
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error, error2;
+
+	error = xfs_attr_shortform_addname(args);
+	if (error == -ENOSPC)
+		return error;
+
+	/*
+	 * Commit the shortform mods, and we're done.
+	 * NOTE: this is also the error path (EEXIST, etc).
+	 */
+	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
+		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(args->trans);
+
+	error2 = xfs_trans_commit(args->trans);
+	args->trans = NULL;
+	return error ? error : error2;
+}
+
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC void
+void
 xfs_attr_calc_size(
 	struct xfs_mount		*mp,
 	struct xfs_attr_set_resv	*resv,
@@ -176,34 +204,6 @@ xfs_attr_calc_size(
 		resv->bmbt_blks;
 }
 
-STATIC int
-xfs_attr_try_sf_addname(
-	struct xfs_inode	*dp,
-	struct xfs_da_args	*args)
-{
-
-	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
-
-	error = xfs_attr_shortform_addname(args);
-	if (error == -ENOSPC)
-		return error;
-
-	/*
-	 * Commit the shortform mods, and we're done.
-	 * NOTE: this is also the error path (EEXIST, etc).
-	 */
-	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
-
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args->trans);
-
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
-}
-
 /*
  * Set the attribute specified in @args.
  */
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index dc08bdfbc9615..0e387230744c3 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -104,5 +104,7 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_attr_calc_size(struct xfs_mount *mp, struct xfs_attr_set_resv *resv,
+		int namelen, int valuelen, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.19.1

