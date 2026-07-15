Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1781E3955CF
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127112; cv=none; b=H3RRdwIXDn7rsDeotl4WY7vc2ck2as9SMpNCw4QuNj7+VKeo7U8SLEcGGg0w9vnLGLTIoqn9GISG7D5CiFoRymk3nrsM3ixVAUjlQggeexENBAYef8CT0r6XXeM4VSfG0GDqCKcoIt5jil3v0b7Xqfym/qTNq+XupoY8x0jeJrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127112; c=relaxed/simple;
	bh=xglo7iAfkQmN0C1l91ZnVQ+ddP1SJh5Eg/nXhI6CVZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FOXl8OiiMeKRvwlwP3Tt375RiYhaTOSW4S/X4y9RLPJ9dKXQdqGCF9HmgfjiqGdw3FCFhLiDJL6CGBDHXBefT0xdqYju2k30gzyBHz6mK+EDcaijp7X6FNuZ9uyr0y/ilgDwlP3TZCGqM3vbsvIFlC6f0ejxGmibNY8jHQcpA4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VheiPn5d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VheiPn5d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=QWuUzuoF1w44zHSGcNzyke5k+AlX9jNdqZexI60+4c8=; b=VheiPn5dvjTOtvP6w7vRwpuigA
	2ApNaoHMRzUteaFEasrOtMj6++u9gzKtcSWsnylTE2EUUUG03CUB1BJ+waRQKVAS83ev08JWUcFFq
	ejlyF/3rXSPwUSyULq716ZZdQklIYNJLirCM7WwxL+fkChXL/447rO6yubd6ym9TxSQyam43ZFDGH
	WjZIPIB4rJGzTBSdPNzVlQrRqgmfj8h8UrgtgR1nlsVp8nJ4xPI6UeaIwF+gFzTFu/GqC71Q/Amh9
	R/Q0TcY9e5QT1m8pKqZWcOizcQ0DS7MGIggJ8Rpa53tw0tWCgVau+UwV6p1cuN1EUCxcHlQAVyziL
	WpFxO4Mw==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0xi-0000000FDUJ-1Iwk;
	Wed, 15 Jul 2026 14:51:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc buffer cache improvements
Date: Wed, 15 Jul 2026 16:50:53 +0200
Message-ID: <20260715145147.95654-1-hch@lst.de>
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

Diffstat:
 libxfs/xfs_btree_staging.c |    7 
 libxfs/xfs_dquot_buf.c     |    8 
 libxfs/xfs_ialloc.c        |    2 
 libxfs/xfs_inode_buf.c     |   15 -
 xfs_buf.c                  |  392 +++++++++++++++++++++++----------------------
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
 15 files changed, 239 insertions(+), 228 deletions(-)
