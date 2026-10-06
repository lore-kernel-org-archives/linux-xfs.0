Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892333EDE64;
	Tue,  6 Oct 2026 08:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276997; cv=none; b=NEFsKPpOMQRQl7WwcNqnlFnoafoJPRXyw6CwxgvPRYIXDrM0kzoM4jgbdBQe7n2cd2izTFF7TbPgWisfATSKWclZJ7Qxmus5/WF6UoVd1wC1A+SED0/cA5j1rj8q5UBb7PfZbXVllJhoRS6nj6rNWsXXHuIHGgVwKH0qo/6tIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276997; c=relaxed/simple;
	bh=60E+t6q6co0d05gGgr4OkA6j9JDcvD6X4ODinnmyV2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI9YyRNdQIV39L6NfTwSquUl0hUeA/NNsQ+p8NlI2/7LpLC2LizyMX+jWUDsmgFksFSuBM75bRv64rwsLJAvieoKk4zgNffbagdIGBcIqZTwG5mHY+KHpElLScwOg9GVLyKRkpw6n2ODN8lNkmaDeDTAUrsffkTZjMxbO8+TteM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/g4Pjl6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/g4Pjl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4CD1F00899;
	Tue,  6 Oct 2026 08:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276996;
	bh=BtTskWMnfIlp4MDEJfOPivbfPFh+CkjY5SPbGpSoyFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/g4Pjl6C6+Op5R0+aOrTDFV5mjokxIgK0TPliBpUwdiKVfLlNjvD41gKfbnx5jSg
	 39kfG4Qd2WXRB2q0bPptmMK1Q0Ru/DX4ct4F8uXUrbptpKaKv3WHSKnTCQdtCnXkeg
	 MROgu8p46WhcswpABF74ot412084KaYwrq5COIu84aZAVHR0PaXBHCkvJ30evl6f/z
	 mmMnrL14MSB44jNvOfSxGD+x+xALpQQedrHYM6gPpoPYSwc4LU8kL40KE8HPVfPD1w
	 h33AB+UHeezbVjxEPU/+Pd8scnm0aBFgf0x29OkDnHMyDloMrLzkeBsFHiSC9Rz7Df
	 DR4SCbnB52i9Q==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 11/21] fstests: verify statfs f_fsid is derived from the filesystem UUID
Date: Tue,  6 Oct 2026 16:55:37 +0800
Message-ID: <98450cf50f0b962f4b6c2b0a16ec10c47362bccd.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On btrfs and ext4, statfs f_fsid is computed from the filesystem UUID,
so a filesystem created with a known UUID must always report the same
f_fsid. Userspace relies on this, for example fanotify and file handle
users that identify a filesystem across mounts.

Guards against f_fsid changing across kernel versions, which would break
userspace that relies on it.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/902     | 38 ++++++++++++++++++++++++++++++++++++++
 tests/generic/902.out |  2 ++
 2 files changed, 40 insertions(+)
 create mode 100644 tests/generic/902
 create mode 100644 tests/generic/902.out

diff --git a/tests/generic/902 b/tests/generic/902
new file mode 100644
index 000000000000..44dd685a887b
--- /dev/null
+++ b/tests/generic/902
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test No. 902
+#
+# Verify that statfs f_fsid is derived from the filesystem UUID.
+# Create a filesystem with a fixed UUID, mount it, and check that f_fsid
+# matches the expected value. Applies only to filesystems that derive
+# f_fsid from the UUID (btrfs, ext4).
+
+. ./common/preamble
+
+_begin_fstest auto quick
+
+_require_scratch
+_require_uuid_based_fsid
+
+_fixed_by_fs_commit btrfs 72de4807ba84 \
+	"btrfs: derive f_fsid with dev_t only when temp_fsid is active"
+
+_scratch_mkfs_uuid >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+_scratch_mount
+
+blkid $SCRATCH_DEV >> $seqres.full
+f_fsid=$(stat -f -c "%i" $SCRATCH_MNT)
+expected=$(_scratch_expected_fsid)
+
+echo "f_fsid=$f_fsid expected=$expected" >> $seqres.full
+
+[[ $f_fsid == "$expected" ]] || _fail "f_fsid mismatch"
+
+_scratch_unmount
+
+echo "Silence is golden"
+
+_exit 0
diff --git a/tests/generic/902.out b/tests/generic/902.out
new file mode 100644
index 000000000000..e20395365cb5
--- /dev/null
+++ b/tests/generic/902.out
@@ -0,0 +1,2 @@
+QA output created by 902
+Silence is golden
-- 
2.43.0

