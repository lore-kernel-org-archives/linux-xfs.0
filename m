Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C99A2D739B;
	Wed, 26 Aug 2026 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769082; cv=none; b=usX6GjcfZl0eWa+nh8JmSLEGJsrRhWuErEzWHpN2mWcSy2a1fzQmYA/EhTkdXmMvk88uPm5Q0a5M1QTjx75Nis5p5OgQ9Q6vfT5rcuRG5QwrnNnkjS7sxH6ibm/CkvCnsifx7Br3cJzR+q782yX9XvG7smddxEvDKJbN7C1VlIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769082; c=relaxed/simple;
	bh=wWrqpqk0WwcVPIBst8dBWbTLMtNFr8XE+tQH+QewdJw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qoU0EE0K8JVvfDFCQM+7t85/gnYBt/tSPR9fpfmi24f72/02a+dUdRx37/22UPnXCQNYM7IGTk2zX56ujHhzvPGhZxzutL/ro5rx5OVey4Wk8L7davuKiXbYeL8p71XsBZwnb0HRIS/4gsZF33DlCb/96qUF2e4lcYtCxl8W32g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrT7D6Ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrT7D6Ky"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D4A9E1F000E9;
	Wed, 26 Aug 2026 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787769065;
	bh=YrPQoOn9mjd29DvJqfArGWNVh96uU4FstpryaWG1u2I=;
	h=Date:From:To:Cc:Subject;
	b=HrT7D6Kyl9BjzeQPYeagzg50yM2+mWQmMn1nyNSAsEwDKCaXIrOPycx5HC6GrpUV6
	 W+qVNYoen0uTWQ8c/WJnT3FgZ0NT++6Upt2WXUIvnifRGe23/IR5cWl/EFNUPddyUN
	 WQQikfHtElV3tJjejuha8ckG3WlFm+s6r+3EB24xURTUK3NMXvQhmKx5GQq2OPO88R
	 QIpsFDQXJtIRrvz95uOltt0YGgPFvCcALR7fyCR2SS8YrZjyWJQjz/+IzZTkIxrITV
	 a2JQ2IhB7xnw+UvbYzF3Ie0WQEjzyhz0eLKomNiu38g/BuocEMZOyvuUdw3qCdiMeA
	 M5BEQ5yEbS4IQ==
Date: Wed, 26 Aug 2026 11:31:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: basic functional testing of media verification command
Message-ID: <20260826183105.GX839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Implement a simple testcase to check that media verification works on
however the scratch filesystem is configured.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs         |    3 +
 tests/xfs/1908     |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1908.out |   28 ++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100755 tests/xfs/1908
 create mode 100644 tests/xfs/1908.out

diff --git a/common/xfs b/common/xfs
index 81add2086866c8..8dec3475579e40 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1786,6 +1786,9 @@ _xfs_filter_mkfs()
 	}
 	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
 		print STDERR "rgcount=$1\nrgextents=$2\n";
+	}
+	if (/^\s+=\s+zoned=(\d+)\s+start=(\d+) reserved=(\d+)/) {
+		print STDERR "zoned=$1\nrtstart=$2\nrtreserved=$3\n";
 	}'
 }
 
diff --git a/tests/xfs/1908 b/tests/xfs/1908
new file mode 100755
index 00000000000000..85d55e7060351d
--- /dev/null
+++ b/tests/xfs/1908
@@ -0,0 +1,122 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1908
+#
+# Basic functional testing of the verifymedia command.
+#
+. ./common/preamble
+_begin_fstest auto quick scrub selfhealing
+
+. ./common/filter
+
+_require_xfs_io_command verifymedia
+_require_scratch
+
+# Make the data and rt volumes small enough that this won't take forever
+# on large slow devices.
+_scratch_mkfs_sized $((600 * 1024 * 1024)) | _filter_mkfs 2>$tmp.mkfs >> $seqres.full
+_scratch_mount
+
+. $tmp.mkfs
+
+filter_verifymedia() {
+	grep '^verified' | \
+		tr '/' ' ' | \
+		awk '{printf("VERIFIED=%s WANTED=%s OFFSET=%s\n", $2, $3, $7);}'
+}
+
+testme() {
+	unset VERIFIED
+	unset WANTED
+	unset OFFSET
+
+	local x
+	x=$($XFS_IO_PROG -c "verifymedia $*" $SCRATCH_MNT | filter_verifymedia)
+	eval "$x"
+}
+
+cat $tmp.mkfs >> $seqres.full
+
+DDEV_EOD=$((dblocks * dbsize)) # bytes
+
+# t0: no parameters, which means the whole data device
+testme
+_within_tolerance "t0 wanted range" $WANTED $DDEV_EOD 2% -v
+_within_tolerance "t0 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t0 offset" $OFFSET 0 0 -v
+
+# t1: data device
+testme -d
+_within_tolerance "t1 wanted range" $WANTED $DDEV_EOD 2% -v
+_within_tolerance "t1 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t1 offset" $OFFSET 0 0 -v
+
+# t2: realtime volume
+if [ $rtblocks -gt 0 ]; then
+	testme -r
+	if [ -n "$rtstart" ]; then
+		rtend=$((rtstart + rtblocks))
+	else
+		rtend=$rtblocks
+	fi
+	_within_tolerance "t2 wanted range" $WANTED $((rtend * dbsize)) 2% -v
+	_within_tolerance "t2 verified range" $VERIFIED $WANTED 2% -v
+	_within_tolerance "t2 offset" $OFFSET 0 0 -v
+else
+	cat << ENDL
+t2 wanted range is in range
+t2 verified range is in range
+t2 offset is in range
+ENDL
+fi
+
+# t3: external log volume
+if [ "$ldev" != "internal log" ]; then
+	testme -l
+	_within_tolerance "t3 wanted range" $WANTED $((lblocks * dbsize)) 2% -v
+	_within_tolerance "t3 verified range" $VERIFIED $WANTED 2% -v
+	_within_tolerance "t3 offset" $OFFSET 0 0 -v
+else
+	cat << ENDL
+t3 wanted range is in range
+t3 verified range is in range
+t3 offset is in range
+ENDL
+fi
+
+# t4: start of data device
+testme -d 0m 10m
+_within_tolerance "t4 wanted range" $WANTED $((10 * 1024 * 1024)) 2% -v
+_within_tolerance "t4 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t4 offset" $OFFSET 0 0 -v
+
+# t5: middle of data device
+testme -d 257m 281m
+_within_tolerance "t5 wanted range" $WANTED $((24 * 1024 * 1024)) 2% -v
+_within_tolerance "t5 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t5 offset" $OFFSET $((257 * 1024 * 1024)) 2% -v
+
+# t6: end of data device
+t6_offset=$((DDEV_EOD - (11 * 1024 * 1024)))
+testme -d $t6_offset $DDEV_EOD
+_within_tolerance "t6 wanted range" $WANTED $((11 * 1024 * 1024)) 2% -v
+_within_tolerance "t6 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t6 offset" $OFFSET $t6_offset 2% -v
+
+# t7: start after end
+testme -d 241m 217m
+_within_tolerance "t7 wanted range" $WANTED 0 0 -v
+_within_tolerance "t7 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t7 offset" $OFFSET $((241 * 1024 * 1024)) 2% -v
+
+# t8: range crosses eod
+t8_offset=$((DDEV_EOD - (3 * 1024 * 1024)))
+t8_end=$((DDEV_EOD + (70 * 1024 * 1024)))
+testme -d $t8_offset $t8_end
+_within_tolerance "t8 wanted range" $WANTED $((3 * 1024 * 1024)) 2% -v
+_within_tolerance "t8 verified range" $VERIFIED $WANTED 2% -v
+_within_tolerance "t8 offset" $OFFSET $t8_offset 2% -v
+
+_exit 0
diff --git a/tests/xfs/1908.out b/tests/xfs/1908.out
new file mode 100644
index 00000000000000..bbc55ef31a13a0
--- /dev/null
+++ b/tests/xfs/1908.out
@@ -0,0 +1,28 @@
+QA output created by 1908
+t0 wanted range is in range
+t0 verified range is in range
+t0 offset is in range
+t1 wanted range is in range
+t1 verified range is in range
+t1 offset is in range
+t2 wanted range is in range
+t2 verified range is in range
+t2 offset is in range
+t3 wanted range is in range
+t3 verified range is in range
+t3 offset is in range
+t4 wanted range is in range
+t4 verified range is in range
+t4 offset is in range
+t5 wanted range is in range
+t5 verified range is in range
+t5 offset is in range
+t6 wanted range is in range
+t6 verified range is in range
+t6 offset is in range
+t7 wanted range is in range
+t7 verified range is in range
+t7 offset is in range
+t8 wanted range is in range
+t8 verified range is in range
+t8 offset is in range
