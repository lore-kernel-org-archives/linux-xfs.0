Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E2D2D47F6
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942452; cv=none; b=cBhup4UwX9mYK9IDV5/GfT92+05dl6OEehyZjB9tc06dnh1oxJJB2koK6W3aajVbM1d9xAKgqLsVzytHXPKUrW1Ueb4pqPjpNen/gFNGQzxcqhUBS1jcngi2k1HP1/HYRd+mGy4vBI8/5bWs8mi0ijFWiQ51/nn3aX1cdHxLyFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942452; c=relaxed/simple;
	bh=FgdDZqjl+IO49eYAZNTtqu3FhZviiuSzZYF9okoomvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X6g4dBLE1RW3/wYF+23bHoyGkjfqM1YzmLrSjzdpARitT+Q0c1ALgT7STCYywbhaypHeuDKO3CBugvyVaVOvJ9l8a5PX8vbUC8lssyibyyndZIQdJ7S/aBmXCSyztYRMmNqmUzNkJpQRTzY31Q0wrTPfKAfenGzRyUDa1XST5IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JpjH0IHh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JpjH0IHh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=GClh4wWLJZMl6dL+r0qb+qeKLcM7Js/Ulomlkr+tqoc=; b=JpjH0IHhy3cbVqhoL2gjrivzwE
	aHsGrkmEOK/EllFxcHq1KvFAVBzIazUWuHwUSqArDR9dG0BHl94RvhQLw+8zvl3pi0ibinddVWYFA
	luEND4BRVBLoqTlfL9HX3FoHCDioIQg0mi6T5TNKv+wUOd2Kx7E6vWOEArO7IQUJvmG9WVlHTPQxk
	tYoa0plgli24G+o2TTT+FtnJ6kQOFuk96NKUUx9isGWrPXEVFkYhPzUioEaeS+h9PsYidIKcV7q6F
	dnjmeERhwbylE3Bc2Q6U+mZ7VaApQzmxQhPqUkOasAaxbfD5he7COIcF4xynDL8OilnFH/9eqgU2e
	F9jnERtA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy98T-00000004IMF-2Xm5;
	Mon, 15 Sep 2025 13:20:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix cross-platform log CRC validation
Date: Mon, 15 Sep 2025 06:20:28 -0700
Message-ID: <20250915132047.159473-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes recovery of logs written on i386 on other
architectures or vice versa.

Diffstat:
 libxfs/xfs_log_format.h |   30 +++++++++++++++++++++++++++++-
 libxfs/xfs_ondisk.h     |    2 ++
 xfs_log.c               |    8 ++++----
 xfs_log_priv.h          |    4 ++--
 xfs_log_recover.c       |   34 ++++++++++++++++++++++++----------
 5 files changed, 61 insertions(+), 17 deletions(-)
