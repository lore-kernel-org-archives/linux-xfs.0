Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58158C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9282077B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fekp5aA/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgAPFKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:10:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPFKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:10:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59WCU154815;
        Thu, 16 Jan 2020 05:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yoHjzEoLeU4OqrWJ4cCJO0a5dvQ9kLQmXeRaDfXK/vo=;
 b=Fekp5aA/FHkkB/YHRAjlQ4IIPXm0f6Ic8y/O5UE5AyfyP7+ExaXyjDLJTz9wN2+rOnG3
 xj29dKOwU381wdEjAfwAEkuxH3IDGS8QNhnhJomxw0GYpKvgwCws01ccjBnWIoxmQOfm
 P0WbG3IPKVNOD0mKnsuz/UrLWV2EyyYEuFR9Qhe3XxTryXbeaNkXdiKwQtin4WRVj5fA
 4j+40pBWSxdiU+7eYeNkcc/wdlkaelvAmF6ejk8xQBQXGGnX9bhtHRPAzVn+C2WT9unK
 Y+x904F3nKURzDYC7nZNcRMktnEtS1f0r22GvVZM10AZTLUkPFDeDJwkRJrg4scI2A3G dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73u04mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59EPe085395;
        Thu, 16 Jan 2020 05:10:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xj1psd0jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5Agi3018051;
        Thu, 16 Jan 2020 05:10:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:10:42 -0800
Subject: [PATCH 1/7] xfs/449: filter out "Discarding..." from output
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:10:41 -0800
Message-ID: <157915144176.2374854.14349580805612117354.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfsprogs 5.4 prints "Discarding..." if the disk supports the trim
command.  Filter this out of the output because xfs_info and friends
won't print that out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/449 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 7aae1545..83c3c493 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -39,7 +39,7 @@ _require_scratch_nocheck
 _require_xfs_spaceman_command "info"
 _require_command "$XFS_GROWFS_PROG" xfs_growfs
 
-_scratch_mkfs > $tmp.mkfs
+_scratch_mkfs | sed -e '/Discarding/d' > $tmp.mkfs
 echo MKFS >> $seqres.full
 cat $tmp.mkfs >> $seqres.full
 

