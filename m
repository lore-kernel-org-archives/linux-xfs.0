Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7F9191F91;
	Mon, 20 Jul 2026 05:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784523930; cv=none; b=fmUXPzq1EBmtX3QYGQmL0kUBEWf4Px9JgH3lmdqCEnvIkoX+m6D0isb7EbvKKam095u6lUvS1soN4wmEEQBe+wq9ehHfdq9os4GToRK1BhQigdrkP1AOp9USvcV22g0z0Ub5AjIxo5ipeW1oLT0XGxo1oM5GuNNHXauhSXG/Hgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784523930; c=relaxed/simple;
	bh=BllDB/8PHNXDG8OXidniY8lg+JtptD6ijJhs/FtjbC8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Np+VPzupCqRbBVxnB+zk1i2/FHFhXh2jgQh9ESgtKBnf/BGTezcLrqkMEA/2mVWMANykodpUUHWIgw90jpBKhlhYBUzWbQFYIpjXx1f9q9o4EAmXvTOP+hyfWfEvI/XlVY5FoZn7Ky9yzcRs/cumyQyP4SlsPW3PRGrFQ/JxylU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=jrfKDozK; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="jrfKDozK"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K4F35P3336928;
	Sun, 19 Jul 2026 22:05:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=8OsFxC3Hg
	krBWmOkhGaP3r3aW6YVb6J43euAbQppPYs=; b=jrfKDozKT0YqvqRD1iSmdWthB
	zxzE/LGnAPuOFQWVST53oDfvCPJJx04pQ+WErWqiUce+ijMmG7O1xhtTcFksZ1ag
	jS+2TMyZmshSKxBL8A+G0QFciCHaYZEi3bEr+7ykFi1JHmLf8mi9xrZZcN1/q/Zr
	oGkRyScahWo0Smh9dRM9HZB2nWMA81geLM8DWq6TAhkbBcyRNdIWMyAqwu4Y5WBM
	gIS/wui8xyf3Ii0wHIg3TIsGzb8upsCd0CmPC8YyPE3zqlu59kjSzyQg3pZhMo1M
	8losG4Qu1xOdbGxc7nU9OLwIngdtw+F4fn+F3mxEmw7EA4WbbDSaNq2M0RknQ==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg90csffu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 19 Jul 2026 22:05:25 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 19 Jul 2026 22:05:24 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 19 Jul 2026 22:05:23 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <akpm@linux-foundation.org>
Subject: [PATCH] xfs: fix nofs context corruption in xfs_btree_split_worker
Date: Mon, 20 Jul 2026 13:05:22 +0800
Message-ID: <20260720050522.3101824-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dYz9mMcoyZe48EnBr21hbIwZ3hJkPXN0
X-Proofpoint-GUID: dYz9mMcoyZe48EnBr21hbIwZ3hJkPXN0
X-Authority-Analysis: v=2.4 cv=AOkSgtoa c=1 sm=1 tr=0 ts=6a5dac95 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=CUyHY5p52LtCR0w9yPIA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA1MyBTYWx0ZWRfX7GJ3Xk77Gjqs
 h1vJFYZaaNn4g8XohRCsxe299vaVihXtRX+N+kPGbtCt46iBBEwwXfQMb9M4Aot55hBBvnhoGWz
 IHLtTSTjK1xxjheApg7AhUhRu561n/Yo6QJh9yn9ivyfASRi5K/g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1MyBTYWx0ZWRfX7i5VTEFJUhEq
 sji/gFucN+xBFh1vaMlIC+bTzJEWihE6pUTP+niXgibAhc6iphRUITmlvTdRKlIWy8SUJW85kZC
 8lpS8WbhDeJNi1WVQ0AhbxuvPjgOHmf3vmjontxGpAKH7dD4Az1OFVihFK1g9H/CkIbsAs8fp47
 l4uf1PgQJqQIEUs4Ki6niY3j06o/PXZSYJ5kkrxyKPxGDa2tcmHvU6RmcNJdCVGAOpeuyHn7G6O
 WR0TaRFvdXDpEaD6rjrunNdcPpYmOeFB7568MzTJ+zDmM1xeLothsqFMjsKwpTNuhr6oWl313c3
 suj2l6tvVSjo/0w0Fsrbci5slnmFjkGm2Q7FrS2sEKKnaekbDtScWLz+SZjlY/8UHOBL2mw7FFb
 2G3O8wUTRgsrGnqBnXfQrh3r4Mgzcnu6gvEfj5ZUpjlX14dVOYJAE5H90FVQGF71ry4rDwMErkP
 wlJzSfU46PfqG31UPYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200053

xfs_btree_split_worker() calls xfs_trans_set_context() on the shared
transaction, overwriting tp->t_pflags saved by the submitting thread.
This can cause the submitting thread's NOFS protection to be cleared
prematurely when the transaction is freed, risking deadlocks from
allocations recursing into fs_reclaim.

    Thread A (NOFS set)             Worker
    -------------------             ------
    xfs_trans_alloc()
      xfs_trans_set_context(tp)
        tp->t_pflags = 0  (*)
    ...
    xfs_btree_split()
      queue_work(split_worker)
                                    xfs_trans_set_context(tp)
                                      tp->t_pflags = NOFS  (clobbers!)
                                    __xfs_btree_split()
                                    xfs_trans_clear_context(tp)
      wait_for_completion()
    ...
    xfs_trans_free(tp)
      memalloc_nofs_restore(NOFS)
        -> clears Thread A's NOFS!

    (*) returns 0 because NOFS was already set by outer scope

Fix by using a local memalloc_nofs_save()/restore() in the worker
instead of touching the shared transaction state.

Reported-by: sashiko <sashiko@sashiko.dev>
Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/xfs/libxfs/xfs_btree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 60ef7f08b1d3..1e4c43b7fa3d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3010,6 +3010,7 @@ xfs_btree_split_worker(
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
 	unsigned long		new_pflags = 0;
+	unsigned int		nofs_flags;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
@@ -3021,12 +3022,12 @@ xfs_btree_split_worker(
 		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
-	xfs_trans_set_context(args->cur->bc_tp);
+	nofs_flags = memalloc_nofs_save();
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
-	xfs_trans_clear_context(args->cur->bc_tp);
+	memalloc_nofs_restore(nofs_flags);
 	current_restore_flags_nested(&pflags, new_pflags);
 
 	/*
-- 
2.43.0

