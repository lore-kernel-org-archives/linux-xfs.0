Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CB9C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CA742469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PDC2yszJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB1Xkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48836 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1Xkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcTv0160974;
        Fri, 28 Feb 2020 23:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gCcCuXV3591nuJY5gGndOe0aUUDM3xfx4wf05yKp/b4=;
 b=PDC2yszJ/NCXHbjeEU/3l6ooH8j3rR5jFko2eyjikUpOYQU88TqfERl412UjrLYA0D9N
 3Fz2AHWbE2A5qJRrtB+xSvarb+j4ChEKG9ZwE+2ISRJNCVINremckUWTUyIXzB2DRK/Y
 UUXE+0jCRjnSX5kheM041VMkQmWRTFmG4LiunwCGeDe9ZX0Gs5oeX3mYFFXrWKs6gNY0
 CGTsPFlaeg9Ha9hUvQuLdRN3wwWVIBaxIcHCsahqoeVsqYjjz0l7swCx7A0U6b5aqUAx
 ENvEvq4zGZgGx58hxXmCVOoF84uWc0tZbFZ+ZBzLNgMHXE9TrqVmsW9c8lVi3H3dmKWE fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yf0dmc5wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcPfh056543;
        Fri, 28 Feb 2020 23:38:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcsgbcuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNcRKk024972;
        Fri, 28 Feb 2020 23:38:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:20 -0800
Subject: [PATCH 19/26] libxfs: remove libxfs_writebuf_int
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:19 -0800
Message-ID: <158293309940.1549542.2764319407914966521.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This function is the same as libxfs_buf_dirty so use that instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    1 -
 libxfs/rdwr.c      |   13 -------------
 libxfs/trans.c     |    2 +-
 3 files changed, 1 insertion(+), 15 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 78ce989c..646e340b 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -217,7 +217,6 @@ extern int	libxfs_bcache_overflowed(void);
 extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
-extern int	libxfs_writebuf_int(xfs_buf_t *, int);
 int		libxfs_bwrite(struct xfs_buf *bp);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index db6f2388..bb925711 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -986,19 +986,6 @@ libxfs_bwrite(
 	return bp->b_error;
 }
 
-int
-libxfs_writebuf_int(xfs_buf_t *bp, int flags)
-{
-	/*
-	 * Clear any error hanging over from reading the buffer. This prevents
-	 * subsequent reads after this write from seeing stale errors.
-	 */
-	bp->b_error = 0;
-	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
-	return 0;
-}
-
 /*
  * Mark a buffer dirty.  The dirty data will be written out when the cache
  * is flushed (or at release time if the buffer is uncached).
diff --git a/libxfs/trans.c b/libxfs/trans.c
index ca1166ed..df1ec90b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -863,7 +863,7 @@ buf_item_done(
 
 	hold = (bip->bli_flags & XFS_BLI_HOLD);
 	if (bip->bli_flags & XFS_BLI_DIRTY)
-		libxfs_writebuf_int(bp, 0);
+		libxfs_buf_mark_dirty(bp);
 
 	bip->bli_flags &= ~XFS_BLI_HOLD;
 	xfs_buf_item_put(bip);

