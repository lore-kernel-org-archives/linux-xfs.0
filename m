Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57447ECE58C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1C821479
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e7WRy+jq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfJHBDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 21:03:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57750 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbfJHBDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 21:03:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980xNV5190794;
        Tue, 8 Oct 2019 01:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bF4y32Oh22uUHynBlfNeyYOAi2KI9yl111Hjs4N6mRE=;
 b=e7WRy+jqHuj9dYTnzI/SbajaxaqfHDaeKNDpOX1o4aBBdysn0o50RngQNI67ibR3CK8b
 YnZqjKGHqNKsfnCQ9jw0M+6+w2WToCLoK1q5llJk7jTkWnzci6c4FMgY+92KVxBvUpo+
 y3RzAThJZBM635FLonB2ptUuNzXvJW/3d6og/ebEzNIrCuyqUwO6L4i3nkcMedu+MJbw
 WCNDbhnQc8e1LOMXNkwC7ZUxizNe86HoNZ5eq01Ni5deapeUIdmixkkX3PNUwbrEu51X
 1cPKr/XO2hUWOWeEWQYEDOtIpCMSLqZSGzAnSPsBrWkupRbuLBmO4VuR5MEFOnKsdOZy +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qa4fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980wZ0A025750;
        Tue, 8 Oct 2019 01:03:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vgef9mw9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9813C9R010277;
        Tue, 8 Oct 2019 01:03:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 18:03:12 -0700
Subject: [PATCH 1/4] xfs/196: check for delalloc blocks after pwrite
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 07 Oct 2019 18:03:11 -0700
Message-ID: <157049659135.2397321.4055705884999858018.stgit@magnolia>
In-Reply-To: <157049658503.2397321.13914737091290093511.stgit@magnolia>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
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

This test depends on the pwrite creating delalloc blocks, which doesn't
happen if the scratch fs is mounted in dax mode (or has an extent size
hint applied).  Therefore, check for delalloc blocks and _notrun if we
didn't get any.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/196 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/196 b/tests/xfs/196
index 5dc28670..406146c5 100755
--- a/tests/xfs/196
+++ b/tests/xfs/196
@@ -50,6 +50,8 @@ bytes=$((64 * 1024))
 
 # create sequential delayed allocation
 $XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -elpv" $file | grep -q delalloc || \
+	_notrun "Unable to create delayed allocations"
 
 # Enable write drops. All buffered writes are dropped from this point on.
 _scratch_inject_error "drop_writes" 1

