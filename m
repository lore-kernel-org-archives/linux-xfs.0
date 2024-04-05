Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA191EB2B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 06:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712297242; cv=none; b=SlqFIMd0Dh64fW+TQkCf/FcsT0dYrZIUyJOirKDx97xoR1ljEevBaxj33ICdkoJjWPeNV0aMsHG/zX7KUuy5f/5d+SwXMmLRp9h2A5RL6W/z3KWVEIUqPBTxy4N2cFPoTVDOEtRD4IDwjNF19I/A17CH4XjlHKHLO6rkPLCQiQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712297242; c=relaxed/simple;
	bh=d5fyDJEbqQOMR32EjRpKxGP23Uu/ubzBqAt3gbfNqGI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yid+o94BO7Gz+V09ndm04iURNZbY9K3XQA56vT/ucPeuOChhZh9YOxduCMCYO1rMx1Roy63QqAdNrEg3sLp1JNmdEqK+Cyq7zMmsH9qagQfKVrzikjcORU11olkygcH/ugNKhojKD2/2yHfISGEJZcW+nDbMrjAhOI6yaz1dE3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FZlLlRzr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FZlLlRzr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bBuSofmK5kcFULFHUV9RZL5kWmHFWLF1LwoqpMG2NgA=; b=FZlLlRzrF7e6GnAVa/qwwpwidK
	vQi4Z1G/qOBB3loZGIjEUTzMtTXSI72nh25aYE89uAdCTrRE+q7feoGjjP2agYRqYWlQjwqxM1Fkv
	YU0IfP/FnvyHvmpwbq2M+kCo/3/z7bbLUnCEo+wwo7Xsp1Y/TdmaCeGQWUIBV64VjgSIvhsuxvqx/
	SzpznI//QQ/1zZLEBjOyAqMoVveoSnFFmJ5FwUI3kOBligpBiDkWnMw3LzC411ctBnt8Ozf9eQkeK
	gOHoKHIsU4GbffsBop0KJCDEcuHtTiypnobBXO01ZBsJe97L3j/B0uuArQ/yloqgmkPWK2Bj66Wp2
	ebSpDjsw==;
Received: from [2001:4bb8:199:60a5:d0:35b2:c2d9:a57a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rscjQ-00000005ONX-06Dz;
	Fri, 05 Apr 2024 06:07:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: remove the unused xfs_extent_busy_enomem trace event
Date: Fri,  5 Apr 2024 08:07:10 +0200
Message-Id: <20240405060710.227096-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240405060710.227096-1-hch@lst.de>
References: <20240405060710.227096-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aea97fc074f8de..62ef0888398b09 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1654,7 +1654,6 @@ DEFINE_EVENT(xfs_extent_busy_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len), \
 	TP_ARGS(mp, agno, agbno, len))
 DEFINE_BUSY_EVENT(xfs_extent_busy);
-DEFINE_BUSY_EVENT(xfs_extent_busy_enomem);
 DEFINE_BUSY_EVENT(xfs_extent_busy_force);
 DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
-- 
2.39.2

