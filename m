Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E1AC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 372942469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KS/wMEEa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB1Xjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54658 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgB1Xjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXbUq069336;
        Fri, 28 Feb 2020 23:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=R+TzaO/KFXQMeb9+P+WhI5GW6ARQMKUoz4+RyS0XX4U=;
 b=KS/wMEEa3v0ifEmIoXaOVGJijjrbjkRVti/KwF1Rc/CWjvDm4aBYDGFzFK2RzhycbVAZ
 10uyfgWipYDk2ZbnR4PhbeGR2NllbhDE6ejwKpAS+Jgegerf5gpO0efnrtYPuPd7igrV
 AXQH0qdPD7ku2pB3jvDFTqR+ZjBy4K3H0KR1FnI8RUDBX6AU7ALA3YgRJNYWRyjiAFUf
 G1zpLdr8Y68kU9Y+37LcNz9ouTJtaKmxZEkhvWo2NHzxCJTtM9O8Y6qzpFCRUhX9Kw+P
 U4V3PGGTv7Zr/8DlXTHyzaugiqsAWQVnfD9KWs+qAUehmOlcPbJl/mXGjS2Exb2QT7UU 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWL9X042106;
        Fri, 28 Feb 2020 23:37:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ydcs9vk1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:35 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNbYtD020572;
        Fri, 28 Feb 2020 23:37:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:34 -0800
Subject: [PATCH 12/26] xfs_copy: use uncached buffer reads to get the
 superblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:33 -0800
Message-ID: <158293305300.1549542.7853811535219027135.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Upon startup, xfs_copy needs to read the filesystem superblock to mount
the filesystem.  We cannot know the filesystem sector size until we read
the superblock, but we also do not want to introduce aliasing in the
buffer cache.  Convert this code to the new uncached buffer read API so
that we can stop open-coding it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 9e9719a0..5cab1a5f 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -562,6 +562,7 @@ main(int argc, char **argv)
 	libxfs_init_t	xargs;
 	thread_args	*tcarg;
 	struct stat	statbuf;
+	int		error;
 
 	progname = basename(argv[0]);
 
@@ -710,14 +711,20 @@ main(int argc, char **argv)
 
 	/* We don't yet know the sector size, so read maximal size */
 	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
-	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
-			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
+	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
+			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &sbp, NULL);
+	if (error) {
+		do_log(_("%s: couldn't read superblock, error=%d\n"),
+				progname, error);
+		exit(1);
+	}
+
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
-	libxfs_purgebuf(sbp);
+
 	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (sb->sb_sectlog - BBSHIFT),
 			     0, &xfs_sb_buf_ops);

