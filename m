Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881093D333D
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540774; cv=none; b=q1XSQlxSRudfne9hy2lIIVk6dkPP9vQhuZdd6OUQPA5YFhTV6KfHhWl3OxPasm7gipRIMSffYOc6JR03e+zAhZ3+eswXn3lVP1NncyPeQuf3ORHrqP+sz0Xyix3Ps1aGxV+qGd94EVHzMh+HDzBXLFwEbl45pfAcx+afBOHtuhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540774; c=relaxed/simple;
	bh=LMHhDnvJMAPhDR4ZTNGhak0zm9BTlWbkUPsugCRwIVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=joM2DcslU1U/TQLQrdHDKOI2kQ8cngP9zpF9D+zVnGdwGufWaKZygqb9K8Hz9eKqJl6n6AY348JZ/FPQQ7RvqXlpj+TlqlmfRIoB1YXTKshbQu34r2n5Y5HMoijkwXpXtmTNMsKg7878TVtPse/QnrixDfZN1dHh/HjlneroGt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fuN23trh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fuN23trh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ehnV0E3Lagp6NQ+RAEriV70YuTyRxY5NJgm9xEu/LF0=; b=fuN23trh6+YrSYewzHh3DYFGHO
	Bo9sMLaMAulBa0YTpW4g5+CP7hMEVeGo9gvZO/yMfDxiefJiV+N4pDpLOIbHN53aw20JtLcrlRboe
	3a1Nkd3zqT7SPqLDTkCxge9hpPZD5F3NzblJAJ+43kSe6G4tcofu0z8WVwXja2BxF92S2DIt6Ga5h
	NfiCkEmd96u3qtsVmyaX6YJ1zvIsvmMg0kRH/gOvyeuRFSpr8GAZIkFruaS7nGAYrMANx3amesGbC
	QGLRsb6TT/p7zDq7pUEwF4mttzSL8CnSmAR9wDa5TpuvBS2SJc3yfLp8iqZmOUKVRVN2Rl2rYE0wp
	lYLC0LzQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZf-00000006MhJ-2Q3w;
	Mon, 20 Jul 2026 09:46:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: improve log context annotations
Date: Mon, 20 Jul 2026 11:45:37 +0200
Message-ID: <20260720094609.2191633-1-hch@lst.de>
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

this series improves the lock annotations in the XFS code.

Note that right now this is all mostly unused - the less stringent sparse
lock context checks got disabled when the clang version was merged, and
we're not quite ready to enable the latter yet due to our conditional
locking in the ilock helper and the locking contexts transferred to the
transaction for the inode and dquot locks, but I'm working on that.

In the meantime having these corrected at least serves as useful
documentation.

Diffstat:
 xfs_extent_busy.c |    4 ++--
 xfs_icache.c      |    3 ++-
 xfs_log.c         |   33 +++++++++++++++++++++------------
 xfs_log_cil.c     |    3 ++-
 xfs_log_priv.h    |    4 ++--
 xfs_mru_cache.c   |    2 +-
 xfs_trans_ail.c   |    4 +++-
 xfs_zone_alloc.c  |    2 ++
 8 files changed, 35 insertions(+), 20 deletions(-)
