Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B062950AC3D;
	Mon,  7 Sep 2026 16:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799269; cv=none; b=LMP3dGT6lMHPcc9BYpCar5IiiLjni9sRVMq1H3fvsjxBIv8oA3bgBzf/8W1cpMt7csjzHiWZogy3eSNfmxpHbvpeZMQAJFppy2r3XMWPPxlwvlajUd3ZLMq1q7cxIxv1fc9+natcm9Ue119k+m7m1aKvycCswrZkoc9A1MztfYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799269; c=relaxed/simple;
	bh=ngIE7i8Ri+eoKhNF6qDr/v7o4Y9VH1LeJ3FjJX3joxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJrNWbXy4KAevvFT1z+YrKR61+VNsEXEgYxbiJtDjSqdmfHwMfEq9YaMD/MTjArN9txXi3x2edOtudPZ1HZBLhMJLvF5Jpk6KMos6vHSSr4e0/K0RVhD7p1Ght4exz3oF9QCOwN6jmW7XUljRt1usBxswYeZqE//ayL9XDXGxrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8V6PtIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8V6PtIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59491F00A3A;
	Mon,  7 Sep 2026 16:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788799267;
	bh=vMmfwMEmU393cecn0M4z7/xIIFWOp/h/WposGcvQc/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8V6PtIeWydOObJz+2xu0uPOvwGh3Pk2feyf5Znv+qqY5q1NnI5ogxaOCeeh6Ed5C
	 KR08foL0XV47/psOxkURjb1YrqO+7kepKJYwzO2RVh1V3/b+RGGrhDc+WPDWqIQQov
	 uvmiWKp8Grhy/llpdSWdrSzQ7/H18Wt/1w97so2xEWLV2rbUFu7B97flf4AQP0DRtI
	 S+SwmvE5lLkatXcnlgrzMjRIyeVTi1NZoSMRp8n8BOsT9uXtA+KomCjTSRO48zpxTF
	 SzVuq2MDiD/f1sS9x1jdEVugYcvBNzPio7xjC8uqOgdsfWvtEv1N45gv8W5r1WXu+Z
	 UBNeJBVK4/SPw==
From: cem@kernel.org
To: zlang@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	jack@suse.cz
Subject: [RFC PATCH 2/2] generic: add test for quota enforcement via a nfs share
Date: Mon,  7 Sep 2026 18:40:48 +0200
Message-ID: <20260907164054.111393-3-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907164054.111393-1-cem@kernel.org>
References: <20260907164054.111393-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This tests the quota enforcement when changing the group of a file via a
NFS share, caused by mishandling of capabilities check.
This initially has been found with a XFS filesystem backing the NFS
share, but this still possible to occur on a different filesystem if it
happens to also mishandle capabilities check.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 tests/generic/803     | 106 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out |   2 +
 2 files changed, 108 insertions(+)
 create mode 100755 tests/generic/803
 create mode 100644 tests/generic/803.out

diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100755
index 000000000000..ab889466d80f
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,106 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Red Hat.  All Rights Reserved.
+#
+# FS QA Test No. 803
+#
+# Regression test for group quota evasion via NFS.
+#
+# A user belonging to two groups with quotas enforced on both could bypass
+# group quota by changing a file's group via an NFS client. The NFS server
+# runs as root (real credentials) but impersonates the client user via
+# override_creds() (effective credentials). The old code used
+# has_capability_noaudit(), which checks real credentials, causing
+# XFS_QMOPT_FORCE_RES to be set and bypassing quota checks.
+#
+. ./common/preamble
+_begin_fstest auto quick quota
+
+_cleanup()
+{
+	cd /
+	[ -n "$mpoint" ] && $UMOUNT_PROG $mpoint 2>/dev/null
+	sleep 2
+	[ -n "$exportdir" ] && exportfs -u 127.0.0.1:$exportdir 2>/dev/null
+	_stop_rpcbind
+	$added_to_fsgqa2 && gpasswd -d fsgqa fsgqa2 >> $seqres.full 2>&1
+	rm -rf $tmp.* $mpoint
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/quota
+. ./common/nfs
+
+_require_scratch
+_require_quota
+_require_user
+_require_group fsgqa2
+_require_nfs_server
+_require_nfs_client
+
+_fixed_by_kernel_commit e2f62a9744ebad3bcb6347a648e615026e9efeff \
+	"xfs: fix capability check in xfs"
+
+added_to_fsgqa2=false
+
+_qmount_option "usrquota,grpquota"
+_scratch_mkfs >> $seqres.full 2>&1
+_qmount
+
+# Ensure fsgqa belongs to both fsgqa and fsgqa2 groups.
+if ! id fsgqa | grep -qw fsgqa2; then
+	gpasswd -a fsgqa fsgqa2 >> $seqres.full 2>&1 || \
+		_notrun "Cannot add fsgqa to fsgqa2 group"
+	added_to_fsgqa2=true
+fi
+
+exportdir=$SCRATCH_MNT/exportdir
+mpoint=$TEST_DIR/mpoint-$seq
+nfs_userdir=$mpoint/userdir
+
+mkdir -p $exportdir/userdir $mpoint
+chown fsgqa:fsgqa $exportdir/userdir
+
+setquota -g fsgqa  0 2048 0 0 $SCRATCH_MNT
+setquota -g fsgqa2 0 4096 0 0 $SCRATCH_MNT
+
+# Use exportfs directly so we don't need to deal with /etc/exports file
+exportfs -o rw,insecure,no_root_squash,sync 127.0.0.1:$exportdir \
+	>> $seqres.full 2>&1 || _fail "NFS export of $exportdir failed"
+mount -t nfs -o vers=4 127.0.0.1:$exportdir $mpoint \
+	>> $seqres.full 2>&1 || _fail "NFS mount of $exportdir at $mpoint failed"
+
+# Write a 2MiB file via the NFS share as fsgqa, filling the fsgqa group quota.
+_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/file1 bs=1M count=2 conv=fsync" \
+	>> $seqres.full 2>&1
+
+# Confirm we hit fsgqa group quota limit, a second write must fail.
+_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/verify bs=1M count=1 conv=fsync" \
+	>> $seqres.full 2>&1 \
+	&& _fail "fsgqa group quota not enforced after writing 2MiB"
+rm -f $nfs_userdir/verify
+
+# Change file1 group to fsgqa2 using the NFS share.
+_su fsgqa -c "chgrp fsgqa2 $nfs_userdir/file1" \
+	|| _fail "chgrp of file1 to fsgqa2 failed unexpectedly"
+
+# Write a second 2MiB file via NFS as fsgqa.
+_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/file2 bs=1M count=2 conv=fsync" \
+	>> $seqres.full 2>&1
+
+# Change file2 to group fsgqa2 via using the NFS share.
+_su fsgqa -c "chgrp fsgqa2 $nfs_userdir/file2" \
+	|| _fail "chgrp of file2 to fsgqa2 failed unexpectedly"
+
+# Write a third 2MiB file via the NFS share as fsgqa.
+_su fsgqa -c "dd if=/dev/zero of=$nfs_userdir/file3 bs=1M count=2 conv=fsync" \
+	>> $seqres.full 2>&1
+
+# This chgrp must fail: fsgqa2 is at its 4MiB hardlimit.
+_user_do "chgrp fsgqa2 $nfs_userdir/file3" | \
+	sed "s|$nfs_userdir|MPOINT/userdir|g"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/803.out b/tests/generic/803.out
new file mode 100644
index 000000000000..3830b8595793
--- /dev/null
+++ b/tests/generic/803.out
@@ -0,0 +1,2 @@
+QA output created by 803
+chgrp: changing group of 'MPOINT/userdir/file3': Disk quota exceeded
-- 
2.55.0

