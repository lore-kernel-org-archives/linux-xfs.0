Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EB2C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE380246B8
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p5+9Ro1W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgB1Xit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:38:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46790 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1Xit (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:38:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXolw158259;
        Fri, 28 Feb 2020 23:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xxH1peQTMJN7hOtSrB4oEIJfOB/p2WMtTkK3X+9HjVQ=;
 b=p5+9Ro1WidrW/8Yj6TLa0QzYKYR8o2YfEsKLYgPbc8nqesEFZP+gsugIZTLymj6BeSz6
 n47ZQ+d3THUD7J4MpH6i+YXZsa6CVYoWw8dnSSDBo/0VOnrqvvOLUmLfwlwrXgPZdPUd
 7/ysMl/+SRkJDM+8E0EyzIUOFE2v1wH3IlKU8jQjQ0ekF46BOKoWdLSu35QIJbJiJVC2
 yYHvwVER+GG0SF65w2rKK1cJ7Qx+UlD2Akgnwgk27+QBMQ0bHQYwcR73U8UCgcwZD1Gw
 CZojFr+mAONxX4jlK9OG0TDQtMDREMD/SpAPQPdDfkHpAYgmqnLrW1RmIQu6Tcw/dasg hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yf0dmc5sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWCYe165633;
        Fri, 28 Feb 2020 23:36:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4s31b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNaf8c012660;
        Fri, 28 Feb 2020 23:36:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:36:35 -0800
Subject: [PATCH 03/26] libxfs: remove LIBXFS_B_EXIT
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:36:33 -0800
Message-ID: <158293299305.1549542.13184662198307235173.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=967 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've removed all users of LIBXFS_B_EXIT, remove it as well.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index f775e67d..ba16ad4d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1082,14 +1082,10 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
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
@@ -1160,8 +1156,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
-		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
-				 LIBXFS_B_UNCHECKED);
+		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
 	}
 	return bp->b_error;
 }

