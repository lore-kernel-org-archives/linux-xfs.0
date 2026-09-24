Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286F83955FF
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243884; cv=none; b=QZMGkBQabkWMpHIg63wD/o653Bb5DXf4DPwheuzhQjN4gbDU5EBsz74EIg5b2nNjEtoKSzWZr1/HMhI1OHK26iVt4MCDp75esWGag95NGC66iP1DcM+Y3Uc9RUHU7I5Fpj5EmOP/xE56xaQywgm3lgIsju4hpVIubokQ4h/zQR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243884; c=relaxed/simple;
	bh=eWPm7BAqVlEskn2HuxhizDInN59eFGG1zvXdSAcDOQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X4klDfjIi8LGRwU78GAE7T0NpFJL0tN+FZHOEiVUkzs8YKDl/s9yKFyd2y15nWeqvpmUVGpGct6z2DUVdRlgvyKryZR/Y28jXvnn4fELZl/syTcwIVCwLBgprxPWCLjSvNTSN1TomYnhyYfX00RC2sJ22tt7w4VZMJnOvrW5dzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xZobttmD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xZobttmD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=prWbv492erE48CHcKSukRo3z3v1M6UR8xp53YgDDS+0=; b=xZobttmD71hSpF1PdyNS6SeVsi
	4P3Xzsq/qS7jJqbgM56AOip34KX3jg5Mq5E6QDMc50M/v6y7InvetRQlkATsS1p8PyiJIRzqsjEN2
	6323izzcaBj760Er4GK5v//2uqfJeRfVwswZigygvGDhA/CBSmU/BMy5y53D3/+EWU/NSBwCurgfC
	HNwOlt/ZrdXwu8daqPFe5CX57840kp0TDWVc65diCpeom5yV63SjiXrfSrcSX9Vz08A8NH/15UROg
	gnhgT2VjDuwKoWaIgYjbuug2AjN8jGDt4SrJhPCGgXnuYmRwgnYZ3UKbVvnbrUhZPTyVc8Pex7TMa
	5L8X/4dA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gD2-0000000AeM9-0KuJ;
	Thu, 24 Sep 2026 09:57:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc cleanups
Date: Thu, 24 Sep 2026 11:57:01 +0200
Message-ID: <20260924095740.2732474-1-hch@lst.de>
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

this series has various cleanups developed as part of the data checksum
series that should be useful on their own.

Diffstat:

 libxfs/xfs_rtbitmap.c    |   79 ++++++++++++++++++++++++------------------
 libxfs/xfs_rtbitmap.h    |   45 +++++++++---------------
 scrub/rtbitmap_repair.c  |   15 --------
 scrub/rtsummary_repair.c |   15 --------
 xfs_ioend.c              |   81 +++++++++++++++++++++++++------------------
 xfs_iomap.c              |   53 ++++++++++++++++++----------
 xfs_verify_media.c       |   87 ++++++++++++++++++-----------------------------
 7 files changed, 181 insertions(+), 194 deletions(-)
