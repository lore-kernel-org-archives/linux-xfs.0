Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D60C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05DEB206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBEUPBPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgAABNA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190Fd089152
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Wck3FBsH6/5CiPa+hKMdmBKFcRvWkG0QjuEJdm2h5MA=;
 b=EBEUPBPWY1bRJo2/wLFhtvqJmJ+8/ExCo54qHjdxahd+oagAlW4uRjcFLDUVN0SQchCi
 h8oeK5ky5my1jyUQEXyxQ74O2LEnh1qZbXIowMzFNDobcclpdSCb7k83XowHNrtRNjTW
 yFGxAzwxsWVwy1n2mNuzpFMTCKAUp71z69gNPIH5TDniCkYZAIZOw/96clVDrJcPLwJ6
 KeroOWgFUVBeeaE8998x7aAE1pnTCfQFm3lzW1EhvacUu4YYivgpizoIFTjw7Q7uE2Yu
 sFKv0Rrl5l364qtir8+93av8U76qF9GH5fn7g6FkcHJoBc9f36YkIj8W6Qcoxq8TfyPg dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118ueE190224
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg25p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Cv5Y007098
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:57 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:56 -0800
Subject: [PATCH 03/21] xfs: hoist project id get/set functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:54 -0800
Message-ID: <157784117442.1365473.6105962201607220028.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |   12 ++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.h             |    9 ---------
 fs/xfs/xfs_linux.h             |    2 --
 4 files changed, 14 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 477d194f7f61..6931871b109d 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -124,3 +124,15 @@ xfs_dic2xflags(
 
 	return flags;
 }
+
+#define XFS_PROJID_DEFAULT	0
+
+prid_t
+xfs_get_initial_prid(
+	struct xfs_inode	*dp)
+{
+	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_d.di_projid;
+
+	return XFS_PROJID_DEFAULT;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 4110ec44adff..2a2f2e0c65eb 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -11,4 +11,6 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(uint16_t di_flags, uint64_t di_flags2,
 			       bool has_attr);
 
+prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 07a12090655d..6cc1cddd6bfa 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -175,15 +175,6 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 	return ret;
 }
 
-static inline prid_t
-xfs_get_initial_prid(struct xfs_inode *dp)
-{
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		return dp->i_d.di_projid;
-
-	return XFS_PROJID_DEFAULT;
-}
-
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c725ba78ace5..398056206d43 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -135,8 +135,6 @@ typedef __u32			xfs_nlink_t;
  */
 #define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
 
-#define XFS_PROJID_DEFAULT	0
-
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
 static inline void delay(long ticks)

