Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099DDC4363D
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80D52067C
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBY0V87c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390474AbgJJW5X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:57:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733309AbgJJUJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Oct 2020 16:09:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHYH6W195522;
        Sat, 10 Oct 2020 17:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NjV8RTbNVGNU0eSTwL8IA2EyyILj3S1YF5HU8HfURdQ=;
 b=NBY0V87c7cADNVS5sSx1k2I74FWGaHTWm2qmRTXhUAFrIP8d7B/1+2+YjBVkr5D3WC8o
 7mgYvV8bk26vXKcOd/SijUsjPoUBRsdsgnnSbSaqkEn9Wc7hAUi0LpvsDEw/skfCcN4o
 S2zR+L9XZPWP8/WdDZOZLQIcw/klqzQxLt7RBsrHRPy+sEfWl83LTwyjkJVq4ComWgC/
 P0xuohTKa6hROOFIDEhEA8BqZjJA1LE7RrBznybsECRl13gJe/vhJdu9njM1UgjUagZI
 4kwQpnhqipfEMhemkX5M9dPZLvVbrMlklmyEkumOICzqSSMZDm9Ca4LZEXI06IrMsll2 KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wk91kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 17:34:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHVJJe075670;
        Sat, 10 Oct 2020 17:34:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34349jfvyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Oct 2020 17:34:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09AHYTE4005725;
        Sat, 10 Oct 2020 17:34:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 10 Oct 2020 10:34:28 -0700
Subject: [PATCH 1/2] xfs: annotate grabbing the realtime bitmap/summary locks
 in growfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Date:   Sat, 10 Oct 2020 10:34:27 -0700
Message-ID: <160235126770.1384192.7924916439728391885.stgit@magnolia>
In-Reply-To: <160235126125.1384192.1096112127332769120.stgit@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010100165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100165
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use XFS_ILOCK_RT{BITMAP,SUM} to annotate grabbing the rt bitmap and
summary locks when we grow the realtime volume, just like we do most
everywhere else.  This shuts up lockdep warnings about grabbing the
ILOCK class of locks recursively:

============================================
WARNING: possible recursive locking detected
5.9.0-rc4-djw #rc4 Tainted: G           O
--------------------------------------------
xfs_growfs/4841 is trying to acquire lock:
ffff888035acc230 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xac/0x1a0 [xfs]

but task is already holding lock:
ffff888035acedb0 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xac/0x1a0 [xfs]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&xfs_nondir_ilock_class);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rtalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f9119ba3e9d0..ede1baf31413 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1024,7 +1024,7 @@ xfs_growfs_rt(
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
 		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the bitmap inode's size ondisk and incore.  We need
@@ -1038,7 +1038,7 @@ xfs_growfs_rt(
 		/*
 		 * Get the summary inode into the transaction.
 		 */
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the summary inode's size.  We need to update the

