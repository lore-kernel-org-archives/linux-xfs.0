Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C67C10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 21:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 597A4208D5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 21:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vek9lgrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgCXVKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 17:10:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33448 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgCXVKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 17:10:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OL97m0102205;
        Tue, 24 Mar 2020 21:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Lo2If3BXS1K7iBn3Z4rYRlqmNQgr9hhqb7oSCvorGY0=;
 b=Vek9lgrMf3oFK191Fxon5Sr9/ui7HIpA4pDf9imTEMwfQX1yI5rLDJ3XDp4EGG4AFL87
 L1cks5hNlx+q4MHvV1FNV50FFtyvq54ZsKuWQbylhLSj0pq45rRad8yOM0t3f/nXsPh5
 NjTd/cSQZk6+mY2qTS//3UZJNFqLvTBvn1tyxxTTwgRrTH/In0lOZ4F3q5azb85P0ggh
 MIDUjm//lrfYwGpsr++XgUpssn/gudOPNESqdPUSCDCd7I3lfP2l2WF1944TBhivirJv
 ++IgulPO/PpIDhLJDPF9gIv5eEEhavxNX5oG7EQDHTMNf4ddBrXKOdwDgCJDXYIAFOD+ Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ywavm6pt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 21:09:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OL8R9t076571;
        Tue, 24 Mar 2020 21:09:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yxw4q27sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 21:09:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OL9vfA018957;
        Tue, 24 Mar 2020 21:09:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 14:09:57 -0700
Date:   Tue, 24 Mar 2020 14:09:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: clean up the salvage read callsites in set_cur()
Message-ID: <20200324210956.GS29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clean up the LIBXFS_READBUF_SALVAGE call sites in set_cur so that we
use the return value directly instead of scraping it out later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/io.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/db/io.c b/db/io.c
index 384e4c0f..6628d061 100644
--- a/db/io.c
+++ b/db/io.c
@@ -516,6 +516,7 @@ set_cur(
 	xfs_ino_t	ino;
 	uint16_t	mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
+	int		error;
 
 	if (iocur_sp < 0) {
 		dbprintf(_("set_cur no stack element to set\n"));
@@ -542,20 +543,21 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
-				LIBXFS_READBUF_SALVAGE, &bp, ops);
+		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
+				ops);
 	} else {
-		libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
 
 	/*
-	 * Keep the buffer even if the verifier says it is corrupted.
-	 * We're a diagnostic tool, after all.
+	 * Salvage mode means that we still get a buffer even if the verifier
+	 * says the metadata is corrupt.  Therefore, the only errors we should
+	 * get are for IO errors or runtime errors.
 	 */
-	if (!bp || (bp->b_error && bp->b_error != -EFSCORRUPTED &&
-				   bp->b_error != -EFSBADCRC))
+	if (error)
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;
