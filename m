Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238B2E7628
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 09:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989565; cv=none; b=LWG/SY8knzbqbZVXsXh+SxPVdtIC8D4GArU6Tl2w7fZM1x5Z4G5fMWN/pGUphzplhDKRLLL98/EV+f/WRKwg52hVjHE5Rlrli6BnxIoFn+yNlqdD5PyvMYyUAI0xQKXEHuz+p1PiC91zjvL6obm0GTr3qwUycWBilO9mQ72I3ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989565; c=relaxed/simple;
	bh=yZl5v0wHsynIZAX6yv+TT1tS4LeP7tblhHhrFoK/UHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7viu0xqzIHRPuwkGDiv1+9COAq04NTGKv3B8o9v5ozwwE8ESE/vJ6EppwBX2+JugL2G1y2dRuwWjxLNvK9k7f32qt5Ge8dofxyKY/cJDVtwo7sAALXne8nG+G2ZEwul6hprBmDMErYNRTEe1k/EQSCCY92tilfFFBFymqgDUIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V3OlB4D5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V3OlB4D5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MHoEzAuel9A+9Xiu9W966ecS99BdyzvwvEcy7kFjTy4=; b=V3OlB4D55TO7LBnqZqiDoPWXn2
	FnppsaPdlpelkFrMN2+ORTcgORbng9g3Zp4XwivNvPwWr9AW8Mby0RNIbmRD5IZdpyLafxX0PnN08
	FKRlFQZa2XzLm353ZvZkSL0/BvnVMQlHNxDfKVCIiDzpMia+BPP7cDL+MmM1d1u4jmjVSEl2Kfzn4
	mNA0JTMQJYk903x86fxONjQjtUwBx7eLE7HXKZCgHg+eL0mJiMJXUH9idjPoL9h+M1TvXDI2dKDt7
	XtDrH2fJpxC6n5NBCH7pEl48zI/COewgo2bl+C5iNkI63xWr1wW2aiaiEnde7XRlpi5NTcvhAeg1F
	7txNS6jA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulkxG-0000000AKMF-0rQh;
	Tue, 12 Aug 2025 09:06:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] move xfs_log_recover.h to libxfs/
Date: Tue, 12 Aug 2025 11:05:37 +0200
Message-ID: <20250812090557.399423-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250812090557.399423-1-hch@lst.de>
References: <20250812090557.399423-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_log_recover.h is in fs/xfs/libxfs/ in the kernel tree, and thus the
libxfs-apply tool tries to apply changes to it in libxfs/ and fails
because the header is in include.

Move it to libxfs to make libxfs-apply work properly and to keep our
house in order.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 {include => libxfs}/xfs_log_recover.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename {include => libxfs}/xfs_log_recover.h (100%)

diff --git a/include/xfs_log_recover.h b/libxfs/xfs_log_recover.h
similarity index 100%
rename from include/xfs_log_recover.h
rename to libxfs/xfs_log_recover.h
-- 
2.47.2

