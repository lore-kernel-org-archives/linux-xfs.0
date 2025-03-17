Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B491F94C
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190535; cv=none; b=LUSU2z8Ik+0bcH/6GErPBgNoABzrFSuWY/2gwwOZwErs1wP6WWO1yWlAIEpHsIHdAAyKLVWykBfhy0aS9CJA8vdYHXn5KNggdBTfNDXCBz/HJORYMjZU6Px2Bmm2ZW/mNnL6Y+EOXu4Pzxy2AuGGB+yTu6Z9ujssX/zya9kbKKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190535; c=relaxed/simple;
	bh=knpTQa9O0wW7n1UuH42BtLc8GGjEy36HKVhgHWf3t44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HjRsE0nt3hUHMrFei10smzYcKdB1zdjphWLaR/hLgv8yl4mgSlljEAXtOgzWAstngw9yARxyzvVIHGfD47NxltqI4fL+RQyXCNkD91NzV7soEv0J+dZixVsCQq1defYfbmCPH8+APVBBosSWTZZ7Gw6bePbgto7DXD+1C6TpAIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LqX6cLWn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LqX6cLWn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xfhTiwih9SWdzMkjaXeMN3fuX6+edD2ou+CVjMii86k=; b=LqX6cLWnGn3tQKZk5Xf2aUM+1i
	Wp5MOj2gJU8AVN7OlTn9+SOhakYpppr+y0zyfblCo9p1IIS3DF1oZpePddJsz5doVDREisOPHy+JO
	MBJRKxGYgNsbiFjwMct2/9oKWg2jjdzt3UNZ8Nz4Q5W4ZyWRhrWf3+b4CyosBgMIqgzslTJCjQ57a
	TDZUijQcw/qIpg42IUvllWFUu1VTFv086iS2pLSdJkPU8U2UgbvUB22rrwJSQDoDvmhjOXNoaG6p0
	DK7x5ZE8GbliZwbCw+oOE/mq/i2+YsdAr1PSVcpg2m/w1YC1WLjPHEG/oA31hXG7gJjRueFDYkmRv
	6BHcZO/A==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3LJ-00000001InM-0A0Q;
	Mon, 17 Mar 2025 05:48:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: more buffer cache cleanups
Date: Mon, 17 Mar 2025 06:48:31 +0100
Message-ID: <20250317054850.1132557-1-hch@lst.de>
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

this series started by just removing the unused flags argument to the
uncached buf_get/read interfaces but then escalated a bit.  It is still
entirely superfluous cosmetic cleanups, though.

Diffstat:
 b/fs/xfs/libxfs/xfs_ag.c |    2 
 b/fs/xfs/xfs_buf.c       |  165 +++++++++++++++++++++--------------------------
 b/fs/xfs/xfs_buf.h       |    2 
 b/fs/xfs/xfs_fsops.c     |    2 
 b/fs/xfs/xfs_mount.c     |    6 -
 b/fs/xfs/xfs_rtalloc.c   |    4 -
 fs/xfs/xfs_buf.c         |   54 +++------------
 fs/xfs/xfs_buf.h         |    2 
 fs/xfs/xfs_rtalloc.c     |    2 
 9 files changed, 96 insertions(+), 143 deletions(-)
