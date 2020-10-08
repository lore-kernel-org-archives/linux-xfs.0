Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABA2C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6AB52173E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XK5zWDWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgJHDzx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:55:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgJHDzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 23:55:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983nw1w021133;
        Thu, 8 Oct 2020 03:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=PhvpBYECYdlIwGdCKRpY5n4PUlnFDUS/6sJI01IqrM8=;
 b=XK5zWDWMLDTSHYmxtjFS8iI2AjlkgW2pccJQLw7tdU7tIC5Sjlpx8hgY4qRtf7IFhmSv
 hV7w8AnaRhd5us+iYkgNQmeB8tj1Wuhs0iGN+LzoVygjsaiStj+ihQR+gtEeQ+w2JQu1
 2MEOjQUvx83gegpxHrKLcUwWk7FHOyabZZfI0CrgWebY99DQhn4hohrT/H3sx9qBzBSw
 CXyTjhUXsFDsfwUbib5T+vOnqkwjDIch/nAI+ch7k5B6EsLGs9S3UuEB/5xEwqzDp7Fa
 ED8JbBzDDuCqFai57USAkny4zdWlbN8NdieUPwA5dGUnYWyaLaUDJCLP9vBydIN89cE1 Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34teau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:55:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983isu2142488;
        Thu, 8 Oct 2020 03:53:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410k0fdqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:53:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0983rnMT013853;
        Thu, 8 Oct 2020 03:53:49 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:53:49 -0700
Date:   Wed, 7 Oct 2020 20:53:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/194: actually check if we got the desired block size
 before proceeding
Message-ID: <20201008035348.GA6539@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test has specific fs block size requirements, so make sure that's
what we got before we proceed with the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/194 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/194 b/tests/xfs/194
index c36499c2..238db5c3 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -83,6 +83,9 @@ unset XFS_MKFS_OPTIONS
 # we need 512 byte block size, so crc's are turned off
 _scratch_mkfs_xfs -m crc=0 -b size=$blksize >/dev/null 2>&1
 _scratch_mount
+test "$(_get_block_size $SCRATCH_MNT)" = $blksize || \
+	_notrun "Could not get $blksize-byte blocks"
+
 
 # 512b block / 4k page example:
 #
