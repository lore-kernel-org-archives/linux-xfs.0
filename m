Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50331C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2AC2067D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:19:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QseZexld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAHETT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:19:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50444 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHETT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:19:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JIQM035703
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=b+hHdlvhyfFtyLSSjdIcs8RmhGzTxv1vNNBnfBW7JGA=;
 b=QseZexldx1S1AIA0X/YQw+JeTTPBUFpZCLyS5qadVnhR4riS4Jl+Tr//olLR310giu78
 w7A+nKWt8b2Wt3hb+qbVnRWhYxfzPQeoGb4SAQttg9XVejtTpX6yAOFp+kzH15mvndVk
 vUQnjKARFRJmi+8cC1mXEkqjiblTqlA11sEXExTslHyZCxJLX85F/niHQm+lMFHYtzJ/
 lYXxkuO6bSPIOKatPWI83U76N88+2q2pQf3gwe+tH9RapXsxGvU29qttSYs4dWfzh/bV
 6StnZ3zdEbAt2ytVRZ5Gkgctjbi1jM7Hy6tiEubyzsZP3B501v//5Cj01qFFjQeYGQ/k cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbqscg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:19:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084JHMo075736
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:19:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xcjvep2kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:19:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0084IR5b012053
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:18:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:18:27 -0800
Subject: [PATCH 3/3] xfs: make struct xfs_buf_log_format have a consistent
 size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:18:25 -0800
Message-ID: <157845710512.84011.14528616369807048509.stgit@magnolia>
In-Reply-To: <157845708352.84011.17764262087965041304.stgit@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=975
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
end of struct xfs_buf_log_format.  This makes the size consistent so
that we can check it in xfs_ondisk.h, and will be needed once we start
logging attribute values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |    9 +++++----
 fs/xfs/xfs_ondisk.h            |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8ef31d71a9c7..5d8eb8978c33 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -462,11 +462,12 @@ static inline uint xfs_log_dinode_size(int version)
 #define	XFS_BLF_GDQUOT_BUF	(1<<4)
 
 /*
- * This is the structure used to lay out a buf log item in the
- * log.  The data map describes which 128 byte chunks of the buffer
- * have been logged.
+ * This is the structure used to lay out a buf log item in the log.  The data
+ * map describes which 128 byte chunks of the buffer have been logged.  Note
+ * that XFS_BLF_DATAMAP_SIZE is an odd number so that the structure size will
+ * be consistent between 32-bit and 64-bit platforms.
  */
-#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
+#define XFS_BLF_DATAMAP_SIZE	(1 + ((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD))
 
 typedef struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index b6701b4f59a9..5f04d8a5ab2a 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -111,6 +111,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
 
 	/* log structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);

