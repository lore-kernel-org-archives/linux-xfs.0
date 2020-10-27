Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AC2C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29DBF221FC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fHntdvme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444488AbgJ0TCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48428 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444475AbgJ0TCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsV2U111568;
        Tue, 27 Oct 2020 19:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/YYcOW+Lb/GRpy+3vvv4+svPN4X7l+u+PV2Ty1GVohE=;
 b=fHntdvmeVrB8UkyZ2WlP4juQmcwqSakYfoqjF4GAuB6hUUZgGapIT+YQ7WMWMjJ0qrh5
 iqc9oOup2Qhoq/R2jhQFhr7G1RLBvFmzi3GaOYzxRVGTSNVUZHfeKEBz5cYKnoIgeQTm
 9lmYlq95ujCt1nHpMaLHXCG50qnuObGIHDykKKB4TIAq36yhgIsTT/4Gz/1uknuw4Y0R
 sg3Rbt4i/SpmO2jEbid/x/zjugiZfIPg2/ov7A5XyM6h0MVNOPcxQgUboAsEtvQuVjzT
 G2mwu4FEZ0oJbjTjeBxChhUygCz4Xu90DFM/EguFYd6keilaWI0hvxELk0kilMVv/wg6 gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm41exq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:01:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItKEw019910;
        Tue, 27 Oct 2020 19:01:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6wbm6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:01:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ1vpf000943;
        Tue, 27 Oct 2020 19:01:57 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:01:57 -0700
Subject: [PATCH 4/9] various: replace _get_block_size with
 _get_file_block_size when needed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:01:56 -0700
Message-ID: <160382531634.1202316.310897007206501013.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The _get_file_block_size helper was added so that tests could find out
the size of a fundamental unit of allocation for a given file, which is
necessary for certain fallocate and clonerange tests.

On certain filesystem configurations (ocfs2 with clusters, xfs with a
large rt extent size), this is /not/ the same as the filesystem block
size, and these tests will fail.  Fix them to use the correct helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/328 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/328 b/tests/xfs/328
index 9b17b6a4..26325b40 100755
--- a/tests/xfs/328
+++ b/tests/xfs/328
@@ -48,7 +48,7 @@ mkdir "$testdir"
 # 2^10 blocks... that should be plenty for anyone.
 fnr=$((12 + LOAD_FACTOR))
 free_blocks=$(stat -f -c '%a' "$testdir")
-blksz=$(_get_block_size $testdir)
+blksz=$(_get_file_block_size $testdir)
 space_avail=$((free_blocks * blksz))
 calc_space()
 {

