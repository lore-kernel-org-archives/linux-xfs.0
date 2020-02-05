Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D36C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C00C21744
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RLShm4Fo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBEAqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:46:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBEAqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:46:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150deCd124168;
        Wed, 5 Feb 2020 00:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UyanGVnv18tTGVAI6RvxMpneWZd5sZ/AkObhesMMnt4=;
 b=RLShm4FopeRJdJPSin/HDKO17RnUwPWTUgV2cN1o9qqcYHkBmrUDHG7zRcRnT2tnUu1Y
 kL0/VG5ABv1YmwIQ6exS0maA0IdzIGF/LOYUHHBGY2NsAGJ6Z4zx/AoC0eVYtsQkCefJ
 b5XWdMAlbBv0dVDDibjFj5JPek4wfXp0RYjKjGDMKp2sSIp89asbHThtVkoXzZ6eZ1Pg
 HeitVvI2ed5vI8xWHc17hIQ5AHaNhCLsxfboRPPAEsBfnv/U9aHcqtfOMtECC5UJPxih
 7ta518lPzyb6P+f7I5501B0JIHl7oBvEwNReBjIUe2XSDf7s0Dbe0qu+VkbhO5DP4Yfo Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xykbp00hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150cvK9165952;
        Wed, 5 Feb 2020 00:46:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xykbqgcky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150kTqR010867;
        Wed, 5 Feb 2020 00:46:29 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:28 -0800
Subject: [PATCH 3/4] xfs_repair: refactor attr root block pointer check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:46:28 -0800
Message-ID: <158086358798.2079557.6562544272527988911.stgit@magnolia>
In-Reply-To: <158086356778.2079557.17601708483399404544.stgit@magnolia>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In process_longform_attr, replace the agcount check with a call to the
fsblock verification function in libxfs.  Now we can also catch blocks
that point to static FS metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 9a44f610..7b26df33 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -980,21 +980,21 @@ process_longform_attr(
 	*repair = 0;
 
 	bno = blkmap_get(blkmap, 0);
-
-	if ( bno == NULLFSBLOCK ) {
+	if (bno == NULLFSBLOCK) {
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
 				be16_to_cpu(dip->di_anextents) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
 			ino);
-		return(1);
+		return 1;
 	}
+
 	/* FIX FOR bug 653709 -- EKN */
-	if (mp->m_sb.sb_agcount < XFS_FSB_TO_AGNO(mp, bno)) {
+	if (!xfs_verify_fsbno(mp, bno)) {
 		do_warn(
 	_("agno of attribute fork of inode %" PRIu64 " out of regular partition\n"), ino);
-		return(1);
+		return 1;
 	}
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),

