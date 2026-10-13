Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874661FCE;
	Tue, 13 Oct 2026 00:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850163; cv=none; b=ZJEHVf/yQEDG25kykL9mKfJf1gKWp6Sp2qy000TBOWLCBqDa5dd6HsZXo+uRt4yg8f73OtsC4UY07JVQ2ylrzf1EzlKW83QBkYVNVcB/tkxGaM2I6gzg1/dGpj25r2Iq/Fi02XPwjEgLKN1a/KCSPSciDIZSmZLz+eq/zJpqwAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850163; c=relaxed/simple;
	bh=CjPUp4OiCpJ7f78ReZh64kFcsK3ScSQHPT7pAGwOaTI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8ouUWWd55Ji1Z58zGGJFsqU2RnFNfZ5PhYavudwSOZa4W2wCNB7ZWFwljPzd7rx/q6hq+4Y4mfHWkMZZ4F4NZ3FhtVc8lhKVKJFNmoKzKXA6z4QL067umyAuiz21uJ8cMgG9cD53gat3Vtl2mBlLvxZNH//qAtfBQiwChXj160=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnHDLrQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnHDLrQA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 10E001F0089B;
	Tue, 13 Oct 2026 00:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850162;
	bh=im4YLrUdMNpERFEnk6mQ3VR0QmThPAWjfnCyEVWhhO4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CnHDLrQAl3LYSDFpWwPRi4tNPbeepaGUQEUwkxuKPom5a7BPdoB7clDSMIYFqgFAf
	 Prqglcw8i3mv49HeO12cJxDOiIgHRXCqnFMzRs/6ZdNwXZrWar91zgV/v5O+/shpEg
	 AoLebl+c/Zs8st1GsVGGOwmt0lDzYuuzHjQ5jkOCmwZQ/8vIHY8HCFeURQDCqZLCao
	 S3UQLPzlNyGnI1b8G6Cj/RpHCO3cLjdEp34/Lg2ZMRg3aRZyP3xL6vgsWkhJbrcRJO
	 L4Ivte59KY58wOBGDdK8TfJbJDV2F4qXS/YA1VfdQea6SAA7fW2bsDxN7NEG3CsEnP
	 ZFvbAwEp+yKsQ==
Date: Mon, 12 Oct 2026 17:09:21 -0700
Subject: [PATCH 3/6] xfs: basic functional testing of media verification
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007510.1732194.305700337269281222.stgit@frogsfrogsfrogs>
In-Reply-To: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

