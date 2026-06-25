Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53A9345CAA
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395935; cv=none; b=KODXT/hg1zNXZ6eJ0yzkKeroVl6GlIc0HpWuhuAT4lAdOX+sOY1nPfROn6hahtdv5UebvLCTcZWVwpLzBI4LwwCODrhNhFYhi5QXZhSsYIaCn3F2ruF3RUF0xoXWAs+iLZiAfQF3ndF95805vCO7njcuQIGyjURk4cYshI1oVEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395935; c=relaxed/simple;
	bh=oCaWGhPV/DxiFiamBIjl8i4aAKoNIB9PXa4t3L0aO5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J4XwWg7Js3D9XKgl+vImjgBMB+/sl3uGDIhpjFf/DHOvYOvGGgRu43UmY0vB/LIhstaIR7xnZ8IUhTQYkzqsoU0bMK3ShpCMGo+tmPhFVAfYEKAp5gy6bMcJHhst0asPUFnTpOkCKZTYRD1bREpWUePj6ZaPunwTssYTtB9bRio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0YV5AQT1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0YV5AQT1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WyFMvA+QcKxRKRepPQLgNo5ZpE2bPCJ7PspIG+f1qzM=; b=0YV5AQT1KHuSoTV3i+ityz1B3B
	763TzevLz3L+M4O69+3QxV8hgkyEo1asqpBHo/8iVlKUsY7G4QpZTaQEjHTCIEzfKvML0EuSw1DG5
	8ySJeYYCnZC29jdU924RB1d88bK+uRJCiCSLoKKZHLSFOenQ9IVtX9aFJ6gqfSYvCGAR+Yv0zklpw
	cpHHBlkmm8mt2GXv3ICWAPeYiGn4ef7/6kGN2ewDkbwgFQrMqYHDC3YnDb5GEDemo7ESQwVSY8aOM
	Q7GcxaI9t6NjzjqCgXzZSJAz4/6EjeSr653GLvFiVNGBxGojYls2w1bZ2f87FJFr5t732tM6GX2PR
	lBK12NqQ==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckbU-00000009GqD-1wZY;
	Thu, 25 Jun 2026 13:58:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: xfs_buf_submit error handling fix v2
Date: Thu, 25 Jun 2026 15:58:30 +0200
Message-ID: <20260625135849.2494779-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

currently xfs_buf_submit can execute the endio handling twice when failing
for a synchronous submission.  This series refactors the surrounding code
a bit to allow for a non-hacky fix and then applies that.

Changes since v1:
 - fix a commit message typo


Diffstat:
 xfs_buf.c      |   86 ++++++++++++++++++++++++++++-----------------------------
 xfs_buf.h      |    2 -
 xfs_buf_item.c |    3 -
 xfs_inode.c    |    3 -
 4 files changed, 46 insertions(+), 48 deletions(-)
