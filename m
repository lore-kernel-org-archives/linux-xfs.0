Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC18A4414
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 06:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737007319; cv=none; b=pKn/pivEqflmnJ6iui2Ku3nZc9bkKeOL38vTruBQZ32rP0AS7xvWxLvzchmy86LvpLpW5hcu60Mv3er43bi9X4fAMS7qpMM6rMJW8rq38PWzwXNiYNecSAz1XLiX2CoFRuLuq25b4pAmuMLy05DBQyv24ayR0benvejZ7cQ8xaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737007319; c=relaxed/simple;
	bh=QsnYpEFcVDETrIUDwNfSyrhn6BabRJzoYk12863m/oY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j3QaLAXDVUyu6qN6bH+p7jnWcFXboCFHguIfoFcnOMpoHrWaCZbXMnpqhpAQmFTlgFzCToF8J2gR+R/0IdXAv1yhu1ukpomggZiAVV2kb4Z2swSa2uzHHDSKuq3XRDuIUcZTjgPgaTXl+4OHTTJDhW4ZagTaEUr56GxMx0BMIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tsdleapL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tsdleapL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=y9WXvdZz4guUJtfuVOUS+wQf158NsybeQyMpuWKsNvc=; b=tsdleapLrtdXafdBnmRT55ed3/
	1hyI5akTe+vuDE4xIurAaNPcH/CP2aTetx80eu0mGABgxDxCW990iFUzNCTnGVQpBsWt4npxH1RvG
	fgZVvVIKIya2DakjUsW3SCGVaOr5KrSpdGmEkahYkSiK9acOeTH9AXZzcPUbgyAM0vX75m1bLPIG6
	5g/1eLRcEGNqFjJ9L78EJjrfZR2s/1KAzhC21AuXUvYey+nz9GNefHzFdl7Ow/qwABwkTfm4zXnNN
	bzyS1gC/LZ3sjf3p8AXeFffStGac3vw/QBOHn0+faazyxAbMCvQpvFd7ymQBFBBkDAffWO1Xk/aSE
	f9cwruNQ==;
Received: from 2a02-8389-2341-5b80-1199-69ad-3684-6d55.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1199:69ad:3684:6d55] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tYIx1-0000000Dv7w-46rg;
	Thu, 16 Jan 2025 06:01:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: fix buffer refcount races v2
Date: Thu, 16 Jan 2025 07:01:40 +0100
Message-ID: <20250116060151.87164-1-hch@lst.de>
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

Changes since v1:
 - don't move b_lock


Diffstat:
 xfs_buf.c   |   94 ++++++++++++++++++++++++++++++------------------------------
 xfs_buf.h   |    2 -
 xfs_trace.h |   10 +++---
 3 files changed, 54 insertions(+), 52 deletions(-)
