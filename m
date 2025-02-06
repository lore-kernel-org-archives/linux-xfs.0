Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C964225796
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824412; cv=none; b=WWTHlU0kvisxQF/C5gxl8+aJ9v82zn0on3ArsjFfg79QgZqGc2kW5etVVbNtp1z4kaWTI/Kos+HbCi4q27kS5x0FtfOU7uaTSX9NSyoDkJ3Ejve6FAhvARJBKaRqUzH1Kww3aRKaOdnevenjgBwRzHW6db/jqjKYPHrQJE7Q5ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824412; c=relaxed/simple;
	bh=Hdi9vcSqrOebEWhcVVDMwiLmhLO3mMZs6Y+P2rDMh9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joxcxV7I9KsMAXsDAG9iL4HZvynuJlV/6C5vq1hIWt7eu2rmvztEyXAH6wXSKGh2JTcQFPkfOUY/IOO0ajZIftDvO2Xfl9k2/RvKlCKF6UH6a5BFLCrfjfhNGECzczSasZ6j7ouVg1uX+ohYM9ZliaOv4OwcY3xcQ/qJCQkA6GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KiUKiFU0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KiUKiFU0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0/rNRvp6OAeoD9UZrzYS3vGS8pLp8MN5HiC6wF3E2jc=; b=KiUKiFU027i8S/8xkRnancRFK8
	NfD1U+0Tzkm/hkCc9CXjTPzdTmzXkkmeV9ObLT2LY2DWMF1r5yRl6prfX+OFAvYCRUR55H6IbNEd5
	3Hg+F5fvL4AcmO2vuiBC+u8jwFBg+zK26xJHc3W8OeJ67n6VaIIwGLbvE0rRNrs91sr5Ogq8Vcl1P
	/GYV1Q8VjST1w1+JD8yGxPDKT0H5asxJxwYVBu8aQHsxb2Hr9LgNNRF5SgoAzcTKdISukB3Zaj4G+
	x9tFsbuWuN/2QdQIfNnfvfYz+rmCnuOTTV9CfLGz8L6JO3h0WNQTD1HZIf5iuEO5ckFwqFLpZ+UB7
	8jKc9ewQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvf0-00000005Qn7-1LRn;
	Thu, 06 Feb 2025 06:46:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 34/43] xfs: disable reflink for zoned file systems
Date: Thu,  6 Feb 2025 07:44:50 +0100
Message-ID: <20250206064511.2323878-35-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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
---
 fs/xfs/xfs_super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 34b0f5a80412..ceb1a855453e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1824,6 +1824,13 @@ xfs_fs_fill_super(
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

