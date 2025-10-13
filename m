Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868A9288D2
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323356; cv=none; b=ULhgj5K+1XupsA3ScToMrBSdEygSPp0PGj/XV1ompCwQioqCGxNcBoafN6YM/jSpprkVddIRRW/h41zLQrRucvktIZEHtxuaUx5NWUxjX+xynQOPT6GN4F1xSGBKR9lismkfxTFDg20RxYhYSzXubL9zh2dEIonnNZblsW+soME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323356; c=relaxed/simple;
	bh=OeH8GFoSG64xnFNPgRFw7bCY6MKC2k8QjCStCiGHlak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lp+Z1HEmOOgk3RzbBSBAqsRWt5fh/uyMgcgSxQrW6YQwmVj12EdYd3WmOAWZ4/GaacVlOzCjidKAtqKU1mEN2gfjLqaKmzfJd4/ncMHNP4Ig4TnAOA6qZlz3tNSX7ofbMSm9VbH86c4OhQ8UMuRSD7Oq1MPKM2j8gpevDVYtVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1+KVktrR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1+KVktrR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=O+IkJEvVkugKZfmYN8nI3Wo3if3wkqo8X2I51n6AG6A=; b=1+KVktrRYtfBN0StFBTg7FeqL9
	kcb+cqqIHu2K1r9X3QTrXLdKXuHRElZa+FWxFmbPvQ/ZCjdhz8QSEGJdNRdrKqX6C37p+bUc4XLdw
	7xaO3fDgEKfMuyfIJEaDMGG01LG8wYQlKSHCnnurf6ZzDSPYSp1EJLX2tu+zK4HJaFoLJywbepcav
	0hFc9WYP4VQ/xJmztLmmeLL1mNWIA6oUfELnJwrFh9rGJbl7akZScM/5jqSxA+WbOTfG4IL020hL9
	3aRcd9Y+4shDBARndRdnI2jt4+jEJuoRjBpOjiTOhN6tbowt7saW2P2Zkl3SyJSYpy/uh5gJKwgos
	YcsuU8Iw==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88W8-0000000C7Ey-1m92;
	Mon, 13 Oct 2025 02:42:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: kill xlog_in_core_2_t v2
Date: Mon, 13 Oct 2025 11:42:04 +0900
Message-ID: <20251013024228.4109032-1-hch@lst.de>
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
