Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B100BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82F2B2072A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e8Wv/mZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAABGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:06:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgAABGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:06:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115ICE086744
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=L84VjV1mU9JJllrWdLZVup/vYjz69W3OTIged1IyOwI=;
 b=e8Wv/mZdNkoDHIvPt8A5eUZvgjToMbTFBq6qLRrX9ythQwNUVNEpg3ZEgG+nns4bC5h4
 9mGHiYLLUr5yz+77FJvlb6ilsC3phy9kSaTC+JKazzqhb2Ve0AZpAwfJgivoQKo6B8lz
 pm/A6SseIpKhdYJmv6a+qMvjh/U2TJibnMZZDxCQMpug0tsambu2TyzsB0mzHF6CHlRX
 gqy7ZHpCPnyVp1qNSz2ig9UcOjpGiTj1LB8U58zy1/Tyd7qhUR7aFBrCn9qFbUwLQvQ6
 0jzyBKU2AOQ4pxR71d5tMpxMIKm3b4bAT7Ppoqm5qT4FH4kzMP+usy8k2f6UOFYpcLXo sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115LiD039523
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medf9pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 001165tr004703
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:05 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:05 -0800
Subject: [PATCH 01/11] xfs: move eofblocks conversion function to xfs_ioctl.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:01 -0800
Message-ID: <157784076130.1360343.8944098247511283520.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
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
index 7b35d62ede9f..1f1c40b20fa6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1969,6 +1969,41 @@ xfs_ioc_setlabel(
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

