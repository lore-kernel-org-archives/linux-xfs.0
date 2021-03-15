Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6D8C4332E
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 11:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B56564E61
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 11:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhCOLU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 07:20:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229605AbhCOLUP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 07:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615807215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+qbVrcdtmPe4mZGLdw3S9hgAYqmOPLsAEBr5BVz4L40=;
        b=IFy86lHc60VwHPaRybdRSXdoKKJ5JfTpOfO5J3h9f5rAFNKBWP4Gk76qgab5J/BofLhaNr
        xuVyY9ALgbHwhyVOmhba8K1yXbGgbIHqjtLG/7O1jw3jr7OsWeYgbUcx73ViOuiB8Sa2wL
        XlLgklSCmoOLErnuLW4EOxX41T6h3ls=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-zWRaGV0GMsyi-lcKstyd2w-1; Mon, 15 Mar 2021 07:20:13 -0400
X-MC-Unique: zWRaGV0GMsyi-lcKstyd2w-1
Received: by mail-pf1-f199.google.com with SMTP id x197so18147248pfc.18
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 04:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qbVrcdtmPe4mZGLdw3S9hgAYqmOPLsAEBr5BVz4L40=;
        b=D9gyoV6jbiH9Vii9kM1Djzn+XF29vGXBgdXhSqxzPJv8P1ELxtuR65ewELlZHcOlqs
         OXhlm4N2T5fZAOxQpYdaznWVGFiG+nJZtfbGWCr3nEbMMG3ja+4aUN63UdpUT2DCH+em
         eCn7ViiFQzLoMnSN5Bvm76Yrop1qCfGx81giPHsbwbBdngv3DkEYGzXwUGj2D3h8/MRd
         z5tP7MpE9a/4dmm3j9/WY443VPVtTliz5PXsAnf2zhGdEbd+xyPtaVa8Lif29yLFSBBh
         GpjLeZRfxprQCFzCL/lzQzUmHJFtILqYe8oUiTG2g5WW7RENgy48y2sfqHItlodUYwDQ
         uf8w==
X-Gm-Message-State: AOAM531C16ydNAEYp8Ln4w9yUTRk8JbYg5Tb1ovR0xJ19is+nEUz8ERu
        X+Ixh3Ryb1xbiArnNq+5Ksg09yRy8KJmTKMHskUzMVOQgUSt4T29g/v4jf18AbVcglfFEJrlhHH
        vYuigcfvMYkzN1neCZJs3f6ss0scA58l49haZUPKWPb0hn0AsULjFcs+46qILYoqu4YAoT6/1/g
        ==
X-Received: by 2002:a62:5e02:0:b029:1ed:8bee:6132 with SMTP id s2-20020a625e020000b02901ed8bee6132mr10053604pfb.48.1615807212093;
        Mon, 15 Mar 2021 04:20:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUMmBINRxfxwEg+AcTuoNn0nzk5osUcNmWJLosmGXRAZUNvvxw52jkclMe0t4lWSHfpLx/rw==
X-Received: by 2002:a62:5e02:0:b029:1ed:8bee:6132 with SMTP id s2-20020a625e020000b02901ed8bee6132mr10053568pfb.48.1615807211752;
        Mon, 15 Mar 2021 04:20:11 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r23sm11058448pje.38.2021.03.15.04.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:20:11 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v3 3/3] xfs: stress test for shrinking free space in the last AG
Date:   Mon, 15 Mar 2021 19:19:26 +0800
Message-Id: <20210315111926.837170-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315111926.837170-1-hsiangkao@redhat.com>
References: <20210315111926.837170-1-hsiangkao@redhat.com>
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
 tests/xfs/991     | 122 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 +++
 tests/xfs/group   |   1 +
 3 files changed, 131 insertions(+)
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

diff --git a/tests/xfs/991 b/tests/xfs/991
new file mode 100755
index 00000000..7e7d318e
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
+	if ! _try_scratch_mount 2>/dev/null; then
+		echo "failed to mount $SCRATCH_DEV"
+		exit 1
+	fi
+
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	_scratch_resvblks 1024 > /dev/null 2>&1
+}
+
+fill_scratch()
+{
+	$XFS_IO_PROG -f -c "falloc -k 0 $1" $SCRATCH_MNT/resvfile
+}
+
+stress_scratch()
+{
+	procs=3
+	nops=$((1000 * LOAD_FACTOR))
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_shrink
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
+		stress_scratch
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
index a7981b67..cf190b59 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,3 +526,4 @@
 526 auto quick mkfs
 527 auto quick quota
 990 auto quick growfs
+991 auto growfs ioctl prealloc stress
-- 
2.27.0

