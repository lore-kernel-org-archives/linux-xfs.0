Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAB4C432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910546102A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbhIAAMx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243020AbhIAAMq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700E06102A;
        Wed,  1 Sep 2021 00:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455110;
        bh=rG/2e+3GY4VVp4lQsfUoZ4Ta1YMzSMdrJFbP4iwhAjs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A3ft3nW8944ziF6JjB+f0NfIGSuBlFW8wRZk5izGuDtzkvFrmg7W3BhoALSQr3/gg
         pg/ZURojqBwsE2zbYr4xO/BONCKQSs56yhguNYy3rxWZJYN5Vy4tpkhfAebPM0drrY
         /YuLiVDsQDmLsyqZnIJ57z389TrP1iBO6IfEfcMVj0/3WylrLaXe8HbMi5AMI9/EyC
         rbpJ9Su/BpWS4PaForU8GMUpiQQhWDI9Djo8h6T5wXtKj9/Vkmx8tw/saifvWJr7Xi
         +HCVTKxd0B88VL9djsumQD9VFI6WC9Egx61Z7Nc236wPmr2xGQO2XLJnbf6t5p3wX2
         5JcocVzlnRXcQ==
Subject: [PATCH 1/3] generic: fsstress with cpu offlining
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:50 -0700
Message-ID: <163045511017.770026.7524779302645203861.stgit@magnolia>
In-Reply-To: <163045510470.770026.14067376159951420121.stgit@magnolia>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Exercise filesystem operations when we're taking CPUs online and offline
throughout the test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/726     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/726.out |    2 +
 2 files changed, 71 insertions(+)
 create mode 100755 tests/generic/726
 create mode 100644 tests/generic/726.out


diff --git a/tests/generic/726 b/tests/generic/726
new file mode 100755
index 00000000..cb709795
--- /dev/null
+++ b/tests/generic/726
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 726
+#
+# Run an all-writes fsstress run with multiple threads while exercising CPU
+# hotplugging to shake out bugs in the write path.
+#
+. ./common/preamble
+_begin_fstest auto rw stress
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	wait	# for exercise_cpu_hotplug subprocess
+	for i in "$sysfs_cpu_dir/"cpu*/online; do
+		echo 1 > "$i" 2>/dev/null
+	done
+}
+
+exercise_cpu_hotplug()
+{
+	while [ -e $sentinel_file ]; do
+		local idx=$(( RANDOM % nr_hotplug_cpus ))
+		local cpu="${hotplug_cpus[idx]}"
+		local action=$(( RANDOM % 2 ))
+
+		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
+		sleep 0.5
+	done
+}
+
+_supported_fs generic
+
+sysfs_cpu_dir="/sys/devices/system/cpu"
+
+# Figure out which CPU(s) support hotplug.
+nrcpus=$(getconf _NPROCESSORS_CONF)
+hotplug_cpus=()
+for ((i = 0; i < nrcpus; i++ )); do
+	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
+done
+nr_hotplug_cpus="${#hotplug_cpus[@]}"
+test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"
+
+_require_scratch
+_require_command "$KILLALL_PROG" "killall"
+
+echo "Silence is golden."
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+sentinel_file=$tmp.hotplug
+touch $sentinel_file
+exercise_cpu_hotplug &
+
+nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
+nr_ops=$((25000 * TIME_FACTOR))
+$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
+rm -f $sentinel_file
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/726.out b/tests/generic/726.out
new file mode 100644
index 00000000..6839f8ce
--- /dev/null
+++ b/tests/generic/726.out
@@ -0,0 +1,2 @@
+QA output created by 726
+Silence is golden.

