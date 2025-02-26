Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3875123906A
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596259; cv=none; b=KxUROdRhv0vJIRcSdTRmkBqRf5anQOq4EFO20DqBQWKPMXOaaD6szY4aH8xWmq1PewbpTccKR2b+34auscZLXy71Oo+a8SnD64YvGWUWLLC5aN3NNZK6PTYNTSwumQAG+GfGCQ8DeFMDXEnW1vAEg20ra6B5Al2xZdgIJiUNg1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596259; c=relaxed/simple;
	bh=9FR5O3Zf40DoRs02j42WH/1fuALbmK7Ki9JIEs7mwD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BChVqxewP7IxkhwD4k4prNXVQMq7jW25wiPGw5hrQJyr5alhvOnzyTycl2AoWouO/Hiagrv53LzOb/SOOnxdZsCAYHr66CVvhuHMGj4aQJ9MS3wR8lrro0lmWeBVsIl0+7qxdUbxVKZXtsfUOYMS6ubT81UyaKgMeeioUyxRerw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nh6ipZyz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nh6ipZyz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Z4g3kKDYAfcy3DLUAUmQHLlacdPtbIqAo/d4L5lGXVw=; b=nh6ipZyzW78C8p1AFNR5apKbiu
	omeJ1joZkNOH3oQWwuU8xy7JNwcgWC0KcRoYACxnLFT3pWuX6lOX9dRd+4/fjsTp+qCwlb0qURcnQ
	SqCM6G0zcQ/7w5EQpAEerIkRp7fn2eUyZT61QGJ+DsckqkWg1HXZ1D6qHomNKqakU6uOEN+nmYNLl
	cSnE7z8cy3i9x/sNkc1zMKeNBNr88np35hby4/a9wSxdIyPNIh90x0kRqdOOC8mPLmMLzSqo6gnA9
	T2AAp5VwrzBFGVJfOSo9fNWzJ/4U9YIm/EqcgHqYcuJpDoNVI78FZgf3Gmsx+5ZQHs5trd8PrxKRB
	mOlcc1xQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb8-000000053wp-3kCg;
	Wed, 26 Feb 2025 18:57:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 35/44] xfs: disable reflink for zoned file systems
Date: Wed, 26 Feb 2025 10:57:07 -0800
Message-ID: <20250226185723.518867-36-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While the zoned on-disk format supports reflinks, the GC code currently
always unshares reflinks when moving blocks to new zones, thus making the
feature unusuable.  Disable reflinks until the GC code is refcount aware.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b6426f5c8b51..4ea7150692dd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1829,6 +1829,13 @@ xfs_fs_fill_super(
 			goto out_filestream_unmount;
 		}
 
+		if (xfs_has_zoned(mp)) {
+			xfs_alert(mp,
+	"reflink not compatible with zoned RT device!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+
 		if (xfs_globals.always_cow) {
 			xfs_info(mp, "using DEBUG-only always_cow mode.");
 			mp->m_always_cow = true;
-- 
2.45.2

