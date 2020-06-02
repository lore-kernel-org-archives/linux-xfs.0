Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A483C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB630206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mUWBHksk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgFBE24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524GwoA106536;
        Tue, 2 Jun 2020 04:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0ZVCYD4IqGRONGG59xgnbMM7CNqAoH5JJ3lnDYSKaPs=;
 b=mUWBHksk5VUBx8inddBlFZi1CSZ2PriD9ab5ZexJYmMjY5SyIZRG39t8NccnX5Qy8+oU
 Gpq7Xtsk8IDA/tp8B3EkG5iexggDLOh5gs+TXR23H0h7UHlcvZcIaNaaJD0W8+F8nYPm
 kqv4jrRZ+MZW83/EItOie4EJ24ovVuCM5Yk+On9KsbckWj4WG8ZQ8E9G463u3hxPlxmf
 T/xSVvHmbuy44ziVYBirSgnvzPchyOauF1vRx81a6+hDhER6fKtuk73OLlk9t6zVSwdw
 laIkCpPcrUHRt5QOReDHhYE07neHUBGtkjtijA5ydu0TFhVUu/GmgV9EOF4lWdptSXaS BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem1ta8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hu3E126673;
        Tue, 2 Jun 2020 04:26:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25mnj78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524QpKc020940;
        Tue, 2 Jun 2020 04:26:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:51 -0700
Subject: [PATCH 17/17] xfs_repair: complain about any nonzero inprogress
 value, not just 1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:50 -0700
Message-ID: <159107201063.313760.4770169703246824898.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Complain about the primary superblock having any non-zero sb_inprogress
value, not just 1.  This brings repair's behavior into alignment with
xfs_check and the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/sb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/repair/sb.c b/repair/sb.c
index 91a36dd3..17ce43cc 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -369,8 +369,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		return(XR_BAD_VERSION);
 
 	/* does sb think mkfs really finished ? */
-
-	if (is_primary_sb && sb->sb_inprogress == 1)
+	if (is_primary_sb && sb->sb_inprogress)
 		return(XR_BAD_INPROGRESS);
 
 	/*

