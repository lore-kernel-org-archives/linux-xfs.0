Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766DFC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1B7207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PzGeFeW3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406348AbgJZXcP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:32:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41270 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406297AbgJZXcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:32:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPwg7177218;
        Mon, 26 Oct 2020 23:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7UGFDoNAnO5qtszXy53gLFVdPZvrwxe7IrNeSFrFge8=;
 b=PzGeFeW3gPgZLt8I7KO5+RhJUWffNRQUUiqv5X+OpGogJLEWGGCTWTG3r6Dh7AWMYKrD
 uZyKV7jBnSpf2XYG5Rct4nP/u8l0nJY4sW8uFO9h3Xy//ckRiAR1b0UZS3Pz5ez7XdT+
 LZWQeuNS9byE269bjkgcBv8FMJmtNxDOHt1x/Voxwargs29XZpDRyK0oVIuNTqiIGMjS
 Hg7k45xdxnDYOk2NVdx++lPyksSfE4jftZw+9kZvx/LEAy6Lqsc5vO5DgzzQ8eNG1dF4
 qkAKmaB2k8Lpf2mE+6INQTqM9hG8Leeoa6FB2rfOmpLa98e6iZ87Ew1gSiP2l7piVY+X dQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saqctk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQN6e058335;
        Mon, 26 Oct 2020 23:32:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr73x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNWDrJ006563;
        Mon, 26 Oct 2020 23:32:13 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:12 -0700
Subject: [PATCH 3/5] xfs_db: report ranges of invalid rt blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:12 -0700
Message-ID: <160375513208.879169.14762082637245127153.stgit@magnolia>
In-Reply-To: <160375511371.879169.3659553317719857738.stgit@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Copy-pasta the block range reporting code from check_range into
check_rrange so that we don't flood stdout with a ton of low value
messages when a bit flips somewhere in rt metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)


diff --git a/db/check.c b/db/check.c
index 553249dc9a41..5aede6cca15c 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1569,19 +1569,46 @@ check_rootdir(void)
 	}
 }
 
+static inline void
+report_rrange(
+	xfs_rfsblock_t	low,
+	xfs_rfsblock_t	high)
+{
+	if (low == high)
+		dbprintf(_("rtblock %llu out of range\n"), low);
+	else
+		dbprintf(_("rtblocks %llu..%llu out of range\n"), low, high);
+}
+
 static int
 check_rrange(
 	xfs_rfsblock_t	bno,
 	xfs_extlen_t	len)
 {
 	xfs_extlen_t	i;
+	xfs_rfsblock_t	low = 0;
+	xfs_rfsblock_t	high = 0;
+	bool		valid_range = false;
+	int		cur, prev = 0;
 
 	if (bno + len - 1 >= mp->m_sb.sb_rblocks) {
 		for (i = 0; i < len; i++) {
-			if (!sflag || CHECK_BLIST(bno + i))
-				dbprintf(_("rtblock %llu out of range\n"),
-					bno + i);
+			cur = !sflag || CHECK_BLIST(bno + i) ? 1 : 0;
+			if (cur == 1 && prev == 0) {
+				low = high = bno + i;
+				valid_range = true;
+			} else if (cur == 0 && prev == 0) {
+				/* Do nothing */
+			} else if (cur == 0 && prev == 1) {
+				report_rrange(low, high);
+				valid_range = false;
+			} else if (cur == 1 && prev == 1) {
+				high = bno + i;
+			}
+			prev = cur;
 		}
+		if (valid_range)
+			report_rrange(low, high);
 		error++;
 		return 0;
 	}

