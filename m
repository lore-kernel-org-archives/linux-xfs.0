Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A59C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E332420797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gt3CNBv6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKJSDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52026 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKJSDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxq9o048718;
        Tue, 10 Nov 2020 18:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EVrXdoZSwNoNa76nTzoL+175i3eg2OULFkT2ao3Ru8g=;
 b=Gt3CNBv6iZ7ph2PiXn3NJszxotqQA2mTdXFMK+yK4TmPU4272W/Ms2Ji9CYAJfI8BNMn
 HPN06d5Oy6ToC5NHPkSH0vaGMY7vqeu3pNFXLl235VSErVmz+WmDM2sSaMq8SGv0MWVq
 c/TngNQ75WJ6R+OPg7Zvt7mShUsGqOa8H682uVN426IZGb312ANchmQFDNIrayXzg5KB
 iE4+hjrxOYFfU5Fl1tfndJf/jqZWJq0IOkW7tsyBXn/25DL70v1/ef3z2XE5J+BwBpYB
 nhgOt6CyrKtrXpigss0YYr2wWfTb0omsKvj/42JCs7RJb7ecg6NuGI36NnB1wgItiP/s kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3aw957-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI1Ebb175653;
        Tue, 10 Nov 2020 18:03:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55nx4hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAI3Iha021161;
        Tue, 10 Nov 2020 18:03:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:17 -0800
Subject: [PATCH 2/9] mkfs: clarify valid "inherit" option values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:16 -0800
Message-ID: <160503139674.1201232.14186191797913715969.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

Clarify which values are valid for the various *inherit= mkfs
options.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix a few nits]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 0a7858748457..692daf2a9050 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -378,31 +378,40 @@ without stripe geometry alignment even if the underlying storage device provides
 this information.
 .TP
 .BI rtinherit= value
-If set, all inodes created by
+If
+.I value
+is set to 1, all inodes created by
 .B mkfs.xfs
 will be created with the realtime flag set.
+The default is 0.
 Directories will pass on this flag to newly created regular files and
 directories.
 .TP
 .BI projinherit= value
 All inodes created by
 .B mkfs.xfs
-will be assigned this project quota id.
+will be assigned the project quota id provided in
+.I value.
 Directories will pass on the project id to newly created regular files and
 directories.
 .TP
 .BI extszinherit= value
 All inodes created by
 .B mkfs.xfs
-will have this extent size hint applied.
+will have this
+.I value
+extent size hint applied.
 The value must be provided in units of filesystem blocks.
 Directories will pass on this hint to newly created regular files and
 directories.
 .TP
 .BI daxinherit= value
-If set, all inodes created by
+If
+.I value
+is set to 1, all inodes created by
 .B mkfs.xfs
 will be created with the DAX flag set.
+The default is 0.
 Directories will pass on this flag to newly created regular files and
 directories.
 By default,

