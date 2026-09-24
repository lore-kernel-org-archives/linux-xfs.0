Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33639468C15;
	Thu, 24 Sep 2026 10:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244583; cv=none; b=aX7SNDOwlWbferpkfLtZ8L/kVMDk1j1DgYLN0gInjDaz7Iyr8pZ85JTNEOXm93XCyi/4MQ6Sr+rY+FPXFElQtqN32jHtYMbRG6F1bN9HDiECiZGHz2TMjitzl0v9FEBYL7xlSZXfDD0VploqAQo1UK1rSlY2q0lJIiNco5LQa7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244583; c=relaxed/simple;
	bh=3UyPy2SNDmfWYKjEX7vO3Xnw+qhlyQw/pko9rmkMNSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KseZqxpl+fGxsyZ7if1hRKmufPS6Pi2rfQv9Ye358PC+I4LLSmHoBukcYBYAAhq0S+B9wFzG8ZPkaSk/32BnSOBMZSdSPmAKB89PZ4kTSyHqMVc2dZJeZWzPodpRK7/pP/9V71IkZXiHEmlUpMeREgRYeWGNnkxhch8KyT17PZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=htqscCIA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="htqscCIA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=85Oz3yMeaV9xXp8k0wAbZilV/rszXZVHK5syr7smjGE=; b=htqscCIABufS6JaYfkHUIi/rXE
	/o5iBLz8VICVropgVJbsEYX1TnyYvnoYlOKN0l/bpx84roDflIishB9PvLlB05czCxxhntQ/DQIk1
	x1n5sIXcXr3T6zj7cV/a9aXKXqVgNELNEApQEZTRftF60PaDW5D8jmqTGcYoCAo7pAIl3FqOWgngV
	QTfei6q9DljlkPidNBUgCXkt/D6vPrFHJ2Rlu0jYTWX4PKrBiv6fncIeFIRJVSwhv/EgcJp+O0D5X
	BZo3Tb0T6HPZrBytfkROkBNBgQ6gcYs0H6DotrsnHxar18tgfq8Q8WRBJPMCFKq5xe43xjvRZvomF
	LXXqZATA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOQ-0000000AfpE-2iZE;
	Thu, 24 Sep 2026 10:09:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/13] xfs/2303: test that data checksums detect data misplacement
Date: Thu, 24 Sep 2026 12:07:49 +0200
Message-ID: <20260924100855.2734089-9-hch@lst.de>
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

Test that data checksums detect data corruption due to misplacement
by changing the backing files for two zones using the zloop driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2303     | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2303.out |  5 +++
 2 files changed, 93 insertions(+)
 create mode 100755 tests/xfs/2303
 create mode 100644 tests/xfs/2303.out

diff --git a/tests/xfs/2303 b/tests/xfs/2303
new file mode 100755
index 000000000000..7f53fdf94bff
--- /dev/null
+++ b/tests/xfs/2303
@@ -0,0 +1,88 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig
+#
+# FS QA Test No. 2303
+#
+# Test that data checksums detect data corruption due to misplacement
+# by changing the backing files for two zones using the zloop driver.
+#
+. ./common/preamble
+. ./common/filter
+. ./common/renameat2
+. ./common/zoned
+
+_begin_fstest auto zone quick datacsum
+
+_cleanup()
+{
+	[ -n "$mnt" ] && _unmount $mnt 2>/dev/null
+	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
+	_destroy_zloop $zloop_dev
+	cd /
+	rm -rf $loopfile $zloopdir $mnt
+}
+
+_require_test
+_require_renameat2 "exchange"
+_require_loop
+_require_zloop
+# hack to only run for block based file systems
+_require_block_device $SCRATCH_DEV
+
+loopfile="$TEST_DIR/loopfile"
+zloopdir="$TEST_DIR/zloop"
+mnt="$TEST_DIR/mnt"
+
+rm -rf $loopfile $zloopdir $mnt
+mkdir -p $mnt
+truncate -s 1g $loopfile
+
+loop_dev=$(_create_loop_device $loopfile)
+zloop_dev=$(_create_zloop $zloopdir 256 0)
+zloop_id=$(echo $zloop_dev | grep -oE '[0-9]+$')
+
+_try_mkfs_dev $loop_dev -r rtdev=$zloop_dev,csum=crc32c \
+	>> $seqres.full 2>&1 || \
+	_notrun "cannot mkfs filesystem with data checksums"
+_mount $loop_dev -o rtdev=$zloop_dev $mnt
+
+dd if=/dev/urandom of=$mnt/file1 bs=4k count=1 conv=fsync >/dev/null 2>&1
+dd if=/dev/zero of=$mnt/file2 bs=4k count=1 conv=fsync >/dev/null 2>&1
+
+xfs_bmap -v $mnt/file1 >> $seqres.full 2>&1
+xfs_bmap -v $mnt/file2 >> $seqres.full 2>&1
+
+rg1=`xfs_bmap -v $mnt/file1 | head -n 3 | _filter_bmap_gno`
+rg2=`xfs_bmap -v $mnt/file2 | head -n 3 | _filter_bmap_gno`
+if [ "$rg1" == "$rg2" ]; then
+	_fail "both files placed in same RG: $rg1 $rg2"
+fi
+
+zloop_filename1=$(printf "seq-%06u\n" $rg1)
+backing_file1="$zloopdir/$zloop_id/$zloop_filename1"
+zloop_filename2=$(printf "seq-%06u\n" $rg2)
+backing_file2="$zloopdir/$zloop_id/$zloop_filename2"
+
+_unmount $mnt 2>/dev/null
+_destroy_zloop $zloop_dev
+
+# intentionally corrupt data by swapping the two zone files
+ls -i $backing_file1 $backing_file2 >> $seqres.full
+echo "swapping file $backing_file1 and $backing_file2" >> $seqres.full
+$here/src/renameat2 -x $backing_file1 $backing_file2
+ls -i $backing_file1 $backing_file2 >> $seqres.full
+
+zloop_dev=$(_create_zloop $zloopdir 256 0)
+zloop_id=$(echo $zloop_dev | grep -oE '[0-9]+$')
+_mount $loop_dev -o rtdev=$zloop_dev $mnt
+
+# should return an error on buffered read
+echo "Reading file1 using cat - should fail"
+cat $mnt/file1 > /dev/null | _filter_test_dir
+
+# same with direct I/O
+echo "Reading file2 using O_DIRECT - should fail"
+xfs_io -d $mnt/file2 -c 'pread 0 200M' | _filter_test_dir
+
+_exit 0
diff --git a/tests/xfs/2303.out b/tests/xfs/2303.out
new file mode 100644
index 000000000000..fca2c4830e3c
--- /dev/null
+++ b/tests/xfs/2303.out
@@ -0,0 +1,5 @@
+QA output created by 2303
+Reading file1 using cat - should fail
+cat: /mnt/test/mnt/file1: Input/output error
+Reading file2 using O_DIRECT - should fail
+pread: Input/output error
-- 
2.53.0

