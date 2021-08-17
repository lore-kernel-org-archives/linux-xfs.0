Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB71C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B8761051
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhHQXxy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhHQXxx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F05EA61008;
        Tue, 17 Aug 2021 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244400;
        bh=Hyylsb12bCc9mWlZA1bOLlVBoys21asDFGRkkUM1Oyo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vNVy3WS+TMLSExy0x1evTcLh7aMNW44efwpHKNykC+ldNRrKcOdnZs+CxPupL05FK
         4wnABHrxX7umoEXhKt05RX3dYWuJ9QOYmmXFC6RlCys2+fZX9UCWLxht3nJCqutrS5
         KLF1f6s6FdNeiQjircydnLnmC2L2tKfbvgAatJUgFBQu1hIrTQ2SzDCe8DTg+dTGA9
         nGHjgM9dcwd9k95pSnzJcyLCaZ77Oq/DLX4igly8G9R0Su/G2mwQ7CsWRZfqvDVIsc
         JXTR5a197cp+e48Ht6CXNYtRNICVIiVbJTfXvLWy0FdaZGv6/xNbYkOsw4fY6hYLpl
         KfiLEfgVZBINA==
Subject: [PATCH 1/2] generic: fsstress with cpu offlining
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 17 Aug 2021 16:53:19 -0700
Message-ID: <162924439973.779465.13771500926240153773.stgit@magnolia>
In-Reply-To: <162924439425.779465.16029390956507261795.stgit@magnolia>
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
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
 tests/generic/726     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/726.out |    2 +
 2 files changed, 73 insertions(+)
 create mode 100755 tests/generic/726
 create mode 100644 tests/generic/726.out


diff --git a/tests/generic/726 b/tests/generic/726
new file mode 100755
index 00000000..4b072b7f
--- /dev/null
+++ b/tests/generic/726
@@ -0,0 +1,71 @@
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
+_begin_fstest auto rw
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
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
+# Import common functions.
+
+# Modify as appropriate.
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
+nr_cpus=$((LOAD_FACTOR * 4))
+nr_ops=$((10000 * nr_cpus * TIME_FACTOR))
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

