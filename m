Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F21C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18184206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YW/EHLnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFBE3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:29:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgFBE3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524GvGD106525;
        Tue, 2 Jun 2020 04:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KJZzEwctKaE+IzYXEBAXzxTx1R5uomN41GZbLM6VwmI=;
 b=YW/EHLnDYdSm7O6cfoUwbjlo1XPw/93BXdGbQBPJSGGTlt5bfLhFlbZt9sFZBow6fYQt
 CulprSqMeznchLkG4foCyuqEa8Irp+xi95rNoHTmJXuHPFpyb4dg8MkfmD0sH/MPyw3d
 MdRAjBjhklHNQvVMLXU/T4lt6B15jD4tbwIcoHpbmH/ct+8GDy7GvTEjIZ9VHPuwSBS0
 gATH50b5n2RLo90d8yHm85Qa5I0gP60TZDMyuVwTFd91GzUbAcs3R0kVs52M4a0sBeMx
 Env2kiSZLXwfne4/1i2WAISnN0Fr7OTAzS/v0MDxJWeNaSA7jjaZ6JvRyUQooBU2XRAp yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem1tc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HuhQ126583;
        Tue, 2 Jun 2020 04:25:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25mng7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:48 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524Pl3v019672;
        Tue, 2 Jun 2020 04:25:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:47 -0700
Subject: [PATCH 07/17] xfs_repair: fix rmapbt record order check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:46 -0700
Message-ID: <159107194648.313760.17092174816202906919.stgit@magnolia>
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

The rmapbt record order checks here don't quite work properly.  For
non-shared filesystems, we fail to check that the startblock of the nth
record comes entirely after the previous record.

However, for filesystems with shared blocks (reflink) we correctly check
that the startblock/owner/offset of the nth record comes after the
previous one.

Therefore, make the reflink fs checks use "laststartblock" to preserve
that functionality while making the non-reflink fs checks use
"lastblock" to fix the problem outlined above.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 7c46ab89..7508f7e8 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -925,15 +925,15 @@ struct rmap_priv {
 static bool
 rmap_in_order(
 	xfs_agblock_t	b,
-	xfs_agblock_t	lastblock,
+	xfs_agblock_t	laststartblock,
 	uint64_t	owner,
 	uint64_t	lastowner,
 	uint64_t	offset,
 	uint64_t	lastoffset)
 {
-	if (b > lastblock)
+	if (b > laststartblock)
 		return true;
-	else if (b < lastblock)
+	else if (b < laststartblock)
 		return false;
 
 	if (owner > lastowner)
@@ -964,6 +964,7 @@ scan_rmapbt(
 	int			hdr_errors = 0;
 	int			numrecs;
 	int			state;
+	xfs_agblock_t		laststartblock = 0;
 	xfs_agblock_t		lastblock = 0;
 	uint64_t		lastowner = 0;
 	uint64_t		lastoffset = 0;
@@ -1101,14 +1102,15 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			/* Check for out of order records. */
 			if (i == 0) {
 advance:
-				lastblock = b;
+				laststartblock = b;
+				lastblock = end - 1;
 				lastowner = owner;
 				lastoffset = offset;
 			} else {
 				bool bad;
 
 				if (xfs_sb_version_hasreflink(&mp->m_sb))
-					bad = !rmap_in_order(b, lastblock,
+					bad = !rmap_in_order(b, laststartblock,
 							owner, lastowner,
 							offset, lastoffset);
 				else

