Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F0DC43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894EE208C7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="obS+t/ZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgIGRyH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:54:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgIGRxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:53:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HoAoW043486;
        Mon, 7 Sep 2020 17:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=beosbEekhC8pFPBX3BqDotf5Q/trsSwCBgC9flpud+Q=;
 b=obS+t/ZTBDp4pSeUAKcR1bR77xhxKLBDF1WT13S1+cjlFdPDn2JsdhXJBpYI1lOf7+qw
 /b45bjgvbw2ip3oKVsGU/NMRABHR0lRJEjaW241q650hveManv/tKRduuqQa4tCB2H4W
 Imycbu+Ym2E4lJ58RHYo/seT1V3isP/XtdsrevTKb7Ep3sxZikz7TzWexWHosYDcjeKb
 wg1z9dxt24dk5m9PoDoPedTZ8HWjCFLLTDJR7peAcv2o5c2NgyRm1ZugTnqJcZnZRXsJ
 fmIBD/2WXpqP8T9De9JkyndjW5gc6IzmjterDwdiOeJf1aCgmsam/NKtK+mriWYTD1cG TA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amqgp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:53:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnM09066088;
        Mon, 7 Sep 2020 17:53:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33cmepvh9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 087Hrp1e012665;
        Mon, 7 Sep 2020 17:53:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:11 -0700
Subject: [PATCH 2/7] xfs_repair: fix error in process_sf_dir2_fixi8
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:10 -0700
Message-ID: <159950112994.567790.6177947698105660609.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The goal of process_sf_dir2_fixi8 is to convert an i8 shortform
directory into a (shorter) i4 shortform directory.  It achieves this by
duplicating the old sf directory contents (as oldsfp), zeroing i8count
in the caller's directory buffer (i.e. newsfp/sfp), and reinitializing
the new directory with the old directory's entries.

Unfortunately, it copies the parent pointer from sfp (the buffer we've
already started changing), not oldsfp.  This leads to directory
corruption since at that point we zeroed i8count, which means that we
save only the upper four bytes from the parent pointer entry.

This was found by fuzzing u3.sfdir3.hdr.i8count = ones in xfs/384.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dir2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index 95e8c2009d1f..eabdb4f2d497 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -84,7 +84,7 @@ process_sf_dir2_fixi8(
 	memmove(oldsfp, newsfp, oldsize);
 	newsfp->count = oldsfp->count;
 	newsfp->i8count = 0;
-	ino = libxfs_dir2_sf_get_parent_ino(sfp);
+	ino = libxfs_dir2_sf_get_parent_ino(oldsfp);
 	libxfs_dir2_sf_put_parent_ino(newsfp, ino);
 	oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	newsfep = xfs_dir2_sf_firstentry(newsfp);

