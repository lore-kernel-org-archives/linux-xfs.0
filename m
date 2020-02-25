Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75086C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F0A20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r2h5B59m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYAMs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:12:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07cBc050107;
        Tue, 25 Feb 2020 00:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Jsnb3x3wPw1wDzJIhhtpImOQXaL5NI8hQbYgWjUUhSo=;
 b=r2h5B59mAPdGJ2gGzz/F3184SJxQdAhKlJAq9KlXv0VG1gtietFlKpyxtfVPd/COOqOU
 csJBEml084/JADD8oTymPIbYM6wga76hfRf16Ok04PBPvZuIPyBKLB6XrvKAbK/PZhl8
 Sg/CJZ7BZeWod64DEQ6QSGec/jcuy38JGxNiNd1HA8mTt0IK9ZMRwiF8Xuz7SLvHiPBh
 cznNuxcJstDGw8EzeFmPaL/+KwKFBqbvYEQnds3RodRPYD4n8KHwPVhHtH/Aq+sXSjDo
 7oXQmGQOgCm1f6u1WwyKeGP9kcOoMBNBYTeUQWV0/tzZWckb30YqahHVvx268TrfilbW tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07v6x109148;
        Tue, 25 Feb 2020 00:12:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12eqdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:45 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0CjOd031196;
        Tue, 25 Feb 2020 00:12:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:44 -0800
Subject: [PATCH 12/25] xfs_copy: use uncached buffer reads to get the
 superblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:12:44 -0800
Message-ID: <158258956405.451378.5036099292043192938.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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

