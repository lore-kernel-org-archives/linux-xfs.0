Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E91F7092
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 06:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104209; cv=none; b=gfZb34l3A3Ps4nUIZjo8R7BM+IF/eqpT2q+Mvhr1FZUe8la6ai72ORpJXy4QObXThNxyOtwrPUgvxzeIozjQd0rePuv8oQXrMSDjixv5iyZoCo3iIMXamQVjwI0hLYpUQO0TTV1N5qtdVwA/1l4uEoPanNUBn0fYyrh+mpRgB6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104209; c=relaxed/simple;
	bh=Y/Zom2PjmxI/iPBBg7lnuiD1JrWn4h5Br5vjcc+zn6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlTpFxV84NJwOGyI/4dAOI7bw3244LI76IzQaQktbISOMOc2FzEAzLUhnKGa3qRq9qFgX+fVd4mMX+OyJZJGn+ndiQvWHxZcLaBRrdSA+LqPHA5hn6WnBu6taXh2wRA5MGuxzTd8hCyKmTZm/9+LvXsisFP6gREbpswRXArxChE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qmocv1XG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qmocv1XG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3X2/z6nf+lfge3kYKAYNImUefISsqW+n6gtkQpgIXXs=; b=Qmocv1XGEMEo/zV/2Y7vn8/xq+
	pTz60puFYcjLngMS9Ygv5wKOnAkZTsC9uV3Wbt/7lN/tZhGCjDggEK6MGTEFnbmihzHkBNLc9vQZ4
	cOQZIOmz+PEvxMALzlpLD4GKyM1K+l4HHrqYbLXCDvF4xndCdG+Pad39eVThVOG1mzPKrNrgH8Irl
	e6Is39yPgxlWeJ5iGuGODn3ACRpr/xlCMNJZAV47DfTVEvqCuVfT4/TTgh0j/pCuB7KD6+u/BtBj9
	gT2vxJshz1eoyd3/nIhEsdCz9bN3ULIXQmIMOEkykZRvGDNzt1SimC3f4FxHMlBwAaY3jphrqI4S3
	wXnSLdHQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN3u9-0000000Eq3s-17mh;
	Thu, 05 Jun 2025 06:16:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/4] xfs: check for shutdown before going to sleep in xfs_select_zone
Date: Thu,  5 Jun 2025 08:16:27 +0200
Message-ID: <20250605061638.993152-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250605061638.993152-1-hch@lst.de>
References: <20250605061638.993152-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Ensure the file system hasn't been shut down before waiting for a free
zone to become available, because that won't happen on a shut down
file system.  Without this processes can occasionally get stuck in
the allocator wait loop when racing with a file system shutdown.
This sporadically happens when running generic/388 or generic/475.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 80add26c0111..0de6f64b3169 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -727,7 +727,7 @@ xfs_select_zone(
 	for (;;) {
 		prepare_to_wait(&zi->zi_zone_wait, &wait, TASK_UNINTERRUPTIBLE);
 		oz = xfs_select_zone_nowait(mp, write_hint, pack_tight);
-		if (oz)
+		if (oz || xfs_is_shutdown(mp))
 			break;
 		schedule();
 	}
-- 
2.47.2

