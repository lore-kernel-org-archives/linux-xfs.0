Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25160C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB53B206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QufAnKi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgAABNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190sH089149
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mblJ1NHEc364GnYhXVldGqBf0qiniXp/tkC0lDekd0Y=;
 b=QufAnKi+kjVkQmxQ35s1Ty5vCFmhxc8NoNVQIJ5dEvG7n7tBtdieUrLNVJh/UvvtfzOo
 m9a116R3Cv9qLOeur+oQOkEKuf6OihS7kFYP3W47iOPR2M3Zz9NNC9uYBbdNtRCq6QcU
 RWyL0i3ZFRZkC7ZRZG7TBkAh/RM7m3cl82FdlgwhRG19ynJoecdvMhjvdLnh942dOmLW
 yvU6LHoDJZ5owYwKrWg/ynuXa4+/eiE7TMfhHFtdELFninBoFJ3gw5VDpIPlOT4E1UvM
 VFD7zjJYmzWzd2K+J4v/wS4nLxN0cU5DYu7B2FqSeTlW+DFJFYrvlLLChlJ6Br6K0Wxp Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xfA012445
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8guef3h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011DGD9007228
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:16 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:15 -0800
Subject: [PATCH 06/21] xfs: use xfs_trans_ichgtime to set times when
 allocating inode
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:13 -0800
Message-ID: <157784119340.1365473.1547830478581821122.stgit@magnolia>
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

Use xfs_trans_ichgtime to set the inode times when allocating an inode,
instead of open-coding them here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c1952d08fe2c..f71ddcccd390 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -661,8 +661,8 @@ xfs_ialloc(
 	struct inode			*inode;
 	xfs_ino_t			ino;
 	uint				flags;
+	int				times;
 	int				error;
-	struct timespec64		tv;
 
 	/*
 	 * Call the space management code to pick
@@ -739,11 +739,7 @@ xfs_ialloc(
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
 
-	tv = current_time(inode);
-	inode->i_mtime = tv;
-	inode->i_atime = tv;
-	inode->i_ctime = tv;
-
+	times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG | XFS_ICHGTIME_ACCESS;
 	ip->i_d.di_extsize = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
@@ -755,9 +751,10 @@ xfs_ialloc(
 		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
 			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
 		ip->i_d.di_cowextsize = 0;
-		ip->i_d.di_crtime = tv;
+		times |= XFS_ICHGTIME_CREATE;
 	}
 
+	xfs_trans_ichgtime(tp, ip, times);
 
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {

