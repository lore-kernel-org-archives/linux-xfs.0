Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81F642E8E1;
	Mon, 13 Jul 2026 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783954222; cv=none; b=n+06+8V3+fzQ8YQpoh4FhO4ri3UCzITc8IKSntsJXI9zaR0f/p88okKdaHl2zoU6rt2DmB4W9A8tsQtaM6J7U5kwXhWF3Z9BcuZ4X2XAERqWyMx/h0t3Ffe7gxDnPCZzl38eiAcYswh80QNTdSMlr43XRsOa6tiHtqXk5IRbWzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783954222; c=relaxed/simple;
	bh=L1NX+wW8Ok7XFw1hsv7Q09QcDIPe7dend3SJn73PXeU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O0sLLzxiFLScUTDKDLvrtIWHvZmBOhiCN2rBelm8z2wUUtPRhb5QXN1DZEJVtPOBopcos9JcElyuqjKKXkvaPbWozIx9ieJ3cO0JGpkxQggJKBmipr2YB61lTUIT4uKdeHMicgM4+Z4PXi06QVrBZPZ7T7rbUk2Is7MuTzuzkuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=VDKzfQPG; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="VDKzfQPG"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCEwt13812073;
	Mon, 13 Jul 2026 14:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=5m771+D50
	Z8JZ0Y+9aliS+KzXp6AcS/ZvOAOnlw9G0c=; b=VDKzfQPG+d81hieO4aZVfNgX4
	qo3bACa4XNHQV4KDyFIDzojO0eIHPKZkomjo9UOVFD8kmGwPFj0Qn7Wxt0Pmo5fg
	hMv++xE/V9u4qVcDLl/isGg+pPIF0bCOiQbbmMfECgn3qxvlB7OXZbM9IrhcdWZ4
	D1SSo6ou9iZ5ZXI6du7FYAU/dYnC9zZQnfqrTylhSlrT5STlmDwpFzJGdIk8Q8u+
	HgWNl978YD2xMC6mW9womvhkTkPfXLpMizfOJJY7ZdBOPVzWX8TwkMs1bTa1foQa
	u5nLuvRDez6tMOBkFQ9xMTwi3rT/RU65uOfqd5WShbrWAELt2zMzl8trWTJRQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbcpn2fjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 13 Jul 2026 14:50:06 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 13 Jul 2026 07:50:04 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 13 Jul 2026 07:50:03 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>, <hch@infradead.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Mon, 13 Jul 2026 22:50:02 +0800
Message-ID: <20260713145002.1627608-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE1NCBTYWx0ZWRfX5m2uBcjf9znk
 QVUwhpRX2meKUAnESbAhD5lO7jATeIabqmn80wAZUJEadjRfHK6M9TlzMXKQK0EtLuuw7pVlSy6
 URwUFLczwEvvMQRvY8R1cXD2a8pjBE0vjal0tIYf1XBbtLMpzzqBTCLydYyf+RpgqWwEEyEZ2OC
 pfBPnYepirHCJtN9tCS6SjoTpuJkk0ZXSbVs7UVcxmihxHWubd2GP9rDoAujxj6MuVKjAjnOQxT
 cn1j1c24ImTdqkPBDz4dyzjIU0pGnl2X03BZUAg9eKUBrokWhFcJ10Ghx+v453pmDuteBbHqRK9
 arlSGv78T2oLzVNj/+lM2nFVDjRy4nM5gBJgV7QOePMi9BjehlDKeX3UGlFlOcacyQRrBl/UPTu
 VM2qBF6VnMX5qpd4yNRKnEw2BnhgNyQZt5BwgnY7Q/LP6Qa+CL1G1YfExDflDKeJZrQ0aeAxPRz
 Eerz219a8rGBKQP3eng==
X-Proofpoint-GUID: ec_1w4fud14EvDD9zuWmNwWIxRX0zHWC
X-Proofpoint-ORIG-GUID: ec_1w4fud14EvDD9zuWmNwWIxRX0zHWC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE1NCBTYWx0ZWRfXyxZ8DewYuHl9
 T9iFp5hRPv6icjn46AheugXEI41HYmD2pzaH7GqkBSesNRP+yiYPRsPQ+Yn8rD8ZjjqNxuD9ak7
 L4O0ox8drbmxbKWRqBi6AYYt0M2wleI7I1dd1LyCJKthIO912p4N
X-Authority-Analysis: v=2.4 cv=JNsLdcKb c=1 sm=1 tr=0 ts=6a54fb1e cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=iBksvAyJ2aauEmJFfc8A:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130154

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
 fs/xfs/libxfs/xfs_sb.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7690..fbb4505b1e9e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1471,7 +1471,6 @@ xfs_sync_sb_buf(
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
-	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1480,26 +1479,28 @@ xfs_sync_sb_buf(
 
 	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
-	if (update_rtsb) {
-		rtsb_bp = xfs_log_rtsb(tp, bp);
-		if (rtsb_bp)
-			xfs_trans_bhold(tp, rtsb_bp);
-	}
+	if (update_rtsb)
+		xfs_log_rtsb(tp, bp);
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

