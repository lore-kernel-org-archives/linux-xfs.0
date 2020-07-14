Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808C6C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B59021927
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PXQP/6Y0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGNBb5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:31:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGNBb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:31:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1Qx1Y123728
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tco/9osRzDiVVwj044E18X9stfUHwhovZDWbBs3+Ops=;
 b=PXQP/6Y0KRG/+BTeMcal9fpNXYfPKzIQOfUhsdmUy7jemoBn4Y6L+18Zd0fR+UbbGnsk
 32VMQGpMNhAi8H+UHjyGqwJE2sIzOopvXQAoSK/fBi7E/mPizKAT08tWKQEjfHXoxLiy
 sy3lIckViBccFMVv2neqTTTV2kTJfThMgSKbH6gHZ0uOCUvZHFVNjYFW6xrRUCFLW+Sp
 ztaUba0iH9LCkW56pZ9L13qsNiWhcqHvoKkfq0d2Nox0A7nDR/iDEWmPsr7TeePRVtM+
 6N5C7qxxnxZEA8r1Gys9se3l+09FgNxwMkEBpqUvrTK+4ZbI1b4sqK2Oq5601lqcrbpD fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762na9tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:31:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1SaR6054861
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:31:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qbwgx0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:31:55 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1VsYf012132
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:31:54 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:31:54 -0700
Subject: [PATCH 04/26] xfs: move the flags argument of
 xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:31:54 -0700
Message-ID: <159469031402.2914673.4988908192357652743.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since xfs_qm_scall_trunc_qfiles can take a bitset of quota types that we
want to truncate, change the flags argument to take XFS_QMOPT_[UGP}QUOTA
so that the next patch can start to deprecate XFS_DQ_*.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

