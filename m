Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4535DC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13DF6217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mZ0OA26w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfHZVtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHZVtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLiMlN185183;
        Mon, 26 Aug 2019 21:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=soeLY4l8QdbIh8KZN//qlBiSLIZ5TopdkP/apfV7G+0=;
 b=mZ0OA26weRqdy6m443uNMmSInYK+ITbyh/tj5CufOCGdqVN1Nnq1qkA/y5l7HtUvKTeU
 yg7dER0MhgQtX88JrmrlSJQee02T8DvEYmHqbxd5RYWI1RxLrbqOrwwnKd+N3HFFx9jC
 rxlCyMBYd3JxemapwHJ8Ky9WM97H1sjbneI4CEcdOb/Wih8OPi11qNSw2Ig4E4W83iOP
 NR+IEoxXBYafJ+gMywh/S58ERRu0Jg7s/+M+0+J/XA0+py5s+r5Xv1CLdt0Y0W9ORDeT
 PvfUhtGRsIcx2DeuQJuSD0xBDQKPWGC0umI6ulN9/hUglMYqeSMK2wlWLSut5ndANDKO YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t84qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:49:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLm9J1050517;
        Mon, 26 Aug 2019 21:49:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2umj2xwcjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:49:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLnB26008334;
        Mon, 26 Aug 2019 21:49:11 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:49:10 -0700
Subject: [PATCH 4/4] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 26 Aug 2019 14:49:09 -0700
Message-ID: <156685614992.2853532.4191470495720238021.stgit@magnolia>
In-Reply-To: <156685612356.2853532.10960947509015722027.stgit@magnolia>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260201
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
unsigned values.  Nobody needs this now, but the online repair patches
will need this to work properly.

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

