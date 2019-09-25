Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA65CC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA29921D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rL/cU/V1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfIYVcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:32:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56198 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfIYVcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:32:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTG6k050686;
        Wed, 25 Sep 2019 21:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=49tm2aKcDFlLPoWd3aYMcNWLlMIIeQl9xfm45RAks24=;
 b=rL/cU/V10cSmmOg55WUblzlDbHSbxiDXUmGLlCG00OkBnhctG3R6x5Z7NRyhRuq2lc3Z
 XSnu/LoE6BAoarI4e6oe6vNzfrQ0ZBxsG0mIQw/9hl2OyzJ2srWNdk7+MFEz3JqtmqUS
 pV9oGXA889SpdbXvRy9s2/MsmejrAO6YrRYusgMNZZFUNJm9xcwTbXzSoRNk8pZXx/9l
 XutRmQSMuTqBAESBmfYExURwoWqzu5Zd0xr3a04bA1uZjqFuVT+zEDEtmdMh1M2XqLcI
 Xpp97BU6hZafpt10OMnWdWY4gKedJXTe5CDeVaneXDF9EVe19ozvjwNTvRo/aDNJ/WF9 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7ej5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTNSC194323;
        Wed, 25 Sep 2019 21:32:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v829w4uxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:14 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLWEAH013866;
        Wed, 25 Sep 2019 21:32:14 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:32:13 -0700
Subject: [PATCH 2/4] libxfs: fix buffer refcounting in delwri_queue
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Wed, 25 Sep 2019 14:32:12 -0700
Message-ID: <156944713252.296397.10857029102757641618.stgit@magnolia>
In-Reply-To: <156944712040.296397.10216531793013990772.stgit@magnolia>
References: <156944712040.296397.10216531793013990772.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the kernel, xfs_buf_delwri_queue increments the buffer reference
count before putting the buffer on the buffer list, and the refcount is
decremented after the io completes for a net refcount change of zero.

In userspace, delwri_queue calls libxfs_writebuf, which puts the buffer.
delwri_queue is a no-op, for a net refcount change of -1.  This creates
problems for any callers that expect a net change of zero, so increment
the buffer refcount before calling writebuf.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h   |    7 +++++++
 libxfs/libxfs_priv.h |    1 -
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 7dcb4bff..09ed043b 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -245,4 +245,11 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
 	return bp;
 }
 
+static inline void
+xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
+{
+	bp->b_node.cn_count++;
+	libxfs_writebuf(bp, 0);
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b05e082a..13dab58a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -382,7 +382,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_queue(bp, bl)	libxfs_writebuf((bp), 0)
 #define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 

