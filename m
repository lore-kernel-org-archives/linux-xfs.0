Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C5139341C;
	Wed, 14 Jan 2026 13:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768396021; cv=none; b=YR041WuUqVQCSAGIqMEKTfn1VB45OtijmuyY58ePB9gGxeXKyEENDyCZwnLHq8/Nz1K39yGzSoAjKbYDQx/1O8Utq/AYRKtBVi+CigLrmlzdvCEItd7Wf8ipakpQK+7YnAn9pdHgC4ZYm/qni/Xc9Wd+VwKiSFMLHfzdqKr1wj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768396021; c=relaxed/simple;
	bh=KymYalqCGHQHjWj6dfcrk/7AJKNS/yERAh28tLYuKt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QkjHkJjCwbL6usxguD0+Nk/jN+XgV1TOrl5uloefIEmQEdcwMyH4fdi1wA8jpphe4o8OjYISe4AtCadT/Cg7+kakFsAJsr8IT0OxVlIHBsRTtfaM46hipgGuWExXBzyQZJGllFw6UjRqwkb2fjUsvStDd8q5zwk9ms2OcbljG2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AzP7Bly9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AzP7Bly9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=LXqA28y9Oig2YRTtApztW4Fds2gfaCixYRqICaxHRCY=; b=AzP7Bly9T9HM559Km+K+oRv3aS
	OjTWs4v4ge3We+t18M6qF0Apo9WyGZGWnarGGQ13RcSs+hwp+4ZXoOVteOqWb9F+xsZgBuE+FT0Qi
	jSN/CCq8MokaM3rEdhE+vNubc/bMyBPofCXGYPwcR51uUb4lgnr1PO4LVwU6q7NMB2cp/QXcywRzq
	VNYNm4KcsFMkk6fyu1Vam6mPF67czDc0FnfKpmwz2eIdYVu+5lQgohyKoS7AGSY5ytSoZeIIc6NWZ
	oDPp1WkTbmMEx3YhgnOW5BSeOnHxiVLlJuJFl+FozXwxrVPyB/TYKcaHbIhLJUvsDc8oCGJc3jIeU
	LnNTdcPg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vg0aP-00000009Gy0-2vZz;
	Wed, 14 Jan 2026 13:06:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: improve zoned XFS GC buffer management v4
Date: Wed, 14 Jan 2026 14:06:40 +0100
Message-ID: <20260114130651.3439765-1-hch@lst.de>
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

the zoned XFS GC code currently uses a weird bank switching strategy to
manage the scratch buffer.  The reason for that was that I/O could be
proceed out of order in the early days, but that actually changed before
the code was upstreamed to avoid fragmentation.  This replaced the logic
with a simple ring buffer, which makes the buffer space utilization much
more efficient.

Before that, two patches  makes the reuse of the bios a lot less fragile,
and for that we need a new block layer helper that should eventually also
be useful in other places.

Changes since v3:
 - pass an op to bio_reuse and fix GC on conventional zones/devices

Changes since v2:
 - fix a commit message typo
 - fix a missing : in the bio_reuse kerneldoc comment
 - warn about bios with integrity and crypto context, and add some
   documentation about this

Changes since v1:
 - assert that the reused bio is not cloned, and update the comments for
   bio_reuse a bit

Diffstat:
 block/bio.c          |   34 +++++++++++++++
 fs/xfs/xfs_zone_gc.c |  113 +++++++++++++++++++++++++++------------------------
 include/linux/bio.h  |    1 
 3 files changed, 95 insertions(+), 53 deletions(-)
