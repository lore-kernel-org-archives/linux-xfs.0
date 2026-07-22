Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D9B33FE33;
	Wed, 22 Jul 2026 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727553; cv=none; b=OHvFWzJbw0QSRiy4nLElyX90D+Ryj2zlVbM3ohBVV83nkj+JvW1FypPqvOK5qQMTdakAKdT3H6xhM0/rBOvPH4c3PhG6VL3sthjhGheDxjh+ro4Q1KNaQMxvOk0PAa32i3c4v29gZfLuKM2EM37r8emj1Wk8x3NmHFVh+xHF+/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727553; c=relaxed/simple;
	bh=sDd1FAahTF+OGNnEMWZmO3aNcMXP0d9FSmALXAJh7Oc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N1BdVIX3v1h3uXyRLR6anRpf9rkYC1HXAGBWbhlfveZCIVKYV9+RUKtLCP2kGJvsxSag3SQT89HKEkZPiZ+J+oRc1pdy+Y3juCFQDP/R+BD6fxLvdtoLkgzdwQLwlYVRgGcJ2yLEQc3vPxDJ96o7BRxizD9iubNbucjiuJZb+mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=unknown smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=fJnE5fWB; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="fJnE5fWB"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MD0MTc875842;
	Wed, 22 Jul 2026 13:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=7LQdZxLtG
	2RfhEbUwtHRz/kQebXRISLmz8e6oRjqlos=; b=fJnE5fWBudUolEntnoUBa+kz0
	r39bHhLpaRVHPX9hI3dMkbUut0OT4PfXyNUnM8mN40L4v6nnN17B0rIE9muIj0n7
	IRaLBRM547xTm3N/V9t/uzdYrsOp3pUJnHlyD4UCxOFAJYwH69Oz6HjxPUp9I/OZ
	OfHqAjqq+Q2ENq6SBWDRHG8md87NMCoXEBVum1uJZgpBakwhsunBZKoCZV0pA4x2
	s+4L7uBWkhusedjjIumDmjoX1P64+0s6G/1Xj7Ts9WeC6WCqpO3Qxc0RTedaV6OG
	jEyg7oEU/Xy7JzLRm99aklxCK3Fj+dEuV8r8TUHJAz1+Ip0VBqR/N7FzB8Ebw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg0f5g998-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Jul 2026 13:38:48 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Wed, 22 Jul 2026 06:38:46 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Wed, 22 Jul 2026 06:38:45 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Wed, 22 Jul 2026 21:38:44 +0800
Message-ID: <20260722133844.2900030-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDEzMiBTYWx0ZWRfX5l+DvTq6PRLR
 XQ5fUjH3RG6ePudCbsoPNfxtgtC7Xqja0CVlARglKYcU7ezHg2+C7on27M5+MgkW5PCpHWqyxuX
 VVZsIbeSGJFJhTItVeKR87FalFWb5ZaIeASToRI2gBYWVzhP1GTdtdiBB0/YeogVRjoBfqYvzvV
 KxuhGhHlAAqH2hL8KSEdnRJ4U9bii+TgAizDm0ejQF1yu75GygFBDBR8h5jursbqu1STKDkPaUh
 arZu/4njFST3xw2w4KYdP9SHjUaeebj0VRzkRr3x/uFTmiDTME9GHuHXAhUT6PseCMwj9POHT88
 UEgbA59+t4l3JGOl4nMbr6IaPU7C9oiJeuL0PkLvM13CV0EU8GUiat2U9m2HGfBJYX0CNnXSqFk
 SjRmP3PdzT+0qBCWgBi2CTYnEdWoniJ4jG7XWsCRXJ8e3UgMEsSrvxctFotAym0sxs1wcjZ+X6Q
 A/bwZgFb+LENEs3PgFg==
X-Proofpoint-GUID: k_LHlGrkHapBBNvR48JO4VbraURwQ2tn
X-Proofpoint-ORIG-GUID: k_LHlGrkHapBBNvR48JO4VbraURwQ2tn
X-Authority-Analysis: v=2.4 cv=IM0yzAvG c=1 sm=1 tr=0 ts=6a60c7e8 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=tUtbpdhI3CECM1wNtOsA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDEzMiBTYWx0ZWRfX0OWaff1zzeRz
 nHuZm/s6Z2Kuz0v1ZAe8/ArIWKAbHEp6irNDPAbXOLsOTKw23hRBlNVMT5Wo6Z4mtW2qRSqR8Ey
 fQwlUR/4avdoBWCXPiib8jZkNDbtJiHYfkaAGBg4gw5/2wqDJpql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_04,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220132

xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
xfs_trans_commit(), which flushes the CIL push workqueue internally.
If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
lock these buffers to fail them, causing a deadlock:

  setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
  CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)

Remove the xfs_trans_bhold() calls so that commit releases the buffer
locks normally.  After the sync commit, re-acquire the buffers via
mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
Changes in v2:
- Remove the bp variable and pass xfs_trans_getsb(tp) directly to
  xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
- Convert xfs_log_rtsb() stub from macro to inline function to avoid
  the need for (void) casting (Christoph).
---
 fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
 fs/xfs/libxfs/xfs_sb.c      | 39 ++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index c0b9f9f2c413..fca2eb74908c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 # define xfs_update_rtsb(bp, sb_bp)	((void)0)
-# define xfs_log_rtsb(tp, sb_bp)	(NULL)
+static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
+		const struct xfs_buf *sb_bp)
+{
+	return NULL;
+}
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7690..929677ad95b4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1470,36 +1470,35 @@ xfs_sync_sb_buf(
 	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
-	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
-	if (update_rtsb) {
-		rtsb_bp = xfs_log_rtsb(tp, bp);
-		if (rtsb_bp)
-			xfs_trans_bhold(tp, rtsb_bp);
-	}
+	if (update_rtsb)
+		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto out;
-	/*
-	 * write out the sb buffer to get the changes to disk
-	 */
-	error = xfs_bwrite(bp);
-	if (!error && rtsb_bp)
-		error = xfs_bwrite(rtsb_bp);
-out:
-	if (rtsb_bp)
-		xfs_buf_relse(rtsb_bp);
-	xfs_buf_relse(bp);
+		return error;
+
+	/* Re-acquire and write the sb and rtsb to disk. */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_hold(mp->m_sb_bp);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_relse(mp->m_sb_bp);
+	if (error)
+		return error;
+
+	if (update_rtsb && mp->m_rtsb_bp) {
+		xfs_buf_lock(mp->m_rtsb_bp);
+		xfs_buf_hold(mp->m_rtsb_bp);
+		error = xfs_bwrite(mp->m_rtsb_bp);
+		xfs_buf_relse(mp->m_rtsb_bp);
+	}
+
 	return error;
 }
 
-- 
2.43.0

