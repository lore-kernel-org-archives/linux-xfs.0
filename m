Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3712E54A9
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753273221; cv=none; b=gp897bwIdM0MWa3i34eq6Jc/E4vFoAPGPKOM5bJ/jVvB1JVympedp8+T4I+VOufWOQpLL9bnf2Ns5R73Y+9EZtkT9FHsA99QjN6Fwgx39sWTReXxSd/M6J1zCMsR52wKl+IDv59HS4LXUxYcqZcUU/54VNOoALnuYFydAddIii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753273221; c=relaxed/simple;
	bh=b8+0P3UWTxw1UHzsJX9NjbxoAujZXOW3hlPltvU9sN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQRq6mY1d5z556bZVEkc985Py5jqKkRStMhTKIRVmM5b7VzPn6QIr/jBAh+RmpR+BVU9oPDGXV4GGk6SeFxhoK4cnSP4ZWX51XzfNk/LYSw6TpJK0X3xwoU/qSQAi7+FWbeN2DiXdqqthWW8MsYhlEqzQn4IuGDU5nSbiy5txV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jx7GxhcK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jx7GxhcK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=i/VYZFYUkKLHG+5I/fzperk8FkBx+0Y7cHtRPhCNJ0M=; b=Jx7GxhcKzkElPM5u8gNg7XkVk0
	x1bDtzRtH1ugFkHYBMxSs3m56QvwEQR+iH/eAt3rfAwN/iieHkamzvSH0SjlWFrRgoZOHswe+5od1
	4H+hf4W168ji6PXesHGEjFagBtYGaIh5/8+6Qjw/WnM2IoTtXIgABxC6a4+PYKxrkLJk1Mbrz9WiW
	yUeyb8F8W98GAU1yJQgD0zx19kztq/LcGpPBV+USA7SJxZzuln/VTxog48NKZ1FLeiaEn/z/Gxi6b
	8cleruzk2EjgKWUCLUg7D0/WixdHbmLb0jWrTmyTNY3HQl1QTnriDyz6AjA4seLM1eNacWMwpk1bw
	Koy5XkAA==;
Received: from [2001:67c:1232:144:a1d2:d12d:cb2d:5181] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueYSF-00000004tVU-1y2l;
	Wed, 23 Jul 2025 12:20:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: cen zhang <zzzccc427@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags
Date: Wed, 23 Jul 2025 14:19:44 +0200
Message-ID: <20250723122011.3178474-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250723122011.3178474-1-hch@lst.de>
References: <20250723122011.3178474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fix up xfs_inumbers to now pass in the XFS_IBULK* flags into the flags
argument to xfs_inobt_walk, which expects the XFS_IWALK* flags.

Currently passing the wrong flags works for non-debug builds because
the only XFS_IWALK* flag has the same encoding as the corresponding
XFS_IBULK* flag, but in debug builds it can trigger an assert that no
incorrect flag is passed.  Instead just extra the relevant flag.

Fixes: 5b35d922c52798 ("xfs: Decouple XFS_IBULK flags from XFS_IWALK flags")
Reported-by: cen zhang <zzzccc427@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_itable.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c8c9b8d8309f..5116842420b2 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -447,17 +447,21 @@ xfs_inumbers(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
+	unsigned int		iwalk_flags = 0;
 	int			error = 0;
 
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
+	if (breq->flags & XFS_IBULK_SAME_AG)
+		iwalk_flags |= XFS_IWALK_SAME_AG;
+
 	/*
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
 	tp = xfs_trans_alloc_empty(breq->mp);
-	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_inumbers_walk, breq->icount, &ic);
 	xfs_trans_cancel(tp);
 
-- 
2.47.2

