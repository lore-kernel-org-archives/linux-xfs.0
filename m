Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3327C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8032063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eHaJAYUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgEIQbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GPSev065598;
        Sat, 9 May 2020 16:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9/8p2pSeNLN8oDv4pZtCefxvMMy0j4OvXk/HXcJH2lk=;
 b=eHaJAYUqJcpRCb4Tl8rvyv9JRLQYOCNKaJ6rQ7GL0HFuNcCDQod+kH+TrgYNE8tOsarg
 tRATmEEsprIncIu0gzGSrbF5cwvzue2KbagJRxB3YpvOd8CvF1EtaKxPK1saD37e1FiU
 xUjaJ+rD8Xop6VUECLDAkSgmQM4XQShWNW/yqli5myuIWBdkQy+Z2Zr6aCZDidHRByWd
 PrM9H++fnqNMyOPuSybx0fRIOTU0qCZFzTIqQ66A9Fz4UFt+6Zjf+SE9qt5QUoQl3HFb
 WhwXrP3zlgA1uHiJB6Plh+6X2QrcHdI5gP7ez91s2xmsKb6Mm5gTAudPZShBKVqvP5C9 aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30wx8n86pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRcFv132516;
        Sat, 9 May 2020 16:31:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30wwxb5hux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:02 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GV1xU004762;
        Sat, 9 May 2020 16:31:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:01 -0700
Subject: [PATCH 10/16] xfs_repair: refactor verify_dfsbno_range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:31:00 -0700
Message-ID: <158904186058.982941.7156787817804393560.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor this function to use libxfs type checking helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dinode.c          |   26 +++++++++-----------------
 2 files changed, 10 insertions(+), 17 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c03f0efa..69f79a08 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -184,6 +184,7 @@
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
+#define xfs_verify_fsbno		libxfs_verify_fsbno
 #define xfs_verify_ino			libxfs_verify_ino
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_zero_extent			libxfs_zero_extent
diff --git a/repair/dinode.c b/repair/dinode.c
index b343534c..135703d9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -228,31 +228,23 @@ verify_dfsbno(xfs_mount_t	*mp,
 #define XR_DFSBNORANGE_OVERFLOW	3
 
 static __inline int
-verify_dfsbno_range(xfs_mount_t	*mp,
-		xfs_fsblock_t	fsbno,
-		xfs_filblks_t	count)
+verify_dfsbno_range(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		count)
 {
-	xfs_agnumber_t	agno;
-	xfs_agblock_t	agbno;
-	xfs_sb_t	*sbp = &mp->m_sb;;
-
 	/* the start and end blocks better be in the same allocation group */
-	agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	if (agno != XFS_FSB_TO_AGNO(mp, fsbno + count - 1)) {
+	if (XFS_FSB_TO_AGNO(mp, fsbno) !=
+	    XFS_FSB_TO_AGNO(mp, fsbno + count - 1)) {
 		return XR_DFSBNORANGE_OVERFLOW;
 	}
 
-	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
-	if (verify_ag_bno(sbp, agno, agbno)) {
+	if (!libxfs_verify_fsbno(mp, fsbno))
 		return XR_DFSBNORANGE_BADSTART;
-	}
-
-	agbno = XFS_FSB_TO_AGBNO(mp, fsbno + count - 1);
-	if (verify_ag_bno(sbp, agno, agbno)) {
+	if (!libxfs_verify_fsbno(mp, fsbno + count - 1))
 		return XR_DFSBNORANGE_BADEND;
-	}
 
-	return (XR_DFSBNORANGE_VALID);
+	return XR_DFSBNORANGE_VALID;
 }
 
 static int

