Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D904C433E2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2306C208C7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wBHdUxMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgIGRzh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:55:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbgIGRz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:55:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Hnrc6043240;
        Mon, 7 Sep 2020 17:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=M12GFJgk9H+IEcVGOab87wQzVegv2vD3BY6hemm5XbU=;
 b=wBHdUxMphEjIRY1/tlhzheKTEcEb1hHN2P5XirG4sfQC7FAfvbJU1NLjLLd4GY71hsUf
 oOAW6kGEwq1EqUAbMUOQhLjD1H+N180VqpdgWuHrzrCi3EZdYrxjlmz2SeDSu1ox6951
 nQ8PaIRgfVymQQh/89ol0B6W6d/cd3jKZ5ARLidCLj0UIxEViny2EbXRRMVlWXcxJ4vA
 vJprIWBXPaObKCYW8IoaLMVgoHb4Z3VR/VEwxhbDPtLrEWvp0/c+AovmcB2/A6T/LT0i
 +Rl3q3nPfNl1QzOfHlRKYdJIaOCTphPJcp6ZHKvl7E+YSpqbdo9J4lpHZ9S+XjsomLz4 fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3amqgwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:55:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Houed017035;
        Mon, 7 Sep 2020 17:53:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33cmk15nqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 087HrOcl006817;
        Mon, 7 Sep 2020 17:53:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:17 -0700
Subject: [PATCH 3/7] xfs_repair: junk corrupt xattr root blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:16 -0700
Message-ID: <159950113638.567790.12521493655366784663.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
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

If reading the root block of an extended attribute structure fails due
to a corruption error, we should junk the block since we know it's bad.
There's no point in moving on to the (rather insufficient) checks in the
attr code.

Found by fuzzing hdr.freemap[1].base = ones in xfs/400.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 6cec0f7075d5..d92909e1c831 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1107,6 +1107,15 @@ process_longform_attr(
 			ino);
 		return 1;
 	}
+
+	if (bp->b_error == -EFSCORRUPTED) {
+		do_warn(
+	_("corrupt block 0 of inode %" PRIu64 " attribute fork\n"),
+			ino);
+		libxfs_buf_relse(bp);
+		return 1;
+	}
+
 	if (bp->b_error == -EFSBADCRC)
 		(*repair)++;
 

