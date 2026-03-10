Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5ED31A065;
	Tue, 10 Mar 2026 18:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167945; cv=none; b=m2OmVZzjevcR77JZV5/nl6iOzMdrjVEbizo/lSRsSW+rX0G3elqYg88lJqBlxpI2/mxP9YfoiC8LoFhcVeOjZc57m5V4IPHxKuNSQceHqOekNG3vHC+7NpPI5rN2QeC2AE23zzlTEIfHVog5YCE9Fx8cBIDATR1j1y4MFjZIE94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167945; c=relaxed/simple;
	bh=A9j5b+rQvehAI7NL74S2TgM6Wg4Uf9+5xGABk0nrT3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfoNcQouje7MdOEdJGZDlvq6GONqJIyKIArBJseig25m4uud6tyd1cxR3a3dl5ONPyl5kOxCLAqewEJgy8uqlzc873NC1hRjdk1oxGBOi5lywQWISKRbQ7iU7aWBuea9PTLQVhlBRlIMOngt5YdGbVrb9N/GgJkVJk79qnnKrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=lmPwzUnv; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="lmPwzUnv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773167944; x=1804703944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vVjnwKHzMvt5HNbkq0uZWsIbyPr5V7v/G9NKgqI0neI=;
  b=lmPwzUnvXelLnqpJqsouvs+mKXk38osHhIGC80f6yt6mSj3wDePwKS18
   auYG9ZL6oJNdzWDNWo8n2WHNgIG7RhIYox844DF4K2aa719sE/skvsTEy
   W63Onz+mvkR2A0WQufognVsAByokmN4+RefuMt1Fif1/DuEffzfeqd2LX
   34fclsVnbZ/ppJMIpP6ManhBNXM6bBJmfXAIMquLW9nZmYtabylfgYKrS
   z5PyF3YBwywpTyY6uOVDF2MxU8ruwLr3SXFIeac+GrGrhyid6GVlguPNv
   z6T0o2lVQbC2VYDfKR47HMvYzomk6SQ/jBomu8WgHYdbN2NwsaqXjq6Vs
   Q==;
X-CSE-ConnectionGUID: Je/2pfdCQx6p8Wu2rlTgfA==
X-CSE-MsgGUID: hIGc9hrdRi6q8VP2S86ucA==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14264659"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 18:39:01 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:13189]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.152:2525] with esmtp (Farcaster)
 id e285a619-f1d8-4fda-8b32-bf3b74c52e60; Tue, 10 Mar 2026 18:39:00 +0000 (UTC)
X-Farcaster-Flow-ID: e285a619-f1d8-4fda-8b32-bf3b74c52e60
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:57 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:55 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v4 3/4] xfs: save ailp before dropping the AIL lock in push callbacks
Date: Tue, 10 Mar 2026 18:38:39 +0000
Message-ID: <20260310183835.89827-9-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260310183835.89827-6-ytohnuki@amazon.com>
References: <20260310183835.89827-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In xfs_inode_item_push() and xfs_qm_dquot_logitem_push(), the AIL lock
is dropped to perform buffer IO. Once the cluster buffer no longer
protects the log item from reclaim, the log item may be freed by
background reclaim or the dquot shrinker. The subsequent spin_lock()
call dereferences lip->li_ailp, which is a use-after-free.

Fix this by saving the ailp pointer in a local variable while the AIL
lock is held and the log item is guaranteed to be valid.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: <stable@vger.kernel.org> # v5.9
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_dquot_item.c | 9 +++++++--
 fs/xfs/xfs_inode_item.c | 9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 491e2a7053a3..65a0e69c3d08 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -125,6 +125,7 @@ xfs_qm_dquot_logitem_push(
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_buf		*bp;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -153,7 +154,7 @@ xfs_qm_dquot_logitem_push(
 		goto out_unlock;
 	}
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	spin_unlock(&ailp->ail_lock);
 
 	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error == -EAGAIN) {
@@ -172,9 +173,13 @@ xfs_qm_dquot_logitem_push(
 			rval = XFS_ITEM_FLUSHING;
 	}
 	xfs_buf_relse(bp);
+	/*
+	 * The buffer no longer protects the log item from reclaim, so
+	 * do not reference lip after this point.
+	 */
 
 out_relock_ail:
-	spin_lock(&lip->li_ailp->ail_lock);
+	spin_lock(&ailp->ail_lock);
 out_unlock:
 	mutex_unlock(&dqp->q_qlock);
 	return rval;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8913036b8024..4ae81eed0442 100644
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
@@ -795,7 +796,11 @@ xfs_inode_item_push(
 		rval = XFS_ITEM_LOCKED;
 	}
 
-	spin_lock(&lip->li_ailp->ail_lock);
+	/*
+	 * The buffer no longer protects the log item from reclaim, so
+	 * do not reference lip after this point.
+	 */
+	spin_lock(&ailp->ail_lock);
 	return rval;
 }
 
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



