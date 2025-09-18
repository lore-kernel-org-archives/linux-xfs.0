Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634421714B7
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206097; cv=none; b=GQZGZSTHGjETZyQW4OjOy/7ELB5B3rohvgFcaB+xXtL1LLSvtKJKU+MqoJHzfVj770ULNBDdlTdog5GVrKXBCuUtshPdy9hUxpr0pfMtndw7MclXbFZgyx/fvMdA8xXKo36yRVdkoYSfD+Em51Qs6yBSpRjeYRX2iNgbCoW1SI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206097; c=relaxed/simple;
	bh=7t5xaIWFHz9avtVzWOkdeDGEt02sReAIifemaKT96MU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kqjCHn0J8wLPEbLt5WDH7KyQD6nWVouKGF9ZcTr4qG9XK+iOMnD1iKzaw14J+oRNdatLktuvvN6AobvVmcn8c5dQ9j4VS1YgmLgq4ZbRoRuzxsop5qwor5s7oUpC3ch/ITwOWkZC4Bv+XqnkQxNged2i5II+mZjVT8jg/uyiioo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=33Zlhk/s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="33Zlhk/s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HGXN7yB9RkzKU1KYZFE6paK/D+b0fEF75r7p2hhl2CY=; b=33Zlhk/sbDWiuoaElsKrRNP5fR
	On0I49BNJO7ypBn+6nkPxB2brWdpMBWWsn6I7k5/6EZvqUps5E1xgV8+Z16WurlOBPmSCGiMuq1LS
	POXH4ll0lV8rllBQaiu2Q4HSIEn8lvJkZC2qnn5crO5h20xf+vdjXqz3YZG7rxkN11/1ZzfFs1M1D
	mF6BUhteNEQ3hAKmSI3KePnzDeyaM7lYoPUHAoYw7qMabquZYIVHF5YT9vCilpqBQqRBdJGNnc+1r
	vrm0qK1z0h60wV05zqyl9msyn+StP6X20sOoXKm7VFkMhcJSPOTY60BvlWuPxEw+7eoXVvQ5VezfR
	ag1fOr0w==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzFiq-00000000ADt-0Lhu;
	Thu, 18 Sep 2025 14:34:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup error tags v3
Date: Thu, 18 Sep 2025 07:34:32 -0700
Message-ID: <20250918143454.447290-1-hch@lst.de>
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

while adding error injection to new code I'm writing I got really annoyed
with all the places error tags had to be added.  This series cleans the
error tags so that only the definition and one table have to be updated.
I've also cleaned up a lot of the surroundings while at it.

Changes since v2:
 - improve comments in xfs_errortag.h, mostly based on text supplied
   by Darrick
Changes since v1:
 - add a big fat comment and a idef/undef pair for the ERRTAGS magic

Diffstat:
 libxfs/xfs_ag_resv.c    |    7 -
 libxfs/xfs_alloc.c      |    5 -
 libxfs/xfs_attr_leaf.c  |    2 
 libxfs/xfs_bmap.c       |   17 +--
 libxfs/xfs_btree.c      |    2 
 libxfs/xfs_da_btree.c   |    2 
 libxfs/xfs_dir2.c       |    2 
 libxfs/xfs_errortag.h   |  114 ++++++++++++++-----------
 libxfs/xfs_exchmaps.c   |    4 
 libxfs/xfs_ialloc.c     |    2 
 libxfs/xfs_inode_buf.c  |    4 
 libxfs/xfs_inode_fork.c |    3 
 libxfs/xfs_metafile.c   |    2 
 libxfs/xfs_refcount.c   |    7 -
 libxfs/xfs_rmap.c       |    2 
 libxfs/xfs_rtbitmap.c   |    2 
 scrub/cow_repair.c      |    4 
 scrub/repair.c          |    2 
 xfs_attr_item.c         |    2 
 xfs_buf.c               |    4 
 xfs_error.c             |  216 ++++++------------------------------------------
 xfs_error.h             |   47 ++++------
 xfs_inode.c             |   28 ++----
 xfs_iomap.c             |    4 
 xfs_log.c               |    8 -
 xfs_trans_ail.c         |    2 
 26 files changed, 171 insertions(+), 323 deletions(-)
