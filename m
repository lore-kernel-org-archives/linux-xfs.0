Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0024C5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE7742173B
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l7g+ffSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfKFEoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:44:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfKFEoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 23:44:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i8HA078441;
        Wed, 6 Nov 2019 04:44:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9OdNinNJ7DNtRfWC2HFWqKGc9Pft7kDNZx+7+SHneSw=;
 b=l7g+ffSh6JyV7hj3kQmGzw8SmGJfKD5XWKLpidZYsFKPIUtC6JZ+Hgz7Zn9TNQGJZDdd
 lC0I6vr2AjTGPrjKYUmtR9ITmHhm59uLjXnDIp0SepwMvWnDANE0gthG2VEMVVKkisN8
 hMKRTQEaC0tFStd1cxrXP5mwpZ8TrzhMZYKyYI8eL4pol/RK6OefKvAx4k/+QESIeNJp
 +3XUfrxqf4kCeHVbpsWBzh8SczrOhMdrRFXi4q88FzYwTPIHGv/ZoZG7cQ+6v9mVr5lk
 0otZnLK2zulWNFrBX9FT/ZeVnUiTfLiM0sGr/fbM48h48CRFRJFhST2Ge/fW2RacHVCR ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12eraxt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:44:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i45G033825;
        Wed, 6 Nov 2019 04:44:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w35pq7bsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:44:05 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA64h0ls031424;
        Wed, 6 Nov 2019 04:43:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:43:00 -0800
Subject: [PATCH 1/2] xfs: add missing early termination checks to record
 scrubbing functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 05 Nov 2019 20:43:00 -0800
Message-ID: <157301538007.678524.17905821115324746213.stgit@magnolia>
In-Reply-To: <157301537390.678524.16085197974806955970.stgit@magnolia>
References: <157301537390.678524.16085197974806955970.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrubbing directories, quotas, and fs counters all involve iterating
some collection of metadata items.  The per-item scrub functions for
these three are missing some of the components they need to be able to
check for a fatal signal and terminate early.

Per-item scrub functions need to call xchk_should_terminate to look for
fatal signals, and they need to check the scrub context's corruption
flag because there's no point in continuing a scan once we've decided
the data structure is bad.  Add both of these where missing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir.c        |    3 +++
 fs/xfs/scrub/fscounters.c |    8 ++++++--
 fs/xfs/scrub/quota.c      |    7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1e2e11721eb9..dca5f159f82a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -113,6 +113,9 @@ xchk_dir_actor(
 	offset = xfs_dir2_db_to_da(mp->m_dir_geo,
 			xfs_dir2_dataptr_to_db(mp->m_dir_geo, pos));
 
+	if (xchk_should_terminate(sdc->sc, &error))
+		return error;
+
 	/* Does this inode number make sense? */
 	if (!xfs_verify_dir_ino(mp, ino)) {
 		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 98f82d7c8b40..7251c66a82c9 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -104,7 +104,7 @@ xchk_fscount_warmup(
 		pag = NULL;
 		error = 0;
 
-		if (fatal_signal_pending(current))
+		if (xchk_should_terminate(sc, &error))
 			break;
 	}
 
@@ -163,6 +163,7 @@ xchk_fscount_aggregate_agcounts(
 	uint64_t		delayed;
 	xfs_agnumber_t		agno;
 	int			tries = 8;
+	int			error = 0;
 
 retry:
 	fsc->icount = 0;
@@ -196,10 +197,13 @@ xchk_fscount_aggregate_agcounts(
 
 		xfs_perag_put(pag);
 
-		if (fatal_signal_pending(current))
+		if (xchk_should_terminate(sc, &error))
 			break;
 	}
 
+	if (error)
+		return error;
+
 	/*
 	 * The global incore space reservation is taken from the incore
 	 * counters, so leave that out of the computation.
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 0a33b4421c32..905a34558361 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -93,6 +93,10 @@ xchk_quota_item(
 	unsigned long long	rcount;
 	xfs_ino_t		fs_icount;
 	xfs_dqid_t		id = be32_to_cpu(d->d_id);
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have
@@ -178,6 +182,9 @@ xchk_quota_item(
 	if (id != 0 && rhard != 0 && rcount > rhard)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return -EFSCORRUPTED;
+
 	return 0;
 }
 

