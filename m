Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE223D45C1;
	Thu, 20 Aug 2026 09:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216654; cv=none; b=P6TfxAzUWcYb9gECeqza4v76U9vLQjgsPvuRGII6czyZIy776pkndtfcBdS+xPvaW3jvIP9CrZcJeuzkpaE07m+940m2VwpnLDY1JhYifwVLJHnWEJhN5d125Eauj/ShtH9LCbPMPvmBkTXR8XwUS9bEfI80Ec91XkIFWAh30TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216654; c=relaxed/simple;
	bh=uvH402ySxUgyuyVvMa0q7RymEFxqsA8cCh8r76qUyvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QWJYLnIxfPW9DKYE1W9VLe39mcdBlXaqJHq+updvBgjfwU7TseOOARXwOMi0W6bNA+hfncf6ZmS99V8+x7I3ttbZfNeFS3bwFc3QNbZOogHa0+/QjnW73d6BtO/kjvbt8aoxZ0V0Taz7PCD2iU4zCU+QvlPzvafIIa9Di8ptwrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hQctw4cVKz8tcQ;
	Thu, 20 Aug 2026 11:04:08 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-man@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>
Cc: pankaj.raghav@linux.dev,
	hch@lst.de,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	linux-xfs@vger.kernel.org,
	gost.dev@samsung.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-ext4@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Date: Thu, 20 Aug 2026 11:04:00 +0200
Message-ID: <20260820090400.857720-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag was added to the kernel in v6.17. As of now, only ext4 and
block device nodes support this flag.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Changes since v1:
- Change the phrasing around zeroing and its condition (Zhang Yi)
- Update ext4 support only for extent-based files (Zhang Yi)

Note:
This feature was recently added to XFS and it is expected to land in
v7.13. I will update this man page again once v7.13 is released.

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

