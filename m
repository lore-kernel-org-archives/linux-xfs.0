Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53102FE0F;
	Mon, 13 Jul 2026 03:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914919; cv=none; b=UGblsKSnXpNWaMjV2vJ7IIo/2vnZYaoK+uNCtoLYhhuVTTklJvC0HDKa1FOdFi5/Uv2aVQA0tFvbt0mCKzc3BvIFHMRNL83qhUy7CFEOzrKMOJFUXIGyQYnldKD7Jyph922/oD8YpwCgUp5bgmyBURNejYe3ZxFfbRESEnXGjI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914919; c=relaxed/simple;
	bh=WenNaULncWqcvZY47A8ESh0mMMbI6efAG0Ty2bGVuKI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O/lcrNsVYHJaEYCzlkCWZ0J+ht2u7FbPKBpeGXbNYmH/hDycAqiSsrWvpWG+2vI3zQEeBmk5LqZLEJLpbgBNStxbJZPbhLJd9etjhUToWscgNacXRqldjCRmognL0dL11zJwOCGY123n0AlprqBFQoXqoYZe6U9PMgSASB5fNVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=HRyGIr/q; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HRyGIr/q"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D3OZ8B2798054;
	Sun, 12 Jul 2026 20:55:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=LgEx4yp5a
	axkUnLJtOZoceAc2wsPpWd0pcLngC8fhSE=; b=HRyGIr/qDm1NBBISW9l5qC4OG
	DPSDBWit52csmP82JBt5DwgHiAKwWDRWbimQiGZWMMzGn9aO5pYkObtU3+9oVeaD
	jXT8i9oHnYotO7kLrLbt3ggTztV7PKdirbJzCJGUjcmTT8/TIx48raLIidLhWval
	dYkz+heu9X84JJJ2TCBy2v1+KjKE6kiCpg9d5wLQ9TzoKQ3R/mbO818zfr7OUTfl
	efQeoGo6qT8NIqzXkpeGvRiq68XHWOnM7/S4ItVn4yRnaObxhV/4UzajY1YZ5GYL
	ikJH0lVe/wzT0jVclmblbkUbIODQBNJu6jqdOmYEzLME/z1P8cCl0ea43ickA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbh40sk7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 12 Jul 2026 20:55:08 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 12 Jul 2026 20:55:07 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 12 Jul 2026 20:55:06 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] xfs: restore nofs context unconditionally in xfs_trans_roll
Date: Mon, 13 Jul 2026 11:55:05 +0800
Message-ID: <20260713035505.1635191-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAzNiBTYWx0ZWRfX/KVTWWGQAnAg
 Z9kgzPT4pyIhp69VV2rtcd8jgi7aDHhQJrD5NVddMLw3LopSQt2hVDwNg8m4+ioBHQTHGDriXL6
 /6KAht52DO8rcjuw3JfmaL7ZKytJLgf1MuAZEbUIZR2tQhfPMWtEz1R45QKXuV2N7qyWrWTPEta
 i47I7EE2j+DDAzSE6nePIsKK8oFK81dzneC/4SN3o0CYc9/hy1iJHLkrcoDaQr4pi0GwnL6NAU3
 yOllkgPRd6ecsFOm5p2Ghm2PVzlRpNceJFRfv0d7vLr0sbB5EqMZmV2vl2G0XZvQx6CKTn7oD4o
 y36ecJmyz+pwLe17lPXEHwIUUtBi8zmZh4WxR67ZNGdnp9KeywTJtcMPTZDBa6np22ci7nLJsKe
 I7g4stnafKuAkOKou1gJizIEkLgLBbivqj36Ep75B/LLC1WGm1bRAZRYFefdTfUYdbcQlaGz+rl
 FmGVxxnCXuU/5XULjgA==
X-Proofpoint-ORIG-GUID: 0qPYxYbTZcNnivjzD7ja35Z0CwYGCotO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAzNiBTYWx0ZWRfXxMlgfPt1NOhV
 82ETA6M5pP330srV+16mSuskYFXKbVMzx/S06ikH3MiBDpXv831JwShChjKDj9DNJroILUGDZM9
 JRKBBhuWOIp18tB9WSuY7Ay9WNOotizzRWq6Gse39pkVe/N5VzL5
X-Authority-Analysis: v=2.4 cv=JbGMa0KV c=1 sm=1 tr=0 ts=6a54619c cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=f6HC1ILcO5oyKfBqgOoA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 0qPYxYbTZcNnivjzD7ja35Z0CwYGCotO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_01,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130036

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

Fix this by moving xfs_trans_set_context() before the error check so
that nofs context is always restored on the new transaction.

Reported-by: syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=59178abfeb0ea3f0ab20
Fixes: a1ca658d649a ("xfs: fix incorrect context handling in xfs_trans_roll")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/xfs/xfs_trans.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bfbd9f6f0df..1b36cf12d4e3 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1029,6 +1029,15 @@ xfs_trans_roll(
 	 * duplicate transaction that gets returned.
 	 */
 	error = __xfs_trans_commit(tp, true);
+
+	tp = *tpp;
+	/*
+	 * __xfs_trans_commit cleared the NOFS flag by calling into
+	 * xfs_trans_free.  Set it again here before doing memory
+	 * allocations.
+	 */
+	xfs_trans_set_context(tp);
+
 	if (error)
 		return error;
 
@@ -1040,13 +1049,6 @@ xfs_trans_roll(
 	 * either nothing be locked across this call, or that anything that is
 	 * locked be logged in the prior and the next transactions.
 	 */
-	tp = *tpp;
-	/*
-	 * __xfs_trans_commit cleared the NOFS flag by calling into
-	 * xfs_trans_free.  Set it again here before doing memory
-	 * allocations.
-	 */
-	xfs_trans_set_context(tp);
 	error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
 	if (error)
 		return error;
-- 
2.43.0

