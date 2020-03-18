Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5710CC5ACD7
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E8952077C
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dmWZN+jX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCRPBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:01:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgCRPBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 11:01:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IEvhd6033551;
        Wed, 18 Mar 2020 15:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=aH99mpkEOFwv/k/B6kJbVv9vAv06SvRq7RWKZN5L4UM=;
 b=dmWZN+jX6I7u+1SHFgJYChE8P2sRbEY7m5ybB8QzJdIlGMCPuVFzsHjsHxnhjr24CuBt
 6nZpzAGDkAUSLNls/m2SnSVlMsejpS9FFgR8lohh+mt0me7WJRam1JFU4lQ3/8Y9sHE0
 YsMXVR5QvbnO3VL35hKT1jnlWhnUjnRjpmUekoBCPEBEuK08aXUidMdD+KJa12VDtd4M
 +vPFWPvdI8SIV9wwk703fmxj4bseoMPR6QKI2D4wlDQhLbhYcdDznUf3GQunTs9NB1+E
 ucV6iIQpcVlZnn7OtwGWePr7tGdy+VYTzZcF/l4FHt9Cxn0aGwd8xCKNpORRBYR9u4Ge ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yub2730a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:01:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IEvdK9190822;
        Wed, 18 Mar 2020 15:01:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ys92gmwnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:01:43 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02IF1gl4017602;
        Wed, 18 Mar 2020 15:01:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 08:01:42 -0700
Date:   Wed, 18 Mar 2020 08:01:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     zlang@redhat.com, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/587: fix rounding error in quota/stat block
 comparison
Message-ID: <20200318150142.GA256607@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180072
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It turns out that repquota (which reports in units of 1k blocks) reports
rounded up numbers when the fs blocksize is 512 bytes.  However, xfs_io
stat always reports block counts in units of 512 bytes.  If the number
of (512b) file blocks is not an even number, the "$3 / 2" expression
will round down, causing the test to fail.  Round up to the nearest 1k
to match repquota's behavior.

Reported-by: zlang@redhat.com
Fixes: 6b04ed05456fc6c ("generic: test unwritten extent conversion extent mapping quota accounting")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/587 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/generic/587 b/tests/generic/587
index 7b07d07d..2ffa367d 100755
--- a/tests/generic/587
+++ b/tests/generic/587
@@ -57,7 +57,8 @@ check_quota_accounting()
 {
 	$XFS_IO_PROG -c stat $testfile > $tmp.out
 	cat $tmp.out >> $seqres.full
-	local stat_blocks=$(grep 'stat.blocks' $tmp.out | awk '{print $3 / 2}')
+	local stat_blocks=$(grep 'stat.blocks' $tmp.out | \
+		awk '{printf("%d\n", ($3 + 1) / 2);}')
 
 	_report_quota_blocks $SCRATCH_MNT > $tmp.out
 	cat $tmp.out >> $seqres.full
