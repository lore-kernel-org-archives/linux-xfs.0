Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5291B21B4;
	Thu,  1 May 2025 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106986; cv=none; b=LZOs7GwuEyr69PpYlklogmpZjHUQHgRkX8ok2BcoF+cPyflszXXB8KocayIOEujzn5MfCO2F1NHe1AejZmLOwNX8jEXTi97YbVg/zY9/IOdmS1Yg50S/kLF+qT8q/n0nvomHsBkqbS41uMNt6jdLpH6BArtW/+QnVsv+NWUuQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106986; c=relaxed/simple;
	bh=OtfB5bKn+HQtEdFxljlu+JAF5n0TmV1tdotEgckp50Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhCuYk9zWoNSn+HO35186baIgCh1dXKSwzPWvq5VAerznj7N5yDNtdpxAxY7Ob3kN9ZJG6Dqn0mVDcS33LF+LD7YFJ6SwPyVyQU4JViWln053ePKlPNGfZkQ50BWCd1+xTHrPJRVz6ep7/ZkYqmGlDTMjLK0fjizQKQSpqAfGQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CDa3b113; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CDa3b113"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gNa0jNlTgI4b3TpgYRJPABgztA0wh5w0PUc1w76BfKc=; b=CDa3b113gVtEsH1iVFgiHn4hcE
	c7kJrttPwj3cJzDlFXod43LH+dLvbxBRmE5QuW1RQBCeQoqGscvHGGW3Wu8HhHlFpPdyYrMbCLVtm
	EFvsCSUroUqyW2F+5j21QqnxtWXuUpXRDoYgP3waQkgulJKIHrEgrZr97L1xoEHABnw+gc9TXEEFE
	JR2PSJerp1lo55VL564k0010tXs9Fd1vjZyyWFHNQH8EgtFFaBAXz96Qv4wh8ZAfPE5l1QA3NivF9
	79h8/Q916CVwQRPNsqvUn8McvW5GtEaTH0Ih6sfN90OPs62EWBAo+FWjf946jYrMxeNP5fWedw9LD
	5x4L4rJg==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBs-0000000FrPU-24KM;
	Thu, 01 May 2025 13:43:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] xfs: add a test for zoned block accounting after remount
Date: Thu,  1 May 2025 08:42:39 -0500
Message-ID: <20250501134302.2881773-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501134302.2881773-1-hch@lst.de>
References: <20250501134302.2881773-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test for a problem with an earlier version of the zoned XFS mount code
where freeded blocks in an open zone weren't properly accounted for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4201     | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  6 ++++++
 2 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..5367291f3e87
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4201
+#
+# Regression test for mount time accounting of an open zone with freed blocks.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_require_scratch
+_require_odirect
+
+tmp=`mktemp -d`
+
+_cleanup()
+{
+	rm -rf $tmp
+}
+
+#
+# Create a 256MB file system.  This is picked as the lowest common zone size
+# to ensure both files are placed into the same zone.
+#
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/test1 oflag=direct conv=fsync bs=1M count=32
+dd if=/dev/zero of=$SCRATCH_MNT/test2 oflag=direct conv=fsync bs=1M count=32
+rm $SCRATCH_MNT/test1
+
+# let delayed inode deactivate do its work
+sleep 1
+df -h $SCRATCH_MNT > $tmp/df.old
+
+_scratch_cycle_mount
+
+echo "Check that df output matches after remount"
+df -h $SCRATCH_MNT > $tmp/df.new
+diff -u $tmp/df.old $tmp/df.new
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
new file mode 100644
index 000000000000..4cff86d90b0f
--- /dev/null
+++ b/tests/xfs/4201.out
@@ -0,0 +1,6 @@
+QA output created by 4201
+32+0 records in
+32+0 records out
+32+0 records in
+32+0 records out
+Check that df output matches after remount
-- 
2.47.2

