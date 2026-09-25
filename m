Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2814BB5C2
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349362; cv=none; b=qWxLph3QFVoWl+cv2ipiBrVfZhZJblGhP+cNu+Hy3nvhoqbgva1z8kZm5LfwbUk7dzWAadp5TsbUGDVeto4PKdmaKj30cPddiVTFlJRp3vloEO5jwxha11avq4l4qLPpLVsr6+hcbA+QpqNWLDO8YD7W3H2XWFzYh1mWTCWuHuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349362; c=relaxed/simple;
	bh=XRyvHEMEZxxFqA5Ot+7AMfjMpPOe+6oKGtdetRmQ+wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qth96Nk3VHs8v/II3oh5kxuBvHV6ZLIFuCJpWqIdrO+YIiakK7hbRPvZQdv4uuz1ZJcISX8TRnLq5w37NX747OkKqKnut9a3nqhW0UKsiRDk2et/AggsPxiFfwz7hfUC6Zi1sPcs9BoBWxvNOAzMVYexGVgqALSCxrfO7XTGj0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ir59/ij4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ir59/ij4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9ezoviY+edgScH0mrmtTD32xhKO0KbL55Q9cM5ykCrU=; b=Ir59/ij4uht8a4u0g/sl6eu4Nk
	xS/mfmvWdpFwmT9h9tQJuieab9MFKKiqeUeRXuTy54iD8YzeoUDOMngzDlPEdXk81e90JTTEaSj8h
	wo9RPj3bmA4J8RcLIuAs3uF2QgXFqYFnkH8GHDMZ53mShYqUB+d/Er681n5TgST+bXol9E+KLoTDJ
	y6BOJQA3zAHH0EUM7QvvgpAhuRFJvpz4V97o+GMhrbGkuneBJDfttPOAPFthNlt8BxHF+wbULUYrU
	7NVOpUKXN0smyq2Kzf+wuoRqbvAvb5W4zRJYYBhuZyd0kI5cEs7ugLHoIr8ddQZLo5WGN5OcX75YN
	P9DQaoXA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7eQ-0000000Djg3-44UW;
	Fri, 25 Sep 2026 15:15:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: clean up xfs_fsync_flush_log a bit
Date: Fri, 25 Sep 2026 17:15:36 +0200
Message-ID: <20260925151543.3382123-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925151543.3382123-1-hch@lst.de>
References: <20260925151543.3382123-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dd6d2e08faff..1eabd436ce59 100644
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

