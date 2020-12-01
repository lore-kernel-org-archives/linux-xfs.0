Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E0EC71155
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B8920796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vs5FiG5X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgLADjM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:39:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60648 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgLADjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:39:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13Uqt5067235
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ingpWCL0/mtojmX4ZQnCBR+d9mIl8d9MWscgGejuhjI=;
 b=Vs5FiG5XN3qYGSgtHZW6i+B47P25YFDH9QQIATJ4NPKyvp+zTRj0vPAII9o23+OReH6A
 6PZG25mrDbteDqrFGvqktHaS6SAqUhTKjZ59wFwlpAjDSkMi4v8MMbVIs6RDX5WBNuND
 7ztS/30SkjFtfdHI31fFQONWQLvWaMnwh2pueZF0WHUgqP8F5P07FiUwNiDcAaCHcUXL
 yvnAOfa+b7MwNWkqtjSZbbGQczPb8cvecL6uKu9FoMrOcRkqEM5N6AF/WJeVZyTL9Ky+
 IgPnaztZM6d9ngN8KCpIcAXFtbD9h1mstB3UNddp+CFGVX4wm/QD8V2ANptBzT5ObiDh KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2arhmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UJvq181486
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3540arh85n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B13cTom018652
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:38:29 -0800
Subject: [PATCH 08/10] xfs: improve the code that checks recovered extent-free
 intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:38:28 -0800
Message-ID: <160679390871.447963.15070829026899571950.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=3
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The code that validates recovered extent-free intent items is kind of a
mess -- it doesn't use the standard xfs type validators, and it doesn't
check for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_extfree_item.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index b5710b7fc263..b1c004016709 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -584,14 +584,14 @@ xfs_efi_validate_ext(
 	struct xfs_mount		*mp,
 	struct xfs_extent		*extp)
 {
-	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			end;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, extp->ext_start));
-	if (startblock_fsb == 0 ||
-	    extp->ext_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    extp->ext_len >= mp->m_sb.sb_agblocks)
+	if (extp->ext_start + extp->ext_len <= extp->ext_start)
+		return false;
+
+	end = extp->ext_start + extp->ext_len - 1;
+	if (!xfs_verify_fsbno(mp, extp->ext_start) ||
+	    !xfs_verify_fsbno(mp, end))
 		return false;
 
 	return true;

