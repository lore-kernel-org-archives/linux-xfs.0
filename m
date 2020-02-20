Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600FBC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36EC921D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LJdPzYBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1i6le168816;
        Thu, 20 Feb 2020 01:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=e5TDcAj6R+CUEt1VHfWggcvXOk6Gx9Ps4BCeEEi3suc=;
 b=LJdPzYBLFaCmJXnB6OIz6lEYDDDhoDMM6aG+HctQ7/kRtjErKJ+r6a6Mtl+EGcn2jErL
 OzLNsvr1MazDLI5/ID8UDsy4aqB2TXSXqCjp341By/EWDRibHI9EARyvwigA8rbwbs30
 TDP+A0lOxOe2gZGh4ls32H3S/t80/a7Y/Emfq3AjkoHOfaxVopNYycoUZFAyFxmaSNva
 3q8JqpMi/FK5kTT6a6vkxjoXXQZqLusQM2NeS9B9X1naGdNFOhiIKzudQylJl7bUHLPJ
 QdeEgkKYmL7XkPYC+yov4PKcFT1Htp+5l0vOgMJPJqIncdgdJDRoo+JqZoXZDKc3GV80 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16sdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gCAR188971;
        Thu, 20 Feb 2020 01:44:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y8ud973ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:05 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1i4aO028203;
        Thu, 20 Feb 2020 01:44:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:03 -0800
Subject: [PATCH 14/18] libxfs: remove libxfs_writebuf_int
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:02 -0800
Message-ID: <158216304216.602314.17621620292262138084.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This function is the same as libxfs_buf_dirty so use that instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    1 -
 libxfs/rdwr.c      |   13 -------------
 libxfs/trans.c     |    2 +-
 3 files changed, 1 insertion(+), 15 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index ad8acc1e..1f6e6d97 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -219,7 +219,6 @@ extern int	libxfs_bcache_overflowed(void);
 extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
-extern int	libxfs_writebuf_int(xfs_buf_t *, int);
 int		libxfs_bwrite(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index af363bef..9302a698 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1225,19 +1225,6 @@ libxfs_bwrite(
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
index 4c208422..e23ae598 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -863,7 +863,7 @@ buf_item_done(
 
 	hold = (bip->bli_flags & XFS_BLI_HOLD);
 	if (bip->bli_flags & XFS_BLI_DIRTY)
-		libxfs_writebuf_int(bp, 0);
+		libxfs_buf_dirty(bp, 0);
 
 	bip->bli_flags &= ~XFS_BLI_HOLD;
 	xfs_buf_item_put(bip);

