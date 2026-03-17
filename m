Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B6B2C21C2
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773754880; cv=none; b=DV4ohRZPzHqH7lofebdkWrWDxKN3eg+Bm8EIlMFD/525CQwt1oTB0tGVSAvl1fM5WTAwUQbg4o6ESyW/AwFOLUl6w8zfcG1zaOonl7QMO+lwSZipVskq4bzzsOUrY2dkiQAivS21fQk/Ex8dlyRWOQ+E5S6dOzFpZWPCa8xiwtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773754880; c=relaxed/simple;
	bh=IJ5zOBvhxTSMdpyLM5GQZu/M2oDlAtjI+0iU7h7Njlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMYyjZTeNXDDYWe9YoKXgY8jIJTlqevLBCxIeL6W8bp1f2SIxJ/SHI6d3ldisdSvFaDRr0ydgB9YqrK8bEANdZgzXeX7z8XfXDGftNn62MTuP1j7veWiuwqiltOGt9mMAd9oMabGYcO2mMqc9YGN0/zVVijz+YAFgY6qVB+GcsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vGroMG2L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vGroMG2L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rWUJmjmcmZcVq87HR+85wefRhx29UFjIMbpS74VVWLA=; b=vGroMG2Llcp8UU33qC916mNd7s
	CLVTbz/0W9lB9CAsX559K4kHm/4cY9u7Ho63C47yrrmEjdNMOelWZ/M5lfxv3BkQf7rZpCI1QRHG9
	bj4Ssgc0Rdrv9u/LcV3AkZUIGDob4gU5ec7qUk8iHVTMDHqI0Of5KQjTYM3RV34TXIMS0P1d4/yGL
	CFpZJcYSXL8GhOtLV/simgUDtrNSjaFjURBzJlksyD9ZXDQr4YUf2J7fyDCdfIxyc59ElQoFrOCBX
	EYrJN7lLHA0OVXG91aUyc0rowJ2Cfkho22n1+bm13Z8JH0w3W+ycJQs1S8HfTvoWiqZN+ae+FSZ8g
	xV8JvxBQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2Ufa-00000006T1X-42EB;
	Tue, 17 Mar 2026 13:41:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplification v5
Date: Tue, 17 Mar 2026 14:40:51 +0100
Message-ID: <20260317134110.1691097-1-hch@lst.de>
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

this series has a few old patches that simplify the LRU handling, and
moves back to only having a per-buftarg hash now that the buffer hash
is using the scalable rhashtable.  While some of this looks like
performance work, performance and scalability is unchanged even on the
80 core dual socket system I test this on.  Besides cleaning up the
code nice, it also happens to fix a syzcaller reported use after free
during buffer shutdown, which happened incidentally because of how the
tear down of the buftarg vs the perag structures is handled.

Changes since v4:
 - don't drop the required first patch from the sent out series.

Changes since v3:
 - split the change to handling how referenced buffers on the LRU
   are handled into a separate patch

Changes since v2:
 - mark b_hold as signed in patch 1 before removing it in patch 2
 - document the changed locking in xfs_buf_rele_cached.

Changes since v2:
 - add more details and a link to a commit message

Diffstat:
 libxfs/xfs_ag.c |   13 ---
 libxfs/xfs_ag.h |    2 
 xfs_buf.c       |  237 +++++++++++++++++++-------------------------------------
 xfs_buf.h       |   20 ----
 xfs_buf_mem.c   |   11 --
 xfs_trace.h     |   10 +-
 6 files changed, 93 insertions(+), 200 deletions(-)
