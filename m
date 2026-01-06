Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8918941C63;
	Tue,  6 Jan 2026 07:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686364; cv=none; b=TH5x8IC2w5TwbdSjJM/viqW2zbq1rRsWQMchcJU2t0/d+oJpheNcLoMqeuScxdze/B7TZMokCCjFo3qTm+/A7fMK5NDXGTJ4avqCGnHEgZl9aqgeJNh53foJGM/iA6WHjlcFWLGRi+DScqQZGmQkCbRPonClR/rrjAkxS3+E6qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686364; c=relaxed/simple;
	bh=qOj4hy1tEM8tcwwfQ7aCNruC5Fq6tvnMsEzPKG+xpFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BtKKHOxvYKU+10j2eYyScexygUk8beGNsxgfp/+Se70RErylbjS8UgQ9qyCKl+AoNhtEFkKQBOu/ZnsLTYFMxIN7Kf7ZWA6+OPjXr7qDeNvpjApu2q/tuC064rLC6IlzWWSnzjCTfCy0Gnt1msznqNJFCbkqa6cAhoijrBAkVGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hOcL6BCm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hOcL6BCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=u2TVw9nD5YPiGQ9L/cYRukDC2imzEcSfYXb+tfxKUxw=; b=hOcL6BCmfn3saK3IxXb5JJ2nWI
	8FNh7PHwMkR9126rGVbzJ7paelUJd7jAe5U2Q18lLWcNZFI245vL+i5hkZs/wKFrYUcUOWdYJEpLz
	ZFBAYlXRNq3KB8KhnAm+FiUxA7/dgj1kDMTp85RJxP2f7vuQV4AUK3vw6xFe6uqUQCkEbMAv63CAr
	91iT/4UExGvPyHVsLHqWuT/NprnYRkZkaAdczqDKYbfTypqvv/5CgAx8wN753uYJ+u6v12gX2TCD/
	hZh4wASEo5/eJN0g4atWh6XtlMqaiax+4UuM89rpDNOx9lru0f8zu60RZJwxQZ9B7KcrgVHc96UdK
	z/aSScSg==;
Received: from [2001:4bb8:2af:87cb:5562:685f:c094:6513] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1yI-0000000CZzi-3Xzr;
	Tue, 06 Jan 2026 07:59:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: improve zoned XFS GC buffer management v2
Date: Tue,  6 Jan 2026 08:58:51 +0100
Message-ID: <20260106075914.1614368-1-hch@lst.de>
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

Jens, let me know if merging the bio helper through the XFS tree is ok.

Changes since v1:
 - assert that the reused bio is not cloned, and update the comments for
   bio_reuse a bit

Diffstat:
 block/bio.c          |   29 +++++++++++++
 fs/xfs/xfs_zone_gc.c |  113 +++++++++++++++++++++++++++------------------------
 include/linux/bio.h  |    1 
 3 files changed, 90 insertions(+), 53 deletions(-)
