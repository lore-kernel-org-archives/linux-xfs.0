Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB1A426405
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 16:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466969; cv=none; b=k7eFQSXNnio2xgtb/eAoOrAz8q2OlNSuCPjiIGmBhbgBDP/x4FFuWZieYMXDHJHf4QbK9QOjamc3hVJ+UBuHRPjidHr4sHiQEEmncb3klkb1TRE87ArATRvya+GNbXAK0qMYq9hdcML6GabblgPz4naMdefbVrbfdMNJy8FkXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466969; c=relaxed/simple;
	bh=HJnSe5S+KOO2fW0dSCyNHiu14YGqkB9kJYHddTzOSx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYBFxSy6IFCHXtW0t/zlLKho7ydawkKWDRdqRxuUJk4/IhFQJ38ozdz+zczskhMhz7+BrQ5QeG39RxL+wLkS9yjF4C1ZePiGXPy8M9ioszKVgE/jB76OXDSFp2GQu+kpeqgQZTolVI1XSWmSE1FP8vKU/YtURc6L2Dx+egoGNdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3pr1QRIk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3pr1QRIk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uimOoeItMdANRCF3bCs0osIS8FpBTESU6Cff/bFaKOc=; b=3pr1QRIkTO2/Hmbcpu9Z99dcI9
	1nJF2ejN3i7t1LWxch5Mc1yImsYlXJC24SjA0cjTOIsmpybCWSyGoGJaBXg838pkRq6XAkz0axhPd
	GCc5J9QAleCoNCh3uzbMGUclbD7KF2Vg7yTRlq0fJwOx6yvYgkOr61lf4TBD8Hg3L40bWFharoNQG
	8kYVmbs4X24+lQPPD3X6T1FWawRm3jXp8PxmTIcySOwuO1pyg/QThKhaD5rg6lzqunZHbqVyUkdQu
	Esp5wy2vqPObaw6rDh/dxLW0zY6kC+N5IGxZZPRE4JBSHWF7tc2e1KJDEQ1DPZUBCk/Uyg9MnKZIG
	XfhNO9YA==;
Received: from [129.253.192.68] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtpfI-0000000EYIk-33nq;
	Tue, 11 Aug 2026 16:49:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: zoned xfs updates v2
Date: Tue, 11 Aug 2026 10:48:36 -0600
Message-ID: <20260811164912.124416-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

this series as a bunch of zones fixes, and a trivial code movement to
move the ioend code into it's own file.

Andrey just sent a basically identical version of the third patch, but
I'm including here as this is the series I tested.  Feel free to take his
version and take my indendent reimplementation as a reviewed-by.

Changes since v1:
 - fix a commit message typo
 - clarify the reuse of an old zone in set_zoned_cached by better code
   structure and comments

Diffstat:
 Makefile         |    1 
 xfs_aops.c       |  188 -------------------------------------------------------
 xfs_aops.h       |    1 
 xfs_file.c       |    2 
 xfs_ioend.c      |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 xfs_ioend.h      |   16 ++++
 xfs_iomap.c      |    7 --
 xfs_iomap.h      |   14 ++++
 xfs_zone_alloc.c |   66 +++++++++++++++----
 9 files changed, 273 insertions(+), 206 deletions(-)
