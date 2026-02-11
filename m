Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB5D315D35
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770818164; cv=none; b=aGXasTgCkZoaH1ZAjNI1ria3Ci8JDCdW7Z8jm35zAKEf47ZXHpjv+TZF2LHVzStKWf2GVedqS/WX6TnbF2f2OFRkXfKJWjLxKPjA9PKI7Q/xRKohRidBtTmvz3mx3QhKSX0CrIs3IAm2ugsEbV1YuBgAVD7JjY2DW2IcqqOCbpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770818164; c=relaxed/simple;
	bh=zwLxfwHVPKl7eShpbswHQURRWP7TL0Fb9Rm0VlfJ604=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEfDoVwa86rdP6Z3KJXvPVUqjmEsk/ZFOhNFjE0Er49B891XybeRjCGbxnKih4cyFFLHLYA9LW9jHc9936OHdm+J8YM6jY2/3rsf8hY09yRF4Zrx3NAlJtq2blZn3Hi6g+z+OOYK9cF1X7+Nm3fDBQL0nQ2Xp9osgNtdiiS5SH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=auUY/VyN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="auUY/VyN"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BB8MWx3537614;
	Wed, 11 Feb 2026 13:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FTem5XsjNQH3nG7U5
	egQUYOM5YIJy9CKoH5s8m0NJwo=; b=auUY/VyNwv7bx0yz4WNsZc9192/bZh5/a
	2HtaOsmJINu69vPg7mh97nczq2hrxmjInpL0gaOb2FhskjFJvz2gVOWaPq8DHrmz
	UXbMqAOGAqGXbS3sk/K+GP9lS3hGV+zaEQNV5tLjdumcXnKSrDIT28nmMAgfCBCU
	iKqOCtTjtNMQxRiKR+3NRqCZqItXpSlu1zrMQ0p6o8sWa2VEetzNkfWfPj5EW7pV
	D34NdgtGRso2IHlEr5cS+EJehbX+Vh593vWb6l+KNAAu/QpnC3bNeNtHleYPkcoB
	hv/R011o2wbWpgQlapF/UDjKzMdMdkU2eZ/7Ogxw3gi1XMMc2VfLg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v6uyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 13:55:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BA3udk013013;
	Wed, 11 Feb 2026 13:55:56 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7kdvyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 13:55:56 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BDttN858458610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 13:55:55 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECC4B58060;
	Wed, 11 Feb 2026 13:55:54 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89B4F58056;
	Wed, 11 Feb 2026 13:55:52 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.20.201])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 13:55:52 +0000 (GMT)
From: nirjhar@linux.ibm.com
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com
Subject: [PATCH v2 2/2] xfs: Replace &rtg->rtg_group with rtg_group()
Date: Wed, 11 Feb 2026 19:25:14 +0530
Message-ID: <d7a3281a7172f15498bb6f2d91afb7a269c0d5b6.1770817711.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: VbOusfv_TmKBR8mSHWPrN3BEokWAxTbt
X-Proofpoint-ORIG-GUID: 4_l2tZuQHik-7pOjZ2cadHwCRFpeR6cI
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698c8a6c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=805WVEJ56RaaM9acf4MA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX+T8J8Clx7APT
 dJ2y9tKIwThJDTXNQGMzIRYu6rvMlmVguQUBmdv3yvsChffXrQwuoAjZdXk6+7DX1DTTlhgPpqD
 xFsAmqRPt9A6lxAW6TMSnuR/54KWF/Xn+4fIaHP8h+vturcpuiEK3JiQP4yPqR+9f0sI5sTUJST
 HRtqbpPs9xsHMLsZwKTkbnGnyzYSNlSTITCA2KoRFngo3teBO6zKqIWajXN4tKJKDjEWXWZqdsw
 wHgNadrBIpfegQBaxsU8SAHyMhaaT9URPNv4qB25WgUcjbPaxcSywCj8iRoLTML4w/iwGa4Ki6m
 DL0d9BsjSN7NxTMQcVSec0pPGF+BxmYllkZ6NwNgN+XjPbQYCv/fCuq11iVql5VDhBdQ6fmOj3d
 TwAnTVSY1XCFpgKiqzXOkoxKrV501oOdW4qnFDuqtlQ94IwMfni1V3rYqX+ts6y61y+HwATqR1y
 9OC2RM6ZXp6FqSPAk8w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110107

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Use the already existing rtg_group() wrapper instead of directly
accessing the struct xfs_group member in struct xfs_rtgroup.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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

