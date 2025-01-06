Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89D31A00EC
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157050; cv=none; b=IlDmRm45S74KZhMDOtftYiQIzLC0biYudA2jp2C6ot2mF6oYfSwJhydFltas8NAK7PQ9AvxiG80yj9g4FQpls+M3oY0ZjsevpTtaadWt4kn/a4tMLf5tdnjFIk2q1WeghLQcAGdfcloetpE7CjmSSvXCaahtRVPqIw6hHEk5KgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157050; c=relaxed/simple;
	bh=BVkR0RDQf8l0IccJizlJQpGvuHL8LeotCouPYCFqHzg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NL7anPwo5sZwrnAlZgYAvJbb7M4MhyTz3ippYIno9gg0HuubAzFG9h2pBnLrr/uKoiQbcea/4846+qZZF0piJ3L6t2GmrlQo2YG4hrL5OqtquBYfLYyDlKBqS5oDdI3skLoWtCCy6NW0QRNmOdE+3JvvIXVzUq+Yx/pXJKcdLWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qmlgMSGe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qmlgMSGe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=J4vri3Jch7zxZddEaG3434irBMLbZmeul6Sks93ms4U=; b=qmlgMSGeUe+Z+h5VDiNmtaOa2J
	dcZ9o17Pt2XKsaQhTS5LkJQxv6IQbcO00LYAe4WfYLIctLoPrcY8ysG6UUx8oCDxuTka3XAQ5DqCy
	wro+y7m/gSB4an63Dda+VdS0LtqncO2JI7vbfX2eeRyCYMJxy5Vql4lWXr6qTWyL+XWd3jmLhqFmY
	CHouXZvXIbc2UUpy3lATqEf1G/bQVifr6+bMg9dMvEEBTp73G0/tCfle935X2cN1H9LTAymLSXHgb
	IU3Twrf0X7h70kh8WDbq6YqxoLR4K6H6JlzVhWQQIOAvZa8Vgx/OVHNYObtEy5E6a+r2pTWV1C161
	CMRVVv/A==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjl1-00000000kCO-1KKx;
	Mon, 06 Jan 2025 09:50:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: trivial cleanups
Date: Mon,  6 Jan 2025 10:50:28 +0100
Message-ID: <20250106095044.847334-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a few very trivial cleanups.

Diffstt:
 libxfs/xfs_dir2.c       |    6 +++---
 libxfs/xfs_dir2.h       |    1 -
 libxfs/xfs_log_format.h |    6 ------
 xfs_trans.c             |    2 --
 xfs_trans.h             |    1 -
 5 files changed, 3 insertions(+), 13 deletions(-)
