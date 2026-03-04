Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A29B241139;
	Wed,  4 Mar 2026 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641461; cv=none; b=IEUj9baHvB2CaEwOw1GlQX0J5bvXLkKjYhiRuHg6YRQQH7lvWzHCCz69za741I/xU9apAFbPfFr7TYIvIKk5B+ZTHEyUAhIfhmnA5kVh1LfVCxgDsXn7l/qIoTTD0mtwmTbE/xwDUYejqBOFs0NLrJbnQ84mlTRuv73Blq2anvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641461; c=relaxed/simple;
	bh=B8eNkJ65eVhNso6TQYQ/uxzg8Zbm1ggT2e5NuXuYHrs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mC6t81BRQ+ykyeiA/wDFO35m4KUPW3Ub3/qKGBYA308IZyzsxYtOqJCCVwYlghbvfS+QQX7KGB6Xqz33NdiamHeP5jcXZK/QpXxdO1xaTbn8ybgQA6MAwlq6fpZh2g1DMcuYu7WPhDVPCZS6DpNvhqxWZXYA4ccEG1Te9Fjy+Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=lMowOp4f; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="lMowOp4f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772641460; x=1804177460;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2hOcY5DZinjFfRQaWJ22nOMxK/xTHlKGps9qXv/NCZE=;
  b=lMowOp4fG7Y+gYJoOQ446cUhytZqktnb2rAcQfr2eBfcE4rp9xcpfrun
   uWJxDiBNmp3O4Z9yJlKw9jay6NTvnYER/zQLa5tAmu7gi3cttch+mCwmO
   NWScYiIH+v1tQyL2UTTPJrs8Go+rStD1s8pjW/pQGkgyj/t78PMOUNtIr
   1WbMx7g6LBVChBaiALPk8KEJWV/T+uMEhHMoNRfvsG06lN8xydesVCUJ8
   XfLdT7RLGDT/6/6IhWnfrca5beos4DHnpUdN88cRyCl4PUQZCUbNsBt6r
   9TDuK2KKE2WPfdQvTh4+UsZr5xFhYk45/yc123vt0DQ2BduNeTRwaXWq4
   A==;
X-CSE-ConnectionGUID: bxvQI1+4QMOA4pMfplgrPg==
X-CSE-MsgGUID: Gurz/gbXTRCzL7ziNIu73A==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="13830347"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 16:24:16 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:28163]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.108:2525] with esmtp (Farcaster)
 id 334b0d0e-a9c4-4910-aad9-159686ace235; Wed, 4 Mar 2026 16:24:16 +0000 (UTC)
X-Farcaster-Flow-ID: 334b0d0e-a9c4-4910-aad9-159686ace235
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 16:24:16 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.14) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 16:24:14 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner
	<dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>
Subject: [PATCH] xfs: fix use-after-free in xfs_inode_item_push()
Date: Wed, 4 Mar 2026 16:24:06 +0000
Message-ID: <20260304162405.58017-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since commit 90c60e164012 ("xfs: xfs_iflush() is no longer necessary"),
xfs_inode_item_push() no longer holds the inode locked (ILOCK_SHARED)
while flushing, so the inode and its log item can be freed via
RCU callback (xfs_inode_free_callback) while the AIL lock is
temporarily dropped.

This results in a use-after-free when the function reacquires the AIL
lock by dereferencing the freed log item's li_ailp pointer at offset 48.

Fix this by saving the ailp pointer in a local variable while the AIL
lock is held and the log item is guaranteed to be valid.

Also move trace_xfs_ail_push() before xfsaild_push_item() because the
log item may be freed during the push.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_inode_item.c | 5 +++--
 fs/xfs/xfs_trans_ail.c  | 8 +++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8913036b8024..0a8957f9c72f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -746,6 +746,7 @@ xfs_inode_item_push(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -771,7 +772,7 @@ xfs_inode_item_push(
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	/*
 	 * We need to hold a reference for flushing the cluster buffer as it may
@@ -795,7 +796,7 @@ xfs_inode_item_push(
 		rval = XFS_ITEM_LOCKED;
 	}
 
-	spin_lock(&lip->li_ailp->ail_lock);
+	spin_lock(&ailp->ail_lock);
 	return rval;
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 923729af4206..e34d8a7e341d 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -510,6 +510,13 @@ xfsaild_push(
 		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
 			goto next_item;
 
+		/*
+		 * The log item may be freed after the push if the AIL lock is
+		 * temporarily dropped and the RCU grace period expires,
+		 * so trace it before pushing.
+		 */
+		trace_xfs_ail_push(lip);
+
 		/*
 		 * Note that iop_push may unlock and reacquire the AIL lock.  We
 		 * rely on the AIL cursor implementation to be able to deal with
@@ -519,7 +526,6 @@ xfsaild_push(
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(mp, xs_push_ail_success);
-			trace_xfs_ail_push(lip);
 
 			ailp->ail_last_pushed_lsn = lsn;
 			break;
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



