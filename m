Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0A6380FE3;
	Sun, 19 Jul 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784455085; cv=none; b=oZYC+Eq2v7vdRFu2FEVVdK6aPJFkySIyVXIbKXDZWYCSV+L2s/O+3wxMhVY28f1MY3Wt5hsJEP06zSW0PfT1nRkkMY5U3DJ5NquZvd/6vrH+vfMZxmrxgd1SqgspRNPZHEH0IOXBnFghmDPsM1n9lgQFuDmWE3ibLRebnIjYa1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784455085; c=relaxed/simple;
	bh=LbTFUWzvjIFdJ5d7tMQeCZMFj+NKpb3AW0/FRHvSzH4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rPY+OzUZqn7/UGnQZC9Q5LvadCB7OhY8rIJa8PE7YjV8HPiT3mnbOllYXTpYiBvarf/1nNbAbh6DeqGoVXZ3PwLWWoWeoHw6MjFBefZuoOF2vM2BbGwMBBZeCypQrGTLlJY5TsRVoYXo7VLCIxUSgeCS1fYVsF5E+tPV10NrHe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=agaUKGI6; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="agaUKGI6"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66J9j2FN1452948;
	Sun, 19 Jul 2026 02:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=8xG0FikcQBoBqJe8W4yHS8i0RG2JM9df/6Fln9kQMvU=; b=
	agaUKGI6iweMXmRBdF+0gwI1weje4fV1YdjFZ7kCAIGpkhc5Ux2AHfM3einJfXsm
	39nBDXjgG7E2MqZw4R2o/7nSBVpQsj9USIcwDWCUA94+c6K29okag47WXwdGjxxc
	fW7ecHGGKAMVeR2uFhC/JGuJzMiEWlpa7tbHssNxVOGJbYxtXLr0a9WYj5bS4VcB
	+XZ85BEYeUVYuEmjD6YhKRlLAn44+ncJxaHE+MfSvPMKi4sZJuXYj0lYuoXU5PaQ
	sz2NngGKEkG9UzjP1o4BNWpsHGAWjaq65eX64asLDab1+OUYhG0y9PcD0RxHkGj/
	BiDUOiUkZtv7XbwvaY3BiQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg90crq9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 19 Jul 2026 02:57:40 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 19 Jul 2026 02:57:40 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 19 Jul 2026 02:57:38 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>, <djwong@kernel.org>
CC: <hch@lst.de>, <willy@infradead.org>, <akpm@linux-foundation.org>,
        <hwenwur@gmail.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v2 2/2] xfs: restore nofs context unconditionally in xfs_trans_roll
Date: Sun, 19 Jul 2026 17:57:32 +0800
Message-ID: <20260719095732.1813590-3-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719095732.1813590-1-yun.zhou@windriver.com>
References: <20260719095732.1813590-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: URpqz1pBn0HKgIvcOoRb7n1kom9lU5-V
X-Proofpoint-GUID: URpqz1pBn0HKgIvcOoRb7n1kom9lU5-V
X-Authority-Analysis: v=2.4 cv=AOkSgtoa c=1 sm=1 tr=0 ts=6a5c9f95 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8
 a=t7CeM3EgAAAA:8 a=Hv54xS5d5VjlolbwrkYA:9 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDEwNyBTYWx0ZWRfXwKtCF6jqKUPl
 B/qYPI6S0WLB++FvZhtenpL6TyLcdaWGq0vBUm/KG1nYAzQWo4GvbhGLmC+mvjMMFLM9AZGER0E
 Wg6xiNLtBIkKMR4GRirn08aBOjkmk9QXkQlOUiu/Z8UV/T5ddbzu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDEwNyBTYWx0ZWRfX2GzVReqr5VfQ
 37suYghIXjv2lIh0GCYBKt6eLS82FD0Avt/kia9cs/wjCGDXqASqgQcrExXUlaRxiXNY6Q+mX8D
 Gn68+wZO5vf9foREUTd8ddsqjCytakKAzsEAjjcU3yfAmTWmf7HS+eVteTyNyuzOvGEd0djAcxM
 sAd3D5i7nDN2YWCwShbwbSXJz3HA+YfFPOp9EGdiZTMEtPIc+dYtgwtZnK4WoYFfncoCR7CEMv9
 zw2DBqQO3vujkePW5/fPb8Ws5XF7YRAAclnW+rhP/UcUHb9OJrQ6Up+irms1gO97IJkmun1/9Rl
 ++crznEHvb5nYRqqLIBJLdKpcLDUooaMZ6+X49dmR/aUUtNOiaYZTf/SpDPLcvw/vQx6WK7FDiA
 jJnU+7bGG1HGQlTqLN+/+jhdZBqGkTryBNDmL3umehQccYZHb0EMUYkpgqmjchuBkccu+rdgwt2
 7LI/PEGHGMT0+5yzyRg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607190107

When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
is cleared but only restored in the success path.  This leaves the
error path without nofs protection, causing a circular lock dependency
between xfs_nondir_ilock_class and fs_reclaim:

       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
  lock(fs_reclaim);

Fix this by transferring the nofs context from the old transaction to
the new one in xfs_trans_dup() via memalloc_flags_move(), so it remains
active throughout the entire roll sequence regardless of commit success
or failure.

Reported-by: syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=59178abfeb0ea3f0ab20
Fixes: a1ca658d649a ("xfs: fix incorrect context handling in xfs_trans_roll")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/xfs/xfs_trans.c | 9 +++------
 fs/xfs/xfs_trans.h | 2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bfbd9f6f0df..89818c67b64f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -127,6 +127,9 @@ xfs_trans_dup(
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
 
+	/* move the nofs context to the new transaction */
+	ntp->t_pflags = memalloc_flags_move(&tp->t_pflags);
+
 	xfs_trans_dup_dqinfo(tp, ntp);
 	return ntp;
 }
@@ -1041,12 +1044,6 @@ xfs_trans_roll(
 	 * locked be logged in the prior and the next transactions.
 	 */
 	tp = *tpp;
-	/*
-	 * __xfs_trans_commit cleared the NOFS flag by calling into
-	 * xfs_trans_free.  Set it again here before doing memory
-	 * allocations.
-	 */
-	xfs_trans_set_context(tp);
 	error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index eb83c5dac032..fd792584275a 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -152,7 +152,7 @@ typedef struct xfs_trans {
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	struct list_head	t_dfops;	/* deferred operations */
-	unsigned long		t_pflags;	/* saved process flags state */
+	unsigned int		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
 
 /*
-- 
2.43.0

