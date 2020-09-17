Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5732C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1BE206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lcWqBxXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgIQD2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:28:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIQD2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:28:43 -0400
X-Greylist: delayed 8961 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:28:42 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Orqg041017
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rH028JryIhrBVXuDAezOl/JlBKys+okr6GeSzXNk4z0=;
 b=lcWqBxXhoImDZQXhGw7MXc9ferlGc15h/DiuKx+QwjAsmkkxKFeYIKnadmdCGyew1Q6V
 6FQiRX4/J6eGsAF1Xnbt77u0AGqhNEqrnTauendob2buTOyRT0FxqTYQh4qzt6YUMe86
 KcWG8fnpZzBy/k6BsmEPGhiBIY4sgxiIwnSFp7C2pUrV8mHLUDxkRd6/PjbAhqdgNGt1
 bOG1w6QLG69GQ+gc178tVCQ90NYUdMHplB9k4m2yuM56hYQ6rDmSEM2MRp6WJLfWsEaz
 Vs+gJg6Awo+B5g31R8fwl17i90Uzxv7XXom5Sf8L+RVtdSKlDMbwr48VD+rCIkOCjX+Y rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9meg5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3PV3u080020
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88a24w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:41 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H3SeRe020144
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:28:40 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:28:40 +0000
Subject: [PATCH 2/2] xfs: check dabtree node hash values when loading child
 blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Sep 2020 20:28:39 -0700
Message-ID: <160031331944.3624286.5979437788459484830.stgit@magnolia>
In-Reply-To: <160031330694.3624286.7407913899137083972.stgit@magnolia>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When xchk_da_btree_block is loading a non-root dabtree block, we know
that the parent block had to have a (hashval, address) pointer to the
block that we just loaded.  Check that the hashval in the parent matches
the block we just loaded.

This was found by fuzzing nbtree[3].hashval = ones in xfs/394.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dabtree.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index e56786f0a13c..653f3280e1c1 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -441,6 +441,20 @@ xchk_da_btree_block(
 		goto out_freebp;
 	}
 
+	/*
+	 * If we've been handed a block that is below the dabtree root, does
+	 * its hashval match what the parent block expected to see?
+	 */
+	if (level > 0) {
+		struct xfs_da_node_entry	*key;
+
+		key = xchk_da_btree_node_entry(ds, level - 1);
+		if (be32_to_cpu(key->hashval) != blk->hashval) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
+	}
+
 out:
 	return error;
 out_freebp:

