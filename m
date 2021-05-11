Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8333C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 23:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C381E616EA
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 23:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhEKXeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 19:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKXeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 19:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620775982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sL1wCx8ELFuxvB703Ojb+3QWnMC1Qc5Cu6MqVlj4zW0=;
        b=Id1L6fqfUXUnFBOS6dOPXs099clK0NgJuXARxF+Qvz0QVyhlTZR+vNLkV9ZSRcS3lykQZJ
        R5zFZYNGdfiULQSJ0kDuLERvLHOBqZz1xpK1g+YaeLx9Nw3pFIkJMVZR9sMkZ5EXUeHega
        8wnE0SY1SAVyXty9x+2HBO/rIE7cfHQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-vjMXhcBDP22A21nvK0khZQ-1; Tue, 11 May 2021 19:33:00 -0400
X-MC-Unique: vjMXhcBDP22A21nvK0khZQ-1
Received: by mail-pj1-f70.google.com with SMTP id mw15-20020a17090b4d0fb0290157199aadbaso2431794pjb.7
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 16:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sL1wCx8ELFuxvB703Ojb+3QWnMC1Qc5Cu6MqVlj4zW0=;
        b=gwXcCx2gVMCi4o0n8Hle2pi5BUcZbgjxsmrCDwB+KaZ3eJnEwGNw/6HSxfRo/ng3Qg
         7sWwD32dn1MV0odeL4Mq0cMcZyBAWvX1gAJ14X4oAQ2uk6LQRw7cha8sj5N8kccq+vk3
         UQShCqiOymyJWfyzsOakyS9186PoF2PegILmbjeouW8ZOuVlHMpfkpcE6j5Bspmc5kQN
         vXdHZuh/ZeFI0sJ+1dl9xu08p3hiV0yQlMwurB0sDPE/mZ7zSIzt9oYlfHJ0UwlfUilO
         nP7Y1HBed7nyW7LOghMPZybZha85JO1hrqhmoUbkd/tjtua+TjseFjVdhb5UO6Wa0qcQ
         KB5Q==
X-Gm-Message-State: AOAM532gA9nj/1axyoJ1ryR7z3RpoBVvP8aQ3l/eASLuOv+lsNGk+vWy
        4Jx4+vW6MUv2dCKQnM5v6ArwlEzOQc8Q+HrHPaw6l+WqXuPk2Hh1GMhWJ0Bmm4EIJBm3g5T0f0d
        HseJw3Hbse88k0Q+PKsRpXY2q/Iun8V3Glj4IZjFGBqbDxyFL2MykGcVzyFF8lyUCUehRyjHT/w
        ==
X-Received: by 2002:a63:c13:: with SMTP id b19mr33227375pgl.198.1620775979629;
        Tue, 11 May 2021 16:32:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZYLDNIKGf8j3vzgFHYYot+eUqy/6lNa+LMOqutSWDdMNnuoGtxWEIvH7KpS2rDEde5/CzPw==
X-Received: by 2002:a63:c13:: with SMTP id b19mr33227346pgl.198.1620775979298;
        Tue, 11 May 2021 16:32:59 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s3sm15828393pgs.62.2021.05.11.16.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 16:32:59 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 3/3] xfs: stress test for shrinking free space in the last AG
Date:   Wed, 12 May 2021 07:32:28 +0800
Message-Id: <20210511233228.1018269-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210511233228.1018269-1-hsiangkao@redhat.com>
References: <20210511233228.1018269-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This adds a stress testcase to shrink free space as much as
possible in the last AG with background fsstress workload.

The expectation is that no crash happens with expected output.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 tests/xfs/991     | 122 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 +++
 tests/xfs/group   |   1 +
 3 files changed, 131 insertions(+)
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

diff --git a/tests/xfs/991 b/tests/xfs/991
new file mode 100755
index 00000000..7f4001ab
--- /dev/null
+++ b/tests/xfs/991
@@ -0,0 +1,122 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020-2021 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 991
+#
+# XFS online shrinkfs stress test
+#
+# This test attempts to shrink unused space as much as possible with
+# background fsstress workload. It will decrease the shrink size if
+# larger size fails. And totally repeat 2 * TIME_FACTOR times.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+create_scratch()
+{
+	_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
+		_filter_mkfs 2>$tmp.mkfs >/dev/null
+	. $tmp.mkfs
+
+	_scratch_mount
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	_scratch_resvblks 1024 > /dev/null 2>&1
+}
+
+fill_scratch()
+{
+	$XFS_IO_PROG -f -c "falloc 0 $1" $SCRATCH_MNT/resvfile
+}
+
+stress_scratch()
+{
+	local procs=3
+	local nops=1000
+	# -w ensures that the only ops are ones which cause write I/O
+	local FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w \
+		-p $procs -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_shrink
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+. $tmp.mkfs	# extract blocksize and data size for scratch device
+
+endsize=`expr 125 \* 1048576`	# stop after shrinking this big
+[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
+
+nags=2
+totalcount=$((2 * TIME_FACTOR))
+
+while [ $totalcount -gt 0 ]; do
+	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
+	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
+
+	create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
+
+	for i in `seq 125 -1 90`; do
+		fillsize=`expr $i \* 1048576`
+		out="$(fill_scratch $fillsize 2>&1)"
+		echo "$out" | grep -q 'No space left on device' && continue
+		test -n "${out}" && echo "$out"
+		break
+	done
+
+	# shrink in chunks of this size at most
+	decsize=`expr  41 \* 1048576 + 1 + $RANDOM \* $RANDOM % 1048576`
+
+	while [ $size -gt $endsize ]; do
+		stress_scratch &
+		sleep 1
+
+		decb=`expr $decsize / $dbsize`    # in data blocks
+		while [ $decb -gt 0 ]; do
+			sizeb=`expr $size / $dbsize - $decb`
+
+			$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT \
+				>> $seqres.full 2>&1 && break
+
+			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
+			decb=`expr $decb / 2`
+		done
+
+		wait
+		[ $decb -eq 0 ] && break
+
+		# get latest dblocks
+		$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
+		. $tmp.growfs
+
+		size=`expr $dblocks \* $dbsize`
+		_scratch_unmount
+		_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
+			_fail "xfs_repair failed with shrinking $sizeb"
+		_scratch_mount
+	done
+
+	_scratch_unmount
+	_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
+		_fail "xfs_repair failed with shrinking $sizeb"
+	totalcount=`expr $totalcount - 1`
+done
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/991.out b/tests/xfs/991.out
new file mode 100644
index 00000000..e8209672
--- /dev/null
+++ b/tests/xfs/991.out
@@ -0,0 +1,8 @@
+QA output created by 991
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** done
diff --git a/tests/xfs/group b/tests/xfs/group
index 472c8f9a..53e68bea 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -521,3 +521,4 @@
 538 auto stress
 539 auto quick mount
 990 auto quick growfs shrinkfs
+991 auto growfs shrinkfs ioctl prealloc stress
-- 
2.27.0

