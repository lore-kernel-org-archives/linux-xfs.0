Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CDC1EF39E
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 07:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742457153; cv=none; b=fQa6PrlKo6YGRGsYe+/T6SRGW5cU8XXrAOAKi9Qt4ygAOo7j7awpDce5UEtrcZ37bx+JyPfXGw6tvkgtRZ8kdke6ZNsrvBtfXV/NIDsHpi0oLg5iQ77+Gm1h9lxPxtdhB39juBYscNtNovZ3TQU8nG8JDOjzdRBcXe1iRK0JJJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742457153; c=relaxed/simple;
	bh=qwEAvz4eHnvDy3mjv1VdrwDIFnUYDXjuQP/Pr4tEQgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ehvg1+P3taTlFQjFFVFybnXpDhGO/MaBy0omqcF+oaU0lldKcklFyBNPt1F6R4XhhwrZa1MJm6jWpSz0bxocSFfyNs/YR0Kw4ETlevgI4N+jKtzIxBmGZbcpUIVP1rGrnAHSqI8MV6zjgqm45b/Hyf6FoAP3MxLVAC4Ia5Z/IJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yUDciL4k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yUDciL4k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=eX0ZW+CahAbWjUwPrBMEiZ+Jj5NPb9a0b2QwZNFHjQs=; b=yUDciL4k07IKEQR8OT/5r0RGA+
	PHTn+79za1/UtWHD+XCIDEUC1aRec8eCz2S+va3X2B9jsdP2WrPBw8HfmYd6YwjBCIRnJLVrTmHfY
	Sf/WQCYFYY33f7tgD/aO89rYNX9ozidF/Ks9VkN0dgBrkge9kxcDUi6FPn/rpmOZCiyxmDcq4+r0s
	Do3nIAXdtzCiR3e3o9XIOes3Xpm1s7z30CPxV7LTBk68P7S/Flrpi0QhEVhG1aUlFLiD/h0dJ9oen
	nKRce92oMfasyFfIJH4GLBIUxBk1PX+TjmfQtF728XkXY1eAZZ2+2aUct3cifYgpYMJz6b6grn/pC
	THGoFqxA==;
Received: from 2a02-8389-2341-5b80-42af-3c26-e593-7625.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:42af:3c26:e593:7625] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvAha-0000000BSkY-0I57;
	Thu, 20 Mar 2025 07:52:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-xfs@vger.kernel.org
Subject: remove LI_FAILED buffer pinning
Date: Thu, 20 Mar 2025 08:52:12 +0100
Message-ID: <20250320075221.1505190-1-hch@lst.de>
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

this series is based on a report from Dan about sleeping while
atomic and removes the now uneeded pinning of LI_FAILED buffers
to fix that.

Diffstat:
 xfs_buf.c        |    1 +
 xfs_dquot.c      |    3 +--
 xfs_inode_item.c |    6 ------
 xfs_trans_ail.c  |    5 ++---
 xfs_trans_priv.h |   28 ----------------------------
 5 files changed, 4 insertions(+), 39 deletions(-)
