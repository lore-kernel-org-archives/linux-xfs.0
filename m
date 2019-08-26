Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A93EC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4814E206B7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lH5LDDJI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbfHZSiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 14:38:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42452 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfHZSiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 14:38:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIYDpm059818
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=21jz/Zgc82WoioF5CjnYrXDIae9uRzByav67Kzs5I3k=;
 b=lH5LDDJI4sp5jqiwEdVxvD05yS4QdaQBTEzdJDxuIAh36jkY5IG1j2lQCx9ljxQsOK8S
 55uqu2X2GW4MO5ufIZEtwz8S69AhFm1LdSSmvI/0Fbkuu/6vPZcFndWmAhhiaAU3ncAZ
 J/KjLhpyfl0SrjHLa6YL+e/3G2iMxMPN5UDGCZzXe+OE+H4fJxdqfzRcwIF/VBOmSi4J
 crCDQUPj3cJ4crlXZKWFXgmgCIrJSnGBLljJBzIZ8BD/iZeyU7rnaB0NmY+rWFQDYIYB
 0Go2goEnfMzdP6E4GAclQ8yo26ZuuGL31i5UXzs3LkopEa/AItljTREVu9mhk28SWzYZ /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ujw703byn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QIY73v104150
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2umj1tan66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:05 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QIc4Fl003800
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 18:38:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 11:38:04 -0700
Date:   Mon, 26 Aug 2019 11:38:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
Message-ID: <20190826183803.GQ1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_bmbt_diff_two_keys, we perform a signed int64_t subtraction with
two unsigned 64-bit quantities.  If the second quantity is actually the
"maximum" key (all ones) as used in _query_all, the subtraction
effectively becomes addition of two positive numbers and the function
returns incorrect results.  Fix this with explicit comparisons of the
unsigned values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index fbb18ba5d905..3c1a805b3775 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -400,8 +400,20 @@ xfs_bmbt_diff_two_keys(
 	union xfs_btree_key	*k1,
 	union xfs_btree_key	*k2)
 {
-	return (int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
-			  be64_to_cpu(k2->bmbt.br_startoff);
+	uint64_t		a = be64_to_cpu(k1->bmbt.br_startoff);
+	uint64_t		b = be64_to_cpu(k2->bmbt.br_startoff);
+
+	/*
+	 * Note: This routine previously casted a and b to int64 and subtracted
+	 * them to generate a result.  This lead to problems if b was the
+	 * "maximum" key value (all ones) being signed incorrectly, hence this
+	 * somewhat less efficient version.
+	 */
+	if (a > b)
+		return 1;
+	else if (b > a)
+		return -1;
+	return 0;
 }
 
 static xfs_failaddr_t
