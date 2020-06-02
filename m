Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC7FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE4A9206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:25:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XaxqIZef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgFBEZr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:25:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBEZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:25:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hvo4107049;
        Tue, 2 Jun 2020 04:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P+U+IoRBI7cVMkghKY1uOtC1GtaFENvsDXFcVl545yk=;
 b=XaxqIZefP/HtnR7tdkcIg1oiG9MMLLLsikJkgmRJJ+n6HQb2XFxlcrQCkZDbwZQwz8nq
 2xPtxaOcuJ2SrpsDIY1BZMpVpCdeevQQhemVeUjltRm0tX+NNtxmslkTWbTTtyfnACX1
 pBb/ask5UNhjCpcfIcCo/6heFAGu3Sh01dfz62CUAqYx3ceN0/tDkAHG2WWK+lQXzVaZ
 roBAjuo1FyX2nD819YZDOWMW2+p3zX/YtM1W3NcSLSK7hgQNxfItTudYHoFeYMTk+5QZ
 nOsgrVEGIk27nKjab4UHXLfgljtSH4FeFSYAEvMgk+yp9fx1U+1IYNgsRM71EwA0x0/x 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem1t8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:25:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JMRD102175;
        Tue, 2 Jun 2020 04:25:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31c12ng417-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524PfkR020486;
        Tue, 2 Jun 2020 04:25:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:41 -0700
Subject: [PATCH 06/17] xfs_repair: check for out-of-order inobt records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:40 -0700
Message-ID: <159107194026.313760.17246981571184212290.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that the inode btree records are in order.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index 2d156d64..7c46ab89 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1947,6 +1947,7 @@ scan_inobt(
 	const struct xfs_buf_ops *ops)
 {
 	struct aghdr_cnts	*agcnts = priv;
+	xfs_agino_t		lastino = 0;
 	int			i;
 	int			numrecs;
 	int			state;
@@ -2029,7 +2030,16 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * the block.  skip processing of bogus records.
 		 */
 		for (i = 0; i < numrecs; i++) {
+			xfs_agino_t	startino;
+
 			freecount = inorec_get_freecount(mp, &rp[i]);
+			startino = be32_to_cpu(rp[i].ir_startino);
+			if (i > 0 && startino <= lastino)
+				do_warn(_(
+	"out-of-order ino btree record %d (%u) block %u/%u\n"),
+						i, startino, agno, bno);
+			else
+				lastino = startino + XFS_INODES_PER_CHUNK - 1;
 
 			if (magic == XFS_IBT_MAGIC ||
 			    magic == XFS_IBT_CRC_MAGIC) {

