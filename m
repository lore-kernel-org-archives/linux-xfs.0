Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9CF6F31C;
	Thu, 20 Jun 2024 21:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917267; cv=none; b=OPQCeTNdVYJ+X+iLWDrv4tW+THMztOKZuHYsU9lFpxWa4A+2jjgYBmsbcJ7jJVkmL5eUrYRe1XFsegSmh8JLkWyDPIGb50QaRmh0Vr8qeBIp9N733PVnDMOjRlH+sbmHh12Cxr7rW5Q0JoHxp90slBa5O2DfE2UeZGvSbYw32W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917267; c=relaxed/simple;
	bh=+FwNxz3sQfGy3wOFs4WpoRRqrPKNMX1XYftI14P5GYo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/+2Mdtkq96MWI9CzOMIPrie/bUVgb5kMqO7Pe4p9QNcyxrz0NkkebZx4p+32X/jeE5oKNIrCtuaoUkks8mDZg/EgAXArtcYllEt6ep0kBHQbU3hVFLCkhFOa2Kiv/v+K9YBDWCyVYIzmI4On1Jeevw8lnUq3OPMIR6OCi4Y3A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWzmsKQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWzmsKQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE6AC4AF07;
	Thu, 20 Jun 2024 21:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917266;
	bh=+FwNxz3sQfGy3wOFs4WpoRRqrPKNMX1XYftI14P5GYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FWzmsKQltz/OMPBwVrYuGCo3bFwYGwvg/CLpnPUJYQLCxvhTIIKr1i0SRvf95EeEg
	 AsgH30VAjM/+b2WiG1ibPvISz3alywgi6yNmw+bukHPaRbZO/eCt6eX0qM06lOHc4c
	 tYheK0xV2Ol6+SpX92khM6jgsguSXuJ2Y4G1duFZ1oe+IeJ6JHLU6F3n+t3WB9GRGg
	 aw6eNPyVgly6tYTuAZqG4y4vvuNZJlp7HbELYf2dnnGz4DTLiBB6/CIfk9OgAtbyth
	 BNZ4CovIOtIUQsdzxx506AiCDrnlv6BAeLQRP9HRBgQEf8e2bVJi2SLF5QMlMxjV80
	 TsVtHMdPlZByQ==
Date: Thu, 20 Jun 2024 14:01:06 -0700
Subject: [PATCH 2/2] generic: test creating and removing symlink xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171891670909.3035892.15148505199828126713.stgit@frogsfrogsfrogs>
In-Reply-To: <171891670876.3035892.9416209648004785171.stgit@frogsfrogsfrogs>
References: <171891670876.3035892.9416209648004785171.stgit@frogsfrogsfrogs>
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

