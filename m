Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FBF3C9EF0;
	Thu, 30 Jul 2026 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403830; cv=none; b=ST4dt9xbCg/NYQRUMf3TrNIRtTxyvO9CEmWiUMjDu3pupWD3o2Or5ANQo1b5hY2LAHPHdi/qARKCoV4hbQi8lUb4lzQhSqWkVIdbQaxM5iGDb1x8fFVk5FfOuYAXkQ7+SKoDeOFEeiiK+Sn9Hgan/ZD5n4jf6wRkY6jr6LrDUeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403830; c=relaxed/simple;
	bh=OJNuGN0Hj50kh7RGAgQuCLII1etGMK0ufvw5FDUvsD0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mF4r5av/Zud15S2qFrNlaSP2UmhXSLdXIJPXsMTYM2FH8+dFt+CR4FkX++fK+iV1n4bo7IuyFn9/TJ4uyekULqIKtfpON96aAHE/ApT4ZCEb4J9y8hDC7qEaxPsuAK+OpsgIa9IYn5iei0WVu+0sZJinhBHIQA1QCvzbfDzYH2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Ad4krcxP; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Ad4krcxP"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U9NgQe3485281;
	Thu, 30 Jul 2026 09:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=NkDMEQVvQ
	ycmX5AwJFuKMrtZlTLt/iQprHWLOzpaj4o=; b=Ad4krcxPw0VQN4gWWq/9dScea
	vCg572W6wtVg3S2kRfofaCYwArIQUcsNBXgRJyKBtLt3mpQra+Ync+s/jzKDDq5O
	7sEANmdD7lgqZxx1FtoSA7JMMfHNo0kgMdExs+7oqudRkHmfVuFCj+0qyBrI0cBs
	dB4WYGwflfuXB3SfyN4NUHPPeKtARxgJDmr3ekqm/43AW9VoTc+sT+F/Wdkcyu5K
	758seQJtUlylIQMZZM94mNwJknS+7YkHE/r8D5C/Yced3afcoBBSKyg+9xA8kPXb
	Xv6TWg5B8P5eHmNhe7dWSd+5HNvdGMujTpBgqBbqyavbPw9YAVOO5HtWqhubw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fr3xmg08s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 30 Jul 2026 09:30:09 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 30 Jul 2026 02:30:04 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 30 Jul 2026 02:30:03 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] xfs: restore nofs context unconditionally in xfs_trans_roll
Date: Thu, 30 Jul 2026 17:30:02 +0800
Message-ID: <20260730093002.1034320-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA2OSBTYWx0ZWRfXx9aN1w5miHwm
 rbFSJTlPKgJAflYjR9ZSH6AqZNzJTwl6s5/HsJbxYsTVdL3n1DmVIW1Qai8QrzReDj7yBbGC+XO
 o0RbLgQZvQLUICvnbrJdf7+cMDs6r083uEa1HUTVkxyIWzUS5ZguV9nQDf3r2xFYBOg8tU+EpPp
 aQHwfQN4XTXGPvaNqtsNxQOso/1cUo9EdANTtfw7lq8ei1jCamCDoGZN2yo6XlDXUBqLlW2NIU0
 pJgeXTRTRRKMt5VatOahc0uR6R2pLpba/isMeGaspKWFdsP1kdeIIUQnHZL5F4VCdosUkVgQ1r+
 hxBH0jBzQgv2yz5LZMUvh+J8ZR1MSEV9rettlK3gvqFWMSQjicGlscEqJW2RfdURbiqce45Ct/O
 /yUWgrqHiK+VL+cxBRA/mTq/AaIDd3hwMZBYQJNliIrcfInZV1/6CbaX7/je3pqshgLZ5j2zPA3
 gDnZ6AS5QiwhH0fRqhQ==
X-Proofpoint-GUID: I6MB6vzYJbo9nSSreV-NYBb3YNnRxYeN
X-Proofpoint-ORIG-GUID: I6MB6vzYJbo9nSSreV-NYBb3YNnRxYeN
X-Authority-Analysis: v=2.4 cv=fPkJG5ae c=1 sm=1 tr=0 ts=6a6b19a1 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8
 a=hSkVLCK3AAAA:8 a=ENYqueAstlwBTegi0WYA:9 a=DcSpbTIhAlouE1Uv7lRv:22
 a=FdTzh2GWekK77mhwV6Dw:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA2OSBTYWx0ZWRfX7PJCRgetNye9
 jLvmUCLqpnawuqLQ9vE2FS4BV+brwlomSys5hbcvGOLztuA7f58eriOnlv+YKKGXnOLBhUUgeO3
 lCLbBe67XeWeMnKuxmED8rmgpiXbsPp3WQJK7m8BWEdPtAqKxW/S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300069

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
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v3:
  - Change back to v1

v2:
  - Instead of moving xfs_trans_set_context() before the error check,
    transfer the nofs context in xfs_trans_dup() via a new
    memalloc_flags_move() helper, as suggested by Darrick.
  - Change t_pflags from unsigned long to unsigned int to match mm API.

v1: https://lore.kernel.org/all/20260713035505.1635191-1-yun.zhou@windriver.com/T/

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

