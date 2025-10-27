Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59362F5B
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548775; cv=none; b=VpZkJxxeQ8rUmcqUWZaQhhc7Y7crUukhNg46rYLXIWg6oEgpacJdwypzy0c0hfBtzXBGs4BSyrGqMasJ+U4W3FdVr7fPkK0n8AolBC3h9yk0VY+luZtrTcqCwQk+2Dudi4MiD3Q5d/Jo9fS96qAwmMQwzpctdUdzrGcX6KziOog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548775; c=relaxed/simple;
	bh=AinVcIN8kYwF+Oxm03faz0qsuZ7dOkgEqKIoNXlUDmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ItcsHkrr24T0X7JAwCft/R2L7NQJ8Ax966/xRzdc1tEAIpLRz43NXHPSbVwuUFyqqfDXOmHdoELVkj18kUCZfjz0u6X4wQCJVzvs+HrydI4ViEZEiI4Cg/iBvZ2oOR5q4y3lMfsjbdZRLiaYYT/Iz51pKen1ruLNTVVwEt0y9/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FFK0lCDm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FFK0lCDm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CO6sDGRjgoGOYAY7o41ieQBOuUY+fyWtV7WG9XuPUEs=; b=FFK0lCDm0PGR53xDQGIZh8tHgc
	Yun2DOxmk4H9f8ddWGqoQNNRhOjJFW1aPdeqB863pgrPzePo/G/rU4tn14oElUQIqhTeU8jF+PyPI
	2J79IQ2zC7kH+2Uy47jHiByc+1thNQOIGOtSXW5yD4UQBIMiRblB+7fTW3LC62o7SLDjpJtRrMbrg
	Aw/qop7bMQDpL7pvuv4tVFORjdATH2c2i5+gLRLx/xO/zRhWY/QRukliQLgsplsug1hndxgCHwkwa
	kB8NjNGIwpWrBtQm9xJEUf3cfYIo+Sr3Da1/iWP/WLVh+7IMUp66uFSaWf+PqAfJ2rnV4f+JBYOGn
	uiDM+Htg==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHIz-0000000DFfU-021c;
	Mon, 27 Oct 2025 07:06:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: kill xlog_in_core_2_t v3
Date: Mon, 27 Oct 2025 08:05:47 +0100
Message-ID: <20251027070610.729960-1-hch@lst.de>
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

xlog_in_core_2_t is probably one of the most confusing types in the
kernel. Not only does it describe an on-disk format despite claiming
to be in-core in the name, but it is also has an extremely confusing
layout.  This series revamps our C representation of the underlying
data structures so that they hopefully make a lot more sense while
killing off xlog_in_core_2_t for good.

Changes since v2:
 - pick up reviews

Changes since v1:
 - use struct_size to calculate the total header size
 - add a patch in to kill the last remaining struct typedef in the log
   code

Diffstat:
 libxfs/xfs_log_format.h |   38 ++++----
 libxfs/xfs_ondisk.h     |    6 -
 xfs_log.c               |  206 ++++++++++++++++++------------------------------
 xfs_log_cil.c           |    6 -
 xfs_log_priv.h          |   33 +++++--
 xfs_log_recover.c       |   45 +++-------
 xfs_trace.h             |    2 
 7 files changed, 146 insertions(+), 190 deletions(-)
