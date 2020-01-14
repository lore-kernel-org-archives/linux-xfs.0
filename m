Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A01C33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1807620678
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pm302YAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgANGcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:32:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgANGcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:32:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6CrbE133718;
        Tue, 14 Jan 2020 06:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dvvEvMpCQBkf6gcoPDMeBYR7WthXY4c2KLQpN6SULWE=;
 b=Pm302YAiGdTa3t7+CKa1V4/8HgayVgDfftJOaVqI0FsXApmQ1wa3ts0dJuxSG1Hd2gip
 nzXCFfRo80LYh2tv2E9hTr+A/vLTORi96VKS+aHsiQohYkwPKctVLAQ8ics8evlAGzhO
 T4u/exkLHqKdLgx//3YVwvtM+pwzWCS1MVdPbuHKykGO7KBbv7qfiaH3sJ9bYWFF3VJe
 OFgSB+DXpmKcoVGs1Huf8ec/slQWb+hrd/ZUeIRbhm1cdStAcj0uou9we/FrZpyNTCym
 8xTxI4lUrDRgYLzxVGFvfOwXW4vRNNwSWgAOmzXJARRmeB+2RZIyq1y++M6WnlJD+qyP rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73ybv68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:32:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6UJj1053880;
        Tue, 14 Jan 2020 06:32:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xh2sbyfbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:32:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00E6W46L001496;
        Tue, 14 Jan 2020 06:32:04 GMT
Received: from localhost (/10.159.236.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 22:32:04 -0800
Subject: [PATCH 5/6] xfs: make struct xfs_buf_log_format have a consistent
 size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 13 Jan 2020 22:32:03 -0800
Message-ID: <157898352339.1566005.1438502032061258214.stgit@magnolia>
In-Reply-To: <157898348940.1566005.3231891474158666998.stgit@magnolia>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=899
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=955 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140055
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
end of struct xfs_buf_log_format.  This makes the size consistent so
that we can check it in xfs_ondisk.h, and will be needed once we start
logging attribute values.

On amd64 we get the following pahole:

struct xfs_buf_log_format {
        short unsigned int         blf_type;       /*     0     2 */
        short unsigned int         blf_size;       /*     2     2 */
        short unsigned int         blf_flags;      /*     4     2 */
        short unsigned int         blf_len;        /*     6     2 */
        long long int              blf_blkno;      /*     8     8 */
        unsigned int               blf_map_size;   /*    16     4 */
        unsigned int               blf_data_map[16]; /*    20    64 */
        /* --- cacheline 1 boundary (64 bytes) was 20 bytes ago --- */

        /* size: 88, cachelines: 2, members: 7 */
        /* padding: 4 */
        /* last cacheline: 24 bytes */
};

But on i386 we get the following:

struct xfs_buf_log_format {
        short unsigned int         blf_type;       /*     0     2 */
        short unsigned int         blf_size;       /*     2     2 */
        short unsigned int         blf_flags;      /*     4     2 */
        short unsigned int         blf_len;        /*     6     2 */
        long long int              blf_blkno;      /*     8     8 */
        unsigned int               blf_map_size;   /*    16     4 */
        unsigned int               blf_data_map[16]; /*    20    64 */
        /* --- cacheline 1 boundary (64 bytes) was 20 bytes ago --- */

        /* size: 84, cachelines: 2, members: 7 */
        /* last cacheline: 20 bytes */
};

Notice how the amd64 compiler inserts 4 bytes of padding to the end of
the structure to ensure 8-byte alignment.  Prior to "xfs: fix memory
corruption during remote attr value buffer invalidation" we would try to
write to blf_data_map[17], which is harmless on amd64 but really bad on
i386.

This shouldn't cause any changes in the ondisk logging formats because
the log code writes out the log vectors with the appropriate size for
the log item's map_size, and log recovery treats the data_map array as a
VLA.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |   19 ++++++++++++++-----
 fs/xfs/xfs_ondisk.h            |    1 +
 2 files changed, 15 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8ef31d71a9c7..9bac0d2e56dc 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -462,11 +462,20 @@ static inline uint xfs_log_dinode_size(int version)
 #define	XFS_BLF_GDQUOT_BUF	(1<<4)
 
 /*
- * This is the structure used to lay out a buf log item in the
- * log.  The data map describes which 128 byte chunks of the buffer
- * have been logged.
- */
-#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
+ * This is the structure used to lay out a buf log item in the log.  The data
+ * map describes which 128 byte chunks of the buffer have been logged.
+ *
+ * The placement of blf_map_size causes blf_data_map to start at an odd
+ * multiple of sizeof(unsigned int) offset within the struct.  Because the data
+ * bitmap size will always be an even number, the end of the data_map (and
+ * therefore the structure) will also be at an odd multiple of sizeof(unsigned
+ * int).  Some 64-bit compilers will insert padding at the end of the struct to
+ * ensure 64-bit alignment of blf_blkno, but 32-bit ones will not.  Therefore,
+ * XFS_BLF_DATAMAP_SIZE must be an odd number to make the padding explicit and
+ * keep the structure size consistent between 32-bit and 64-bit platforms.
+ */
+#define __XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
+#define XFS_BLF_DATAMAP_SIZE	(__XFS_BLF_DATAMAP_SIZE + 1)
 
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

