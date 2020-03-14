Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1CBC1975A
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 01:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54022071B
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 01:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmPl6xI3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgCOBob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:44:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgCOBnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Mar 2020 21:43:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02EHMsiH144546;
        Sat, 14 Mar 2020 17:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Q84XjpQrhOpFX5GGVECwsHVa93MLI6c4eHSlC7IgqkI=;
 b=jmPl6xI39W1ScOFbk1KHowPIiPPCyUNQWU/LRH5JESDgDN+AulRF51jTP9hNihile/mT
 CfTZItQKUF6/0MMr1i1oItbT7kwwVnB6ruQXeMI1yiziTdb52TSspOea1/hJhgCn3Km9
 TQpAyDNJOmvive1kMwJlvB944Y97Zlezm8fFda5PYGoRu83vQLc4Swq7RWaFuX1/ie5n
 8eQSG7EgcrpN2A5XdibLUwFlIgzovcVPswvoc8WV7K08Rlk90b3GtXldk+04sXfTwHVA
 rrrtQGWrbk7Cp9n3rncZt63QbKSkQ7g7wRpw8UjpeMPEDFymmfMHSCcKoYbDJJapO1/a Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7khbde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Mar 2020 17:29:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02EHOCAp185166;
        Sat, 14 Mar 2020 17:29:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yrna9tf73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Mar 2020 17:29:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02EHTE2e010890;
        Sat, 14 Mar 2020 17:29:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Mar 2020 10:29:14 -0700
Date:   Sat, 14 Mar 2020 10:29:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: xfs_dabuf_map should return ENOMEM when map allocation
 fails
Message-ID: <20200314172913.GA6756@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9560 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9560 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003140095
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the xfs_buf_map array allocation in xfs_dabuf_map fails for whatever
reason, we bail out with error code zero.  This will confuse callers, so
make sure that we return ENOMEM.  Allocation failure should never happen
with the small size of the array, but code defensively anyway.

Fixes: 45feef8f50b94d ("xfs: refactor xfs_dabuf_map")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index a7880c6285db..897749c41f36 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2521,8 +2521,10 @@ xfs_dabuf_map(
 	 */
 	if (nirecs > 1) {
 		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_NOFS);
-		if (!map)
+		if (!map) {
+			error = -ENOMEM;
 			goto out_free_irecs;
+		}
 		*mapp = map;
 	}
 
