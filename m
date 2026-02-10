Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6547021CA0D
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726438; cv=none; b=MiuYgCfHZPZX98WvhMEnm2TKSpnWvj/lBI5cBH43oGYlN3bLQ6svEWJhAOtYKO8GEXEvxDuq/JRquzcgXoK2L+SID9/Pc5t9xMMu82UiVRRataDgmmaDJlsP9i+kOyQ79RnIVFeTx9A254f1xxBzvLNx6YUSdMkns9pL8wCODfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726438; c=relaxed/simple;
	bh=52d6tZWRIxHwagluBO3Jj+e3RA25Wm94EQp9bm60vcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kr9+ChYhKvFqStfaJCmgpxORLHk4RFURn2jyf5O8B81r1qHNMDLrjIQQO2l2kNPvvHcEpvr3tWhT8mI2hvuOihSjo3Pm+wj3fVKkYSfo6XfyrJpq0wgR9DcEGmQFvkOHh+vMyD/vaN8ypvnT0iUNdBEOnPnYBgTFeQrfwDB5l/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WW97vVu8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WW97vVu8"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A1KbdJ3125577;
	Tue, 10 Feb 2026 12:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vVrAgAJz4/sqRCasS
	IfxiiRN0Bzj9FA5pdIM9tEGniM=; b=WW97vVu8W4+Mrk2A+3iejXAmaUIPGd5M3
	OP/rfjjU/wCfIlM+HF5Zv0KuvxHP6KDqJHoAZ8Ieu9xD0jHCllE5AGWeLPmifmMZ
	oDl5t527TRRNIdouYwKoq1yPrXCegpES7S6JkNLw3KhuAMVxSw/u8ZkmHAjuQB5o
	8rd/G6GWdMvr++mv+fq5PJNy0On6tqjoS0CrOMHAsmc8A8oB0FEDMSnTvizrlsZi
	sBbqmOy+YXRQE2VjDlXrFqlXd+XltuHHfNc6Rh6qWh14LFxlxgpBDA8JgynnlRWh
	SGPRbOh8Hk8NPxeuyHzmaKrpku4uJ93fFVRUB1jhdvSKogzaDgMIw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wt20h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 12:27:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABWqBW001825;
	Tue, 10 Feb 2026 12:27:10 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je20x0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 12:27:10 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61ACR9HX15729338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 12:27:09 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97DF85805A;
	Tue, 10 Feb 2026 12:27:09 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DC1058054;
	Tue, 10 Feb 2026 12:27:07 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.3])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 12:27:06 +0000 (GMT)
From: nirjhar@linux.ibm.com
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
        hch@infradead.org, cem@kernel.org, nirjhar.roy.lists@gmail.com
Subject: [patch v1 2/2] xfs: Replace &rtg->rtg_group with rtg_group()
Date: Tue, 10 Feb 2026 17:56:35 +0530
Message-ID: <3234d5a2693e1c18c2e3d34fc45d59118d503b67.1770725429.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698b241f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=805WVEJ56RaaM9acf4MA:9
X-Proofpoint-GUID: xsuIFFdqxrX3iQtmix_WT3ztQjeei5CK
X-Proofpoint-ORIG-GUID: LxCmPuyTUJdZ57VIJfRAvtsR7rT5QsBu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEwMyBTYWx0ZWRfX5bWqIimcluGU
 Isom8AqOOp+FeHnKf7OGBnGE3en5NkiIV9rxmtC3J/oOiGRpujqNgeOm3UKEr8KNSuLnhCLBocQ
 s072prFZEDPPqh+hErdfgfngZJ8+BWB5uEIskrEh+v7ddP9zV7uWWIxtRSdeRoNSvp5eIsMmoBo
 i+O4VaW0wjx8d8OZxmn6Dz8NBJ4dhKS6RI/wA72TGmvMK03LxezCxftIa0kjSECM7OgZtr6wONB
 GQXwnhEK7E/QNeu3t4qC2Q1KIXylT73xTsOekeCp8slXIINhYN3BvJ4EsD2ULlBxfamBBjAUejh
 WPlcG+eUT71prVtVQ4+Wd2Ktz4BUhU96fPMzQ5W/Qdt8AVU8xglP1c5Rk9Ztfez0d1S5zeCbWsw
 /hMACCTRaLLS4vJ2V7ncMYE7bW7mq9QQQtV1J6QjscMfyM3gmzaeEetofnseU/fryemzDZkqPrG
 +7HCulJKQnlEpcWL31g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100103

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Use the already existing rtg_group() wrapper instead of
directly accessing the struct xfs_group member in
struct xfs_rtgroup.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_zone_alloc.c |  6 +++---
 fs/xfs/xfs_zone_gc.c    | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bbcf21704ea0..4c514c423448 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -78,7 +78,7 @@ xfs_zone_account_reclaimable(
 	struct xfs_rtgroup	*rtg,
 	uint32_t		freed)
 {
-	struct xfs_group	*xg = &rtg->rtg_group;
+	struct xfs_group	*xg = rtg_group(rtg);
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
@@ -772,7 +772,7 @@ xfs_zone_alloc_blocks(
 
 	trace_xfs_zone_alloc_blocks(oz, allocated, count_fsb);
 
-	*sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
+	*sector = xfs_gbno_to_daddr(rtg_group(rtg), 0);
 	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *sector);
 	if (!*is_seq)
 		*sector += XFS_FSB_TO_BB(mp, allocated);
@@ -1033,7 +1033,7 @@ xfs_init_zone(
 	if (write_pointer == 0) {
 		/* zone is empty */
 		atomic_inc(&zi->zi_nr_free_zones);
-		xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
+		xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
 		iz->available += rtg_blocks(rtg);
 	} else if (write_pointer < rtg_blocks(rtg)) {
 		/* zone is open */
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 3c52cc1497d4..5f5cc3e0e068 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -655,7 +655,7 @@ xfs_zone_gc_alloc_blocks(
 	if (!*count_fsb)
 		return NULL;
 
-	*daddr = xfs_gbno_to_daddr(&oz->oz_rtg->rtg_group, 0);
+	*daddr = xfs_gbno_to_daddr(rtg_group(oz->oz_rtg), 0);
 	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
 	if (!*is_seq)
 		*daddr += XFS_FSB_TO_BB(mp, oz->oz_allocated);
@@ -705,7 +705,7 @@ xfs_zone_gc_start_chunk(
 	chunk->data = data;
 	chunk->oz = oz;
 	chunk->victim_rtg = iter->victim_rtg;
-	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
+	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
 	atomic_inc(&chunk->victim_rtg->rtg_gccount);
 
 	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
@@ -792,7 +792,7 @@ xfs_zone_gc_split_write(
 	atomic_inc(&chunk->oz->oz_ref);
 
 	split_chunk->victim_rtg = chunk->victim_rtg;
-	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
+	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
 	atomic_inc(&chunk->victim_rtg->rtg_gccount);
 
 	chunk->offset += split_len;
@@ -895,7 +895,7 @@ xfs_zone_gc_finish_reset(
 		goto out;
 	}
 
-	xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
+	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
 	atomic_inc(&zi->zi_nr_free_zones);
 
 	xfs_zoned_add_available(mp, rtg_blocks(rtg));
@@ -914,7 +914,7 @@ xfs_zone_gc_prepare_reset(
 	trace_xfs_zone_reset(rtg);
 
 	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
-	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
+	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(rtg_group(rtg), 0);
 	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
 		if (!bdev_max_discard_sectors(bio->bi_bdev))
 			return false;
-- 
2.43.5

