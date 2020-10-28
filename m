Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A4BC4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 02:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC902076B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 02:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCM1ENEW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgJ1VeZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:34:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgJ1VeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603920860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=T9IgPOcRgHhwtc8vhW0vmFhp+0Lk8VbhiSQiXN63iec=;
        b=DCM1ENEWJZg8ai0UWLPWjhaRjQIMyeZo4UdJx11/+v6apcHIJR9cmWIHtdrt/BWK7MeBAT
        tjzPJXxdUjcZJB307MWPhFOaiON3bIEevSI7bmfvYKFuhNhAZo1ySgu8Yhv2PMKXiYEDA+
        9Rv0ST0j+p/Pw1O1FgnDXgaLc6nRsGc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74--sqAboj5MAuLWdcN1xZxDA-1; Wed, 28 Oct 2020 07:31:23 -0400
X-MC-Unique: -sqAboj5MAuLWdcN1xZxDA-1
Received: by mail-pf1-f199.google.com with SMTP id z125so2760484pfc.12
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 04:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T9IgPOcRgHhwtc8vhW0vmFhp+0Lk8VbhiSQiXN63iec=;
        b=cGEf3uc2I9RBSnXfVWbU6JK457LvmZDLkSWfULP5CoBd5U4DdAG1fUTIxRSY6X/V+i
         xbwBoJH8gLB2Do0uKLemPIfQrkagOZkl7pTUsCmOI7hUZDBi+D/F7qU/6F4d2Cua13x1
         aYTb9888H5FdipWnRfUVMSXjk1FkOCeLKw8m7WLwcn5APim63nLwoe2drPNQAHeytnLR
         NSaH7hgyuF/5DEfI/SpnYIK3pyellNAxNm8bu1wtmaM2Eezf6h0lHMIwI/ROZUL7zwJu
         +Cxqr7N9FlqNhhbS/GK2wYwhMphbZ/bGI/wFGYWWSe5xAirkPlKPzVSijw1XtLuql23+
         BILA==
X-Gm-Message-State: AOAM531ZIIPadWPu4ZmC05Tq+B/AXYhhmiOQm0uTaNsGoS2GqAbE6/n/
        yumz5Pc3sMVkgoYRx+XxfSyxZOuo5Uk1Ng/1m7xuxlwxKhgxcsmkMYgf9NsJWLggaDpTDIMKV1I
        Noq05LntPJNEtRMZjMNYa
X-Received: by 2002:aa7:9255:0:b029:158:ca2e:3f33 with SMTP id 21-20020aa792550000b0290158ca2e3f33mr6849246pfp.59.1603884681951;
        Wed, 28 Oct 2020 04:31:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwP9/rGbwO01u/y6WBQVTdsSD4rhbja7crwpQvrQCX6nshzovbXdAzvGC/oPrn6gGSxVyBLFA==
X-Received: by 2002:aa7:9255:0:b029:158:ca2e:3f33 with SMTP id 21-20020aa792550000b0290158ca2e3f33mr6849222pfp.59.1603884681599;
        Wed, 28 Oct 2020 04:31:21 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j5sm5051712pjb.56.2020.10.28.04.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 04:31:21 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [WIP] [RFC PATCH] xfs: add test on shrinking unused space in the last AG
Date:   Wed, 28 Oct 2020 19:30:37 +0800
Message-Id: <20201028113037.542737-1-hsiangkao@redhat.com>
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

