Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124901DEFC9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182772; cv=none; b=XdeQM/AN2hMTGLGYEpZYYTHFWekdyWy/ivKBj1s/AB9EqkihclF5jvtWz2Nxz0PCKg/XxiOVHhQJfA+7jKecpQQ01xKBhg5SO6VMoK6+Hne/TZvghsmHBIXjwGvygUs5xUryaGwrdhKH/ZpAjgMvS4svASKrSu+3lfPbG2c6w4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182772; c=relaxed/simple;
	bh=1uthL2X16MDKcgfP406POG6hnZTb+/bSPvm5R5jHx4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axSLwsaqKAKq2jF4spaAUoTw1bsfuOjPfSLsxhOrjyDlVhJ/S1RjTcydkKmB5SvlgAYNVpomK+aPkbjzpKkiZXVhnFQlQ4wZsUkMabIMDZ/b1Gif/8fNq3sjO7CjQSHGX5F1+0a0reZ59PEKidVLiSxnG42VigYFF3TTCIRERmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVCi+u3B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVCi+u3B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729182770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwvRWpOvOJ1+Qpzdu1lpVgCFVVD1tuMmBHf2tF8Zd4U=;
	b=FVCi+u3By6a/O5aAq9AwTkF0ASRl/W7YL1C+f9f/QoJOtEbRHxLLxV5ex7BiI6KfhW3xI0
	mupPW7WZ7QTzn0fmk3Pg2765l5e3YX08hFoTviHtfdTYn44Z67IKDcIcmZknodi/x90nTX
	RlV9iNfVzAFxjptu34go9NQo99onscM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-ppFoJskROJSeFZgPKmLaFg-1; Thu,
 17 Oct 2024 12:32:48 -0400
X-MC-Unique: ppFoJskROJSeFZgPKmLaFg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4ACAA195609D;
	Thu, 17 Oct 2024 16:32:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BCDF1956086;
	Thu, 17 Oct 2024 16:32:46 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 2/2] xfs: online grow vs. log recovery stress test (realtime version)
Date: Thu, 17 Oct 2024 12:34:05 -0400
Message-ID: <20241017163405.173062-3-bfoster@redhat.com>
In-Reply-To: <20241017163405.173062-1-bfoster@redhat.com>
References: <20241017163405.173062-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This is fundamentally the same as the previous growfs vs. log
recovery test, with tweaks to support growing the XFS realtime
volume on such configurations. Changes include using the appropriate
mkfs params, growfs params, and enabling realtime inheritance on the
scratch fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/610     | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/610.out |  7 +++++
 2 files changed, 78 insertions(+)
 create mode 100755 tests/xfs/610
 create mode 100644 tests/xfs/610.out

diff --git a/tests/xfs/610 b/tests/xfs/610
new file mode 100755
index 00000000..95ae31be
--- /dev/null
+++ b/tests/xfs/610
@@ -0,0 +1,71 @@
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
+
+_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
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
+	>> $seqres.full
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
+	xfs_growfs -R ${sizeb} $SCRATCH_MNT >> $seqres.full
+
+	sleep $((RANDOM % 3))
+	_scratch_shutdown
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		killall -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+	_scratch_cycle_mount || _fail "cycle mount failed"
+done > /dev/null 2>&1
+wait	# stop for any remaining stress processes
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/610.out b/tests/xfs/610.out
new file mode 100644
index 00000000..42a6d3ce
--- /dev/null
+++ b/tests/xfs/610.out
@@ -0,0 +1,7 @@
+QA output created by 610
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-- 
2.46.2

