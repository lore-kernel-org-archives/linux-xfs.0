Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24C63E3D95
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991820; cv=none; b=oXM2Hu0cKxZCk1M6Saorm/FQB/diaVkM83hRwbrJTAl2ev3UhKESB6YKHi9YwuGBnTLqYGOE7nO0UwGJ53IjcLZICD1aP04hORnBI6xBRLUNMCt0jA+Ozv2ISZXHCpnxUm9mm3QqNQNlAknZ98Lgydp6WYPjGi5s75DmVF8TAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991820; c=relaxed/simple;
	bh=Uox7hENqOtf9y2Ld4xuP9GOLJmvgjSW06zw5xNKVv4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VyvXpUxr6in4tAlJ6rbeXv0bqwA8H2xHp78QyOkZ2NcT7+kcluIL0PQgnW8ZIbbCI6n0XPdLZmBzVerGjaoQ7SOGBc9PhrbVsQSphcbOZp6k62599g7/oiUWdyhV+3UO6eUnqeMcHYQpGpVi/MN4tVGY5BTebiTd2oEf/iNzQm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fZq/bQ+b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fZq/bQ+b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7k/QGKb0Zyuqpqn43VKTr8mRy6L7PFAXc1HipmlPqJc=; b=fZq/bQ+bVc8EFpC0ju3WWPRmDy
	PghGRz3nLN1++Uh56cM/QIg4mDxwBUnhIJKSwVeatTlrhM/bjURoSVmaRxBV7BNR+6M+VDWaPKO5N
	0gP6e/+f7TmG5RyLIhUGkPlxPvo6QCLCpnmXL3yvBFrnoLxELcvBu/2p1FEV9TxHTYHNl+i15qt0h
	JOLAkk83YlsqOpN4iouz9ZrHCBlRK1xJXQCordjdxXfUFFACTaqDdqwjJ381S9k9VrYP8Mu57Xddh
	sCZOtXI0EEGlE6rgGlNgdWCFCaEL13qLc919gzTNy+5/9iIDlvq2lJ29bNvdJcMERCczb5OSstAd7
	55vA4jTw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrKU-000000050yv-3Xno;
	Tue, 09 Jun 2026 07:56:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: zoned growfs fix
Date: Tue,  9 Jun 2026 09:56:40 +0200
Message-ID: <20260609075655.1698743-1-hch@lst.de>
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

this series fixes growfs on zoned file systems, which so far has been
completely broken.  A test to verify it properly will be sent out as
well.

Diffstat:
 xfs_rtalloc.c    |    9 +++++----
 xfs_zone_alloc.c |   11 +++++++++--
 xfs_zone_alloc.h |    1 +
 xfs_zone_gc.c    |    4 +---
 4 files changed, 16 insertions(+), 9 deletions(-)
