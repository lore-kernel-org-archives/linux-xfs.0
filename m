Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DACC4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B50C2076E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YpV7Co/E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgJHPCc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:02:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbgJHPCb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 11:02:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098Exntl184471;
        Thu, 8 Oct 2020 15:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nsOF70tKCoIGu5DEEOdctCTkzewjtfvweIVqXNHTZlI=;
 b=YpV7Co/Ep48q+ykmdgywLD9gmC1GTvb5/QflAAWHAvuoNlv9poLf5YJgZ6bJlfSGAqwi
 iNwQJ4rRaa5S0nK8zbdTQYDYP1OOrdiq6BPcMh494xnj2/kjMUYv3V1GYvThbxVALfA9
 8WYhuGZUeNUFN8nB8Dg3M3srJsIPvYLtKMAw56CcS0F3k9orZ9gsA4jcII//NM9dYws/
 eG5ctMLgz9t9Ho/DGIS/GhPEuM/sk1BDy/4xpGRud64k/iqB6hzzEEtst0rKOK2FgQXL
 xwfwrmnmhajPkXoknyt8xHMhVLflUFV7q/IzXu5SYN1bCG65/4uriRbUACdciWPaNsdw UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn84n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 15:02:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F1NpU079157;
        Thu, 8 Oct 2020 15:02:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33y2vr5d8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 15:02:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098F2OCp012561;
        Thu, 8 Oct 2020 15:02:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 08:02:24 -0700
Subject: [PATCH 3/3] xfs: annotate grabbing the realtime bitmap/summary locks
 in growfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Date:   Thu, 08 Oct 2020 08:02:23 -0700
Message-ID: <160216934339.313389.7386951309252031696.stgit@magnolia>
In-Reply-To: <160216932411.313389.9231180037053830573.stgit@magnolia>
References: <160216932411.313389.9231180037053830573.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080115
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
index 9de83723462c..678af4201699 100644
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

