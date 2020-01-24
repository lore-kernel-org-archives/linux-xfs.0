Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76B3C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3CE02071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eX1p3nR0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgAXARX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAXARX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08rO8182933;
        Fri, 24 Jan 2020 00:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BOP91qwr/dnhQzLgzvLI6OK6tGlToJOGVHsgSnYYXZ4=;
 b=eX1p3nR0oYyoocdu+kW/Z5n3O+m3A46DAmS1+i6wdkzYaGjwB0GGKULxqJQE+9+g70yf
 nEqtzV/DtKTe188HgMbDXgB4iQt9YvqXjel2KVa3rc712RvAsJr5cauHyElKsufm4J3E
 m7x34HJyydjHBHWLAp158R5wyeDOWym9D93NlPmn+1ZIWwjBITxZvi0Bu/1YLuLPlJ+6
 kneGNPZMAg5O+8wQSLrlRo58ZNgAsDR1KDIWheqZ9c3A/zQPGeA4e/ag35qk02jovDpi
 k5iqqTdBOnholqPm1pkVquBi0+oauto0iorHX1UdQTCLL6yWKyY5vg2LhckbW6T5o/mH BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqns2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E7Xn111158;
        Fri, 24 Jan 2020 00:17:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1f6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0HJgG030705;
        Fri, 24 Jan 2020 00:17:19 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:19 -0800
Subject: [PATCH 7/8] xfs_io: fix pwrite/pread length truncation on 32-bit
 systems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:17:17 -0800
Message-ID: <157982503725.2765410.9945705757777826157.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=998
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The pwrite and pread commands in xfs_io accept an operation length that
can be any quantity that fits in a long long int; and loops to handle
the cases where the operation length is larger than the IO buffer.

Weirdly, the do_ functions contain code to shorten the operation to the
IO buffer size but the @count parameter is size_t, which means that for
a large argument on a 32-bit system, we rip off the upper bits of the
length, turning your 8GB write into a 0 byte write, which does nothing.

This was found by running generic/175 and observing that the 8G test
file it creates has zero length after the operation:

wrote 0/8589934592 bytes at offset 0
0.000000 bytes, 0 ops; 0.0001 sec (0.000000 bytes/sec and 0.0000 ops/sec)

Fix this by pushing long long count all the way through the call stack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/pread.c  |    4 ++--
 io/pwrite.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/io/pread.c b/io/pread.c
index 1b4352be..d52e21d9 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -164,7 +164,7 @@ static ssize_t
 do_preadv(
 	int		fd,
 	off64_t		offset,
-	size_t		count)
+	long long	count)
 {
 	int		vecs = 0;
 	ssize_t		oldlen = 0;
@@ -199,7 +199,7 @@ static ssize_t
 do_pread(
 	int		fd,
 	off64_t		offset,
-	size_t		count,
+	long long	count,
 	size_t		buffer_size)
 {
 	if (!vectors)
diff --git a/io/pwrite.c b/io/pwrite.c
index ccf14be9..1c28612f 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -54,8 +54,8 @@ static ssize_t
 do_pwritev(
 	int		fd,
 	off64_t		offset,
-	size_t		count,
-	int 		pwritev2_flags)
+	long long	count,
+	int		pwritev2_flags)
 {
 	int vecs = 0;
 	ssize_t oldlen = 0;
@@ -97,7 +97,7 @@ static ssize_t
 do_pwrite(
 	int		fd,
 	off64_t		offset,
-	size_t		count,
+	long long	count,
 	size_t		buffer_size,
 	int		pwritev2_flags)
 {

