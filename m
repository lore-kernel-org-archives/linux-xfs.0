Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6330367F40
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770041711; cv=none; b=ZDs95cmGBS1LdQJaiMGGjXHKO2NtxD7kXSpD7pYncvY2TiJj94HLiCvFWa7qUlvhnIYVJzXl8iAApHXOhvS7yhFym9gVfWriR2Po2EzAA+rKuAB18C91d5rDtFkce8Z4zMHrznkJfjOpD8aE7oJWcMTeYQpVM6qrVVpRQ0vH+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770041711; c=relaxed/simple;
	bh=QpGHeeWF0V7cCj2YfkRMuy9YG9RKF1qsshjWkZ3NPPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bCnJcTIhUkKk5dYG3rAnS0mao/QBguB5a2WommTvYZoqNnz5GyQRtxhEBUUztz90O3q60S8B7fNWK0gnX/6Iq+esrRHMH9J/Ld/hMT8ZuwaZ+a4c1xpOgDsatjBPDI+bkFPawdN9i2mJUItIEUpHaKJs+YL51rzLL/mejWtWVfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E1eJ7Aot; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E1eJ7Aot"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=psdP5vkIdg2CeN/jj+7urDeqJ0RTX8DiC8JJxS0qSbk=; b=E1eJ7AotkwRYdPwLWzylhcSNBy
	kMBmUqyesuagZ/z2eElUM4Q2Ps86m1XV1evCJoOgC2CMtEqc9GRhTfCL5EtMzROeby8f8KGZLrnDP
	xa4CtYMLSUUqs/N3NWbutIcNBB4AtUt6B1ziQDdPDVCcPmw7/O0sfZCjtS8MYtXV353plfp3gj5rK
	B/P552kQfd0VwBY3SgpVVkS8K9IoMS62lBWokgagJ8L15Y2Qb0V5K+oaCfIJdQwa8wBxs+mHoBV5Z
	dKOdYJf3QIaiDKgm0N04pndERaw5xGgx5VJ8jr26HQ0/QnNjSBzeRfCypzhg0oAL3p6OR1ZhfU1g/
	qCdCIHQQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmuhm-0000000558G-3mPe;
	Mon, 02 Feb 2026 14:15:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix inode stats with lots of metafiles
Date: Mon,  2 Feb 2026 15:14:30 +0100
Message-ID: <20260202141502.378973-1-hch@lst.de>
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

the second patch fixes the active inode/vnode count on file systems with
lots of metafiles, i.e. on SMR hard disks.

The first patch cleans up the counters a bit to prepare for that.

Subject:
 libxfs/xfs_inode_buf.c |    4 ++++
 libxfs/xfs_metafile.c  |    5 +++++
 xfs_icache.c           |    9 ++++++---
 xfs_stats.c            |   17 +++++++++++------
 xfs_stats.h            |   19 ++++++++++---------
 xfs_super.c            |    4 ++--
 6 files changed, 38 insertions(+), 20 deletions(-)
