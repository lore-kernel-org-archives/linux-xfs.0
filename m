Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEC71922D3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 17:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173525; cv=none; b=sNAtzyEBzivCpfqgydc7oq29UoIHQ7hUUedWZ1wOvMEQ9Ren9G+jNJ75brS8q1xs6jdeROac4HROlZ/fUuCtEfUGuTzFXrMgkBDiPdANSNlWkTAOcUZLnnt2djBvqbdx4b1T0vSzjA0ZuUfOiGcETaKDpx0Kca+46SOZv429c+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173525; c=relaxed/simple;
	bh=7LqVje7eVFhTpKcIPmWeKEZ/NVeg1W8GChN5fQB7CJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=It/4eMug36BOcFsIiBCD++QnIKNnO+1MXCZ5rYnEDVh+h1h26GOrjj7BTRoZg21nG+4tLlNqJqStXyWSX/8JkuyhHIJE/GlfV5UbaRWaD7w7kKq37Fnu9YKKwpXZNXGp/QycUq1cXVWr8RqT3g/6p9bsmJ6Uj8Y8kDTSYccDAeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kwNdLCkM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kwNdLCkM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Ve7Y6BBlSaJ6ChAMTBi0aLsWQ/5c1WKpyD8Lx6q0OfQ=; b=kwNdLCkMFrx8fMHCJfhN1/1Ogk
	ZhQ++1ddWRWoGudxMv/2I2iU9xM5ywjci+ooO4k29OzcexwpWHPeIp3RWYQWfZPSzFSIctcD3MFAD
	/Rzoy2Zub2LRcn8gM3v2ITUTo0QNHXsT23Ult3v6GKZ30RafycyokXoUWgBh6BuvYImQ0Z9AeU0Pf
	wvjvLNctf/q2whwAZABrO38YsVT1NHZob5bEr2p6GmndjGZZll3fPEkIavS0XUhTShEM8LfJMJ9eI
	wyThxi+zTZ3FGHYO1L/o2gaDqgqhOfog+1+/LpigjIJ2f9CC0Rqdqymnom1XZqRXAK9adjfuwkzo5
	V2gGvmfQ==;
Received: from 2a02-8389-2341-5b80-6a7b-305c-cbe0-c9b8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6a7b:305c:cbe0:c9b8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgSIK-000000066ZA-18XW;
	Tue, 20 Aug 2024 17:05:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix a DEBUG-only assert failure in xfs/538
Date: Tue, 20 Aug 2024 19:04:51 +0200
Message-ID: <20240820170517.528181-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

when testing with very small rtgroups I've seen relatively frequent
failures in xfs/538 where an assert about the da block type triggers
that should be entirely impossible to trigger by the expected code
flow.

It turns out for this two things had to come together:  a bug in the
attr code to uses ENOSPC to signal a condition that is not related
to run out free blocks, but which can also be triggered when we
actually run out of free blocks, and a debug in the DEBUG only
xfs_bmap_exact_minlen_extent_alloc allocator trigger only by the
specific error injection used in this and a few other tests.

This series tries to fix both issues and clean up the surrounding
code a bit to make it more obvious.

Diffstat;
 xfs_attr.c      |  178 ++++++++++++++++++++++----------------------------------
 xfs_attr_leaf.c |   40 ++++++------
 xfs_attr_leaf.h |    2 
 xfs_bmap.c      |  134 +++++++++++++-----------------------------
 xfs_da_btree.c  |    5 -
 5 files changed, 143 insertions(+), 216 deletions(-)
