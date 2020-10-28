Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F94C4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 23:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A3820791
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 23:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cEvKu4Kt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgJ1XKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:10:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726503AbgJ1XKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 19:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603926616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=T9IgPOcRgHhwtc8vhW0vmFhp+0Lk8VbhiSQiXN63iec=;
        b=cEvKu4KtUaLjI8HOhoC5hipYjtSU6jknifT7VBS4bmZoQk/46xMI5WR0AgUIE56AJzkDIl
        m3IRBkhPNFccHq9U+eeGBaF/G/C1yXyQHw7UCatzswK/WbsyMkNiIYsXVtUum5hGGF5REH
        nOgsIdDLpHmhFb3Cjt4mUO8vb4HEZrw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-hTf9Ndl-PyiFcNr1bdQBYA-1; Wed, 28 Oct 2020 19:10:14 -0400
X-MC-Unique: hTf9Ndl-PyiFcNr1bdQBYA-1
Received: by mail-pl1-f200.google.com with SMTP id p3so603581plq.21
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 16:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T9IgPOcRgHhwtc8vhW0vmFhp+0Lk8VbhiSQiXN63iec=;
        b=fVtPiK9Y1Qgt/emP8wkf0Il2yo5kAav9qHufzJF9H7beIbtdGDeRXQ5WiZipm8VzWh
         7SAr5Wvgbyz4cBNexqpHN31AFySpxwBFUk87TJwHdcSOlEEQBCJcIE91BDDU+fvYoQPX
         7sKl+D0M6ZZeARsqzu6i3/DeyErZhq5a0kIsOpzweJIPJtq1bGp3e4uJIhEFLTfIwjqV
         +1BD15axl2GQlkOOo+QQpNH0u8IpeRXrw8XCNRfC4tXvcdhAxRip8TErY3rjfZ2CAVPL
         +jEzopcIhabWq1x8HIHJu19GW6P0Fin0Mx1hVGx4za2K/Eu9pz4JQPXGa90RDKrWaeWr
         AIXg==
X-Gm-Message-State: AOAM530Rll9BoYBhhuzYjGGhZx2zWySy987pcBRL6C2OECDcqgd53U/X
        GbCqZckUkL19oEBKM6NpPy7ib0JaDwi7Juz0e5ynY3r6/T/Am99l9n56IwiFqZbJV50d4YYGZax
        IUTfJXtXgm05qB/9hlmP2
X-Received: by 2002:a62:ea0c:0:b029:164:3789:547b with SMTP id t12-20020a62ea0c0000b02901643789547bmr1523913pfh.27.1603926613205;
        Wed, 28 Oct 2020 16:10:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYT1tKt35m97ib3vTsCPYXp65Lr/mm02Y+vE3msZ8TNkexISurdlI8A69vY/5EZU/eXY4eKg==
X-Received: by 2002:a62:ea0c:0:b029:164:3789:547b with SMTP id t12-20020a62ea0c0000b02901643789547bmr1523889pfh.27.1603926612867;
        Wed, 28 Oct 2020 16:10:12 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u4sm451136pjy.19.2020.10.28.16.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 16:10:12 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [WIP] [RFC PATCH] xfs: add test on shrinking unused space in the last AG
Date:   Thu, 29 Oct 2020 07:09:09 +0800
Message-Id: <20201028230909.639698-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This adds a testcase to test shrinking unused space as much
as possible in the last AG with background fsstress workload.

The expectation is that no crash happens with expected output.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 tests/xfs/522     | 125 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/522.out |  73 +++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 199 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out

diff --git a/tests/xfs/522 b/tests/xfs/522
new file mode 100755
index 00000000..e427a33a
--- /dev/null
+++ b/tests/xfs/522
@@ -0,0 +1,125 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 522
+#
+# XFS online shrinkfs-while-allocating tests
+#
+# This test attempts to shrink unused space as much as possible with
+# background fsstress workload. It will decrease the shrink size if
+# larger size fails. And totally repeat 6 times.
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
+_create_scratch()
+{
+	echo "*** mkfs"
+	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	. $tmp.mkfs
+
+	echo "*** mount"
+	if ! _try_scratch_mount 2>/dev/null
+	then
+		echo "failed to mount $SCRATCH_DEV"
+		exit 1
+	fi
+
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	_scratch_resvblks 1024 >  /dev/null 2>&1
+}
+
+_fill_scratch()
+{
+	$XFS_IO_PROG -f -c "resvsp 0 ${1}" $SCRATCH_MNT/resvfile
+}
+
+_stress_scratch()
+{
+	procs=3
+	nops=1000
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
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
+totalcount=6
+
+while [ $totalcount -gt 0 ]; do
+	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
+	echo "*** creating scratch filesystem"
+	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
+
+	_create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
+
+	echo "*** using some initial space on scratch filesystem"
+	for i in `seq 125 -1 90`; do
+		fillsize=`expr $i \* 1048576`
+		out="$(_fill_scratch $fillsize 2>&1)"
+		echo "$out" | grep -q 'No space left on device' && continue
+		test -n "${out}" && echo "$out"
+		break
+	done
+
+	decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
+
+	echo "*** stressing filesystem"
+	while [ $size -gt $endsize ]; do
+		_stress_scratch
+		sleep 1
+
+		decb=`expr $decsize / $dbsize`    # in data blocks
+		while [ $decb -gt 0 ]; do
+			sizeb=`expr $size / $dbsize - $decb`
+
+			xfs_growfs -D ${sizeb} $SCRATCH_MNT 2>&1 \
+				| tee -a $seqres.full | _filter_mkfs 2>$tmp.growfs > /dev/null
+
+			ret="${PIPESTATUS[0]}"
+			. $tmp.growfs
+
+			[ $ret -eq 0 ] && break
+
+			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
+			decb=`expr $decb / 2`
+		done
+
+		wait
+		[ $decb -eq 0 ] && break
+
+		size=`expr $size - $decb \* $dbsize`
+	done
+
+	_scratch_unmount
+	_repair_scratch_fs >> $seqres.full
+	totalcount=`expr $totalcount - 1`
+done
+
+status=0
+exit
diff --git a/tests/xfs/522.out b/tests/xfs/522.out
new file mode 100644
index 00000000..03d512f5
--- /dev/null
+++ b/tests/xfs/522.out
@@ -0,0 +1,73 @@
+QA output created by 522
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** creating scratch filesystem
+*** mkfs
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** mount
+*** using some initial space on scratch filesystem
+*** stressing filesystem
+*** creating scratch filesystem
+*** mkfs
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** mount
+*** using some initial space on scratch filesystem
+*** stressing filesystem
+*** creating scratch filesystem
+*** mkfs
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** mount
+*** using some initial space on scratch filesystem
+*** stressing filesystem
+*** creating scratch filesystem
+*** mkfs
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** mount
+*** using some initial space on scratch filesystem
+*** stressing filesystem
+*** creating scratch filesystem
+*** mkfs
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** mount
+*** using some initial space on scratch filesystem
+*** stressing filesystem
+*** creating scratch filesystem
+*** mkfs
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+*** mount
+*** using some initial space on scratch filesystem
+*** stressing filesystem
diff --git a/tests/xfs/group b/tests/xfs/group
index b89c0a4e..ab762ed6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -519,3 +519,4 @@
 519 auto quick reflink
 520 auto quick reflink
 521 auto quick realtime growfs
+522 auto quick growfs
-- 
2.18.1

