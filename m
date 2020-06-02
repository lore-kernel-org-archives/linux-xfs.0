Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F60C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941FC206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x5W+CDe/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBE0i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:26:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46628 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBE0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:26:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I2sh121431;
        Tue, 2 Jun 2020 04:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gb+Z453zpL7t3C5dTwLKsImw5+0qzKmLyD3mrKU/lRA=;
 b=x5W+CDe/S1nN4MFjcngmebZXQEfuEZUvCgc/ZZI68j93FOD7apquTmGNnFNIEMS6agZ/
 EeAOtos+9hztONnrRfxDjYXiN3V5soOW23ZxPWeBtBmZgNqkOlPViYOLsVd+FHh7dp0V
 2qfPNPulQ4TVp3K7TlzmRPg149eXvtyPiu2mp0PICv22oiDAwLycxNlglxJRJIfm21Fj
 jEIoDcyK0yUNOqX+UQhgdSLLkTyH0uwS+kIdFt6xmI4vGyaE4ztSzQVojCFwsjDB9pnK
 t4DtAg+1y4n3LVVOEbGniYI+UMWts8ujlXYTDRRJ7/n0Hoavd9jbhX9xkZ02/7lGZ2HQ HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31d5qr20pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hw5h040208;
        Tue, 2 Jun 2020 04:26:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31c18sgguq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524QWIM021303;
        Tue, 2 Jun 2020 04:26:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:32 -0700
Subject: [PATCH 14/17] xfs_repair: mark entire free space btree record as
 free1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:31 -0700
Message-ID: <159107199172.313760.3705658346320047281.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=2 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=2 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In scan_allocbt, we iterate each free space btree record (of both bnobt
and cntbt) in the hopes of pushing all the free space from UNKNOWN to
FREE1 to FREE.  Unfortunately, the first time we see a free space record
we only set the first block of that record to FREE1, which means that
the second time we see the record, the first block will get set to FREE,
but the rest of the free space will only make it to FREE1.  This is
incorrect state, so we need to fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 76079247..505cfc53 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -719,7 +719,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				state = get_bmap_ext(agno, b, end, &blen);
 				switch (state) {
 				case XR_E_UNKNOWN:
-					set_bmap(agno, b, XR_E_FREE1);
+					set_bmap_ext(agno, b, blen, XR_E_FREE1);
 					break;
 				case XR_E_FREE1:
 					/*

