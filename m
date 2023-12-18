Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF31963A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uAs1oh5m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=QoB1D+DRNklW4NZONWbuHWo8a9xdWBU6GJe2n8ufhW4=; b=uAs1oh5m/MYuzCgBUYlHgrefhc
	YZWlDefNLcLGtfEkqB60AelYQNtXOjBg+LsbfLGtEtRnqaDI5zPR5pDYkcUTM99Gjf6x60UFRhG+J
	2VjTsYCrjkolfKCRGZPQtxZvkR9okxkLLUfK9A81LU2o+6M95pw6itweqN8OEgvcwkNBkpULDjOgU
	QruRjYyrFtNNNJAEVe5NULRDnlkJSfcBt4kMjW65SS5KrtcXsI/c3DyzIgJL4183Yjo/4Suy4RHWW
	hmw8lelvxTN0fp+3GiD+IvZ9w7AgTEaIeT1PVwxl5KHAilNIw7zB5V5mR29SjTtwviNHBc73ceSGG
	jilFzq0A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hD-00956M-25;
	Mon, 18 Dec 2023 04:57:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: RT allocator tidy ups v2
Date: Mon, 18 Dec 2023 05:57:16 +0100
Message-Id: <20231218045738.711465-1-hch@lst.de>
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

this series has a bunch of tidy ups preparing for my research into
per-RTG RT bitmaps.

The first is a fix for a one-off bug that I could only reproduce with
my hacky patches, but which seems real.  The second- and third-last
patches change the policy for retrying allocations that didn't succeed
and could use very careful review.  The rest is fairly mechanic
cleanups.

Changes since v1:
 - various spelling fixes
 - split and refine the cleanups to xfs_rtallocate_block
 - rename xfs_bmap_rtalloc

Diffstat:
 libxfs/xfs_bmap.c     |   57 ++--
 libxfs/xfs_bmap.h     |    2 
 libxfs/xfs_format.h   |   14 -
 libxfs/xfs_rtbitmap.c |  106 +++-----
 libxfs/xfs_rtbitmap.h |    4 
 libxfs/xfs_types.h    |    1 
 scrub/rtsummary.c     |    2 
 xfs_bmap_util.c       |  141 ----------
 xfs_bmap_util.h       |   17 -
 xfs_quota.h           |    5 
 xfs_rtalloc.c         |  648 +++++++++++++++++++++++++-------------------------
 xfs_rtalloc.h         |   37 --
 12 files changed, 419 insertions(+), 615 deletions(-)
