Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EFDC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D28120809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L2x69u4I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407090AbgJZXfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406419AbgJZXfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPLiW158051;
        Mon, 26 Oct 2020 23:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=urbrMZchH55rMFt5lBaVBoMVYWpITr0s0Jkc9XBlQ2g=;
 b=L2x69u4IaIXPkysCPhKwR601VLYHCowOTWLROtrDm80vAnrVXQkC3A1u6dNCZTQUFEW1
 aefSJdTKYcVBlf+bwGoZbFa3WrZJqVMre16Yef2SYinTaSS2+KV4CXrcaSW9MVu6s9J0
 ty5aOHJb84Ev7PtUHFg7xOgJoFOVTGv6rSvKMSpYfM+q4KQm/zWFYf0oHGR2lDV8BlEx
 WlK3mDTVC7E2XLuLhJzhiz1IiFRoFzdqRYTr3S50EsYA77n+IXsep4LqcOT6W9LkZFcZ
 70soE9n7XWDP6yfixZMmM2dgdGQoXhc9LlmSlGgzOyV377IlwyfI2jklnQIfCqpHScar Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQOrd058479;
        Mon, 26 Oct 2020 23:33:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr83r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:40 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXdfo007141;
        Mon, 26 Oct 2020 23:33:39 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:32 -0700
Subject: [PATCH 4/9] xfs_db: support displaying inode btree block counts in
 AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:31 -0700
Message-ID: <160375521177.880355.5574700800853381205.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
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
 

