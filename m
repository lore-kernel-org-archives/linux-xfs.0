Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84810C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8AD6112E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhDBJuw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234482AbhDBJuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617357050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvIaXkfRgYuskgswG5QCMho02/eUmFzyTn6nc4CAmqk=;
        b=exKO4TZ8px49MyFwn8QKOLm3dSF9Zm/1hN+NuGrapQRFSD2wk9Y/hgTPKLVE6RZ8Tyapvn
        JgAhuld49HVX4GLIOqwGMfn1hzHJYOzzLHHmUe547975jU4w2GiGRcTMzgS3BfzXluO8a+
        t7GNQI7P4uWHgZO5gf9PS+np/B46uXA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-7-XJ46DfPemSRfXSZZO6AQ-1; Fri, 02 Apr 2021 05:50:49 -0400
X-MC-Unique: 7-XJ46DfPemSRfXSZZO6AQ-1
Received: by mail-pj1-f71.google.com with SMTP id lj2so1340819pjb.1
        for <linux-xfs@vger.kernel.org>; Fri, 02 Apr 2021 02:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lvIaXkfRgYuskgswG5QCMho02/eUmFzyTn6nc4CAmqk=;
        b=NItGOuEAteizpva06biR0xnvB2WF9So9rRPWYXa3PgJHtsWIAOuuPrz6id9ozWSkYc
         kFTWnIhyUuPfi8THhjrI5uQ5vFkZ4RsxWGvQVpGqIKZcKMDjlKHRpNGwzvhN+UZXZEC/
         45C4XKPHV5ys8CoP0ng+RSZbP7jn/pAX/87MEmLe/h4rnSrKxmDqFl6YT1j7PXcLqdb0
         LDGYuUatynUCt5cRQZaP4BK18DR5tLA8QK3DpZSAwbZFiZBjv4aI3bJLgw5l0+W0uV/Y
         eICmiNdWd52MvR+KbAb5l7vSVtDMnVc7Lcu25JTRmomGicsYIJJ4x8uAu4QDkjFONdXA
         y4Tw==
X-Gm-Message-State: AOAM530Zia+UVtb6dpJGji/6RnEv+j+ei32oEh1ZUHKtQU8ezhe76GLT
        nyBbejRhjUSBGvF2R5YW7PbRbuZmmllBAwzH1eX2IH0KqJSLrTxxgKrKfK0BW0p+5oTowx8JnqD
        w//nzR14QyfsIPJIg1KKFQZtuP15JNcWHH5tPbjmZyWOF3BjypbB3p0ODfHHAhZ+roeRwy7QGGA
        ==
X-Received: by 2002:a17:902:7246:b029:e6:78c4:48d8 with SMTP id c6-20020a1709027246b02900e678c448d8mr12320288pll.18.1617357047745;
        Fri, 02 Apr 2021 02:50:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvSer4Clk48leF8gEUjmKKAGdzHUjfsvB4jideKGUaUEVUGQzk9HR7ADOjvChexk01lzXf/w==
X-Received: by 2002:a17:902:7246:b029:e6:78c4:48d8 with SMTP id c6-20020a1709027246b02900e678c448d8mr12320264pll.18.1617357047368;
        Fri, 02 Apr 2021 02:50:47 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l124sm7730354pfl.195.2021.04.02.02.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:50:47 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 3/3] xfs: stress test for shrinking free space in the last AG
Date:   Fri,  2 Apr 2021 17:49:37 +0800
Message-Id: <20210402094937.4072606-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402094937.4072606-1-hsiangkao@redhat.com>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This adds a stress testcase to shrink free space as much as
possible in the last AG with background fsstress workload.

The expectation is that no crash happens with expected output.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 tests/xfs/991     | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 ++++
 tests/xfs/group   |   1 +
 3 files changed, 127 insertions(+)
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

diff --git a/tests/xfs/991 b/tests/xfs/991
new file mode 100755
index 00000000..8ad0b8c7
--- /dev/null
+++ b/tests/xfs/991
@@ -0,0 +1,118 @@
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
+	local nops=$((1000 * LOAD_FACTOR))
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
+decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
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
+		_repair_scratch_fs >> $seqres.full
+		_scratch_mount
+	done
+
+	_scratch_unmount
+	_repair_scratch_fs >> $seqres.full
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

