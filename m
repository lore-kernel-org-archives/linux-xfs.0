Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC3F47127D;
	Thu, 10 Sep 2026 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039237; cv=none; b=AA6sTjBiQQWIDhsCQS0Ac9r77hP+J0E2N+icc8kJR/a59WusQ1/xz7fS8afLlEV6tsQg0Ywtqeuw7Eno95UZVLBJKh1lzuqBnRV5XyfmzgIrUliSIQSdRXizhP6MPq/XJhkDRSRqltX0nFPD7ICtMLQCkUio1bXFIw+vaokn/h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039237; c=relaxed/simple;
	bh=RCGYJEhBSAF5DE2tJhdVvO5rz8NP6FGV2iRExhOfowM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RbsNjj2W+3Ompfp4WptPeIuQF1ihu6xVt2BHWlPXvUOTXICsRaDnZf9nY7tnGT1QajbOQQG/OkMpgJLSugROShoEBZGjvBojRNned6HrI8TLB7EkHe0evcW5fVjwu3GmCyN3qr7GYX05EiJFDAUANzb5quOc3PkDLOkKBVO4bc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4hgZwZ32K6zMlDk;
	Thu, 10 Sep 2026 13:20:30 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: pankaj.raghav@linux.dev,
	linux-xfs@vger.kernel.org,
	gost.dev@samsung.com,
	linux-ext4@vger.kernel.org,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3] man/man2/fallocate.2: Add doc for FALLOC_FL_WRITE_ZEROES
Date: Thu, 10 Sep 2026 13:20:23 +0200
Message-ID: <20260910112023.2591987-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4hgZwZ32K6zMlDk

This flag was added to the kernel in v6.17.  As of now, only ext4 and
block device nodes support this flag.

Cc: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: gost.dev@samsung.com
Cc: linux-ext4@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Changes since v2:
- Changed the commit format based on Alejandro's feedback.
- I have retained "preallocated" term based on Zhang Yi's feedback[1]


Note:
This feature was recently added to XFS and it is expected to land in
v7.3. I will update this man page again once v7.3 is released.

[1] https://lore.kernel.org/linux-man/3f17d214-f69c-47b6-abf6-4437cc5840c0@huaweicloud.com/

 man/man2/fallocate.2 | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
index ef6586c77..48a8c3468 100644
--- a/man/man2/fallocate.2
+++ b/man/man2/fallocate.2
@@ -244,6 +244,43 @@ SMB3 (since Linux 3.17)
 .IP \[bu]
 Btrfs (since Linux 4.16)
 .\" commit f27451f229966874a8793995b8e6b74326d125df
+.SS Writing zeroes in file space
+Specifying the
+.B FALLOC_FL_WRITE_ZEROES
+flag (available since Linux 6.17)
+.\" commit 7bd43cc79cab3850f34da0a31d5b042b701590ef
+in
+.I mode
+physically zeros space in the byte range starting at
+.I offset
+and continuing for
+.I size
+bytes.
+Within the specified range,
+blocks are preallocated for the regions that span the holes
+in the file.
+After a successful call,
+subsequent reads from this range will return zeros and
+subsequent writes to that range do not require further
+changes to the file mapping metadata.
+.P
+Zeroing is done within the filesystem.
+The filesystem may use a hardware-accelerated zeroing command
+or may submit regular writes.
+The behavior depends on the filesystem design and the
+available hardware.
+.P
+No other flags may be specified in
+.I mode
+in conjunction with
+.BR FALLOC_FL_WRITE_ZEROES .
+.P
+Not all filesystems support
+.BR FALLOC_FL_WRITE_ZEROES ;
+if a filesystem doesn't support the operation, an error is returned.
+The operation is supported only in ext4 (only for extent-based files)
+since Linux 6.17.
+.\" commit f4265b8d32c49ff95711e6fef7d05245a2905b30
 .SS Increasing file space
 Specifying the
 .B FALLOC_FL_INSERT_RANGE
@@ -385,6 +422,7 @@ or
 is
 .BR FALLOC_FL_COLLAPSE_RANGE ,
 .BR FALLOC_FL_ZERO_RANGE ,
+.BR FALLOC_FL_WRITE_ZEROES ,
 or
 .BR FALLOC_FL_INSERT_RANGE ,
 but the file referred to by

base-commit: d926b42e0ea0406d5c2556e18205eced92d053f1
-- 
2.51.2

