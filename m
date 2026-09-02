Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5182138DC53
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328197; cv=none; b=cwptlLxlQxrcCUhsLUmXST72rFL/GP3H/lDIZnc498iot3tGkdXNSGIHcjs/tL/zJj1VgWr/ehRkPHiAj3Dh7vSUJMhJSTfK+uygvvUlBRI14HsNoJE5kpB+XgwTu/jqVxvh6WmYRHmZiihJI2/xL5p8dfLtCoTkCP9L6S+PpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328197; c=relaxed/simple;
	bh=8LkdJYOiNgcJnFbc69ctxekpVGuWOOPHjqPBUz6MaXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uE3pQBcVTsfxoq6BwUL/ax2EZ5KC/MrF2Hw4eNI3vNJGiDfoxm2J/EaZ7TpvMbS2z3P2opv/1xB7d1pLi+BfzdCyp2v7EO1vjEbrZr8+P3w4bGiA3Uzaxqu8bqPtSLjJWFrzjmHFlymqqt8icMQRJ+1+hMNz5YOCpSE5mws9nO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zWH10Nsg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zWH10Nsg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AksLNTS5qllndmkcP0X7kqF8HviIygbf1HddQ6qcH8s=; b=zWH10NsgRw4T9o0uyuj/sBzO3D
	teh7SaBsgDsHaOiZOUeOlYuN8MA75KVDMQlj9Qd6yxhec9dsCj+RfeoG/b/8V+auGUYQ9tsBfsHLu
	WiPOAw97/ut8ENEmIBERDGKkNI+cwRpNio1iTvXaQ9oaiKhRL3AVTwB9k3/v28jX4QThfvbUfXTnd
	136rZw1yPMe9fgEqLtw8LlSF6bhbtreXRwVfOoVmsA1B0GhDldxYvAaRkz/Pre11IdvpVlLOuwuLh
	78uruX7p03CQv7rcD0VQ7qkEoay2Agc8hByX3cBWoKWNV3LWvSz64wqdKnEr7hTMzP3S+dvuMCYip
	X3555KUw==;
Received: from 87-119-185-211.ip.elisa.ee ([87.119.185.211] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1dr9-0000000Dp5Y-1JA5;
	Wed, 02 Sep 2026 05:49:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: clean up xfs_fsync_flush_log a bit
Date: Wed,  2 Sep 2026 08:49:17 +0300
Message-ID: <20260902054942.111988-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902054942.111988-1-hch@lst.de>
References: <20260902054942.111988-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The log_flushed parameter still fits on the previous line, so move it up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0d31fea67a2c..cce324321b4c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -117,8 +117,7 @@ xfs_fsync_flush_log(
 	if (!seq)
 		return 0;
 
-	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
-					  log_flushed);
+	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, log_flushed);
 }
 
 STATIC int
-- 
2.53.0

