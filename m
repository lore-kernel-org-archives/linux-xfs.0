Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B44C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A196120850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JBEF2D6O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfHZVWC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:22:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbfHZVWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:22:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFVKD162597;
        Mon, 26 Aug 2019 21:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wrH44Kp165+Rj+LVQqlVFfU9xn5PP/q2XnV1JM2UdX8=;
 b=JBEF2D6OUS54eN4VtcJ4mxi2PHNOTHwK79d1EagRJbP2voWRHG+jc2/0ZLvTxW4mBQ0a
 sR/dNhHU+/pP2GVc/7GTNgEmzYT/pxCg62fM4vU/JUhkgDm6n9Tyb+UnG71I7/0+Sb+p
 TaJVFoGlikisYPbnjfPMxCF1lkHVlF6zzWM+wc3A8LH6KeDEJENA1C+AA9W/BEa+B1qe
 yI2lqhbjhxkUIFRJq1MO3d8iBgJr2+ft8OHBPgTK0LmipjYZ3Qfgslqwa2RGRnHvXRjq
 5R4l/s96eSiq863dEsP04weQ0WpfAzz5lEjxWuKwPMEdxYEHRqAMwbPsBFLNunwmxUg/ XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t8102-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItcZ185080;
        Mon, 26 Aug 2019 21:21:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvrgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:56 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLLsHB024549;
        Mon, 26 Aug 2019 21:21:55 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:21:54 -0700
Subject: [PATCH 2/4] libxfs: fix buffer refcounting in delwri_queue
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 26 Aug 2019 14:21:53 -0700
Message-ID: <156685451300.2840210.3032794344526737971.stgit@magnolia>
In-Reply-To: <156685449440.2840210.11908449959921635294.stgit@magnolia>
References: <156685449440.2840210.11908449959921635294.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index 99cfac1f..ed2d665a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -382,7 +382,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_queue(bp, bl)	libxfs_writebuf((bp), 0)
 #define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 

