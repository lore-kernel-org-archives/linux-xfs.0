Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BC35B1E0
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 05:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725428309; cv=none; b=FClRA2ic446H4DeppnNhjPwEta6bWogH7YMJLKtUHXQl+7P1mBFl9cOFC/HsGcccsBdZFx404O40Im0ZkSOKXULPw/OarwlqivEphte5/EUzKPbi18bzf1bX4+reIdqKbs10TcwP2Qie00xFrPYrgHwjKnWVBQoIsHciSADVoZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725428309; c=relaxed/simple;
	bh=CQBs5KEosBuM2otso1jZeMcWJCg1uHwJdbTQ0mCd6cc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dIwgX5YE7HfTRaKOOM87yIe6g7OaYgMUtpIf+duRd4WysaMBUK8SWcr9/HiNGeh8NbC41fzgqwCeZgAmx1pv2K/zVrt9/GJ1EhSkH3ILwtwPRBLojGy0EKplfFN8pNv5AMQ3FFatbi8U1P1MWZROQ64VD+rYkVoco7AQwdzgkdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BDgMDDWo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BDgMDDWo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WUepUKsyQiSlJpPLc+iypDIJpoDAS0ye4lfkpV/ANOg=; b=BDgMDDWoKUmzwJw6dMuXGfmb3u
	imL2FGwwjIJe805Uowx140X/IfbZkWO1j36M6uiZ3QDtGL1St70Le7hRvKJqN11bXrMRDscvBJZil
	7h2WCpEIMSYXSqrb46BcHGLBrVNsytgj30x1A+Mnx2UnlWGenh/t2P08kbeKureyAE59WcB7xuNzi
	zUSnBxI9Db2PP8ZmXpIeMqC5HI7ukTSpPPFVGeP8fkmnzgaLAcRGimSsayDQp08xiLYlIh9hGWPgs
	TGwDkYTZcoCSookaGYYLeQepAJzI60pUrUUpoIjJLWY9Y2dhLV+G5n/3M0y7m5DoDUf3x0CJcl5YE
	i/Jto/9Q==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sliin-00000002v5y-2C5d;
	Wed, 04 Sep 2024 05:38:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix a DEBUG-only assert failure in xfs/538 v4
Date: Wed,  4 Sep 2024 08:37:51 +0300
Message-ID: <20240904053820.2836285-1-hch@lst.de>
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

Changes since v3:
 - fix compile for !DEBUG again by making sure the minlen error
   injection code is always compiled and then eliminated by the
   compiler

Changes since v2:
 - add back a missing -ENOSPC return from xfs_attr_node_try_addname
 - add another patch to fix potential -ENOSPC confusing from
   xfs_attr_node_try_addname

Changes since v1:
 - fix build for !DEBUG builds
 - improve a comment
 - fix a comment typo

Diffstat;
 xfs_alloc.c     |    7 --
 xfs_alloc.h     |    2 
 xfs_attr.c      |  190 +++++++++++++++++++++++---------------------------------
 xfs_attr_leaf.c |   40 ++++++-----
 xfs_attr_leaf.h |    2 
 xfs_bmap.c      |  140 ++++++++++++-----------------------------
 xfs_da_btree.c  |    5 -
 7 files changed, 153 insertions(+), 233 deletions(-)
