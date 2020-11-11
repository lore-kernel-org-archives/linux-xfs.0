Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E06DC388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6D421D46
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d0YV9Jx8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbgKKAok (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:44:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbgKKAoj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:44:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZaiR016919;
        Wed, 11 Nov 2020 00:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=atYemPZBsWov6lHhJQg/LW4GDgtllAhk02fu6dVnZhk=;
 b=d0YV9Jx8TdsNZZGzfyLhegopgg9q+jWga5S9gvVFiz9/SoXaAXpKGW6GnMdwebslU4XF
 lsTRErrGcNP1Shorq5iwKOogz04W3dxT1CYu17rp4iqNW82Y9ubl+J/FspHozZ8gABrP
 PDpaG3mvDqQtroH+GGbCxkMRQA99C93yQkM5hTmBCwfloKFC3hhiuTGebjv2pHxjMBlD
 ZSCesukiCuZVHPuwBMv066gDsZAZlfFpMWzcc6T/dHdOPtSEzpmTF+4ZMTGkmuBkCzMo
 FL+VKOx/bnwEuOTbd1GveJS9/2pTQtsl9T4rUmlJxq0fYyOHjyiJxtYbGXke1FgEStWW gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72emv63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:44:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0VEC2095386;
        Wed, 11 Nov 2020 00:44:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55paub8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0ianc014027;
        Wed, 11 Nov 2020 00:44:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:35 -0800
Subject: [PATCH 7/7] xfs/122: fix test for xfs_attr_shortform_t conversion
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:34 -0800
Message-ID: <160505547480.1388823.13194081097582987.stgit@magnolia>
In-Reply-To: <160505542802.1388823.10368384826199448253.stgit@magnolia>
References: <160505542802.1388823.10368384826199448253.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The typedef xfs_attr_shortform_t was converted to a struct in 5.10.
Update this test to pass.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/122     |    1 -
 tests/xfs/122.out |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index a4248031..322e1d81 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -72,7 +72,6 @@ for hdr in /usr/include/xfs/xfs*.h; do
 done
 
 # missing:
-# xfs_attr_shortform_t
 # xfs_trans_header_t
 
 cat >$tmp.ignore <<EOF
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 45c42e59..cfe09c6d 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -62,6 +62,7 @@ sizeof(struct xfs_agfl) = 36
 sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
+sizeof(struct xfs_attr_shortform) = 8
 sizeof(struct xfs_btree_block) = 72
 sizeof(struct xfs_btree_block_lhdr) = 64
 sizeof(struct xfs_btree_block_shdr) = 48

