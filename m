Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6780AC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 652EF20820
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BNN/jIcR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392135AbfIFDem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:34:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48278 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392128AbfIFDem (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:34:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YPff110089;
        Fri, 6 Sep 2019 03:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=49tm2aKcDFlLPoWd3aYMcNWLlMIIeQl9xfm45RAks24=;
 b=BNN/jIcRQS1WvB5VPtHHvhh2N9Hl0kIdn4YKhcDscAeJKrJ984f/dl9fQmIsFS1JSwDr
 vbHchOg2rMkJY8nicmHPrwIolDtaZBRjLG4AjO6z9zWEcw+K1/IhxonFbGEN/t7e59Qr
 Q4wGi8XGWpxxNR7dSM7EAW8ZuJ7J94wupwCKwCm/7rwZeF7sB/ly1bLEzfL0YSm2YQEL
 e/cn8LPBt+ZsouO8sjo1bJ3lNgflVb66UZNCbp4VyMESKEeMPs/868ejYcIzTAG1JzI0
 U8YkGdqPQygcfXdr1M3/AVwZTMJhEugVt0GXiR0aU/s4f7q5oWIrApjW/Y/scCiWU9AY Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuf4n0357-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xa6x069093;
        Fri, 6 Sep 2019 03:34:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2utvr4jt7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863YYxI014244;
        Fri, 6 Sep 2019 03:34:34 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:34:34 -0700
Subject: [PATCH 2/4] libxfs: fix buffer refcounting in delwri_queue
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Thu, 05 Sep 2019 20:34:33 -0700
Message-ID: <156774087342.2643362.6934117999460507337.stgit@magnolia>
In-Reply-To: <156774086083.2643362.4042713521116931635.stgit@magnolia>
References: <156774086083.2643362.4042713521116931635.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
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
 

