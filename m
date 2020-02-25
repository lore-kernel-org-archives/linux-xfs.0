Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84D2C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DBB020838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R8xyStsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgBYAPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:15:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32894 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:15:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09ZXC034219;
        Tue, 25 Feb 2020 00:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=afHqcwJucrIUUOksM0IMoLNFAilNQ55UtBTLwWJAf4E=;
 b=R8xyStsQGKIWg3T3IdDQDhNliyvEDP6hcL4el1vLCnQzVyFwiviwwEYd7RniC01DDzNt
 ax8msJGufmkMvoszIHgjePzbJWtOOaof/4kDPQDOfGkDNza+vla5tKxUecEB12OMSMvg
 jp5Lpltn/HUizkVoz95DeWRLdX6HcxycSj6vHER9sPakSej8pMqvM/LCQsQ4Z/5sr1QV
 jyDWNfDE+yrru8bzDpSMYBLcwyrc0Nl+P1/dmEk91oRwKlzEI1MeXmJFVENj1t5Zo/Oh
 JOdj4pTiWKa9VMWYYXjsvT65cSYQWqErtLsfyhZCv244dqtgzb2DUtCrIWl/8eKOpUlA 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr8gt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07v74109148;
        Tue, 25 Feb 2020 00:13:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ybe12er87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:32 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0DVow014125;
        Tue, 25 Feb 2020 00:13:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:31 -0800
Subject: [PATCH 19/25] libxfs: remove libxfs_writebuf_int
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:13:30 -0800
Message-ID: <158258961047.451378.12614044225690623977.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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
index 34693725..5285abd5 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -979,19 +979,6 @@ libxfs_bwrite(
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

