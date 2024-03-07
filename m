Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA6512DD99;
	Thu,  7 Mar 2024 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824321; cv=none; b=D6ADPrneRbEPyiY6E7DNYM5zF4SzkvECLP2sf+qUb4PKBKqwweU5Ifg73ejSgjrwu9C5YDULqbWcnwUj3Lh457aMibA0dEAdkdjrQ9JXxD3SJN4EAcllm9WvTZY3HX0koEzN46AYpkIgtWzNUiSYEPyjVFtAhQAdw/VjsMQSmKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824321; c=relaxed/simple;
	bh=Wl9TDpjbcsEQFTjNttax1/Zg+2GJ5Gq4ZNNeMgy5WZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NMv4TGkEc9I5GFM48tTsF7HqNvAFFo2SQ0geEXOBe6R6NXeW9MaK17Q+KOsiFjepQrx7lwuqalS5megiJlA7tnZ2eiZo7txQeAghoxmLhvuZNMZjMxOu1xAb7OQsLrhI7/0jZE4affsMEPGUy2sCsM00swL+ZaisLSalsxUCniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DVgNbQMz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DVgNbQMz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=K02DG2I21K2ObYxemDxzBjU+AOxsGZACg52CFCT18Zw=; b=DVgNbQMz9cKFU4BtYsYIlEp2DW
	95jFOF7I7XdPf8FFUSY6qG3h3eaITd6gfl+IYHLVUPYXTyLMSBGeJLkjf5lE9K9SSgcLgpWehYtgk
	OlMSWhtx0M5f85RRqkcolW2Ji8CMqkhJY/9uk55bk8akwPEFrb7Jilq+/GHNQsVwFdyhmaw6iiaLO
	i6f+RQKdXlL1GLRlWi0fELclNfTm1dF1E8JzvmePbsRw1zOCqDoYNAmBPhyEbTpEcxOv5EkI7ejyP
	MLSICM5i3l1e88V+o/c2GwccN0XovVrx9XzuqqONTivNPVG4/49ac2tJNin/gTszMLuxY0k0dgvaS
	MadURxBQ==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPa-00000005D6F-388x;
	Thu, 07 Mar 2024 15:11:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: RFC: untangle and fix __blkdev_issue_discard
Date: Thu,  7 Mar 2024 08:11:47 -0700
Message-Id: <20240307151157.466013-1-hch@lst.de>
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

this tries to address the block for-next oops Chandan reported on XFS.
I can't actually reproduce it unfortunately, but this series should
sort it out by movign the fatal_signal_pending check out of all but
the ioctl path.  The write_zeroes and secure_erase path will need
similar treatment eventually.

Test with blktests and the xfstests discard group for xfs only. Note that
the latter has a pre-existing regression in generic/500 that I'll look
into in a bit.

Diffstat:
 block/blk-lib.c                   |   78 +++++++++++++-------------------------
 block/ioctl.c                     |   13 ++++--
 drivers/md/dm-thin.c              |    5 +-
 drivers/md/md.c                   |    6 +-
 drivers/nvme/target/io-cmd-bdev.c |   16 ++-----
 fs/ext4/mballoc.c                 |   16 ++++---
 fs/f2fs/segment.c                 |   10 ++--
 fs/xfs/xfs_discard.c              |   47 +++++++---------------
 fs/xfs/xfs_discard.h              |    2 
 include/linux/blkdev.h            |    4 -
 10 files changed, 84 insertions(+), 113 deletions(-)
