Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236274E25;
	Thu, 20 Jun 2024 20:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917188; cv=none; b=FZnRcTnlakhu9FvsM4tXg5Mu92M0gSEAKapBraOL7YdqJy1pLgTlV7vSyfsdOX9HwFMvvRQrEI99+q7LU3wNDDqFA0zciiOWP1ei81AOu8PsZHUzUR5XHRakRtx6AThBKgmP/KqQawyGzDDdLPISWcXsLIub7gI0vsalUpmjXMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917188; c=relaxed/simple;
	bh=enXH2pEXSDvEjzvXRDx3hnHjkAm+w4OwdqNsZua0PSw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rT++MjTHN8shsdN8PuLPnKX+hwrPPEYo8sBSyd6US3byuE1V/DTwrPr0ySWlG09sNr9dyU1G4masV1OBzCUTn5P635jr9h7Mg4rPd97Z77ZGA41ZJrc0p09PRWw/HonNmO0iaTcJjZqB/Gs48FXSefAyBkWGlRRMOqF2SZ6+hHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwIhBJAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwIhBJAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853A0C2BD10;
	Thu, 20 Jun 2024 20:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917188;
	bh=enXH2pEXSDvEjzvXRDx3hnHjkAm+w4OwdqNsZua0PSw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hwIhBJAHyBDx/BoAHE/jhl04vuGmZFAHl0LZdwtZ0ymsqzOyyvg8l3ed1ENvJJ+gL
	 /GtNjYupfpJqhBfoZyU6FSFbd/ATQgZ+1+12Xbe7QtKyEgj3YnxPu/KuhDRbLD2rHl
	 XZHG7WnTFbtmY9X1K0H6yzNjiKa0XGZwM9jcLJqbDBdzXbD0WSP7zLmUG4iR6IJUZc
	 Xe8fbZbiVnlfqZPDMbWZm/m2iJscAtLvpQoeeimpk5sRWXti4rHG61LOap4Qk4Me9A
	 JDP6KF1hlMw0sSRDV9s0NppxF42FNFFfiX/7nIDHbDSydR2RgnbqtN3eHqo3+BfJph
	 2DWPPRkktos2A==
Date: Thu, 20 Jun 2024 13:59:48 -0700
Subject: [PATCH 11/11] xfs: add parent pointer inject test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, Christoph Hellwig <hch@lst.de>,
 fstests@vger.kernel.org, allison.henderson@oracle.com,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171891669807.3035255.7966365981580716720.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers after an error injection and log
replay.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/1853     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1853.out |   14 +++++++++
 2 files changed, 99 insertions(+)
 create mode 100755 tests/xfs/1853
 create mode 100644 tests/xfs/1853.out


diff --git a/tests/xfs/1853 b/tests/xfs/1853
new file mode 100755
index 0000000000..7fdb46a580
--- /dev/null
+++ b/tests/xfs/1853
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 1853
+#
+# parent pointer inject test
+#
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/inject
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
+_require_xfs_io_error_injection "larp"
+_require_xfs_parent
+_require_xfs_io_command "parent"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+$
+: back in the root
+testfolder2 d--755 3 1
+: done
+$
+EOF
+
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
+_check_scratch_fs
+
+_scratch_mount >>$seqres.full 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file4="file4"
+file5="file5"
+
+echo ""
+
+# Create files
+touch $SCRATCH_MNT/$testfolder1/$file4
+_xfs_verify_parent "$testfolder1" "$file4" "$testfolder1/$file4"
+
+# Inject error
+_scratch_inject_error "larp"
+
+# Move files
+mv $SCRATCH_MNT/$testfolder1/$file4 $SCRATCH_MNT/$testfolder2/$file5 2>&1 \
+	| _filter_scratch
+
+# FS should be shut down, touch will fail
+touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
+
+# Remount to replay log
+_scratch_remount_dump_log >> $seqres.full
+
+# FS should be online, touch should succeed
+touch $SCRATCH_MNT/$testfolder2/$file5
+
+# Check files again
+_xfs_verify_parent "$testfolder2" "$file5" "$testfolder2/$file5"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1853.out b/tests/xfs/1853.out
new file mode 100644
index 0000000000..736f6dec00
--- /dev/null
+++ b/tests/xfs/1853.out
@@ -0,0 +1,14 @@
+QA output created by 1853
+
+*** testfolder1 OK
+*** testfolder1/file4 OK
+*** testfolder1/file4 OK
+*** Verified parent pointer: name:file4, namelen:5
+*** Parent pointer OK for child testfolder1/file4
+mv: cannot stat 'SCRATCH_MNT/testfolder1/file4': Input/output error
+touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
+*** testfolder2 OK
+*** testfolder2/file5 OK
+*** testfolder2/file5 OK
+*** Verified parent pointer: name:file5, namelen:5
+*** Parent pointer OK for child testfolder2/file5

