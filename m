Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF981EF07
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 19:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952367; cv=none; b=Rcrm69nCzsrcr5LVGeTT0EY+mFpr4COmizqju0D2/N8Gu7IjrPO22Huleitdky8Dft41QnWBsiYo7kgWdIMxcKifATRhp1BZ7DUuCE8oUomOL0ZF8olfDE48RuDEcY9vVYjM8oQojE2n6c/PhPFYAK0c4IM/bJrQ4dY1rh1jMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952367; c=relaxed/simple;
	bh=Rl0Cg/CVbJT4BofUk/Hdkt7YpW2nmcYpBGZ13oheN5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nZzpO+uDrmXDxl9MC0BaOZMXRkAjaqK6pCXilugmECQWAbtsHpwZHDXR0JfuuK81zbHNzUGiYznX/xnYX4nhWK5eTqB3ZxibfpqTuGFFRyciJkEwuO5vi69qnhUBpzGIzbsBfBGRh5ZkXEpxJRbs21/IfhZMTiZ2K7ZZcmEYfeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GIZxY6z5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GIZxY6z5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=JmiL4EyfWmz+gPIPvLfF4xclkD+bnMsjq9Vd3NTgvyQ=; b=GIZxY6z53Bmyno7ejfnvwJbPSM
	kNDpXFpxo85DdM8qWJjsbYcx7mX+mgbNncelPtP6PTjUpr5hCVyt8mqeFwiEOcOuVEuD2tGTy6c5A
	v1QpTVc4iKTHso4kCzZcu5v1k3rSCF3/Uandi/74vuK6zhUfP34eAyGGFiHnJICZ2CaPBe1/Q+w5V
	rT16S/A9X+acpBuNMwPn+wGYESdlr4ChHPOvhoIaRG5HVGQUIodwg9tMbqpCFwgYR+7L80l1NFa+c
	zJulnvdlNbMqMELGsSNPy+ireikIAjgTpZsXVz7yU0rkcDTPW8pHVizHVCFagV5H5CNasQtzRqwm0
	+zPYGlpA==;
Received: from [2001:4bb8:198:a22c:146a:86ef:5806:b115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS08f-00DkTd-1g;
	Mon, 22 Jan 2024 19:39:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: vmalloc buffers POC
Date: Mon, 22 Jan 2024 20:39:12 +0100
Message-Id: <20240122193916.1803448-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Dave,

this is my old vmalloc buffers POC.  I just dusted it off and did
a quick rebased.  It survives a 4k quick xfstests run but otherwise
this should be treated as not very trustworth.  Maybe it will be
useful for your folio work.

Diffstat:
 libxfs/xfs_ialloc.c    |    2 
 libxfs/xfs_inode_buf.c |    2 
 scrub/inode_repair.c   |    2 
 xfs_buf.c              |  267 ++++++++-----------------------------------------
 xfs_buf.h              |   22 ++--
 xfs_buf_item_recover.c |    7 -
 xfs_inode.c            |    2 
 7 files changed, 65 insertions(+), 239 deletions(-)
