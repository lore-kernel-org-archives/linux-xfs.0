Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDEC19754D
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222417; cv=none; b=u35LqvtaZf7nSD6O1mjuJ8e4CAtb1ngAt/IRFBfVzNIXqp8yH8Hh2MTi3isNLddiyC7biDs95NOz6Qu0dAgHi6zLSGl9xoQzmEeV5USTxiOeK+Zu8/axMFTQ+Oa41Uy8zGWrIwg5bo4+gAaXP7b4T2UeOmemrThAzzlyDYIlJkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222417; c=relaxed/simple;
	bh=DI/rDXU61NdUSxjrsB+kKEpTKh7ivbJ54qIaTpUSe60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vg02tEVMY4lo9eRbBNPScLHJNQvXCCItmDqkEtgkPmCHNIZcuj+RnsASYP8YdKQuwXuzD83OKLGIg8FtyzDMWd9hr+58elaBRn4Zz+PgTPSG3EKgXWJuHa+jRg6iuWsFptuWLbx4Flj90ll7MVfD0RHF+5xkPEPKvfOGNdoNtyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFNXb0Sk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFNXb0Sk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730222413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D7VOhplXjq0WHVBmGFXpK38St65iMG6GsMAHhX+GTxs=;
	b=HFNXb0SkdaFD6eIbHQLp7dOyOV+DhwCsc+CV3RJrTCfkCzZ6VlYFxWdWAMxVK13eJviBS3
	3YzADEyGwgIo1Fl8TsSzoOfHeL8OqoeHLKGFdi/eAbX/BWwhEyzrxN8ZnYz/qGESeXntcZ
	aWdd/0dBwpBUVrNWHjKFno4jX6VN6EQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-Y4JjDDgzPkSc0H1S5h2u6w-1; Tue,
 29 Oct 2024 13:20:10 -0400
X-MC-Unique: Y4JjDDgzPkSc0H1S5h2u6w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DFC51956083;
	Tue, 29 Oct 2024 17:20:09 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.135])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 23E4719560AA;
	Tue, 29 Oct 2024 17:20:08 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH v2 1/2] xfs: online grow vs. log recovery stress test
Date: Tue, 29 Oct 2024 13:21:34 -0400
Message-ID: <20241029172135.329428-2-bfoster@redhat.com>
In-Reply-To: <20241029172135.329428-1-bfoster@redhat.com>
References: <20241029172135.329428-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

fstests includes decent functional tests for online growfs and
shrink, and decent stress tests for crash and log recovery, but no
combination of the two. This test combines bits from a typical
growfs stress test like xfs/104 with crash recovery cycles from a
test like generic/388. As a result, this reproduces at least a
couple recently fixed issues related to log recovery of online
growfs operations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/609     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/609.out |  2 ++
 2 files changed, 83 insertions(+)
 create mode 100755 tests/xfs/609
 create mode 100644 tests/xfs/609.out

diff --git a/tests/xfs/609 b/tests/xfs/609
new file mode 100755
index 00000000..4df966f7
--- /dev/null
+++ b/tests/xfs/609
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 609
+#
+# Test XFS online growfs log recovery.
+#
+. ./common/preamble
+_begin_fstest auto growfs stress shutdown log recoveryloop
+
+# Import common functions.
+. ./common/filter
+
+_stress_scratch()
+{
+	procs=4
+	nops=999999
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
+}
+
+_require_scratch
+_require_command "$XFS_GROWFS_PROG" xfs_growfs
+_require_command "$KILLALL_PROG" killall
+
+_cleanup()
+{
+	$KILLALL_ALL fsstress > /dev/null 2>&1
+	wait
+	cd /
+	rm -f $tmp.*
+}
+
+_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+. $tmp.mkfs	# extract blocksize and data size for scratch device
+
+endsize=`expr 550 \* 1048576`	# stop after growing this big
+[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
+
+nags=4
+size=`expr 125 \* 1048576`	# 120 megabytes initially
+sizeb=`expr $size / $dbsize`	# in data blocks
+logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
+
+_scratch_mkfs_xfs -lsize=${logblks}b -dsize=${size} -dagcount=${nags} \
+	>> $seqres.full || _fail "mkfs failed"
+_scratch_mount
+
+# Grow the filesystem in random sized chunks while stressing and performing
+# shutdown and recovery. The randomization is intended to create a mix of sub-ag
+# and multi-ag grows.
+while [ $size -le $endsize ]; do
+	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
+	_stress_scratch
+	incsize=$((RANDOM % 40 * 1048576))
+	size=`expr $size + $incsize`
+	sizeb=`expr $size / $dbsize`	# in data blocks
+	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
+	$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT >> $seqres.full
+
+	sleep $((RANDOM % 3))
+	_scratch_shutdown
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+	_scratch_cycle_mount || _fail "cycle mount failed"
+done > /dev/null 2>&1
+wait	# stop for any remaining stress processes
+
+_scratch_unmount
+
+echo Silence is golden.
+
+status=0
+exit
diff --git a/tests/xfs/609.out b/tests/xfs/609.out
new file mode 100644
index 00000000..8be27d3a
--- /dev/null
+++ b/tests/xfs/609.out
@@ -0,0 +1,2 @@
+QA output created by 609
+Silence is golden.
-- 
2.46.2

