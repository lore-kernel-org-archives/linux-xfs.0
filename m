Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2051A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612762; cv=none; b=OqsmigLj4kZCFWs8Mqym4HiAw+gEBVHgm6QmiwedDvQNbsUM6PyD21l6OoyNue40YROVZLKeKYpXmbBSDf9qw682NaOf2VxcMo3JWwwOMBffA/js33T8e6wvvyPMz19ayQgqKj0vmfCbbkXF8+sJfXkv8v7Ws+uIWShweCJMKMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612762; c=relaxed/simple;
	bh=iKQXRIBtflo8o87t/cxnPwHahS3q8BYEOnVIMI00dyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h9HgAoVmnFkHNJIHZLzb8ZDGWoHS57neMrVs2YTZB/AI+si2japYTh36K+OhpUH5Pji8Hs7NfO8Ra5xPHTSWd09ypMTeq822u0SRbGRfeElifKKDc1MwpSWW7L34I7QRord34W2F6AE5vx5GJHhiQZ6Zwsxg887JBmmMvGBfkB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MhP6oAB3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MhP6oAB3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MaEt4oXw9OXNNQOUAEv5Gmi5+o624F3/L2AlYMKQWzY=; b=MhP6oAB3EbbdbAP/uAomCYO78/
	NXezjgVCO1dgQ56GPP8sGgKhwDmhwLcPR9mPWtRHxy4eOyRvPGP+gW/Ni9wIuVE/kmCkk9WK6DzTH
	ojnmIvMqWgMk+X3gx/ZM3W9iu3UiChe8U9bc/WkTFv9IN1dRTRC23AbyTwJSwlgQANGLZFzN5k4E2
	SPP96qlMzZa35d+lLiULk3p1GxQXjv5Y2gHg/zXxNJRDxXJwJScUjwvZbzlsl+2jF57i/UmVryaeT
	09jKAXlEcoySqOn5ELFEgytNVF0vaIkEuX702vHsIg86OgRiqHetMLuEdl6UhO589OAKioe0NZG9I
	rJr/x2TQ==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd2N-00000002lfZ-3RIH;
	Mon, 10 Mar 2025 13:19:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: use folios and vmalloc for buffer cache backing memory v3
Date: Mon, 10 Mar 2025 14:19:03 +0100
Message-ID: <20250310131917.552600-1-hch@lst.de>
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

this is another spin on converting the XFS buffer cache to use folios and
generally simplify the memory allocation in it.  It is based on Dave's
last folio series (which itself had pulled in bits from my earlier
vmalloc series).

It converts the backing memory allocation for all large buffers that are
power of two sized to large folios, converts > PAGE_SIZE but not power of
two allocations to vmalloc instead of vm_map_ram and generally cleans up
a lot of code around the memory allocation and reduces the size of the
xfs_buf structure by removing the embedded pages array and pages pointer.

I've benchmarked it using buffer heavy workloads, most notable fs_mark
run on null_blk without any fsync or O_SYNC to stress the buffer memory
allocator.  The performance results are disappointingly boring
unfortunately: for 4k directory block I see no significant change
(although the variance for both loads is very high to start with), and
for 64k directory block I see a minimal 1-2% gain that is barely about
the variance.  So based on the performance results alone I would not
propose this series, but I think it actually cleans the code up very
nicely.

Changes since v2:
 - don't let the large folio allocation dip into direct reclaim and
   compaction
 - add a comment about using __bio_add_page

Changes since v1:
 - use a WARN_ON_ONCE for the slab alignment guarantee check
 - fix confusion about units passed to the vmap flushing helpers
 - remove a duplicate setting of __GFP_ZERO
 - use howmany more
 - improve a code comment
 - spelling fixes

Diffstat:
 libxfs/xfs_ialloc.c    |    2 
 libxfs/xfs_inode_buf.c |    2 
 scrub/inode_repair.c   |    3 
 xfs_buf.c              |  377 +++++++++++++++++--------------------------------
 xfs_buf.h              |   25 +--
 xfs_buf_item.c         |  114 --------------
 xfs_buf_item_recover.c |    8 -
 xfs_buf_mem.c          |   43 +----
 xfs_buf_mem.h          |    6 
 xfs_inode.c            |    3 
 xfs_trace.h            |    4 
 11 files changed, 168 insertions(+), 419 deletions(-)
