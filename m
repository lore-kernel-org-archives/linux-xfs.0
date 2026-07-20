Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E834E3D1A99
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540779; cv=none; b=ICOG3bQjYRcFSSCZg7jTjxPImoF0Zys4jd7IoKaHlnp3l4+Kgh+/vzv20U+jsbuf4x0lFOI25kl+2q6T4uuuV7dGYHMYNKUbi/htseENeO5Msud9pHgaE7JGmHK0787GCGnBV13M39Ur0EwAAgO8GF5pam9wt93DQtN3M1Mwd3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540779; c=relaxed/simple;
	bh=VEvSgcWxocnL7Eei8oHrrjurAB30LomLURSIvMAwIqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQdqKLEw+tt9POzSPsjWpRLsoOlWIqjNGc2zAqGCflRixuApcm+maSzvew35+Nu6smjSEP9+0DzEUsERYL4HI78nwyZgWGoZkuthMd5un5zIpEAZUoW4uo8r+cTR/IZElpwcU9jw/y19RwNlG6Yk2hPkAz7DJUQZUPUTWlPykNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PSuai9Ip; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PSuai9Ip"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rQlmgISNz3FrQWXzZSDrMYDDkgIoM9E/6ktM0vFOTOE=; b=PSuai9Ip/QG46GLVdmiMr9Gi88
	ZdRY38RzoTDVACnp4ZX9XclVwxTXneCpppVlEUCFCUNKKNSihxAtBM1NnpKCjWpHIyH9gqavn2ysZ
	ZBmHmIC1d1PXu4EcpIBcJNnu2tLPfWCzqbsd3pv9rySeQZhf2DklheXKKzmqZKL2cSi1xLGXjmk7j
	VUzxpaQ6ErYSoo0+Qfr0LzY1e9n8mTwX/fn9Um1HwOgfTJgkI2/JAA9d5/x6m4Co7GF/XrQRj7dyU
	4k6n9+vsu3Mbeg4k08Wz99ERR7jNqUhkth5E4PFNEny4UIO/j2ibWSaKq5gn5lKV8QTK0UXYqiQx7
	HMOQFd6Q==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZk-00000006MhW-45wz;
	Mon, 20 Jul 2026 09:46:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: fix the lock annotation in xfs_extent_busy_update_extent
Date: Mon, 20 Jul 2026 11:45:39 +0200
Message-ID: <20260720094609.2191633-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Name the correct lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 41cf0605ec22..6da8c1f938aa 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -161,8 +161,8 @@ xfs_extent_busy_update_extent(
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
 	bool			userdata)
-		__releases(&eb->eb_lock)
-		__acquires(&eb->eb_lock)
+		__releases(&xg->xg_busy_extents->eb_lock)
+		__acquires(&xg->xg_busy_extents->eb_lock)
 {
 	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	xfs_agblock_t		fend = fbno + flen;
-- 
2.53.0

