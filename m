Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3F019EED3;
	Tue, 10 Mar 2026 03:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114749; cv=none; b=QwtYZX7Lfgw7dEaCEHvjFO/vB3GXY8Gucg6e6zGQF/l1bR9j6qxppM50uYgsQ/ioEtIlE+MWom2iH3RiNi7fxBqTpevGduAG3IOk3kIpw1VUuWy/z9+fFH0yjQbuV/gQcG7++fQ8dx7yjGkLZc+5DO+1dGQcYO0YFbzltRJNqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114749; c=relaxed/simple;
	bh=Z1XzLAb87kPrIXKyM3Qq3hz31wpWhXydvD4M+Kz6LEU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKmxNkzNXop5LgsYrkfJkSulCmnT1fDKvHPTlpwjd0sN8StRblA0VbLPq9hKC8XYzeo89USepkChvfSHkwjUvE+4aUXkvQDmsInlgC6PsEotcyzjV75WDx3wb9IElTD4QXI0JaRNlTBMMfMg+/2qOv+kUu5mej8B33Yxx6wv6zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDIavtnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDIavtnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2185AC19423;
	Tue, 10 Mar 2026 03:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114749;
	bh=Z1XzLAb87kPrIXKyM3Qq3hz31wpWhXydvD4M+Kz6LEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UDIavtnf/DvZVGoYcEmBFZB0UgaZv5ydWRoFUUVMOTJipvmFMdiTlt20bviTZekDp
	 FsR7B6sYiHgP2WgSrzNUWueMF+9fFjNeOEuOFplqOmrAvHkUg7fXIT3Wg6Sb682FdK
	 CoR31CEfgL8vyFXTzjGyNL/1Ucs+6ped+qz7Y7ZjsHxXaOsWxanvyShnmQSfySUyi4
	 +KBTDK0gcEaZpw1iX2eeq4a2iMnhZz1x1yxiOuVZTidZl5p9g3tDh3VYgdFHdL4JGS
	 58fOyFua/vxu+MDqSTUq6o0IwgYX0ORKot47ZAWKlHmZasIW5lX2aMHtl+zWvAPhDo
	 PzUkULqIpZQOQ==
Date: Mon, 09 Mar 2026 20:52:28 -0700
Subject: [PATCH 09/14] xfs: test xfs_healer can report filesystem shutdowns
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403941.1186408.2309881878313608797.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that xfs_healer can actually report abnormal filesystem shutdowns.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1898     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1898.out |    4 ++++
 2 files changed, 41 insertions(+)
 create mode 100755 tests/xfs/1898
 create mode 100755 tests/xfs/1898.out


diff --git a/tests/xfs/1898 b/tests/xfs/1898
new file mode 100755
index 00000000000000..2b6c72093e7021
--- /dev/null
+++ b/tests/xfs/1898
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1898
+#
+# Check that xfs_healer can report filesystem shutdowns.
+
+. ./common/preamble
+_begin_fstest auto quick scrub eio selfhealing
+
+. ./common/fuzzy
+. ./common/filter
+. ./common/systemd
+
+_require_scratch_nocheck
+_require_scrub
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_xfs_healer $SCRATCH_MNT
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 500k" -c "fsync" $victim >> $seqres.full
+
+echo "Start healer and shut down"
+_scratch_invoke_xfs_healer "$tmp.healer"
+_scratch_shutdown -f
+
+# Unmount filesystem to start fresh
+echo "Kill healer"
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | _filter_scratch | grep 'shut down'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1898.out b/tests/xfs/1898.out
new file mode 100755
index 00000000000000..f71f848da810ce
--- /dev/null
+++ b/tests/xfs/1898.out
@@ -0,0 +1,4 @@
+QA output created by 1898
+Start healer and shut down
+Kill healer
+SCRATCH_MNT: filesystem shut down due to forced unmount

