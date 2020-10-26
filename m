Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF966C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B79920872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o4bvQfpP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406882AbgJZXfO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406870AbgJZXfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP0Fa157923;
        Mon, 26 Oct 2020 23:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/9/bOy4QxrzHvk18qhjkwoTNIYN97lfiTMPbc0EAzjw=;
 b=o4bvQfpPzyDHoYECKQ1FpT+vMruP/tIcQ7cf8QWWZ5deIuwn87NDGeZ4Ir5y9xVSnrsk
 uNfHlYilNcfvg9fGRlN/o1NCAob8y5Ssgq0KtoikdEDoferANiow/H/0JttkCuM7TnrX
 aQf9IXkGef6rft2OwA2bIa6mShKVYkOnm6RKHe+tgKl/h+/S6KEdYG44tjk7wfDf6Wd4
 IbgsZeAfpkwt7Jf6kZ8SgdlFVNa95GovMX10XCLfDZfkahQcQAR8T+EzaAqSBiesGQuu
 rOSZekEA9VHHxq4Ny68WbkdjNbRoKlI1jhBRCXrLd/FYUYRmcGfo3DF1p1mDviTbVNqd kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPx6M110501;
        Mon, 26 Oct 2020 23:33:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx5wfr8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNX8Oi012110;
        Mon, 26 Oct 2020 23:33:08 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:03 -0700
Subject: [PATCH 3/3] xfs: simplify xfs_trans_getsb
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:02 -0700
Message-ID: <160375518271.880210.13520449755739439500.stgit@magnolia>
In-Reply-To: <160375516392.880210.12781119775998925242.stgit@magnolia>
References: <160375516392.880210.12781119775998925242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: cead0b10f557a2331e0e131ce52aaf7ed7f5355f

Remove the mp argument as this function is only called in transaction
context, and open code xfs_getsb given that the function already accesses
the buffer pointer in the mount point directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    2 +-
 libxfs/trans.c      |    6 +++---
 libxfs/xfs_sb.c     |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 1f087672a2a8..9292a4a54237 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -91,7 +91,7 @@ void	libxfs_trans_cancel(struct xfs_trans *);
 /* cancel dfops associated with a transaction */
 void xfs_defer_cancel(struct xfs_trans *);
 
-struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *);
+struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *);
 
 void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 51ce83021e87..6838b727350b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -463,10 +463,10 @@ libxfs_trans_get_buf_map(
 
 xfs_buf_t *
 libxfs_trans_getsb(
-	xfs_trans_t		*tp,
-	struct xfs_mount	*mp)
+	struct xfs_trans	*tp)
 {
-	xfs_buf_t		*bp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			len = XFS_FSS_TO_BB(mp, 1);
 	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 302eea167f4e..7c7e56a8979c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -931,7 +931,7 @@ xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
+	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
 	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
@@ -1061,7 +1061,7 @@ xfs_sync_sb_buf(
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp, mp);
+	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);

