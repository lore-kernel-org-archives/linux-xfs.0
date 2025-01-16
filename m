Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF50E4414;
	Thu, 16 Jan 2025 06:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737007322; cv=none; b=L85JfYqwNHl+27qu63TeuBnQpXy1j/YbFSOKGPJgexGElIQkwmUbG9hE0ipZaXqVwkHhW1UKnvQF1+QfEpnxzowg7pBuftapQ9KJaUHOKKsXGe2sB/+p6gNdRAFkGSWwaX6vYa9YdVfHa4WU+dcELT13J1BLmxZwzqEXv2zh7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737007322; c=relaxed/simple;
	bh=6EVTeRJE2qQCguMHU0pY4y9+LWlFHp8/ngKKdgj04Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEDrmb/iPpkO8FPj0D/XV4Sllq43te/rUew2qZV8l588IT8B5De/rkPZ28PLm+rQihbNbzdyIIK2N2YJRwzWHDtXl4EzEITMPOQ5/C3T9oEtFPTHvJIuZqSVEM6qYYhiAWtM/X4ZVx1KUd2sEZzD1aM/vAH8sA6+Ri9R41vjS8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rAqShkry; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rAqShkry"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4DMsSC2RM4vuk2GbjdcAOU5F1L9kx8kK+5rMeV2MByc=; b=rAqShkryCJOX5Icn5jkfzSE6rX
	XnGmJmfJnJ1RT/CnuRwBU1/eTS/jPl6vYt5ZQfnI3JmDdLAL5Aq59jjPl8AfEvOWBCm+0blR3hzO2
	b9CKRSj+CTvpFliRfZs0638JrDDLZCAp+MJgBkwWdrNlg/Bm1VRVQzTRGHRZZZsxDNRadbP0b1esX
	/bxcNgaK2xSJXyYN2l5cJPtgA7Lnf56fK3V7I/xfOXsRRTjMG5wrz5B8q33qDHDChNVlFEaWOHswt
	PeJu531s34v+XKTC7c+1fKk4YxIO6f0W93xbjOBtu4eYhvyc2oCLdWwGy88gXG35w6dykKruYoLSP
	ahQzt3jQ==;
Received: from 2a02-8389-2341-5b80-1199-69ad-3684-6d55.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1199:69ad:3684:6d55] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tYIx5-0000000Dv84-460f;
	Thu, 16 Jan 2025 06:02:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] xfs: check for dead buffers in xfs_buf_find_insert
Date: Thu, 16 Jan 2025 07:01:41 +0100
Message-ID: <20250116060151.87164-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250116060151.87164-1-hch@lst.de>
References: <20250116060151.87164-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting
new buffers") converted xfs_buf_find_insert to use
rhashtable_lookup_get_insert_fast and thus an operation that returns the
existing buffer when an insert would duplicate the hash key.  But this
code path misses the check for a buffer with a reference count of zero,
which could lead to reusing an about to be freed buffer.  Fix this by
using the same atomic_inc_not_zero pattern as xfs_buf_insert.

Fixes: 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting new buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: <stable@vger.kernel.org> # v6.0
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6f313fbf7669..f80e39fde53b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -664,9 +664,8 @@ xfs_buf_find_insert(
 		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
-	if (bp) {
+	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
 		/* found an existing buffer */
-		atomic_inc(&bp->b_hold);
 		spin_unlock(&bch->bc_lock);
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
-- 
2.45.2

