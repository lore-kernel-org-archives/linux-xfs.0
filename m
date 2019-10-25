Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70222CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4033021872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GuhFTOQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392653AbfJYFO5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:14:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJYFO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:14:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DqID102710
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:14:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3CDPCd3ZwYb4h/PMIMep7lUh600pObsvjV/bN66jUuY=;
 b=GuhFTOQr852vVk18XIQYYho9K9/5AM/F5WRgLii0lqHr0b5cbFpRTo+tlWYxaqy8QJJD
 eNo1fF40Kcnzo5UkHF9i7a0RcKJmgDdSOWDP7S5jRridsBqSHkyoQXcPUCgqfhSwUsur
 puK2UNZ4cMx7PCYRh2X+DMO3fjSrOXsor/s0XMu3AdvRBRMdW1c4+f7kPHFoRbTvjl+E
 t0B9YmbP9tokOA7S6ykZLMHQDJtxnLURQMfSl4lmeIwHx4Dt1CT4qQKUsih0gnRghegp
 EEIUd4mGVbfgidWREOypoJJ9RzG2xRuCZH5jczgaIU3Edacy52062mGUvXlxO7q3IS5k 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4r7yg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:14:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DYEZ125828
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:14:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vunbkgu2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:14:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P5EsFF020659
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:14:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:14:54 -0700
Subject: [PATCH 1/4] xfs: check attribute leaf block structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 22:14:53 -0700
Message-ID: <157198049357.2873445.8604948103647704008.stgit@magnolia>
In-Reply-To: <157198048552.2873445.18067788660614948888.stgit@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add missing structure checks in the attribute leaf verifier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   63 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ec7921e07f69..8dea3a273029 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -232,6 +232,57 @@ xfs_attr3_leaf_hdr_to_disk(
 	}
 }
 
+static xfs_failaddr_t
+xfs_attr3_leaf_verify_entry(
+	struct xfs_mount			*mp,
+	char					*buf_end,
+	struct xfs_attr_leafblock		*leaf,
+	struct xfs_attr3_icleaf_hdr		*leafhdr,
+	struct xfs_attr_leaf_entry		*ent,
+	int					idx,
+	__u32					*last_hashval)
+{
+	struct xfs_attr_leaf_name_local		*lentry;
+	struct xfs_attr_leaf_name_remote	*rentry;
+	char					*name_end;
+	unsigned int				nameidx;
+	unsigned int				namesize;
+	__u32					hashval;
+
+	/* hash order check */
+	hashval = be32_to_cpu(ent->hashval);
+	if (hashval < *last_hashval)
+		return __this_address;
+	*last_hashval = hashval;
+
+	nameidx = be16_to_cpu(ent->nameidx);
+	if (nameidx < leafhdr->firstused || nameidx >= mp->m_attr_geo->blksize)
+		return __this_address;
+
+	/* Check the name information. */
+	if (ent->flags & XFS_ATTR_LOCAL) {
+		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
+				be16_to_cpu(lentry->valuelen));
+		name_end = (char *)lentry + namesize;
+		if (lentry->namelen == 0)
+			return __this_address;
+	} else {
+		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
+		name_end = (char *)rentry + namesize;
+		if (rentry->namelen == 0)
+			return __this_address;
+		if (rentry->valueblk == 0)
+			return __this_address;
+	}
+
+	if (name_end > buf_end)
+		return __this_address;
+
+	return NULL;
+}
+
 static xfs_failaddr_t
 xfs_attr3_leaf_verify(
 	struct xfs_buf			*bp)
@@ -240,7 +291,10 @@ xfs_attr3_leaf_verify(
 	struct xfs_mount		*mp = bp->b_mount;
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*entries;
+	struct xfs_attr_leaf_entry	*ent;
+	char				*buf_end;
 	uint32_t			end;	/* must be 32bit - see below */
+	__u32				last_hashval = 0;
 	int				i;
 	xfs_failaddr_t			fa;
 
@@ -273,8 +327,13 @@ xfs_attr3_leaf_verify(
 	    (char *)bp->b_addr + ichdr.firstused)
 		return __this_address;
 
-	/* XXX: need to range check rest of attr header values */
-	/* XXX: hash order check? */
+	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
+	for (i = 0, ent = entries; i < ichdr.count; ent++, i++) {
+		fa = xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
+				ent, i, &last_hashval);
+		if (fa)
+			return fa;
+	}
 
 	/*
 	 * Quickly check the freemap information.  Attribute data has to be

