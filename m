Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5524A3446A7;
	Fri, 31 Jul 2026 03:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785467448; cv=none; b=Ni91yvAYxIHYb8ECtnPUV3UateGfgVpylGppCCAVu41XpADqc4BLBcubu2uhymGx/HFhxpZHHvxo+j457B4qHpqwXL9x9Vwvn+ZQUDiggjIkHczys8fzqP01D20hUO98ObNrn15i19lxMU1NtzobUXRV+FnWuc/oHXD7WYYw5C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785467448; c=relaxed/simple;
	bh=ppi4/rkpeC+fL/XrP7ArX0Vb8l4Uy5mFOAwPcLz6zAE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JPp+7bPcQGQq6p/4sFf9eF2+MTKDKopaSgb5mUwDDXqaLZP5JR1txQnTVe1HS0E4GHX3/G6E9q0Tpiwa1/iTK/5qRNSx+yfyjmvetPwLspdDqrn9dtXgQnulgPrVS3kVKumxZ63jwgoF44VAf2siiZ9YKBPYEvWOOxZqk/4glMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=unknown smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=KwZUoOFm; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="KwZUoOFm"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V1vqZS1018390;
	Fri, 31 Jul 2026 03:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=u6EMZdHtS
	HP4AHCCoY/BPxettk9FLMyZ0YFVI5i7XWM=; b=KwZUoOFm/mJ5lM2T4QV2fRfDB
	URr4w2a2pm3wDVjC5OOApnAwOCA+la2sxDMlkGaK7qE//+qbwZm+rF1xg3HL7GdX
	L4ZdEP5IfPPiFMJAHDVv5r1fhbFqjxLWpLYiaYg4OYRhS2xInalfD7LS5SzJG1xA
	bdkvYaAtSJXnsT6o4IWHlZGTuOhLI8R51bms81I+FUKoMwVPvggswUVTmu//4MzI
	Dxekq96gzX925dVVfbphv8m1iP6IPbd+G+bEeX3FpG+LYFWtT5Z3b/J8+4vj01q+
	OETbHqevnYnKodD9DDFPGHyR//4jtcx2buUKafGmBa41tHt59Z2JgE31AphZg==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4frhsh0340-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 31 Jul 2026 03:10:13 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 30 Jul 2026 20:10:12 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 30 Jul 2026 20:10:11 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v3] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Fri, 31 Jul 2026 11:10:10 +0800
Message-ID: <20260731031010.2627884-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: j4U1ceR_PEVEEI4KQftyf4fX1wpnrBZW
X-Proofpoint-ORIG-GUID: j4U1ceR_PEVEEI4KQftyf4fX1wpnrBZW
X-Authority-Analysis: v=2.4 cv=Fvg1OWrq c=1 sm=1 tr=0 ts=6a6c1215 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8
 a=t7CeM3EgAAAA:8 a=tUtbpdhI3CECM1wNtOsA:9 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAxNyBTYWx0ZWRfX29s5PUwSEm7v
 3Doihpe8BBXIqBbYdD6iZ2vFKlqC3RG2MLHuOSSYMll75tWCA4jB9kyVq987Ch72AfnKT4hwwJ2
 HXCWlF6HxR9UhCq07btQdj/MTQvku2wmp9AOerJbVcxyf55wHNiTEhR3FBzcejP64mxv9f/z5Zx
 jp+pUM0KjIq9eImhRlUrYqNzFP5GzdWDKNOWM+fk4IeJdkEzknNHZQbf8M5OjYul0StoRx/91Es
 kfoVps84tkQij5zERz3uefZMxOC6EicOx8EjpWTdHUg9Gl8VFWlE+K4QXlIJg9723Z0jdmB1XD7
 Wiz8fefxTz/tHQ07lW4l0AQ+G8mXzDQDi+xZQ1yEkD6S8jwcrlOkpLQJDgtYiP0INU51Fu0Mfiz
 tsH3gp7v/BCNQ8X0lLWhOTt+/EZkhTj+K6Een3/HUs3v719nrKm7dJaJRRBHGOyDT/2T0xxYqFS
 Mh0NB4tdu1w/u27k9qA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAxNyBTYWx0ZWRfXzaS8+wjggI20
 g/SUtw3NFbZeB7B+XMimJKM+I91GFP6stG7r7hwfK6aFRZqMmjvOTT2ekaPMTXrgHxnfIs1zKpG
 v6JaUk9KWQgvgHQr/LUUUanSQg9sMBxGOv/uVemsKjZl36tBYxfA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310017

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
Cc: stable@vger.kernel.org
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v3:
 - Drop xfs_buf_hold/xfs_buf_relse, use lock/unlock directly (Christoph).

v2:
 - Remove the bp variable and pass xfs_trans_getsb(tp) directly to
   xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
 - Convert xfs_log_rtsb() stub from macro to inline function to avoid
   the need for (void) casting (Christoph).
---
 fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
 fs/xfs/libxfs/xfs_sb.c      | 37 +++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

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
index 47322adb7690..2664728f2d8f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1470,36 +1470,33 @@ xfs_sync_sb_buf(
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
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+	if (error)
+		return error;
+
+	if (update_rtsb && mp->m_rtsb_bp) {
+		xfs_buf_lock(mp->m_rtsb_bp);
+		error = xfs_bwrite(mp->m_rtsb_bp);
+		xfs_buf_unlock(mp->m_rtsb_bp);
+	}
+
 	return error;
 }
 
-- 
2.43.0

