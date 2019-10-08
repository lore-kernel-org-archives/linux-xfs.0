Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45785ECE58C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C08321479
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R20yYBEX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfJHBDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 21:03:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbfJHBDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 21:03:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980wsr2035959;
        Tue, 8 Oct 2019 01:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=c6vWHuXEDZChkRQPIhyMpVUSekMEbG5U0+AIqLGiR0k=;
 b=R20yYBEXn/BNvPcNDjS2UCf4IsRwhfJCMptqWJUorhqe6hxNlI5jmSKk3m9HPBhpIxC1
 AH8rKJ/cEBieZbHuU987oh276H08mjWJ1WmXpMaogGwMJRruRtywC4ZSQ+h9et7duSS/
 /6OWnWDHZIB/T6ZKb8QastoPf2L9dzDk+dIUpogmOJ183fZ4Mpn71TXcAKewyKietVNc
 iSp7etOSsVhx57czxHRDxMWgAq8a5QioA43/I7yIX5eNt19pcVtE/LO1/2WbIX3bhXPw
 EwVL0nKfAqTZS3a8rCY5i0PXK8Z+QM6DPhX+KOknulzF/GA3vHT1BeeBhGY0Pd8fQUl7 VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vejkua6am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980wD3U007437;
        Tue, 8 Oct 2019 01:03:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vg1yuy2sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9813OtL011164;
        Tue, 8 Oct 2019 01:03:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 18:03:24 -0700
Subject: [PATCH 3/4] xfs/263: use _scratch_mkfs_xfs instead of open-coded
 mkfs call
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 07 Oct 2019 18:03:23 -0700
Message-ID: <157049660366.2397321.3207595496710777905.stgit@magnolia>
In-Reply-To: <157049658503.2397321.13914737091290093511.stgit@magnolia>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=989
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix this test to use _scratch_mkfs_xfs instead of the open-coded mkfs
call.  This is needed to make the test succeed when XFS DAX is enabled
and mkfs enables reflink by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/263 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/263 b/tests/xfs/263
index 75477937..578f9ee7 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -75,11 +75,11 @@ function test_all_state()
 
 echo "==== NO CRC ===="
 # Control size to control inode numbers
-$MKFS_XFS_PROG -f -m crc=0 -n ftype=0 -d size=512m $SCRATCH_DEV >>$seqres.full
+_scratch_mkfs_xfs "-m crc=0 -n ftype=0 -d size=512m" >> $seqres.full
 test_all_state
 
 echo "==== CRC ===="
-$MKFS_XFS_PROG -f -m crc=1 -d size=512m $SCRATCH_DEV >>$seqres.full
+_scratch_mkfs_xfs "-m crc=1 -d size=512m" >>$seqres.full
 test_all_state
 
 status=0

