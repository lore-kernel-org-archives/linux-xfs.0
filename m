Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93C443BDD9;
	Thu, 23 Jul 2026 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818209; cv=none; b=OcN5mPORFvqblIGz6AhFN58zXC/DDhNWkNGRTO/EXUpnapCxbgB7KD6eCxS+Z7i+c7/dk2p2PEZkjnW2T0v3QDTiY5USnzpY1A1tjYaf3pIuzoE2QXJryEMRgmFqIiWR5S79StyQW7wnAaQ1CHJukAMOblkcVZNLXmhGQRTCB+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818209; c=relaxed/simple;
	bh=Vxxjpac+z/B/AXPXZ6qf9sDM2FVySsZ3M6PQ1Zlm+6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O4hJK5rSPcei9bypOhvpj6/eWfYwf3rK5nL58L1+zkzdOR8Uy7TmozWVRwtY90w/2JvRsUV5MBYXeIPAVDRrmgNLPQbVojB3ujGTI3Z+bPU8rzDzYdkC97Yx+dTci5J1UbYvp7Az+wcS0mQSKfiNdyNB6zGraDGRczXHZRLVuSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r8GM6B10; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r8GM6B10"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/kKs2n9WKaggUmoGlf/eZhlmOxmWjIg3uMokE4IiBg0=; b=r8GM6B10rV2cqSlWkIGMBpQP43
	68SavgpB74h0y8Yf4GngJ3bUAbwjiSiv9g4m+ylDc6iJODhyOYNP5tSZTvwXhNiTn2+T/gN6LQac3
	WPH0QEcVHdsSwBrWHVHH5Qs9OeYVTWkiT+uCah8APse5zrvP2MELWWzCOods+hiWIcGVkzLwrA3R/
	fddswUI5GdKDqRDkQ2DK5yr8uCn/Te9aac5nUIKwl/1TLv1HUM9cx0fjikKMwDPPXh8IRWCBuPm12
	OymWNTZu+mz6Bunt80GU3CBlA90tCSc9H0WQSQjxXZNq4gOR8KAEjNraJgBqhycy1E1gXRTVVqOXI
	I+bZZnzg==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmukO-0000000EXFp-1Yme;
	Thu, 23 Jul 2026 14:50:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: lazy bounce buffering for checksummed reads
Date: Thu, 23 Jul 2026 16:49:25 +0200
Message-ID: <20260723145000.116419-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series improves performance and resource usage for reads from
devices that require stable pages due to checksumming on XFS.

Currently XFS unconditionally bounce buffers reads on such devices to
prevent user modifications to the buffer from corrupting the data,
leading to checksum failures.

This uses DRAM bandwidth and CPU cycles for copies that are not needed
most of the time, and due to the use of a bio_vec for the bounce
buffer to smaller than wanted and unaligned I/O sizes when using 4k
user pages (i.e. 1MB-4k I/O).

This series addresses this by reading without the bounce buffer first,
and then only allocating a buffer and reading into that again on an
initial checksum failure.  To accommodate for rare (or hypothetical?)
applications that have legitimate needs to frequently modify in-flight
buffers, a sysfs know is provided to revert to the old behavior.

The series is a bit of a mess.  Patch 1 is queued up in the VFS tree
for 7.3, although it a fix that really should go into 7.2, but the
request and ping for that were ignored.  Patches 2-6 were submitted
to the block layer independently and will hopefully go in soon in in
some form soon.  Patches 7 and 8 need a resubmission from Tal.

The rest is split over 3 subsystems, and for two of them will
conflict with large in-flight patch series (iomap iter next and
xfs fsverity).  So for now I'm mostly looking for review and will
worry about a merge strategy later if/when we agree on the overall
approach.

A git tree is available to help with the review here:

    git://git.infradead.org/users/hch/misc.git lazy-bounce

Gitweb:

    https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/lazy-bounce
