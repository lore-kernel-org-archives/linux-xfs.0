Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A51F5CDF1
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031008; cv=none; b=rOWCtwBfNBILw3aBs1ONUp+Tc05ByPPL1+IvHn/ayXwiXLCdGh52SqTrgNAK+/9dPCWrJMoQrA2iExvuNmFcYhtZIjlNtRC/BuhrSqaH01Ct6xsbTmjIn9muQZ9CQa0gWp2toQaYC/10h9fCOcd8KY7gVH4xtS2SlK3/JfjA1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031008; c=relaxed/simple;
	bh=pnPfYnon6J80uqfto0WFyN3g4Yr8tmpclz+oQ50vqpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mMTjSKS6eL9Ll2McOBpZ0geLQic3dtrxRBe3rfIFd5enbZWvJW3KUKxUcaoH6RGuoTxocSOdkQv3u2LEgYDQZoSxGCWSpDxkTnGlQKXQ+Pb5W7otQ9/NyKjGYfpzpdIQt0w4cPedHdxT5+Ja2VRNlbTrYbgYGdXEPQw09ME/X3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O9TJ/cAP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O9TJ/cAP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=FC95U8RK7ThH10PFmmOXlerVioZlO6iFMdy/CE/f+6o=; b=O9TJ/cAPrU5BTgwN42N7kCTX0b
	SHde81HxIWgMGqGVgFdQaXAdL1QRWZ5pzCwGvmhSoVwYw4qh/NpHv1N2eQ/LIqWN+GG5yFzOZ4Vg/
	PVB66zvkCTXRtFvroutnUMY0RHWdrzIFqm2bJRFdHOd4gOVIKbHMcQ7PDzDflYTbhAtI0ApYJEf0P
	E8kKZWSjnVZE4gQwnZTHeonNwvYhy+SPLMouwbD7wyEcC1Mo2gq6jyh20ombH9OdPN40HOEedJ/TW
	lxMseZQ0wpfLM2LXqiU51YQSSSa3vD02wi8/h6EoJK8fpZtnTnGfBiYMX9omYaeDfSlCtaACIhn+u
	FG6OVM7g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyWAo-000000080Ub-1Crq;
	Tue, 16 Sep 2025 13:56:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: kill xlog_in_core_2_t
Date: Tue, 16 Sep 2025 06:56:24 -0700
Message-ID: <20250916135646.218644-1-hch@lst.de>
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

xlog_in_core_2_t is probably one of the most confusing types in the
kernel. Not only does it describe an on-disk format despite claiming
to be in-core in the name, but it is also has an extremely confusing
layout.  This series revamps our C representation of the underlying
data structures so that they hopefully make a lot more sense while
killing off xlog_in_core_2_t for good.

Diffstat:
 libxfs/xfs_log_format.h |   38 +++++-----
 libxfs/xfs_ondisk.h     |    6 +
 xfs_log.c               |  181 +++++++++++++++++-------------------------------
 xfs_log_cil.c           |    6 -
 xfs_log_priv.h          |   27 +++++--
 xfs_log_recover.c       |   45 ++++-------
 xfs_trace.h             |    2 
 7 files changed, 131 insertions(+), 174 deletions(-)
