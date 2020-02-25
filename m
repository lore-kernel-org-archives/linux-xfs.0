Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5B3C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60AF120838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e1InmVSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBYALx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYALw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07lkF050164;
        Tue, 25 Feb 2020 00:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zF0slDbmLnMSCbRzj0fKXIlHY86c9HN/fdc2pNipPk8=;
 b=e1InmVSoF8DAbukQokj+nV+4/gV/EHHkHLfL8LksRxcKj193X16YkSDUraX9jITBuSQz
 mGysV4ClJN+W5Z+MFAlfar6nQnOwqzr9/o7fK81bIBqFgNegfCUrTRuD5kWJiBsbBU9f
 pkPC+hSk7Z61dyupGd5zfC34C1UTdXzYJ7hm0JN9+V+6Vy0cLqbBKH05etToU+IvdIrz
 ED3mqJsAjia1b1qB1+Zbj4PmoBhWnzjjNqUfMBVTKEEojk+5F8cAho2MjUB+SFgzrPW5
 HM8ynTNUMTxw4zTCnl1XUGbVzul4/Kq5DB/8NbFb4hEhMGn084zxz1O0h59Iio8vSVHS Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P087e7014407;
        Tue, 25 Feb 2020 00:11:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ybdshxwy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0Bn7M030561;
        Tue, 25 Feb 2020 00:11:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:49 -0800
Subject: [PATCH 03/25] libxfs: remove LIBXFS_B_EXIT
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:11:48 -0800
Message-ID: <158258950834.451378.3980522186420601333.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=956 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
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

Now that we've removed all users of LIBXFS_B_EXIT, remove it as well.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    1 -
 libxfs/rdwr.c      |    7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 87c6ea3e..716db553 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -91,7 +91,6 @@ bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
 /* b_flags bits */
-#define LIBXFS_B_EXIT		0x0001	/* exit if write fails */
 #define LIBXFS_B_DIRTY		0x0002	/* buffer has been modified */
 #define LIBXFS_B_STALE		0x0004	/* buffer marked as invalid */
 #define LIBXFS_B_UPTODATE	0x0008	/* buffer is sync'd to disk */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 011b449d..45b535e4 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1075,14 +1075,10 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 		int error = errno;
 		fprintf(stderr, _("%s: pwrite failed: %s\n"),
 			progname, strerror(error));
-		if (flags & LIBXFS_B_EXIT)
-			exit(1);
 		return -error;
 	} else if (sts != len) {
 		fprintf(stderr, _("%s: error - pwrite only %d of %d bytes\n"),
 			progname, sts, len);
-		if (flags & LIBXFS_B_EXIT)
-			exit(1);
 		return -EIO;
 	}
 	return 0;
@@ -1153,8 +1149,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
-		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
-				 LIBXFS_B_UNCHECKED);
+		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
 	}
 	return bp->b_error;
 }

