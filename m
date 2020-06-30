Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E357C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E074F2074F
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OGVjPuzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389630AbgF3Plv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:41:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389628AbgF3Plv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:41:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFRHEZ011593
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MCOfG6KhlxKxCJ8AaKD2KyFBWgp85YGIGTk90OGvvUU=;
 b=OGVjPuzfm8ZoDn4UmdJmChPk2RubpJHlowiODeklF8z1qEt0jZroEFxy67xUQ4HxXZoX
 e7IE80hCeqnnG4AemOksP1q0zSIOVro4C4gl98K+HmGFm1eFf/2/67nqefP5HSeC6Z/K
 4ePG70dZuVLv/tS7SKgFOgkMwjWquE8Ykez/u6MH6oQ06Hu/484KGU/QGXUyRsemaNLO
 Cif42jYU4mo4D9rxyDV4YPCuEKl6hn1dLfuLqsecicPVGGcnjZ9s0SUzKUiKCGiMRRqG
 vxD4EVtpR6C1dh7Y06adJ9VzeRN77JSaWZdGWGktnumIXmSQEIdjz3B6KOdJ4OjbLa4+ 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1dt5xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFMah6165991
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52j3464-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFfmt6000468
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:41:48 +0000
Subject: [PATCH 2/2] xfs: rtbitmap scrubber should check inode size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:41:47 -0700
Message-ID: <159353170715.2864648.7793153787081876108.stgit@magnolia>
In-Reply-To: <159353169466.2864648.10518851810473831328.stgit@magnolia>
References: <159353169466.2864648.10518851810473831328.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the rtbitmap is large enough to store the entire bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c777c98c50c3..76e4ffe0315b 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -101,6 +101,13 @@ xchk_rtbitmap(
 {
 	int			error;
 
+	/* Is the size of the rtbitmap correct? */
+	if (sc->mp->m_rbmip->i_d.di_size !=
+	    XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks)) {
+		xchk_ino_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
+		return 0;
+	}
+
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))

