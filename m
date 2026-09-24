Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA2F471400;
	Thu, 24 Sep 2026 10:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244568; cv=none; b=PKt502Cd6oAON1iRF1w7F7YwjvjY9+0aRxjGBWaabGNMrIh8ZV1aI0oYDKqLWJANIu4S5kK3i5PjDUAymN6WXWXi4K9NUmtMtsV5ZRH5DApUIUxam11vB37nMDhV4EZzL+MdoGX2w3sKHMyJFx+YwYVIP3FbABdkg+gQ6kCfQCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244568; c=relaxed/simple;
	bh=KxfV9nTmh7iC8QrgZs4grT0OwJVDvQHzc2mY25W9fCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soht/HelFquuJ7MvqxRj8fIt9julVY+6YQBRhzXm6Mut/liNGPI03b4FYBYLtLKTbJBfBy4MvCDhuXjPgUAtiNFscu4I4FfkDxc2HF9oLKo+VZOi38aQaKxU/RJKCQ5xsqBxryxuC2iNig8qHK1Rty1ZDNGmlMc/oYfN1ryIQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g+av7ysB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g+av7ysB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=23jLfzWDA3zRJyoFDpfGfWB064wk+NCU97LxllckENA=; b=g+av7ysBVOfDthXVuODXnHMSpf
	R8Rig0uhDc5xPTHS+jwnNma7jitmqFEi3y8+OVqE+QZ5TxlkLYj7Rpj5fY62Nb2ESCLk0NGkv6V1X
	x72SzGB1PlJV8pbNp9klQbPR0CWzkvFHDig+TzndH1gxkxvRzVImiOArJVUyYdSmTFL7bYajMyHS5
	uMQEevXH+H1uyDgOhWcKWumVttYwrmZxeLDpwCZnVnzH3LU31Llh+NiWYe000DXiTdXNwoZGUCsFJ
	6O6GR3IluuX94Vxf2S3/LS+DLfXM4y4Aw5zaYbuQLal3gFlJ+KUmLDpTwVKaHPZtuaM1Qb4OiNsmv
	3VzhZ28Q==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gO6-0000000AfmZ-2SWZ;
	Thu, 24 Sep 2026 10:09:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/13] common: add a SCRATCH_MKFS_OPTIONS variable
Date: Thu, 24 Sep 2026 12:07:43 +0200
Message-ID: <20260924100855.2734089-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new SCRATCH_MKFS_OPTIONS variable, which contains options that are
only applied to the actualy scratch device, but not to various other
devices like scsi_debug or loop devices created by various test.

This is important to support mkfs options that do not work on arbitrary
devices, like the extended LBA based data checksum support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 README    | 2 ++
 common/rc | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/README b/README
index 8644f163b1ab..cc03f51e1ad3 100644
--- a/README
+++ b/README
@@ -303,6 +303,8 @@ Extra SCRATCH device specifications:
  - Set SCRATCH_LOGDEV to "device for scratch-fs external log"
  - Set SCRATCH_RTDEV to "device for scratch-fs realtime data"
  - If SCRATCH_LOGDEV and/or SCRATCH_RTDEV, the USE_EXTERNAL environment
+ - Set SCRARCH_MKFS_OPTIONS if you want to specify additional mkfs options
+   to be used when creating file system on SCRATCH_DEV.
 
 Tape device specification for xfsdump testing:
  - Set TAPE_DEV to "tape device for testing xfsdump".
diff --git a/common/rc b/common/rc
index 3958ac934980..7fc5ff956959 100644
--- a/common/rc
+++ b/common/rc
@@ -805,12 +805,14 @@ _scratch_do_mkfs()
 	local mkfs_filter=$2
 	shift 2
 	local extra_mkfs_options=$*
+	local mkfs_options
 	local mkfs_status
 	local tmp=`mktemp -u`
 
 	# save mkfs output in case conflict means we need to run again.
 	# only the output for the mkfs that applies should be shown
-	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
+	mkfs_options="$MKFS_OPTIONS $SCRATCH_MKFS_OPTIONS $extra_mkfs_options"
+	eval "$mkfs_cmd $mkfs_options $SCRATCH_DEV" \
 		2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
 
-- 
2.53.0

