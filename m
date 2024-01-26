Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C5BA39
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275753; cv=none; b=WoPgMySqQsucVugeSftz/c72K5oxF8d2nyl1Rw5764lQaClwk7kr5aHjbzrFR5nEj/AiJ3nYIct4kTghZZCXLR/q7qQC2hqyFLRxGBmkoUI1yQYDrHxYj2r887OwgobPkdDDA0HIlLYkbW06Mw8gsUFDzCbHX7JwUNtL3WDoXrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275753; c=relaxed/simple;
	bh=mE0dVdKEBqXgfp0El5eZ2mdC+fNQZaT3v0FrEDU5se0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pf8mLqOWNjZW8kNQJsuiz/ksHB+d5YmulCk4ieqZpzRKKtPribt1TXMIM3m9A/Q06hHkSppnwLtIeOHkjbfBolqQy3mPSX0cd7UZXTYTtfsRav58IKbUk0q5q4CBi617bI4leqqV0yZbC+waPu+Hh5epyO66XhdEz/gt4+i6FyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F30ofml3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F30ofml3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hXa6KhDbJQO4nQLf8wZARjk3kfM7rpSkNV4AyPwA9Ks=; b=F30ofml33LVKikZ7mLADE8gUgy
	Hwo1HQaDT/T8BLYT3wlksPzDIkJJsFhwcXvRCh8yL4OeQrTvEyV5PA0tg3P77fL0LD8jIjum+lTtM
	5au4tThKuWYFsL1wI5v9JRXX6rMD8Njp7MZavpyZJWyS3aN3YETu+btF9cDJ8zU11wQqW4jQEud2j
	SZ2fZV0E9R8DQcXHN7y4Pu7B5NxUbIL6FTZNUk+iwdwJK/2/JIHHdwo7UYuVEIMPuXMspabtiyw+i
	0UrXuCUdIYHwOvDWCGHz5GXpNxLJj8lEK2g3xUVWxbLpdJ8YAKYclbRkMXb4yd0/UxXqQdxIcgUms
	b+CmD8rQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGa-00000004CZM-2uOA;
	Fri, 26 Jan 2024 13:29:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: put the xfs xfile abstraction on a diet v2
Date: Fri, 26 Jan 2024 14:28:42 +0100
Message-Id: <20240126132903.2700077-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series refactors and simplifies the code in the xfs xfile
abstraction, which is a thing layer on a kernel-use shmem file.

Do do this is needs a slighly lower level export from shmem.c,
which I combined with improving an assert and documentation there.

One thing I don't really like yet is that xfile is still based on
folios and not pages.  The main stumbling block for that is the
mess around the hwpoison flag - that one still is per-file and not
per-folio, and shmem checks it weirdly often and not really in
at the abstractions levels where I'd expect it and feels very
different from the normal page cache code in filemap.c.  Maybe
I'm just failing to understand why that is done, but especially
without comments explaining it it feels like it could use some
real attention first.

The series is against the xfs for-next branch.

Changes since v1:
 - fix reading i_blocks
 - provide wrappers for reading i_size and i_blocks
 - update the xfile load/store documentation
 - improve a commit message
 - use shmem_kernel_file_setup
 - add a missing folio unlock in the hwpoison path in xfile_get_page
 - fix checking for shmem mappings
 - improve I/O error handling (Darrick)
 - convert to folios (partially from Darrick)

Diffstat:
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst |   12 
 fs/xfs/scrub/rtsummary.c                                 |    6 
 fs/xfs/scrub/trace.h                                     |   81 ++-
 fs/xfs/scrub/xfarray.c                                   |  234 ++++-----
 fs/xfs/scrub/xfarray.h                                   |   11 
 fs/xfs/scrub/xfile.c                                     |  370 +++++----------
 fs/xfs/scrub/xfile.h                                     |   62 --
 include/linux/shmem_fs.h                                 |    6 
 include/linux/swap.h                                     |   10 
 mm/filemap.c                                             |    9 
 mm/internal.h                                            |    4 
 mm/shmem.c                                               |   38 +
 12 files changed, 368 insertions(+), 475 deletions(-)
