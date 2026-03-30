Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB71382F15
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849283; cv=none; b=WZLR1/vPVCSVTQQuswpiVmxbNaNYxZgQ3j+ZgiDWHpJLmH9OQPXL03fWObOX1912mBJeDqkWLFZXFZ48neuGwgljOUaWooedj/P+x0gugCzlRS5AmJrU46cr9OC++WNHCZmw29aiS6TB2l2G/uaLJNBgQ8Qf2MYRJ5yj9U3VZYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849283; c=relaxed/simple;
	bh=gSS889gF8Z07HWOcdHcM93tTCFA4CYPJRPMkACVpCyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEzldos2BNezJXeGBHpizc7H64oDnASnNGrMbMjtRCN2YKBptq/dYuSpvNJdGCJ3tHlMQAKsEYhMdzda0WGYwDRAX7lqgOjhG+UHxuLXve7deSirjbzddCuSiI98xCGHs8bSo4Z3ZDbzjKoNLvskhscMdswqtcBL9Wbl3tZvnYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MS//03Vg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MS//03Vg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+SdW1o79hv9mAKcZQCHmQ5kmwAdq6nM8nDlML7Dy2ko=; b=MS//03VgBnELL7Rm6Q5Z1ZhhJL
	TqyQFZB+FbDKetCOA+6X9QXaM78iq8Nt313ROGqMJXtUldA4NrLgGqYNsWSFpMubcBW8wtBBUQkrT
	MiRpOVzwClNuYFD3eKDkyRPHp9UXT1waa85sxuPnH22yREBP4TlX/sigKiAq0F5gJykvDKhkkGfnu
	xmX/EHr0ecUHHDvDGaRyhyldEYU9UtNhp0GVkonZQ+iGT5FLHcfV35E7VzmjmskCsFJD+hs5ISyA+
	Zlmtie1YLwLfSe0m0Ywj+isHH0iqp6KYynIjkoY8+lbwdhTcR+9i6lXVpmF53h+EBqs4lTR40pIS/
	xISRk/dg==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75NE-0000000AeO4-493k;
	Mon, 30 Mar 2026 05:41:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: fix handling of too many open zones at mount time
Date: Mon, 30 Mar 2026 07:40:56 +0200
Message-ID: <20260330054111.3855818-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

because there is no actual write pointer when running the zoned allocator
on conventional devices or zones, we can see spurious extra open zones
when the last blocks in a written zone have been invalidated.  This
series adds code to handle that case and remove these spurious extra
zones.  It also fixes up the mountinfo code for open zones to be
more easy to parse, and adds a new sysfs file reporting the currently
open zones, which makes it easier to use the value in tests.

A test for the open zone behavior will be added to xfstests.

 Documentation/admin-guide/xfs.rst |    4 +
 fs/xfs/scrub/trace.h              |   12 ---
 fs/xfs/xfs_attr_item.c            |    1 
 fs/xfs/xfs_sysfs.c                |   13 +++
 fs/xfs/xfs_trace.h                |   12 ---
 fs/xfs/xfs_zone_alloc.c           |  128 ++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_zone_info.c            |    8 +-
 7 files changed, 136 insertions(+), 42 deletions(-)
