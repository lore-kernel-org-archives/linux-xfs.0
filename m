Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FF8369999;
	Thu, 18 Dec 2025 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074257; cv=none; b=DhSKx5+idhQnz0nra/3c9iKpsyCsgsbcIwDcsEr99MyoNakXCYxCxGJsSR4YipZFsh52i3pjuHvS6m27xEQVU3fsMQ2FCOyuLgPHjnVoljI3lCTBMDatfHrcsi75uKC0gThKfnqelLu23oeNbwQSSyLQ9G1XDDR1W+pQ7e2gP7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074257; c=relaxed/simple;
	bh=cRuR1889IIePuW+3r75BfcChvvtUaKJSxUOXjJntRNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+n4dyoqPH3fofINgf+IlK6Qi0jmda2Hgy85cC9Jo5BK3qE3uDOaqf9q/dx4YGsPWcMYytnkZchbXSYOQXbG1rie/Luo8gETYdINvlR/SEp6I5m8844M/uhK8ynQg8mKhjThbl9OI1cExUGWDwKnws/PqXef+4ifKoEYqkRQ9HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=psUYloZL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="psUYloZL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nN9joGPElSaD3pxulqbY8mL/QPRq2/0jwk5mzfkoWzU=; b=psUYloZLH1JryGh2fpYUiXBPL6
	ccQDcGixpJNwjo11nBUUwoXjdKI7eJQeMTjDRwEufQEBFxThyzlrHok1S04Ig8u75iGpNYwAeMEV0
	XpQ6Fo2VcC/zsiX55FBzJcLfkKv0QkuJ3GijYY8ICA0rqcqOWQAb3sC7oe2LfC4C7qtIYi8uqq37t
	kvOrmN5bkGjqBck71JxJDa6FaR1NYGCl0+PksAdnHVzrJVn5os71Zb+5lZFD40CFaMBHDq/MfmUJy
	JWa+4FWhc3TNYMoDwb6/nkVPA1cfe+eGPYVvepqE87hv6PHVzIby0rVawzpptzALtkvrHqU1TcDZM
	IRuC51/g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWGad-00000008n3P-0db6;
	Thu, 18 Dec 2025 16:10:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: test that RT growfs not aligned to zone size fails
Date: Thu, 18 Dec 2025 17:10:17 +0100
Message-ID: <20251218161045.1652741-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218161045.1652741-1-hch@lst.de>
References: <20251218161045.1652741-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Check that a file system with a zoned RT subvolume can't be resized to
a size not aligned to the zone size.

Uses a zloop device so that we can control the exact zone size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/652     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/652.out |  4 ++++
 2 files changed, 62 insertions(+)
 create mode 100755 tests/xfs/652
 create mode 100644 tests/xfs/652.out

diff --git a/tests/xfs/652 b/tests/xfs/652
new file mode 100755
index 000000000000..91399be28df0
--- /dev/null
+++ b/tests/xfs/652
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 652
+#
+# Tests that xfs_growfs to a realtime volume size that is not zone aligned is
+# rejected.
+#
+. ./common/preamble
+_begin_fstest auto quick realtime growfs zone
+
+. ./common/filter
+. ./common/zoned
+
+_require_realtime
+_require_zloop
+_require_scratch
+_require_scratch_size $((16 * 1024 * 1024)) # 16GiB in kiB units
+
+_cleanup()
+{
+	if [ -n "$mnt" ]; then
+		_unmount $mnt 2>/dev/null
+	fi
+	_destroy_zloop $zloop
+	cd /
+	rm -r -f $tmp.*
+}
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+fsbsize=4096
+unaligned_size=$((((12 * 1024 * 1024 * 1024) + (fsbsize * 13)) / fsbsize))
+
+mnt="$SCRATCH_MNT/mnt"
+zloopdir="$SCRATCH_MNT/zloop"
+
+mkdir -p $mnt
+zloop=$(_create_zloop $zloopdir 256 2)
+
+echo "Format and mount zloop file system"
+_try_mkfs_dev -b size=4k -r size=10g $zloop >> $seqres.full 2>&1 ||\
+	_notrun "cannot mkfs zoned filesystem"
+_mount $zloop $mnt
+
+echo "Try to grow file system to a not zone aligned size"
+$XFS_GROWFS_PROG -R $unaligned_size $mnt >> $seqres.full 2>&1 && \
+	_fail "growfs to unaligned size succeeded"
+
+echo "Remount file system"
+umount $mnt
+_mount $zloop $mnt
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/652.out b/tests/xfs/652.out
new file mode 100644
index 000000000000..8de9ab41d47f
--- /dev/null
+++ b/tests/xfs/652.out
@@ -0,0 +1,4 @@
+QA output created by 652
+Format and mount zloop file system
+Try to grow file system to a not zone aligned size
+Remount file system
-- 
2.47.3

