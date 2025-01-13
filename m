Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ABD175D50
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742351; cv=none; b=t9OKGitxJjydJdLMqrs5Bq8YYUuk/xo7Ry1aC5IZFBiqEg5iJ8rPrtv2Uheni49nOAeo4TQnqNgglAKPDnxUe/13UCE5TaaEbGmUiBrUG1WafpfWSVr3mcyaWJrQBkSwTsmS9gfJzEiAZGuEkW9JZytUYwwc4nafCQZazoj5fiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742351; c=relaxed/simple;
	bh=W2xO262wNxcOQ0YfB0z3PjqDAv9mPV7CH+jbfH2Qol4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gl/Qt/aHYh7rYKKoNgYsQJWJ0lLA2NCbluDka3xwb8wC2weqyCLLDbuwGhqerwywP0JEnFsefE76zY/tqMMF421nAm8A3GnKfTYRV3BFnJYItgePATWykBmJUlPrVhjVoOiibakkkcDvAYdE+R4YxEe8/MW3bVIsS7w1/y7Fbo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XSZ9xvpR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XSZ9xvpR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TiYBfys+/ckOMBQ2NX3JxG/8EvXIbtU2f2+jFGWGaIo=; b=XSZ9xvpRzbdPa9bq2vjSOmTDQ9
	UARbhmIzsl1uGdDQRR/rfwrsA+uQBeiug7NBIaGsZhmiEwp6D6RvKyGpkm19f4A2Dqz6N2WsrmeM+
	X/ns2HUJMwYo8e7HufzxGGnPHnrOHCdp/Aa7AABnFwBAdYPTOJK8pFJqHvEKObGbo3sbGubcGfQ3s
	NJubOkEWzYqQNIMLs5bsAwHmkE77QEC+3Fse1skDz58XUx4yDKmAW5SMa0RhM/cUYk+IhjEJet6F6
	T08JmPc7vGNt92KBLNZY6gl6tQV2L4xgdWVVSdRwI+ERM93k6D9OiXZ7lBmFcHa5SNeMmAHUt+Ng0
	Gf57KmTA==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC1L-00000003ygl-00uN;
	Mon, 13 Jan 2025 04:25:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: fix buffer refcount races
Date: Mon, 13 Jan 2025 05:24:25 +0100
Message-ID: <20250113042542.2051287-1-hch@lst.de>
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

this series fixes two races in buffer refcount handling, that I've
so far not actually seen in real life, but only found while reading
through the buffer cache code to understand some of the stranger looking
locking decisions.

One can cause a buffer about to be freed to be returned from
xfs_buf_insert.  I think this one is extremely unlikely to be hit,
as it requires the buffer to not be present for the initial lookup,
but already being evicted when trying to add the new buffer.  But
at least the fix is trivial.

The second causes buffer lookups to be missed when moving to the LRU.
This might actually be able to trigger the first one, but otherwise
just means we're doing a pass through insert which will find it.
For pure lookups using xfs_buf_incore it could cause us to miss buffer
invalidation.  The fix for that is bigger and has bigger implications
because it not requires all b_hold increments to be done under d_lock.
This causes more contention, but as releasing the buffer always takes
the lock it can't be too horrible.  I also have a only minimally
tested series to switch it over to a lockref here:

    http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-buffer-locking


Diffstat:
 b/fs/xfs/xfs_buf.c   |    3 -
 b/fs/xfs/xfs_buf.h   |    4 +-
 b/fs/xfs/xfs_trace.h |   10 ++---
 fs/xfs/xfs_buf.c     |   93 ++++++++++++++++++++++++++-------------------------
 4 files changed, 56 insertions(+), 54 deletions(-)
