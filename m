Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C036FC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B97D21741
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OYl7Gvl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgIOBou (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIOBos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:44:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1il8g031223;
        Tue, 15 Sep 2020 01:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Laru6fYCx+ItFhqawtcrLi11l6zlh5NjYH9DFlpIQSM=;
 b=OYl7Gvl/E/QEitBFWal/EBeE+/Ghu+GWzaHmNVZxBHTaiawnlQ3nBSpQCT2GKQcc/kjJ
 WTLdNNae4Gvq4gAKerE4tBSEIiGoDx1ilI/sK4QpY42fqdFuBHvrhwYmzrDJGYqQm872
 5gDqCXg4kgmVgsj9aS6WtL3cnQc5J1ofkMMfbFaLSlx4vOxRED+zb3iLkuoFvkI0eMgd
 ceeRIxRDDmVgMoINS/3e29f4n09tKdHDKhhP986qmwpdrz/NcSgWsohSiqi+i+A7+S/N
 PO2gFI2CuYmA92triJZAJ1fGUMuiZ2qOKZUaXf0RKxf1LlVIXsjxFaDGPli6F6lh62o5 Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:44:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1igOd028995;
        Tue, 15 Sep 2020 01:44:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h88x2vsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:42 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1iW2G007137;
        Tue, 15 Sep 2020 01:44:32 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:32 +0000
Subject: [PATCH 15/24] xfs/194: actually check if we got 512-byte blocks
 before proceeding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:31 -0700
Message-ID: <160013427110.2923511.12673259176007024613.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
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
index 9001a146..90b74c8f 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -84,6 +84,9 @@ unset XFS_MKFS_OPTIONS
 # we need 512 byte block size, so crc's are turned off
 _scratch_mkfs_xfs -m crc=0 -b size=$blksize >/dev/null 2>&1
 _scratch_mount
+test "$(_get_block_size $SCRATCH_MNT)" = 512 || \
+	_notrun "Could not get 512-byte blocks"
+
 
 # 512b block / 4k page example:
 #

