Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E614964F;
	Tue,  3 Mar 2026 00:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498593; cv=none; b=MGbGSWcIUUePwn+km84CK21UMpJ3Pwp+8q51A2g1WGsmaZA2Besn49WI2LqCwNrC8BDyJb/P0/USyFhqo/xVfEzDkdjT2ZrTn8AxPiZssVy/ZUTJAPC84PtpXlgH/AY//adpHjO4i/2mKsOKWbBUd9BeVgJb8ZEEnL0Nl146bhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498593; c=relaxed/simple;
	bh=Z1XzLAb87kPrIXKyM3Qq3hz31wpWhXydvD4M+Kz6LEU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chM19XHkgdwimqf4WW7L6LoODTCdVphgcot5yrawTuN0wb3yqXmMv81VovNHIsSsqluAikxcLWuLeBe/cj83y7VKXX4YzVf9NpQ/tqe+P9DDGXGMiGiTw+hK93TIYtp/tAfTST0hBtGKQkbKmVeRzmhu1J36qqvdx8XRNAWVnhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bfue/6Hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bfue/6Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09019C2BC86;
	Tue,  3 Mar 2026 00:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498593;
	bh=Z1XzLAb87kPrIXKyM3Qq3hz31wpWhXydvD4M+Kz6LEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bfue/6HkGS0wELxFBVbaLRhmUlLHFxhVi+lvNQSZDpL+wlDU85NjZGWBWelszA/4f
	 50lCZK93SZUfjlEmN6egZ1kqxX1RFUga8/rNWzW+RGF5/0z0blkmKKwyIasQWvuKyP
	 aQU5IeKx09clEjrf+6fCCyBVnPHYny7Vc8XeZo4JHPQVVfZ6Pp6Uc/n3c38DBtwTui
	 5IlngNHgtk9bneQmjxk/TDdaKTnu2BlbpnT4q7ZLuVJEkbTcAe39czHQMJAVZspb8/
	 XCTzo09mPjWWX1IjBp4n7ZCDPaS2Ig1jkEmzIH57qmZKolhwihXrlrr6/cSG6cAxup
	 ZfeVuk9mEhHfw==
Date: Mon, 02 Mar 2026 16:43:12 -0800
Subject: [PATCH 09/13] xfs: test xfs_healer can report filesystem shutdowns
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785934.483507.6419838596988060068.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
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

