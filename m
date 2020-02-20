Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6633BC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A08921D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eS2wjUCK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBTBop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTBop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hZtW064533;
        Thu, 20 Feb 2020 01:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JTJb+YzovNEnxZ2NY8mmjqEocvar4ivUD98Uq7hfoCQ=;
 b=eS2wjUCK9/iSGBofp05QZbI7DRoIWSdcD6y4qEUjf9QnGOb7SrtwQZgDJ+cd57ymrIi9
 KmEgVT9lqR6jDx8ocpNYBD6NULIRjK4fHMcyXnM8RPBsGO0gvsfl6XavXp+qj1y/B3Ak
 i92PQqFXpH4AQ3np5GPZOzsVrSKEdhJGcIeXHoVpo7MVuA8DcwWt+F7FxM+1+Qz5+v6c
 ReYuBNiMDtHAKnGPWxZ/q0Zz6U7NMQmOpXDbKNSTLOWcL0wmPRwTc8IxehhLx6da/tTa
 jG426zK2zHwF8Pzxv4MiYiWRyXbvmBE7zV69oteaMFafL/jSMfnXWHA8zKhcvD3y75KO ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udket3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gJEA189098;
        Thu, 20 Feb 2020 01:44:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y8ud974u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1igoT002849;
        Thu, 20 Feb 2020 01:44:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:42 -0800
Subject: [PATCH 02/14] libxfs: make libxfs_getbuf_flags return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:41 -0800
Message-ID: <158216308182.603628.4786904164891459161.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=684
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=742 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libxfs_getbuf_flags() to return numeric error codes like most
everywhere else in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index b686d1d5..6a7a66ae 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -775,25 +775,21 @@ __cache_lookup(
 	return 0;
 }
 
-static struct xfs_buf *
+static int
 libxfs_getbuf_flags(
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
 	int			len,
-	unsigned int		flags)
+	unsigned int		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_bufkey	key = {NULL};
-	struct xfs_buf		*bp;
-	int			error;
 
 	key.buftarg = btp;
 	key.blkno = blkno;
 	key.bblen = len;
 
-	error = __cache_lookup(&key, flags, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return __cache_lookup(&key, flags, bpp);
 }
 
 /*
@@ -828,9 +824,13 @@ __libxfs_buf_get_map(
 	int			i;
 	int			error;
 
-	if (nmaps == 1)
-		return libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
-					   flags);
+	if (nmaps == 1) {
+		error = libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
+				flags, &bp);
+		if (error)
+			return NULL;
+		return bp;
+	}
 
 	key.buftarg = btp;
 	key.blkno = map[0].bm_bn;
@@ -977,8 +977,8 @@ libxfs_readbuf(
 	struct xfs_buf		*bp;
 	int			error;
 
-	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
-	if (!bp)
+	error = libxfs_getbuf_flags(btp, blkno, len, 0, &bp);
+	if (error)
 		return NULL;
 
 	/*

