Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C673BE15F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226319; cv=none; b=q15rB4S0EJNUJHpnkSq/6txA8/OwoTaKE4py5ARF6ZIEDgu6Rbx3ks610fauEA9rQl0z5hbPkT3u4gK8P+mUMSpIJgKyM0UhmrYTTxK7TEotWKGeitqenUexwTvI9uN6lfU2yHshU4zClu+qttE6yLoU/RvrUMkXsugPTP+dH4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226319; c=relaxed/simple;
	bh=eBo2ug0UMsn7jCHYmAB99X5t/n/ZHZ7DxB3MnswUvnw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDsmOEkfp0uDjsz40ZHMk4A0mJoCL8lPJfKUGKVgaHuCu/QSSha3ePkN2LLoqfdt824Hj8GTFLB4G4tdq2uFxVTKD7IsleV0vVMhhwp4CJcUlNbdowPu8kcDraaCXHAcuQaSfbX6iA4l4TzjKoSkAkys815uIHWSUQw1/FTGWXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WOxVjqr3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WOxVjqr3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8zCTbtwgM+OXIw5yXbHvDhyCT2AXm72LRQSyAEwS8so=; b=WOxVjqr3ApqXBf4owTNMzczwTj
	j9QrBu9OfFpYpIAfJKTSxsYPajtEhsLISi3f1YpMvrApZvpqpnS1h3t4++VyjK9TpaNvFSfaiCZyB
	sbEo+6WI+0fRJMeelNI+OXcW/GC2hqrqVkh5HD7kkW3lVzZgC0e5bFqZLZWVEtsYZL5tZVZAPH4A0
	bHiZ2/7+Q1Uku9E4M/nRv5wHwVCx5HwDVTmM136o6DebLfAEDa6nm4zZdDoQYgiTJ2tTQuWWliRIY
	RA9tNLOkd0o48aM7LBHgU2KX3z7YS1RZh6zMGtSqWyudohCxGyOuuuXv+X71cG7nc+vkZz62EqakF
	KcE4E9fA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocuq-00000004grc-16ge;
	Tue, 28 Jul 2026 08:11:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: misc buffer cache improvements v2
Date: Tue, 28 Jul 2026 10:11:08 +0200
Message-ID: <20260728081152.1778841-1-hch@lst.de>
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

a bunch of misc xfs_buf patches.  These came out of a little
project that needs a async read API (not actually included here),
and to get there a lot of lose ends had to be cleaned up, and a
lockless path for readaheads that doesn't kick off the read fell
out easily.

Changes since v1:
 - fix a bisection hazard where xfs_incore would return 0 instead of
   ENOENT for a few commits
 - update a few comments to better describe the logic
 - fix a spelling error in a comment
 - clear *bpp when returning failures from the public APIs to be
   consistent
 - give xfs_find_get_buf a __-prefix

Diffstat:
 libxfs/xfs_btree_staging.c |    7 
 libxfs/xfs_dquot_buf.c     |    8 
 libxfs/xfs_ialloc.c        |    2 
 libxfs/xfs_inode_buf.c     |   15 -
 xfs_buf.c                  |  417 ++++++++++++++++++++++++---------------------
 xfs_buf.h                  |    8 
 xfs_buf_item.c             |   10 -
 xfs_buf_item_recover.c     |    3 
 xfs_dquot_item_recover.c   |    1 
 xfs_fsops.c                |    2 
 xfs_inode.c                |    4 
 xfs_inode_item_recover.c   |    1 
 xfs_log_recover.c          |    5 
 xfs_trace.h                |    2 
 xfs_trans_buf.c            |    7 
 15 files changed, 261 insertions(+), 231 deletions(-)
