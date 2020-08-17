Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D933BC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B56172063A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JZQwn9in"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgHQW6X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:58:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgHQW6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:58:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuvvP136130;
        Mon, 17 Aug 2020 22:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=urbrMZchH55rMFt5lBaVBoMVYWpITr0s0Jkc9XBlQ2g=;
 b=JZQwn9in+/WNHf7G1ROVNatbvg5Im7/gOmqMMm8lAf+js4c2L69t3WRDbyO0scU1226V
 9/W5obpTDq+Cs2dV8PQVV8EsLt0qmfte+0eqks670VIiwgLogFrnj2csY9Lzs2CcgTxE
 Y6VVLxOoeBz9baCA6sVXTu+oJ0ekTl860a8noM2K37Qk3TCR/BN0SCsL29moS0ScgZWJ
 RXZvwMaH7S5indP67tx7UPlJO/0ScdEvz4RCtieibYGzULma1e44j/TsK6gjOuwM7S+v
 nLCwLWYob2QF0/dxUKZi4IKurCYSQ3ovXOUkEdmfZQnWrR50OOsJHrmM6rlPcznIYEy9 eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn1fwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:58:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjX1113882;
        Mon, 17 Aug 2020 22:58:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32xsm18nu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMwJsM024972;
        Mon, 17 Aug 2020 22:58:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:19 -0700
Subject: [PATCH 2/7] xfs_db: support displaying inode btree block counts in
 AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:18 -0700
Message-ID: <159770509823.3958545.13621703734425302407.stgit@magnolia>
In-Reply-To: <159770508586.3958545.417872750558976156.stgit@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=2 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix up xfs_db to support displaying the btree block counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/agi.c |    2 ++
 db/sb.c  |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/db/agi.c b/db/agi.c
index bf21b2d40f04..cfb4f7b8528a 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -48,6 +48,8 @@ const field_t	agi_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_FINOBT },
 	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
+	{ "ino_blocks", FLDT_UINT32D, OI(OFF(iblocks)), C1, 0, TYP_NONE },
+	{ "fino_blocks", FLDT_UINT32D, OI(OFF(fblocks)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 8a303422b427..e3b1fe0b2e6e 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -687,6 +687,8 @@ version_string(
 		strcat(s, ",RMAPBT");
 	if (xfs_sb_version_hasreflink(sbp))
 		strcat(s, ",REFLINK");
+	if (xfs_sb_version_hasinobtcounts(sbp))
+		strcat(s, ",INOBTCNT");
 	return s;
 }
 

