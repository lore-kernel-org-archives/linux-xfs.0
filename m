Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63561D6194
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222417; cv=none; b=HFopXqbTHKY5VZcHlG6tU/l0MYq5Gtq4phu1Ew3qtKIgv9+eAwbfPoDbDaVjFv0OUoL8joWAz5VfibwAaJeW+W+/RvUp8cT87ezyDrDBDeCPEGh5k8OanHcasA24rQSwHdJDex5fLgwoac/GAQSZNIyWyIrFG8n2RJg5VKODyBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222417; c=relaxed/simple;
	bh=MhM4jNEY10NhLsvtWiwQiLrPBwZR6BXeIgnAMZSMldU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3yIroLEYiHfX1VupKffxiWJqthBRHAfpEWOeZFpEDcB0phharTAIS66JyByZEtW21MzMuKj9mFrxqWfCW62IX02tdSdzC9vwiTOlTw23omvp9Mks/HML1xSIqN2/85jtx5xLR8LuDU7e+TLoG3c9BlGwLuo3CU11hUyKXAdj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iRlk3BqY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iRlk3BqY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730222414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ul8t6nvjw38ibUMng0kK20LcFallp5MsvWYL/2GCqjM=;
	b=iRlk3BqYmo3Xs+Wa6fD8tGcPzhpRcKeYK9DVmwpVbBzswnLW/xBjfMDXpNT+hfuA3fQxsF
	J0yHcLGpCW8TcQs6NtKnqw06vZc6+mUhmXhgmlNJWY+hROMY9iSIa5vAT1w0w9ADCYGg6H
	9V+hL9DU1wirdDN/It97ipteSww9CKk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-rNnI2Aa8M52oQTxzBnVdGw-1; Tue,
 29 Oct 2024 13:20:11 -0400
X-MC-Unique: rNnI2Aa8M52oQTxzBnVdGw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49A891955E70;
	Tue, 29 Oct 2024 17:20:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.135])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50C2219560AA;
	Tue, 29 Oct 2024 17:20:09 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH v2 2/2] xfs: online grow vs. log recovery stress test (realtime version)
Date: Tue, 29 Oct 2024 13:21:35 -0400
Message-ID: <20241029172135.329428-3-bfoster@redhat.com>
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

This is fundamentally the same as the previous growfs vs. log
recovery test, with tweaks to support growing the XFS realtime
volume on such configurations. Changes include using the appropriate
mkfs params, growfs params, and enabling realtime inheritance on the
scratch fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/610     | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/610.out |  2 ++
 2 files changed, 85 insertions(+)
 create mode 100755 tests/xfs/610
 create mode 100644 tests/xfs/610.out

diff --git a/tests/xfs/610 b/tests/xfs/610
new file mode 100755
index 00000000..6d3a526f
--- /dev/null
+++ b/tests/xfs/610
@@ -0,0 +1,83 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 610
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
+_require_realtime
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
+logblks=$(_scratch_find_xfs_min_logblocks -rsize=${size} -dagcount=${nags})
+
+_scratch_mkfs_xfs -lsize=${logblks}b -rsize=${size} -dagcount=${nags} \
+	>> $seqres.full || _fail "mkfs failed"
+_scratch_mount
+_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
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
+	$XFS_GROWFS_PROG -R ${sizeb} $SCRATCH_MNT >> $seqres.full
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
diff --git a/tests/xfs/610.out b/tests/xfs/610.out
new file mode 100644
index 00000000..c42a1cf8
--- /dev/null
+++ b/tests/xfs/610.out
@@ -0,0 +1,2 @@
+QA output created by 610
+Silence is golden.
-- 
2.46.2

