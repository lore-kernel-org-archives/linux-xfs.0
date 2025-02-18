Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C603922B8B3
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866349; cv=none; b=M0kbJTlLryEPHLI+D0M1YYYJ7oh7TSMm/QTQPGf6c8ih24KOqSfL0IyORKKpYiJhkCGM737MmNp8b8tLbZ7ijARe1ltfWUg4tWJ0LR1EpL7Z4T22C40BDTfz45H841YhRXu1ub1WMptsMbsseROYa0PnFR4De5aCjQALxn+zET4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866349; c=relaxed/simple;
	bh=EjzkT/rKe1MgBOMl6I5oCDY8dKEAcURlBs8ncbsageE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nhs3T/wPaDy6uI/N+o/AL71UT7PBFSdfv2CtTf6PRqEFNrAR2isjKqXT8PY1VicVEUDt/Z0eOyjrT8JY8eQRVfJQWlb/KAYOSaRgQaztdlfsxl/VyhLVhIdHBBAs2KVXTm+56Javeb7bUBWcCflye4v50U7LPkOxN8uOr5tQJFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DD4r/Lz+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DD4r/Lz+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iPBvCRbj/X/JcOUTZEUUZxkMmZj07JMHEYJHLce6e84=; b=DD4r/Lz+DV3flf22R2OWu6TplQ
	UaLz7rcVzrfQ6cUuLqluapBRoC03KnE8iNpj0qBM9A4aTKWbGiPrtH7YyO+uppDKjWxtnocBkS8Cf
	3WsjX9NafUN3EspIik1eV/FK8szIRrYwt9wAlW+nTlkLakO3a62kNQz3UJrBBp16sAVWGFLtRxR6+
	T8A4nHlnv3teJGPAkxFYUlNvwPviVpDcR47SNGELw+bviPO08aJmXfYxA9zpOogBwYSGFvgD0q6j6
	+fdWBUvWc2NFOMdfWBTg7Rr0atdkQUmQVoshbq3H7drTcULjXn+oN0I2Ej9Da2Yw18wr+6wlNPHOi
	UYS744Iw==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIiR-00000007CO8-0nWQ;
	Tue, 18 Feb 2025 08:12:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/45] xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
Date: Tue, 18 Feb 2025 09:10:15 +0100
Message-ID: <20250218081153.3889537-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_reflink_trim_around_shared tries to find shared blocks in the
refcount btree.  Always_cow inodes don't have that tree, so don't
bother.

For the existing always_cow code this is a minor optimization.  For
the upcoming zoned code that can do COW without the rtreflink code it
avoids triggering a NULL pointer dereference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b21cb0d36dd4..fd65e5d7994a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -235,7 +235,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
+	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
-- 
2.45.2

