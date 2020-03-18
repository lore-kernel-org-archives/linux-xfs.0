Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140C4C5ACD6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 20:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29082077F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 20:11:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fFhsi9IP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCRULn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 16:11:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRULn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 16:11:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IKAURk155596;
        Wed, 18 Mar 2020 20:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=H2I0Tdvp2iIX53+RRb2MhTthewU+bPLHVvINdSXWj/o=;
 b=fFhsi9IPxv/HPg2nNQeMlWxQqlKV7VD81W/IaLMvK8V5DXXrCeu+He2jfJQIGgU7baCJ
 ofxB0dZxpcJ+7kBwqbsaDUj5jlTBfdIGWQJubupdDlR8fHge5LtuOIsAkfoLueOEacJX
 cyX8aFXgZs6XtycRoh7FMVe8yDvX4GDSuSZmeVI5MgDQARX4ESAIh5xI8TRlzWE9GuVx
 f0AJ8ci5NKn95YQQQnHcL9chocJHueb2ZPLju1917XLD6osfuVhQXYx8tH1NQ5+N83BY
 G17QhntGqoat7oLxlLA8wJEL4HjxwhNIbjGzuexgvbn0SfBma7dypkijWjcLbiRJWnNP Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yub274ny0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 20:11:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IJolAr075139;
        Wed, 18 Mar 2020 20:11:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ys8rj9ru5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 20:11:38 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02IKBbZh004987;
        Wed, 18 Mar 2020 20:11:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 13:11:37 -0700
Date:   Wed, 18 Mar 2020 13:11:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     zlang@redhat.com, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] generic/587: fix rounding error in quota/stat block
 comparison
Message-ID: <20200318201136.GF256767@magnolia>
References: <20200318150142.GA256607@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318150142.GA256607@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180087
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
v2: improve the comments to explain exactly what we're doing and why
---
 tests/generic/587 |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/generic/587 b/tests/generic/587
index 7b07d07d..3e58a302 100755
--- a/tests/generic/587
+++ b/tests/generic/587
@@ -51,13 +51,17 @@ ENDL
 
 # Make sure that the quota blocks accounting for qa_user on the scratch fs
 # matches the stat blocks counter for the only file on the scratch fs that
-# is owned by qa_user.  Note that stat reports in units of 512b blocks whereas
-# repquota reports in units of 1k blocks.
+# is owned by qa_user.
 check_quota_accounting()
 {
+	# repquota rounds the raw numbers up to the nearest 1k when reporting
+	# space usage.  xfs_io stat always reports space usage in 512b units,
+	# so use an awk script to round this number up to the nearest 1k, just
+	# like repquota does.
 	$XFS_IO_PROG -c stat $testfile > $tmp.out
 	cat $tmp.out >> $seqres.full
-	local stat_blocks=$(grep 'stat.blocks' $tmp.out | awk '{print $3 / 2}')
+	local stat_blocks=$(grep 'stat.blocks' $tmp.out | \
+		awk '{printf("%d\n", ($3 + 1) / 2);}')
 
 	_report_quota_blocks $SCRATCH_MNT > $tmp.out
 	cat $tmp.out >> $seqres.full
