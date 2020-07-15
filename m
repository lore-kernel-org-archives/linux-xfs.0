Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5FFC433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388082074B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzGkM5+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgGOBvH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:51:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:51:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1kvD8167664;
        Wed, 15 Jul 2020 01:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+bwFob7EVNPUAQwfZ3scUAY90oGR1a/HrhlWLy/T7gA=;
 b=WzGkM5+wmmxQQsGwgqN+pmx0yLH2Gyn8lCrGNhJcoMwmCH8Uz5CfKYw5YmqEMH2Gt/Y0
 qj1Z7id8zef4tw0ByE3TsjTt3J0d471+HFk0sY/I+oO9PoznwV4HY1VmAO//aaebZURT
 jSzRT1PuSg1yuZZ6DrfTJRJkJhYJheH6aEK5p6YXIkCY5DDnWvOtqte0YtgJuMagmmzw
 iW28jmnmOzYRQmDLCwCZ+Cs1Nyfsyr108pMv5/je2G8M2D1+J3gchpJl2hmbZyGNQXBE
 +szF9LOFWqhzFCc2rdJrHD6e85jXVrLrZ1FzxCC0M3dGnfb4o01BCLhTAVtkZB6xvpaF KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cm8mmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:51:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lcqX080888;
        Wed, 15 Jul 2020 01:51:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0qa5xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:51:03 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1p3Xm018447;
        Wed, 15 Jul 2020 01:51:03 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:51:02 -0700
Subject: [PATCH 04/26] xfs: move the flags argument of
 xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:50:58 -0700
Message-ID: <159477785867.3263162.14797330963625412377.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since xfs_qm_scall_trunc_qfiles can take a bitset of quota types that we
want to truncate, change the flags argument to take XFS_QMOPT_[UGP}QUOTA
so that the next patch can start to deprecate XFS_DQ_*.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_syscalls.c |    8 ++++----
 fs/xfs/xfs_quotaops.c    |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7effd7a28136..35fad348e3a2 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -322,23 +322,23 @@ xfs_qm_scall_trunc_qfiles(
 	int		error = -EINVAL;
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0 ||
-	    (flags & ~XFS_DQ_ALLTYPES)) {
+	    (flags & ~XFS_QMOPT_QUOTALL)) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
 			__func__, flags, mp->m_qflags);
 		return -EINVAL;
 	}
 
-	if (flags & XFS_DQ_USER) {
+	if (flags & XFS_QMOPT_UQUOTA) {
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
 		if (error)
 			return error;
 	}
-	if (flags & XFS_DQ_GROUP) {
+	if (flags & XFS_QMOPT_GQUOTA) {
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
 		if (error)
 			return error;
 	}
-	if (flags & XFS_DQ_PROJ)
+	if (flags & XFS_QMOPT_PQUOTA)
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
 
 	return error;
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index bf809b77a316..0868e6ee2219 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -205,11 +205,11 @@ xfs_fs_rm_xquota(
 		return -EINVAL;
 
 	if (uflags & FS_USER_QUOTA)
-		flags |= XFS_DQ_USER;
+		flags |= XFS_QMOPT_UQUOTA;
 	if (uflags & FS_GROUP_QUOTA)
-		flags |= XFS_DQ_GROUP;
+		flags |= XFS_QMOPT_GQUOTA;
 	if (uflags & FS_PROJ_QUOTA)
-		flags |= XFS_DQ_PROJ;
+		flags |= XFS_QMOPT_PQUOTA;
 
 	return xfs_qm_scall_trunc_qfiles(mp, flags);
 }

