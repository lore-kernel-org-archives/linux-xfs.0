Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BD95C89;
	Tue, 18 Jun 2024 00:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718672012; cv=none; b=Ad+10UaUw7bnT/14cL6xxoY7mkUzJZ/LJzBH207bwKbPBIFZhAjyL0wsu4N3aIPalAkZeTobbHzuf5FlcuDoGIwndaeU4/wTa1eifna13dHl0xSVNdl1rsIKwGqL8a3RchEiXcHAYiW04yUQbCc7FY1oAsggL0CnYWhnoFg1hnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718672012; c=relaxed/simple;
	bh=+FwNxz3sQfGy3wOFs4WpoRRqrPKNMX1XYftI14P5GYo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMiiaS6TrRZd/vWitrUUYR8i4+ViW4QWs/5dIpxPTdgfETKR9bGMxxE+FAYdi5CAKOz0NPiQrde4ziexJTMBuLeoqSu0Gih2D7ilfkYIfax5km+YS2DHmyjB6vOr9fy0JB7MIfRCUJH61beBhkTImajfFWNXJUEDzqVB8sqkz2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZ/0P1xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZ/0P1xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839BAC2BD10;
	Tue, 18 Jun 2024 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718672012;
	bh=+FwNxz3sQfGy3wOFs4WpoRRqrPKNMX1XYftI14P5GYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dZ/0P1xlmUiafotyny5fu0pv55qduWJwsVdVu5Wvy6WvPOyTW6upKVBygXHMCNK3G
	 WlyT5pPedIsfNW46j0fb80XsNw2Fgo/L853KGx1V1mRff/zoRglqsZIZyHQsKpUF64
	 CaoB7lmThdcTeiOrhHrLQMMbNZvnU9QIa0r6nxBucOAH/6MASgsxdDvWj7OOp1vCw/
	 Ew6DCx3tg2xys/1k+SNb3cYatPZiVsmjoUx9Qc+Df5Hvmofo2uswiwxLS0pYnmlFGM
	 eKszuop4Atff1l8K8YbefvsmiJMnH9lfV4L64YcacheEFNkhmws+DwNyDFPu/fjShH
	 AjBI7XelxLJmw==
Date: Mon, 17 Jun 2024 17:53:32 -0700
Subject: [PATCH 2/2] generic: test creating and removing symlink xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, guan@eryu.me,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171867147069.794588.2239729030835992352.stgit@frogsfrogsfrogs>
In-Reply-To: <171867147038.794588.4969508881704066442.stgit@frogsfrogsfrogs>
References: <171867147038.794588.4969508881704066442.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/1836     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1836.out |    2 ++
 2 files changed, 60 insertions(+)
 create mode 100755 tests/generic/1836
 create mode 100644 tests/generic/1836.out


diff --git a/tests/generic/1836 b/tests/generic/1836
new file mode 100755
index 0000000000..1778e207ab
--- /dev/null
+++ b/tests/generic/1836
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1836
+#
+# Test that we can add xattrs to a symbolic link, remove all the xattrs, and
+# that the symbolic link doesn't get corrupted.  This is a regression test for
+# some incorrect checks in the xfs inode verifier.
+#
+. ./common/preamble
+_begin_fstest auto
+
+_supported_fs generic
+_require_scratch
+
+test $FSTYP = "xfs" && \
+	_fixed_by_git_commit kernel XXXXXXXXXXXXX \
+			"xfs: allow symlinks with short remote targets"
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

