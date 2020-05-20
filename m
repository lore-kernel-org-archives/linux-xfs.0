Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D858EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A872E20829
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ykWblUao"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgETBpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:45:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETBpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:45:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1fkat163607;
        Wed, 20 May 2020 01:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8xwu4wjB2AvX+egHVHBohhpwW30/QTSsd1ZWJ6pgJMc=;
 b=ykWblUaoUJKZBG3HkDJyQEt4nVXcOjypOBwns3wrsQvGT6selQVJSI7fJhgYWcsxfgqc
 73LIk1ErESxInz2O07HwMeUoR/Mz14p7UVNVYSUrzjFpg9u7fODCtmIBuqGhG/uD/ZLO
 pTTuF9N3NYig6icv5gGkuyuy5aTVJ+Fv47bMpXjNjr7Lnq9TEp9ibJMIjQqov/NSistM
 dRCNOw+FXk+OK5SXXkG7EVlbnnEnUVqif/H7/DUChXQW88JWJofjnQo/6jBLgJMBoqMb
 Ad0uQtRRZoSm+YZkn6yZHGqI3evBNirUfJS2hjFo6ZwYi63r/8sOPsza8zSSuh5W0NXH mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284m0h9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:45:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1h9o5032629;
        Wed, 20 May 2020 01:45:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 312sxtudq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:45:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1jPU7024109;
        Wed, 20 May 2020 01:45:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:45:25 -0700
Subject: [PATCH 01/11] xfs: move eofblocks conversion function to xfs_ioctl.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:45:24 -0700
Message-ID: <158993912447.976105.10249427349387670469.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move xfs_fs_eofblocks_from_user into the only file that actually uses
it, so that we don't have this function cluttering up the header file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

