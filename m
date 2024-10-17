Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E071DEFDA
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182772; cv=none; b=jjI5b+0GIosEARxJB85Ai1FwJzgTgC1F2AtyB/9UDcnw8/n1aC0g5QYUYsUTB8WwymuAPwAl/s7/B/JADdaSSu8GlpLUofmy5i5YuJrNW13QyonyhyCpW5q4O+H1hASueLoKWQ/NyqKOekJMSAUqN8Nbj0LIf1J9o/Wcm/wD3J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182772; c=relaxed/simple;
	bh=jYHwJe0yd9T1A47IDTMrdIkcR+w65rlFwHvbdtmdtMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhlUAYLAX6D4Owz70qRgl4YEeIY4KYGiDmpvaQ+iu9mbluGHuwLsOkwPNNWms/1CRbUc4HeDUmsA1n8qddsnZh7bBxmHzCKaB0haB3DQcN6DZ1I02pa+MBqLdOqoBJUQrtSjAkvV9mMy9Bk5rLjY/BBa1KsyGf1A7bCxugbAvPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fi9iCezy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fi9iCezy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729182769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TT9WUt3VRF/NUREwAqbRR4URsjIK6lhGygqtbmUDZaM=;
	b=Fi9iCezy33fCLeQLA5EdmH4xyUmdYiMlziH8SyUk9fNJulkEwEit/yORm71nOzAvGcSdLr
	Mqf2H72qhiAf3zArZJCWE0+BhxCWz6UicpvoMrREmOTfjwWTYIiDjgn5IY078/t+cw5XAH
	3wZqpH+ITHddNC9w1BQguz75h7RiH4Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-HF0XJExvMs2bDneg0NcNaw-1; Thu,
 17 Oct 2024 12:32:48 -0400
X-MC-Unique: HF0XJExvMs2bDneg0NcNaw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA08519560B8;
	Thu, 17 Oct 2024 16:32:45 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EBE44195607C;
	Thu, 17 Oct 2024 16:32:44 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 1/2] xfs: online grow vs. log recovery stress test
Date: Thu, 17 Oct 2024 12:34:04 -0400
Message-ID: <20241017163405.173062-2-bfoster@redhat.com>
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

fstests includes decent functional tests for online growfs and
shrink, and decent stress tests for crash and log recovery, but no
combination of the two. This test combines bits from a typical
growfs stress test like xfs/104 with crash recovery cycles from a
test like generic/388. As a result, this reproduces at least a
couple recently fixed issues related to log recovery of online
growfs operations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/609     | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/609.out |  7 +++++
 2 files changed, 76 insertions(+)
 create mode 100755 tests/xfs/609
 create mode 100644 tests/xfs/609.out

diff --git a/tests/xfs/609 b/tests/xfs/609
new file mode 100755
index 00000000..796f4357
--- /dev/null
+++ b/tests/xfs/609
@@ -0,0 +1,69 @@
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
+logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
+
+_scratch_mkfs_xfs -lsize=${logblks}b -dsize=${size} -dagcount=${nags} \
+	>> $seqres.full
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
+	xfs_growfs -D ${sizeb} $SCRATCH_MNT >> $seqres.full
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
diff --git a/tests/xfs/609.out b/tests/xfs/609.out
new file mode 100644
index 00000000..1853cc65
--- /dev/null
+++ b/tests/xfs/609.out
@@ -0,0 +1,7 @@
+QA output created by 609
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-- 
2.46.2

