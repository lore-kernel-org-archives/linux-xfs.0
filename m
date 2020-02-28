Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479A7C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19BA72469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fOOzoYVW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgB1Xjd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1Xjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNclQ0032340;
        Fri, 28 Feb 2020 23:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wjtE904LvKpbv/MS0KRBQsdG9sqY45w0hqsVfEKJNmk=;
 b=fOOzoYVWdqaAtbRdsWtzI6QTQdhuzjLz09vXFvKyrHPu4PAGKulWrUx7bZU8PzxutWEJ
 NJ6HByea5CpjuHc+kdKl8tEa3lMo0CKWcG75YgrRWUG5Abj3hdKQfS8JnlPA5aBxZWCJ
 3gdvmvo4Cki8BuUpzpQkZEvDESShHVuwY0rm7z66v4Z9VGyAvXwBiL3CZZLNL4LWSVBp
 FObyQRutf7m3CDbXgAE/1ni58AcrDtePsQaX1wDz9tYnskvrYz4n1j+mlVd1G5IIA91R
 InjFIBp/N/p8vhnAWoY/OPA3FBduFqYGfc8IYtb7eaAenD8pz6vgMMnerpzLauCxKZWs Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct3nt84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:39:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNanYV113431;
        Fri, 28 Feb 2020 23:37:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcsgej4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNbSWH020566;
        Fri, 28 Feb 2020 23:37:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:27 -0800
Subject: [PATCH 11/26] xfs_db: use uncached buffer reads to get the
 superblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:24 -0800
Message-ID: <158293304493.1549542.2684572550683485144.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=954 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Upon startup, xfs_db needs to check if it is even looking at an XFS
filesystem, and it needs the AG 0 superblock contents to initialize the
incore mount.  We cannot know the filesystem sector size until we read
the superblock, but we also do not want to introduce aliasing in the
buffer cache.  Convert this code to the new uncached buffer read API so
that we can stop open-coding it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/init.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/db/init.c b/db/init.c
index 8bad7e53..61eea111 100644
--- a/db/init.c
+++ b/db/init.c
@@ -47,6 +47,7 @@ init(
 	struct xfs_buf	*bp;
 	unsigned int	agcount;
 	int		c;
+	int		error;
 
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -112,10 +113,9 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_buf_read(xmount.m_ddev_targp, XFS_SB_DADDR,
-			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
-
-	if (!bp || bp->b_error) {
+	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
+			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
+	if (error) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
@@ -124,7 +124,6 @@ init(
 	/* copy SB from buffer to in-core, converting architecture as we go */
 	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
 	libxfs_buf_relse(bp);
-	libxfs_purgebuf(bp);
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {

