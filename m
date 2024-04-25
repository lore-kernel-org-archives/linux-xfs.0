Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DDE1494B4
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051029; cv=none; b=r79CwQrOwNLdgGNnL+2XGCJ+VlYK/LMUZKqL1mZPPcwSXZqQXr2UenC+vv4EsDIxWHf+SOslBYjZY43cjvDAzl4S3YiLXP7GNcHmnCZRuYwe25oHFcNTVugBFY8+VRhvRz7dd6mmS99B3YYBY3rumU6UHXswAz5rIdVZzvtmIao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051029; c=relaxed/simple;
	bh=N+0vJG+WP0A/I9OEw+M8qK2PuvvA4Y2DncnRASgiGwA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JyiAfwYE0ZNnkH02wPFwH/PjNZfLvj2ayrrTn9ZzpRaIF5m1DbPLL8j+Ahf9+XlMN48+a9AgeRI9SOGvn2b0YJgECllV9+U8grtaw/NkLibiHnuYR66SFIf/FvWryzBId0mOkHvG2qExe3xI54VOhcEGpovfpF+QJXgEpHsKYf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ufYZlQlw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ufYZlQlw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=U8LI8UHMu6OEXjPUjgugQMZ14ZpzLD/nWshcZOoeG84=; b=ufYZlQlwAymPQKrmWOXOV32foh
	zvtJCTw5urcWchz4unv24478Wc+fMtZYMFuXM5zpqtDCxu/Igq8Ol7QLJ3mlOGR/7UTmUKzETyX5v
	/l4pWYlGL/pWk13TmPGq7ITMFcvF4pqJ2swqOCdwcYo1chZNbpXGKWl4hlebrrhrX4+2qfcfHI0L6
	ba45VjMjVkQpEUkwGIxLVCQ0t6X9+XRWT+Y5f3veiqLpgO5K/PiNZ2gD+S9Rc1Ys60RYg+3SOFmZk
	1y9KueVmwjJ9BqjgXAGC39ZDDt58x0NJ0d+01VuwTvqV0DEkR+clk2pLJ1mQmiF765Ojgl9ggURGI
	+jvLoVfw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzyyI-00000008RZp-2N9o;
	Thu, 25 Apr 2024 13:17:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: add higher level directory operations helpers
Date: Thu, 25 Apr 2024 15:16:58 +0200
Message-Id: <20240425131703.928936-1-hch@lst.de>
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

with the scrub and online repair code we now duplicate the switching
between the directory format for directory operations in at least two
places for each operation, with the metadir code adding even more for
some of these operations.

This series adds _args helpers to consolidate this code, and then
refactors the checking for the directory format into a single well-defined
helper.

It is based on the online repair patchbombs that Darrick submitted
yesterday.

Diffstat:
 libxfs/xfs_dir2.c     |  274 +++++++++++++++++++++++---------------------------
 libxfs/xfs_dir2.h     |   17 ++-
 libxfs/xfs_exchmaps.c |    9 -
 scrub/dir.c           |    3 
 scrub/dir_repair.c    |   58 ----------
 scrub/readdir.c       |   59 +---------
 xfs_dir2_readdir.c    |   19 +--
 7 files changed, 168 insertions(+), 271 deletions(-)
