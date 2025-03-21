Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C891E9B1C;
	Fri, 21 Mar 2025 07:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541726; cv=none; b=iLTOMzBD183PAS4NeNfqnM47TJ3nwdRVYoIjg1z2DqcMUqTPnb4KhokRv5lEgfmqQlgCxcwa3tbYEMuS5IUeI3Iyr0Ucmhy02OQ7veRvwFUoGmB9CcN2CFfWkIgj8Nn3YDOAtFBss2ZanAwFgXomr1n2aAZgaD3vt1DRlJxvQBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541726; c=relaxed/simple;
	bh=+oiblQz8SYHAi8zR00SxuiDl2eTeaaXo80n/As5iLaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsbnBAG2q6PSmzAaTldxXkzEKrbcd1xytSCJEKqHRJnmHfn7vAyY5QaPzJH1vfU/IkAYSzdEwoG5q40NOnSLlAiWOpp/O+VUmR4aTmH38enchVyP8CDDxyknq6tzHYc/HidDZhRTawZLeAaazv7sY/J1/jpIN73XWXGSeiDerxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N+eFaTYO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N+eFaTYO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QHj0REmAqKaM449EbJjH/bm59DC4DIvklcSeq9s8HV8=; b=N+eFaTYOtEz6i1vjk64z4qRKy1
	LeCy36pjvlPt7F6wBH3cD8yc+bBcOjy0Upbvd5UH4uWyQqEYVX2ULE+uvlzRHEvRDVh28M/Hrq8ti
	j7dKBa0PxAo6KnV6PrwInTYuYYinfz/aiq0TlykbmjW+TmKZFGaOcagibk9h9pAEnZezRP7fSyjnZ
	QtE4nbJSb/Cm4Jw4QtQ57d/3TeU6c7ugicWLjJI8phLeHfKHQfwDyzr4KBH5wI56mlrUbV9tpJRZt
	DKkW60KVijKj3MGy6TFSiK2KahZh5fUNnbUzPbVd4fKnstmxE4Qg43BARkTtk1XFcjgOI1tZL1huW
	nLKZ0bbg==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhg-0000000E5FH-0itQ;
	Fri, 21 Mar 2025 07:22:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/13] xfs: handle zoned file systems in _scratch_xfs_force_no_metadir
Date: Fri, 21 Mar 2025 08:21:36 +0100
Message-ID: <20250321072145.1675257-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems required the metadir feature.  If the tests are run
on a conventional block device as the RT device, we can simply remove
the zoned flag an run the test, but if the file systems sits on a zoned
block device there is no way to run a test that wants a non-metadir
file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/xfs b/common/xfs
index 3663e4cf03bd..c1b4c5577b2b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2049,6 +2049,12 @@ _scratch_xfs_find_metafile()
 # Force metadata directories off.
 _scratch_xfs_force_no_metadir()
 {
+	_require_non_zoned_device $SCRATCH_DEV
+	# metadir is required for when the rt device is on a zoned device
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+		_require_non_zoned_device $SCRATCH_RTDEV
+	fi
+
 	# Remove any mkfs-time quota options because those are only supported
 	# with metadir=1
 	for opt in uquota gquota pquota; do
@@ -2068,6 +2074,12 @@ _scratch_xfs_force_no_metadir()
 	# that option.
 	if grep -q 'metadir=' $MKFS_XFS_PROG; then
 		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
+	fi	
+
+	# Replace any explicit zonedr option with zoned=0
+	if echo "$MKFS_OPTIONS" | grep -q 'zoned='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/zoned=[0-9]*/zoned=0/g' -e 's/zoned\([, ]\)/zoned=0\1/g')"
+		return
 	fi
 }
 
-- 
2.45.2

