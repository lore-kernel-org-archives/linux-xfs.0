Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97299C388F7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5301321741
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nlf8qcJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbgKKAnu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:43:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732399AbgKKAnu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:43:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XmTQ110532;
        Wed, 11 Nov 2020 00:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4ZtBNkTbnpUPrYiymVEW8qoevwfeZ1XMqQUVxskRH8M=;
 b=nlf8qcJncec8GxmFAWrd8N69ead4OY52dbGSD5aT5oTDAAqw8uI7QD4JVWIiJWg5iFXQ
 0XsmGZoKl6U4ZxN8ZgI46Mv780Qc9LOt1AZscCYmSjOvqKmBVSOfAkcxJsB2pvAQRBzY
 3a+HkgLruewwgzRG4VAeiOg3NGLFIKnP1Zg1S9jG6XA3b6/XYdF5M3xUh2cdkeYWEZkT
 SnHWUkvWSXC8KvShcARoPvhjCikwcmzLhdkvS2vNXORJ18mfpmvlNjgEa3/JaOfpbqAx
 rxXq9/txctPZI82eeXf8VIhZnb8eLbX48NqOIhkFudzj9UprswIAS/xUXMlvuCeyjH15 OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:43:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0UArh097643;
        Wed, 11 Nov 2020 00:43:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34p5gxq72m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0hlOo000699;
        Wed, 11 Nov 2020 00:43:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:46 -0800
Subject: [PATCH 6/6] xfs/033: use _scratch_xfs_db wrapper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:43:45 -0800
Message-ID: <160505542588.1388647.226564119701569514.stgit@magnolia>
In-Reply-To: <160505537312.1388647.14788379902518687395.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the wrapper instead of open-coding the call.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/033 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/033 b/tests/xfs/033
index 372426b7..a1311dbe 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -76,7 +76,7 @@ if [ $_fs_has_crcs -eq 1 ]; then
 fi
 _link_out_file_named $seqfull.out "$FEATURES"
 
-`xfs_db -r -c sb -c p $SCRATCH_DEV | grep 'ino = ' | \
+`_scratch_xfs_db -r -c sb -c p | grep 'ino = ' | \
 	sed -e 's/ //g' -e 's/^/export /'`
 
 # check we won't get any quota inodes setup on mount

