Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0650B2DA77A
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756120789; cv=none; b=HptXxkNWK1PiP84Ii9JMzP8UafCmXvqKmPIesUNczB7gYjm+e80Tox7RwYmegUf31+xpVX6HCwY6PbypaOVEfGrKChpeANT0pbY4D620DjHP4ewOGRbusMBMnoGG5wsHrGj3Kv88sQEHsktjvWMUTcsFY7EEVFmb7xIP/dj1hUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756120789; c=relaxed/simple;
	bh=/NAHgEpzSneCnSCio+fuj2sOQRINpgeH2IpALLoZq/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tx2+6gh27jWJlhbGRpRG1HS2WQvncwa+/rN2Axf7r3ZijH1CfPS4AawtKCBOyc4kd/l26CTsBXEU0BjXbasBj6X/Vj9znUNKB75/uiR7oypPIwOSPBWghOBFFF3JgLn5NtHTDvfGzLTz99lUhJWMPzMgMlqnFoJO3dEnRNHSlQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fwkjiudG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fwkjiudG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xHe7h1YOGAqFGL7ESUZfK/0hPqKjTab3V/TClhtkWig=; b=fwkjiudGwwcz/tr4Ww6bn4Zh7B
	MYa14IcgBe5PUYjrbJqZ7H4ZYxDQuYmv42ei5gUwr2xAgw2sfHt9aRm/2TkgNcJHA4TCXb15HH9JR
	ykQlM9w55RUviafgpvcF1HjWk9uNnCW4OnG02SxIUofOzmi0J0ztnj+t3V9ZIrgy3ZlMwV8wVKTpi
	8t7mUD+MZYYG9U6ms3S4ItlenaEVwVp3XzXF2zqqk9zxApVkwzv/HQw9MUE9uqVOtG9asBH8t1iXO
	zwZm66sWgAGIm/LY8pKOLEAmC+MgTBa9fVoh4KJfrcYPNZp0wPo841p8VqSogMymenDH+gkC96Cof
	EefPzXNQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqVEp-00000007ix7-1Rjo;
	Mon, 25 Aug 2025 11:19:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: store the buftarg size in the buftarg v2
Date: Mon, 25 Aug 2025 13:19:34 +0200
Message-ID: <20250825111944.460955-1-hch@lst.de>
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

when playing around with new code that stores more than the current
superblock in block zero of the RT device I ran into the assert in
xfs_buf_map_verify that checks that a buffer is withing sb_dblocks.

That check is obviously incorrect for targets that are not the main data
device, but unlike to hit in practice as the log buftarg doesn't store
any cached buffers, the RT device currently only one for block 0, and
the in-memory buftargs better don't grow larger than the data device.

It's probably better to fix it anyway before running into real issues
on day, and storing the value also removes the need for the notify
failure code to poke into the block device.

Changes since v1:
 - grow the correct buftarg when applying the growfs deltas

Diffstat:
 xfs_buf.c              |   38 +++++++++++++++++++++-----------------
 xfs_buf.h              |    4 +++-
 xfs_buf_item_recover.c |    7 +++++++
 xfs_notify_failure.c   |    2 +-
 xfs_super.c            |    7 ++++---
 xfs_trans.c            |   21 ++++++++++-----------
 6 files changed, 46 insertions(+), 33 deletions(-)
