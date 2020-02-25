Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D64C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC48921927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vpZi7vS9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBYAOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:14:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59770 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:14:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09Lqr033747;
        Tue, 25 Feb 2020 00:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EgTBd1TKNt9Uro71QNVfaPIUzOJHv6U8+pnNxlIezoY=;
 b=vpZi7vS9RElyfh4vtZBKiuP97f/A1si1YiB4lbm8i+nDzv/oN0vQl8upEh3k0EXjhFb9
 cK754B6aaJfwZi+EQEn85l3X+eWmjhbPgClejcgWj1xaqiUAbaeFltQlJuJiRZIuCCn5
 +cKRjyGkg+bOOs/dxe8D8shbCw6CoHzzEWlMLp6RtWOXLyfMHkD2L7OKooeKHyn7AZ9l
 dyOLN0QBDiBwENtvKVJn3fztHOX92yzvlzVufxlWelB76ATQUfnIWQOO3e0bo7t43Vy/
 9DiSEsvo+20SSjlxMERd7QnLeQYt8RNCE+Ki4Wv6MggmEa4Sywju53CV2uhXEdvmvYfu Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ycppr8gp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08BVS158853;
        Tue, 25 Feb 2020 00:12:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yby5e9hdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:28 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0CQUM031040;
        Tue, 25 Feb 2020 00:12:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:26 -0800
Subject: [PATCH 09/25] libxfs: make libxfs_readbufr stash the error value in
 b_error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:12:25 -0800
Message-ID: <158258954567.451378.10139972171777852896.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=757 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=815
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make libxfs_readbufr stash the error value in b_error, which will make
the behavior consistent between regular and multi-mapping buffers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index fb22c118..9ee9d557 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -936,6 +936,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 		pthread_self(), __FUNCTION__, bytes, error,
 		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
 #endif
+	bp->b_error = error;
 	return error;
 }
 
@@ -995,9 +996,7 @@ libxfs_readbuf(
 	 * contents. *cough* xfs_da_node_buf_ops *cough*.
 	 */
 	error = libxfs_readbufr(btp, blkno, bp, len, flags);
-	if (error)
-		bp->b_error = error;
-	else
+	if (!error)
 		libxfs_readbuf_verify(bp, ops);
 	return bp;
 }

