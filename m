Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806762582
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637487; cv=none; b=m0ZNHS+hyDf7wVlMrc85zd3Qq80KlKlUTL/md+AA712XFaVmH7iJZ4vfzLWERhnDgIk0gATT6fuLBY/Dgml4Ko5tEpcf462o4Z/ao1NKrCUjziyitUaGADPJSTCIV2rQqQmnH6LZvl5RTSv+P8cS+wrS2ELwvnI/48SXVU0LR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637487; c=relaxed/simple;
	bh=UCvjJdSb7P9eRBJsorfNp1lAWXDAA8MIGHCGpYV1Y+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UvofaT9jk3d45fMN+dN3uy/L74RezgRYhPJjK+ofcvTViS5d7o2CuREOtuv9GIGVGL8gk59P829CAirCAEABHw8+i5LWLV5BgMKU67jlLF6rmY5LHDPXj9hkrHUr7cEJSYUM4cAnP42yN8wEKXlRf1YN+VxDIpd/l1hd8uUMeJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=34zCvj9W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="34zCvj9W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=LXJj/k6oR04FBOjuxkWz0S80FgfMAZayEJqDvvzCV7M=; b=34zCvj9Ww8ze+OQyYyDjhzmh4n
	0YCCKf9kdIGCz1PSgdBU5jKtut2T8OMsOvpET85CBdxxV6hSIUxtro/LtPYjSXgfVoy6eu48o1TK0
	H1hQ//0DepYJQuyhXvLtOvSUyo9lm75hoxxTk4rEU6CLNtF/U59Lii6Xbly9Y8ZdizUFGFqgfj66r
	d5+7tIAMSRoRSM6m3X1gofsEtCiOX25KmH2FVxTeIccPy0OlITLZLnY8rfLpx/EpT/zrjjfe0iSmn
	jQYB8TgXy+Jn7iV2O/45u7R+RqmiEqwrn+lYTph2SLQwYJHkroUk8V27ASmR1aCEVg95IPuNO3LPG
	SbZML2dA==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnHg-00000007TkB-0oCY;
	Wed, 18 Sep 2024 05:31:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix a DEBUG-only assert failure in xfs/538 v5
Date: Wed, 18 Sep 2024 07:30:02 +0200
Message-ID: <20240918053117.774001-1-hch@lst.de>
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

Changes since v4:
 - pack struct xfs_alloc_arg more tightly

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
