Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA68C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D64B421741
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZzbNLtEx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgIOBnd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1eK5m041876;
        Tue, 15 Sep 2020 01:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iCKVr3xR+EaxYJthUB/1fzzj0xhz3yNO5WC9Eg40NFk=;
 b=ZzbNLtExg0jYwK5NdDshF3V56ZvxNqHexMCm87+u7KFnKh9wuQTTvLTDpqQIwxCpVefd
 PRzRydmYD/c3D7kA9GkdMZWtlrHqV2IDpvgNG9QcseHbFBa7S9mK8NuUJFzakt1juGAv
 T71xZcUqu9aZmbTzbSrZkiajccmRKGK9XRezDF0Shg3Z6ifJ/Y3z4uVYpGQDSWCRPsoc
 TLKRqvDnB5Obxbwv8C0SVY8PbNlwcHtMyi3o8HYbY1SVtz6jXAVaUG7Uv1RMITS7pKXz
 xii4L0eF8VJbA7PRZj+CfWb49LdSu80g5+AmskbJz/JN3Nx/dNEYXrQ405EBGvUweg8r Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dbhky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1eeWm022047;
        Tue, 15 Sep 2020 01:43:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33h88x2uqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1hTxx001018;
        Tue, 15 Sep 2020 01:43:29 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:28 +0000
Subject: [PATCH 05/24] xfs/031: make sure we don't set rtinherit=1 on mkfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:27 -0700
Message-ID: <160013420779.2923511.9462939883966946313.stgit@magnolia>
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
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

mkfs.xfs does not support setting rtinherit on the root directory /and/
pre-populating the filesystem with protofiles, so don't run this test if
rtinherit is in the mkfs options.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/019 |    5 +++++
 tests/xfs/031 |    5 +++++
 2 files changed, 10 insertions(+)


diff --git a/tests/xfs/019 b/tests/xfs/019
index f42b62bb..aa5365e7 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -51,6 +51,11 @@ _supported_os Linux
 
 _require_scratch
 
+# mkfs cannot create a filesystem with protofiles if realtime is enabled, so
+# don't run this test if the rtinherit is anywhere in the mkfs options.
+echo "$MKFS_OPTIONS" | grep -q "rtinherit" && \
+	_notrun "Cannot mkfs with a protofile and -d rtinherit."
+
 protofile=$tmp.proto
 tempfile=$tmp.file
 
diff --git a/tests/xfs/031 b/tests/xfs/031
index 6403fd40..671b6727 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -81,6 +81,11 @@ _supported_os Linux
 _require_scratch
 _require_no_large_scratch_dev
 
+# mkfs cannot create a filesystem with protofiles if realtime is enabled, so
+# don't run this test if the rtinherit is anywhere in the mkfs options.
+echo "$MKFS_OPTIONS" | grep -q "rtinherit" && \
+	_notrun "Cannot mkfs with a protofile and -d rtinherit."
+
 # sanity test - default + one root directory entry
 # Note: must do this proto/mkfs now for later inode size calcs
 _create_proto 0

