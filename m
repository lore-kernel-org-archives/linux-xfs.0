Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDE9F510
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 01:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716253564; cv=none; b=KqSn4+YZZAtaWiZU7m98BscLUWm/cNZmUoMVFApKIddeXYgWK4OiUc/+e7DVEdRIWgwX35whg8HhcFlOlo/cziO4d9yR3BTsSqbzH6p234XuUcfwehKvBYeEuiapyZP1qZmlxm0F4qAy8uopD3+g2Q2x53foBbOwGm3BRi/paw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716253564; c=relaxed/simple;
	bh=FLiRxNRXfix3FidDvsYZRzWZFqTb2hWXWi94GISuDss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQ0dseoq+UFDF9vJK2qSaZ/XsXnqVkiNBFTOHw0y2Xg94qi/6kgchR98sANzh102wXXIWkKuWeeJVSAhtHkQxEifL0icoGxZO/b0dZKYUOStms5P0nIgul/nwvYBObR3612GTpQSR0/H30L+7NTcc2qR6HMIfxd6zXBcHHb9dyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeSYa2LS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeSYa2LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369FBC2BD10;
	Tue, 21 May 2024 01:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716253564;
	bh=FLiRxNRXfix3FidDvsYZRzWZFqTb2hWXWi94GISuDss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WeSYa2LSYEErQz8BHnkS0Qh/LgPIX4iY0v8/RYIWueHhMWXjpGlc2LY/nT3YyAzs5
	 zyUyp4vVqfjZWFATcnj9q3yk1s7cuKbIA3XuPpGEVTEVa+uUSLKo88EsChYF7tcdoB
	 4ZKheG2AGBzBuBPhuc2qa9Xtvg0h18Omo0P6Yv/SJgTNewUvNoXqaweSHY8zfOfY8F
	 uGd7jtFIi48A6kVXKdplZbynzaxrncJ7pfBNxgE0e4+67bfhMfV59aNf5a73RvcPBj
	 nBJxCFdWrbnS4BkGcIeE9DOIANO+FrzgaaoFWDOJlUSOvB3G2QkMTFCjFFdfnf7lnf
	 Qad4PCeaRE0pg==
Date: Mon, 20 May 2024 18:06:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic: test creating and removing symlink xattrs
Message-ID: <20240521010603.GN25518@frogsfrogsfrogs>
References: <20240521010447.GM25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010447.GM25518@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

This began as a regression test for the issues identified in "xfs: allow
symlinks with short remote targets".  To summarize, the kernel XFS code
does not convert a remote symlink back to a shortform symlink after
deleting the attr fork.  Recent attempts to tighten validation have
flagged this incorrectly, so we need a regression test to focus on this
dusty corner of the codebase.

However, there's nothing in here that's xfs-specific so it's a generic
test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/1836     |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1836.out |    2 ++
 2 files changed, 55 insertions(+)
 create mode 100755 tests/generic/1836
 create mode 100644 tests/generic/1836.out

diff --git a/tests/generic/1836 b/tests/generic/1836
new file mode 100755
index 0000000000..d5e45bb47a
--- /dev/null
+++ b/tests/generic/1836
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1836
+#
+# Test that we can add xattrs to a symbolic link, remove all the xattrs, and
+# that the symbolic link doesn't get corrupted.
+#
+. ./common/preamble
+_begin_fstest auto
+
+_supported_fs generic
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+SYMLINK_ADD="0123456789ABCDEF01234567890ABCDEF"
+
+# test from 32 to MAXPATHLEN sized symlink. This should make sure that
+# 256-1024 byte version 2 and 3 inodes are covered.
+SYMLINK=""
+for ((SIZE = 32; SIZE < 1024; SIZE += 32)); do
+	SYMLINK_FILE="$SCRATCH_MNT/symlink.$SIZE"
+	SYMLINK="${SYMLINK}${SYMLINK_ADD}"
+	ln -s $SYMLINK $SYMLINK_FILE > /dev/null 2>&1
+
+# add the extended attributes
+	attr  -Rs 1234567890ab $SYMLINK_FILE < /dev/null > /dev/null 2>&1
+	attr  -Rs 1234567890ac $SYMLINK_FILE < /dev/null > /dev/null 2>&1
+	attr  -Rs 1234567890ad $SYMLINK_FILE < /dev/null > /dev/null 2>&1
+# remove the extended attributes
+	attr  -Rr 1234567890ab $SYMLINK_FILE > /dev/null 2>&1
+	attr  -Rr 1234567890ac $SYMLINK_FILE > /dev/null 2>&1
+	attr  -Rr 1234567890ad $SYMLINK_FILE > /dev/null 2>&1
+done
+
+_scratch_cycle_mount
+
+# Now check the symlink target contents
+SYMLINK=""
+for ((SIZE = 32; SIZE < 1024; SIZE += 32)); do
+	SYMLINK_FILE="$SCRATCH_MNT/symlink.$SIZE"
+	SYMLINK="${SYMLINK}${SYMLINK_ADD}"
+
+	target="$(readlink $SYMLINK_FILE)"
+	test "$target" = "$SYMLINK" || echo "$SYMLINK_FILE: target is corrupt"
+done
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1836.out b/tests/generic/1836.out
new file mode 100644
index 0000000000..cf78922dea
--- /dev/null
+++ b/tests/generic/1836.out
@@ -0,0 +1,2 @@
+QA output created by 1836
+Silence is golden
