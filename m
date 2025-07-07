Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B1E28FFE6
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892815; cv=none; b=S8foFWOn3SRODSXa8My8DBRJmMCeDomJ/+9h49mZmuk/YrNkCKNhD9y/PssJVyvAC7c9JhIq4+HVcaYyIoHkF3eqGHCeY/fx2q+vKnj8hX7AM8WXpxoBkiQ/KGRz/aoUxJoMH1dnNBltyNQHjY6IV8shlwnVT9EImt74QsDvwZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892815; c=relaxed/simple;
	bh=j4Jvc8lTqWvcYz6aL0f/nW0SUdCUA3ZtlU57m9Nyzis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLTwF8WgcRTzIJyrX++N6Pz5CwJvx+CzbHL7TD8Ila6apdcUGqJWkDig7qMr+oE/FvAVeOBeGwwvKyxYJtxbbOw0/strtVXnrZuaQYKeR0a8HrUffgsiIxAomUPvrRYfWR1/8DnlnkIulI0CxriIPdsmIQyZi9vr+cfJGKe6s9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tFZSGHGV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tFZSGHGV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0/LQex390mY1XFvE7u0Ml/adwftBOvtgcNhIJfRPvsE=; b=tFZSGHGVqjHPdHsy4mONI0uueJ
	kAHFN9qGAmovJ1OxuLtXpgkk7DVsE7lV/r77o7AnOwIptXKbUvtjmWgiSRs+RDS+jc++xN+lYeIDs
	RxCCFksF74Y/tcTG9QtT0K6CeKqun6xn4q3p86mFeQYo9rdjBBzhM5OccGPAzA4UkeZWz3ItlleLG
	8SFOP1my2q8/HgnTxaLQIIsZiTDJGS/9WeRL9Sn3WdwGAQGEopwcwhffqWAzIWtwpSgoxTkKl0gI1
	AVNdeR05pb2BFeRYdXLfjq+1ygzdlhUdibmy1drv395onGAuDMEJCV1dGXVjXhrLTVDrD+Jwnho9I
	36HG8xHQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uYlLh-00000002ShW-0Lq6;
	Mon, 07 Jul 2025 12:53:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: remove the call to sync_blockdev in xfs_configure_buftarg
Date: Mon,  7 Jul 2025 14:53:13 +0200
Message-ID: <20250707125323.3022719-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250707125323.3022719-1-hch@lst.de>
References: <20250707125323.3022719-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This extra call is not needed as xfs_alloc_buftarg already calls
sync_blockdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_buf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ba5bd6031ece..558568f78514 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1738,14 +1738,9 @@ xfs_configure_buftarg(
 		return -EINVAL;
 	}
 
-	/*
-	 * Flush the block device pagecache so our bios see anything dirtied
-	 * before mount.
-	 */
 	if (bdev_can_atomic_write(btp->bt_bdev))
 		xfs_configure_buftarg_atomic_writes(btp);
-
-	return sync_blockdev(btp->bt_bdev);
+	return 0;
 }
 
 int
-- 
2.47.2

