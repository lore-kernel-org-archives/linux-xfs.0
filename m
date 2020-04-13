Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A655AC2BB85
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:11:10 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7309A20692
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jjIOO8QJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7309A20692
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-xfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgDMBLJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 21:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgDMBLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Apr 2020 21:11:09 -0400
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD8BC0A3BE0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2020 18:11:08 -0700 (PDT)
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03D1A5xg176197
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=u0UMY0kqsizft3U//z6H+4zer5/PWA8+DWMBvTtIfz8=;
 b=jjIOO8QJ0VRmWKY7EclNnJW/ilPXp416Onn1/P+x7IgOTSQqrkhfiW3vj9e8b3/rRhGt
 jj/HWc3lnap1KXMCBR0EsS9rHKGkAeD/zmoIU9NQsuDOlwxof6d7qI5yrDAPbfdqKpVx
 lYZ977fAePDpbfPZB/pPoc9fs/NzAtdUKC0z3/Gku+cgsIByOARHcy6pHvJs1Dw4GpVO
 +imneAikIjJQ2/6P+ICTxVA0b9nGbzDRBKTJ0tm7wRBQaU/0gdQtDKDPj65Nwm0pAL72
 poKf+66t7UsvmoFBRc4Tz1iEOdKh2pHU50od/MEfOrjfB8uOsrQ6NxrQmkRErv38cSUR FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30b5ukv0dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:11:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03D17806014651
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:11:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30bqeq4suq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:11:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03D1Auat005174
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:11:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 12 Apr 2020 18:10:44 -0700
Subject: [PATCH 2/2] xfs: fix partially uninitialized structure in
 xfs_reflink_remap_extent
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 12 Apr 2020 18:10:24 -0700
Message-ID: <158674022396.3253017.2093178484820838524.stgit@magnolia>
In-Reply-To: <158674021112.3253017.16592621806726469169.stgit@magnolia>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9589 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=1 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9589 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=1 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the reflink extent remap function, it turns out that uirec (the block
mapping corresponding only to the part of the passed-in mapping that got
unmapped) was not fully initialized.  Specifically, br_state was not
being copied from the passed-in struct to the uirec.  This could lead to
unpredictable results such as the reflinked mapping being marked
unwritten in the destination file.

Fixes: 862bb360ef569 ("xfs: reflink extents from one file to another")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b0ce04ffd3cd..107bf2a2f344 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1051,6 +1051,7 @@ xfs_reflink_remap_extent(
 		uirec.br_startblock = irec->br_startblock + rlen;
 		uirec.br_startoff = irec->br_startoff + rlen;
 		uirec.br_blockcount = unmap_len - rlen;
+		uirec.br_state = irec->br_state;
 		unmap_len = rlen;
 
 		/* If this isn't a real mapping, we're done. */

