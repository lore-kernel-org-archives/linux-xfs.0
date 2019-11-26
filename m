Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AF5C432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 16:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD392073F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 16:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sHC2Btfs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfKZQRW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:17:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbfKZQRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 11:17:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQFxFjE108493
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 16:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=iMTnb4xVEBGGuJVUjA6DIndsS5En/pKeInlangWRRNM=;
 b=sHC2Btfs458bl1pz6cb4KYJ/K+7tjEHTXlDKwKSRwDpBbVYR5I2GBFjkBzSSPdSms9QE
 4jqzuGSs2FIYopMnw2sSat0dCp3evJ74kscEcJij+rgjTY3J02Lf4RyrAzdyHG29IMsi
 /KMXjGf9Q7hEpByQOL6jDkWKTRo6hb79Y1a2oS4pzIBFDx2dwuzxUlE+cK87Qe4r132u
 9xeiA26MkzN0klgMSunBHaLJUfbLz3Aa3gghgupnAMyakWXXed/LnQYPyCcQuJj++gvu
 4qNP1Fr2mlhb3AIrxM9sdRVEENDFfSF8tr6T7MrA7kav9nRc5prk+y3uklrbBLSXLZE9 iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wewdr7tgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 16:17:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQFxDJr107995
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 16:15:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wgvfjs6gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 16:15:19 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAQGFIhw031922
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 16:15:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 08:15:18 -0800
Date:   Tue, 26 Nov 2019 08:15:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: allow parent directory scans to be interrupted with
 fatal signals
Message-ID: <20191126161517.GO6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Allow a fatal signal to interrupt us when we're scanning a directory to
verify a parent pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/parent.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 17100a83e23e..5705adc43a75 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -32,8 +32,10 @@ xchk_setup_parent(
 
 struct xchk_parent_ctx {
 	struct dir_context	dc;
+	struct xfs_scrub	*sc;
 	xfs_ino_t		ino;
 	xfs_nlink_t		nlink;
+	bool			cancelled;
 };
 
 /* Look for a single entry in a directory pointing to an inode. */
@@ -47,11 +49,21 @@ xchk_parent_actor(
 	unsigned		type)
 {
 	struct xchk_parent_ctx	*spc;
+	int			error = 0;
 
 	spc = container_of(dc, struct xchk_parent_ctx, dc);
 	if (spc->ino == ino)
 		spc->nlink++;
-	return 0;
+
+	/*
+	 * If we're facing a fatal signal, bail out.  Store the cancellation
+	 * status separately because the VFS readdir code squashes error codes
+	 * into short directory reads.
+	 */
+	if (xchk_should_terminate(spc->sc, &error))
+		spc->cancelled = true;
+
+	return error;
 }
 
 /* Count the number of dentries in the parent dir that point to this inode. */
@@ -62,10 +74,9 @@ xchk_parent_count_parent_dentries(
 	xfs_nlink_t		*nlink)
 {
 	struct xchk_parent_ctx	spc = {
-		.dc.actor = xchk_parent_actor,
-		.dc.pos = 0,
-		.ino = sc->ip->i_ino,
-		.nlink = 0,
+		.dc.actor	= xchk_parent_actor,
+		.ino		= sc->ip->i_ino,
+		.sc		= sc,
 	};
 	size_t			bufsize;
 	loff_t			oldpos;
@@ -97,6 +108,10 @@ xchk_parent_count_parent_dentries(
 		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
 		if (error)
 			goto out;
+		if (spc.cancelled) {
+			error = -EAGAIN;
+			goto out;
+		}
 		if (oldpos == spc.dc.pos)
 			break;
 		oldpos = spc.dc.pos;
