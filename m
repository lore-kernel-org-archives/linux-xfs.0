Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073E74582C0;
	Wed, 19 Aug 2026 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139639; cv=none; b=R34fyIJzwN3rrhaOiHdbveKbbT1XhlDyG7XJVw46UP0ozKZQBibDDvdK8c9MuvqT05tQRh/Vslk4baXCNBwIFA5J+5/eC/B7w8q3zmYODcx1P45CTzE+ruCkA7FT/jBTnqcDDdDSG9rfeNX2RvLr17aw8sDjoGP6PmWDXL9vvd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139639; c=relaxed/simple;
	bh=oxdLZ7PX+hNPpcKI1G/Bv8qg/IUjpBf7s+tg6VNMzIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nOa2BWtMwY0QfrQf2eVhKWZ+1ph/ljKxbjAkibt3LzY6OK9XUEM7dxGgtwhObfGrh1z8Bf2v+nYCj1Juz+gGAZvkt4DtcL3L1zBQ7DfMNcMtxxtw8tNss0apUMIeHW/J88ZH3VmM8zhgNF7ocs0CLGoRhLr1Kj5381umxIZi9dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hQ4Pr1VvWzMlHT;
	Wed, 19 Aug 2026 13:40:32 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-man@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-ext4@vger.kernel.org,
	gost.dev@samsung.com,
	hch@lst.de,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	pankaj.raghav@linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Date: Wed, 19 Aug 2026 13:40:22 +0200
Message-ID: <20260819114022.818734-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4hQ4Pr1VvWzMlHT

This flag was added to the kernel in v6.17. As of now, only ext4
supports this flag.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Note:
This feature was recently added to XFS and it is expected to land in
v7.13. I will update this man page again once v7.13 is released.

 man/man2/fallocate.2 | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
index ef6586c77..b39ca5c8d 100644
--- a/man/man2/fallocate.2
+++ b/man/man2/fallocate.2
@@ -244,6 +244,41 @@ SMB3 (since Linux 3.17)
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
+blocks are allocated with written extents for
+the regions that span the holes in the file.
+After a successful call,
+subsequent reads from this range will return zeros.
+.P
+This
+.I mode
+makes use of the unmap write zeroes functionality feature that many modern
+flash-based storage offers to efficiently zero out the hole space.
+This approach means that the specified range will be physically zeroed out
+on the device (including partial blocks at the either end of the range).
+.P
+No other flags may be specified in
+.I mode
+in conjunction with
+.BR FALLOC_FL_WRITE_ZEROES .
+.P
+Not all filesystems support
+.BR FALLOC_FL_WRITE_ZEROES ;
+if a filesystem doesn't support the operation, an error is returned.
+The operation is supported only in ext4 (since Linux 6.17).
+.\" commit f4265b8d32c49ff95711e6fef7d05245a2905b30
 .SS Increasing file space
 Specifying the
 .B FALLOC_FL_INSERT_RANGE
@@ -385,6 +420,7 @@ or
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

