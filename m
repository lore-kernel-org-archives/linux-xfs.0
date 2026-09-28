Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC16B3A59A2;
	Mon, 28 Sep 2026 15:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609805; cv=none; b=T1E8FOXRDuX9C3UQNDjLv6MEOUhN1JEA8FxEZovVK86nnxmyoXEJTzcbxZ24ngci+a4A7ClGG86ySyX/yKDiG1Wc6MyU8+C8iw0F2ve2ebP4BmcPlCjd6YyIE3M0eAxsx2SeTXv87+y5ny9W3kB6G9pCQcNBjM7/SgWAbrheqrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609805; c=relaxed/simple;
	bh=/mHgIPpRjmXwEcdt+UjSjyzf8Yc2Dqo3KFsB57DM8PA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQnYF6PyVDZQIk7KGOXFZ5fiKPOvU7xxt6Kp1WS/zJxfkd8h0Uxvie2IWhIFNxQQJctLSFUUDjkS8HYzxLfiXeCD43DL9sCwZcMYKGNDThtBHdbWEZ8dPwayXdEJ9hwge5jggxGm7qq7ur16srVQVLH1m2uw7OJa3By0YVQyPHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKdOWtUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKdOWtUt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 667DA1F000FF;
	Mon, 28 Sep 2026 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790609803;
	bh=Ed6irL5wRxAHdaMwnWcAvghSHyBG9zzQ6I152s6Gbzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bKdOWtUto7CR5B/nOS2br2WNzKNE7l/kpkMW86SASrTpJUqwnZq+0iSb8qe1IzmTB
	 faOxt5NHEMb2dfq8/leFrzo4pQqyyoijXarjSIF5+ouYOmP9kE+PLF8M7DfPZhuF/J
	 aQFpNP50Tg4LxOQuyFIYiTi5kvVM1b/DslMXBZwymd8mPUuTgASiDxa4eE+Ivxx25i
	 r+iESPCU/UhZTGkSnNVJNNv/OX/X+J/RK0mpnAPYpx41Tq2VN06xEJ3OHbyQqtkVan
	 rw0I8tugOf+KQtzOxzwahXgGYz6XzZWaKqwtegP/symTRBNt6qxirs/dfRLFXtV/64
	 z1SpSxrYQUrtg==
Date: Mon, 28 Sep 2026 08:36:42 -0700
Subject: [PATCH 3/4] xfs: basic functional testing of media verification
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <179060965824.790984.9346083899208929049.stgit@frogsfrogsfrogs>
In-Reply-To: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Implement a simple testcase to check that media verification works on
however the scratch filesystem is configured.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1908     |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1908.out |   28 ++++++++++++
 2 files changed, 151 insertions(+)
 create mode 100755 tests/xfs/1908
 create mode 100644 tests/xfs/1908.out


diff --git a/tests/xfs/1908 b/tests/xfs/1908
new file mode 100755
index 00000000000000..93a87293adbcef
--- /dev/null
+++ b/tests/xfs/1908
@@ -0,0 +1,123 @@
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
+_scratch_mkfs_sized $((600 * 1024 * 1024)) | \
+	_filter_mkfs 2>$tmp.mkfs >> $seqres.full
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

