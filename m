Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDC2C55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B5620825
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qb9tw7Sz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgKJSDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKJSDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxGjV018619;
        Tue, 10 Nov 2020 18:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WWO0Txw5hyJURRBE0yZMOS8cpMVROxYR/z3Bu3bDYnA=;
 b=qb9tw7SzjSj1xe4/EEYkVefCYYRJ5xuo4+XfXrywZZEAm6ZzaCu9hGNDzuqHbO8zD1CF
 ZPR5ms7BRJLa6vIfWKTQTsNhnhyGm0qyrKo99ywt5YUZ+BOvDnaYBcVeDfKG2Sy0ggfO
 XZxYLVM4uXYUmoAKWP6o6NGCn9rsqCeyB87oQ6UO3fU6+DSAFR952w7EWxLVimJvmpYB
 /q2MAN5lQz8WiCV3VXvGd5F1Cr8mdBbaD4XY2M7ZSE1x237wqp6oMAT74Q392JNob++B
 Wo8fNFOM3q9qoNLZwMGhIfqaYLreQJp8NWYoLPfgQQPzvGx3hMKO/MEtMbcGre1+COpa oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72ek8jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI15sJ092574;
        Tue, 10 Nov 2020 18:03:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34qgp76kq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAI3BpC021102;
        Tue, 10 Nov 2020 18:03:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:10 -0800
Subject: [PATCH 1/9] mkfs: allow users to specify rtinherit=0
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:09 -0800
Message-ID: <160503138929.1201232.16637882579026265131.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

mkfs has quite a few boolean options that can be specified in several
ways: "option=1" (turn it on), "option" (turn it on), or "option=0"
(turn it off).  For whatever reason, rtinherit sticks out as the only
mkfs parameter that doesn't behave that way.  Let's make it behave the
same as all the other boolean variables.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8fe149d74b0a..908d520df909 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -349,7 +349,7 @@ static struct opt_params dopts = {
 		},
 		{ .index = D_RTINHERIT,
 		  .conflicts = { { NULL, LAST_CONFLICT } },
-		  .minval = 1,
+		  .minval = 0,
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
@@ -1429,6 +1429,8 @@ data_opts_parser(
 	case D_RTINHERIT:
 		if (getnum(value, opts, subopt))
 			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
+		else
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_RTINHERIT;
 		break;
 	case D_PROJINHERIT:
 		cli->fsx.fsx_projid = getnum(value, opts, subopt);

