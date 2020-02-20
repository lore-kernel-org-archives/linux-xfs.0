Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23150C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE0C921D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C+h/VV2y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTBoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gqIw092800;
        Thu, 20 Feb 2020 01:44:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z5DXU59GpncfwPPbhxDiVAwd6cFF5G7OGB4FUTGC3ro=;
 b=C+h/VV2yEYvHurLWzEhM0CvoXcZyAJyXGZukuGxMcZ80//HseTArJMBIY1k9nZ5zzJtD
 bBaRdMq/7KHq5Xcyd+uq7Q2JEJQAoY5JulxM8/xUOZpge7eahhxkqj6EqaXjFjriEEb8
 EVQ0qHj9+2bAAT2W4zjHxq6T3+6AXvelq+Xh0wPz11v/ACWP2kyuMUpz2YT1Md/RGZK0
 sZZeGuduPu+B5ZNRkpeHAoYJwYF1FQLIH+WH76gbL95/FpHV5ucQfrC6TqMUw2KiQMav
 ZILpzJVWRhvToAPu+cXUzpqqjFns0ETh1DZFlYMUNad6Tya5ATpoj1TBR2nwCYchkd/A EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8udd6tfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1ggpk094941;
        Thu, 20 Feb 2020 01:44:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmhmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1iADG002598;
        Thu, 20 Feb 2020 01:44:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:09 -0800
Subject: [PATCH 15/18] libxfs: hide libxfs_{get,put}bufr
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:09 -0800
Message-ID: <158216304905.602314.17780460003947176973.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=758 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=816 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hide these two functions because they're not used outside of rdwr.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    3 ---
 libxfs/rdwr.c      |    8 ++++++--
 2 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 1f6e6d97..7d96c2a3 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -216,9 +216,6 @@ extern void	libxfs_bcache_flush(void);
 extern int	libxfs_bcache_overflowed(void);
 
 /* Buffer (Raw) Interfaces */
-extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
-extern void	libxfs_putbufr(xfs_buf_t *);
-
 int		libxfs_bwrite(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9302a698..bab70dfd 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -52,6 +52,10 @@
  * propagation of stale errors into future buffer operations.
  */
 
+static struct xfs_buf *libxfs_getbufr(struct xfs_buftarg *btp,
+		xfs_daddr_t daddr, int len);
+static void libxfs_putbufr(struct xfs_buf *bp);
+
 #define BDSTRAT_SIZE	(256 * 1024)
 
 #define IO_BCOMPARE_CHECK
@@ -666,7 +670,7 @@ __libxfs_getbufr(int blen)
 	return bp;
 }
 
-xfs_buf_t *
+static xfs_buf_t *
 libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 {
 	xfs_buf_t	*bp;
@@ -1360,7 +1364,7 @@ libxfs_bflush(
 	return bp->b_error;
 }
 
-void
+static void
 libxfs_putbufr(xfs_buf_t *bp)
 {
 	if (bp->b_flags & LIBXFS_B_DIRTY)

