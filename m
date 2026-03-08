Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E239448C;
	Sun,  8 Mar 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772994521; cv=none; b=Wqhe2A8GFPMbUfwerO3fLSZ0sCghHtCiHBzNaRlzfxpzytQddl4rRflEGT7fWH9e4Tk5zFlyCVI7Yn+2/L866HsLW4SAjc6dnqigztavgD6ws6c+dLQigCexLL/DBnOT/2oFx1yFuQvMdmJ60O8xu6OkNzipoDFbn5j1LQoHes8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772994521; c=relaxed/simple;
	bh=612fuy+SrLXkZBZcVKEJDpAdsrWFDyRiBahGFybMnLo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hBukyMltzdOZcKXB+FGDQuZ3bjTWZBU+lWRjOTVsSPP6QjY6eTZ6FF9BFqqNCs1uQTyaX+NulpaKO6QLUVWsC0jF7dTw7Xppx0DO4Sf9idVFozsLXJHdkzY4BIvZCfd/k11XtlEIfWPU2Ko7HFqMm0dn+u7lbbh4oEAKpKbUcDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=tAQyajFf; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="tAQyajFf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772994520; x=1804530520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WRc9x4f6CuM/9PVF31ZAOzT26sMcBoVArIU7CRsUxak=;
  b=tAQyajFfFNv8WJnH10/5XUOV5O46R4kYFgmT7eHrcDEC0qYF7TFdvw2C
   SRNS5u3PLKvA4pHG/GKsRlcX1CV/ZzJGjNavLH30JJHuDGGzlq6mUMeCj
   1rWa3Gg/tddNvawGePpKgSuen1gioAhzSMoNlbRmbqUFPEWogUbfvsutD
   5cHmrpuCuApwtPvhKIbnwvC915fGrbYogJlU2+kvmsfeRw2P6pbqZgifr
   veszLT6cOBhuBnGHJuv+mPU8zClhzSFx0DlSC8ay6CHSul8y+eTV+M4Lf
   FJ0FIyk6binpJ3NMeYiyNKnESvlNdD95OVVBcBZq9fdvx7cmwD1pDTl5p
   g==;
X-CSE-ConnectionGUID: frtOTujARgKjv0+zPOS2Aw==
X-CSE-MsgGUID: QmzJba9vQACGtSpOPG1IJA==
X-IronPort-AV: E=Sophos;i="6.23,109,1770595200"; 
   d="scan'208";a="14587974"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 18:28:29 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:6139]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.39:2525] with esmtp (Farcaster)
 id 9e87af4e-7e08-41e4-987e-e7ff4e193084; Sun, 8 Mar 2026 18:28:29 +0000 (UTC)
X-Farcaster-Flow-ID: 9e87af4e-7e08-41e4-987e-e7ff4e193084
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:29 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:27 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v3 4/4] xfs: save ailp before dropping the AIL lock in push callbacks
Date: Sun, 8 Mar 2026 18:28:09 +0000
Message-ID: <20260308182804.33127-10-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260308182804.33127-6-ytohnuki@amazon.com>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
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



