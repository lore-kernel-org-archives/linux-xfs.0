Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBD1C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2CD2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k4htYjNh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgEIQai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:30:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:30:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRVQ8196372;
        Sat, 9 May 2020 16:30:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yLSkf1XjnC0SCOr9oGqevu2jBGt+Mo2b7FRJ5P0p0LM=;
 b=k4htYjNhAxtrh3nTRBrmNnRfunPq/fxKftMSpwhmsWT9gKH1yDFqveqf8Q6YohDkjZ8o
 OEQPMhB11LB9H2nzqAqcO5ds9k1U0ry0Y97y+BzC43cRTWzqXalQ3/xqvIjMkzXtHxfF
 i+hyznEBzJw0sWUBJpxXOzjKz2g4BCaCztB+fUi6bthSaKQ3lUpJgylXdS7Xs7c9sLdF
 eEhWXuHNkcOxYTnxfNqgrKB3B56FdDASxDDiAlm2987qkR8xkHr2JLVcmyl+asa1vzWc
 maX+sg2RJdHn/eyfq7j6UwBvMQnxfAIcO6maB6KWMlidcaRNQ+YVJueMfNRmx6TQjp4b 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30wmfm150m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTJrc097801;
        Sat, 9 May 2020 16:30:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30wx1857wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GUal6020499;
        Sat, 9 May 2020 16:30:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:35 -0700
Subject: [PATCH 06/16] xfs_repair: fix rmapbt record order check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:30 -0700
Message-ID: <158904183079.982941.15948246247495283555.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
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

