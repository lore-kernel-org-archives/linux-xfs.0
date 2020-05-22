Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9B9C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0815C207E8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y/1m6Wns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgEVCxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:53:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgEVCxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mwpD095430;
        Fri, 22 May 2020 02:53:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pZDBez5GyNO2Y+gTGtZR6iz0tmYPUR57WmimFGgohkc=;
 b=Y/1m6WnsWzzMoceBUjM8hk2YHjppb1jeTklN8QaaL+Yzyv7QUezUiGB+Ah+PPQ6y+mlx
 nyWON+lmeaAuJpNdcosjGc5klmarAgF5rVxkEFjRk0sJcmXSqktCYFa580r7zFctoy8G
 7I2/1lKwJZ+Je1EnDWeOcCYouPdvCa8HgPFeH+A/iRPMk8BEdtDQaqbv2FBReRa3/bko
 e65vbP8aTVVbzqSRdtrsADfUD+itGBRDxdw3hvGfBckwJJ3u2k068CSjylSqEpbyXUFW
 bVdlfHfddhrdrxPdbFsZIWPRP7AqshMk0/A4UhEvnibsneCPBbUIHFVYDD96cWkbW2oQ 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284mbj0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mYPb186177;
        Fri, 22 May 2020 02:53:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gmaavfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2rZeD004524;
        Fri, 22 May 2020 02:53:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:34 -0700
Subject: [PATCH 01/12] xfs: move eofblocks conversion function to xfs_ioctl.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:53:32 -0700
Message-ID: <159011601269.77079.3759128420308877436.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move xfs_fs_eofblocks_from_user into the only file that actually uses
it, so that we don't have this function cluttering up the header file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.h |   35 -----------------------------------
 fs/xfs/xfs_ioctl.c  |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 48f1fd2bb6ad..c13bc8a3e02f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -81,41 +81,6 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args, int tag);
 
-static inline int
-xfs_fs_eofblocks_from_user(
-	struct xfs_fs_eofblocks		*src,
-	struct xfs_eofblocks		*dst)
-{
-	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
-		return -EINVAL;
-
-	if (src->eof_flags & ~XFS_EOF_FLAGS_VALID)
-		return -EINVAL;
-
-	if (memchr_inv(&src->pad32, 0, sizeof(src->pad32)) ||
-	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
-		return -EINVAL;
-
-	dst->eof_flags = src->eof_flags;
-	dst->eof_prid = src->eof_prid;
-	dst->eof_min_file_size = src->eof_min_file_size;
-
-	dst->eof_uid = INVALID_UID;
-	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
-		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
-		if (!uid_valid(dst->eof_uid))
-			return -EINVAL;
-	}
-
-	dst->eof_gid = INVALID_GID;
-	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
-		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
-		if (!gid_valid(dst->eof_gid))
-			return -EINVAL;
-	}
-	return 0;
-}
-
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 309958186d33..6a3c675a8aeb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2082,6 +2082,41 @@ xfs_ioc_setlabel(
 	return error;
 }
 
+static inline int
+xfs_fs_eofblocks_from_user(
+	struct xfs_fs_eofblocks		*src,
+	struct xfs_eofblocks		*dst)
+{
+	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
+		return -EINVAL;
+
+	if (src->eof_flags & ~XFS_EOF_FLAGS_VALID)
+		return -EINVAL;
+
+	if (memchr_inv(&src->pad32, 0, sizeof(src->pad32)) ||
+	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
+		return -EINVAL;
+
+	dst->eof_flags = src->eof_flags;
+	dst->eof_prid = src->eof_prid;
+	dst->eof_min_file_size = src->eof_min_file_size;
+
+	dst->eof_uid = INVALID_UID;
+	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
+		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
+		if (!uid_valid(dst->eof_uid))
+			return -EINVAL;
+	}
+
+	dst->eof_gid = INVALID_GID;
+	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
+		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
+		if (!gid_valid(dst->eof_gid))
+			return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.

