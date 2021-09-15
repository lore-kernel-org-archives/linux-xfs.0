Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75A7C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05B4610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhIOXny (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232749AbhIOXny (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 789A760F25;
        Wed, 15 Sep 2021 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749354;
        bh=BnehqFZ+0aAwSqBxXSPaW5QEQl/5N/MbutLTfosz4UM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gTslHSymEfOY73oqc8ZqyzaRDE+Kw0ZZu22C1kgMwwxqMSs4yoMOvI5sZ5r6op5cx
         +RuRZL04+xhKmY2X992GUl/LGXy/tYfiWr7Yz3hMzgjzK1v594ojL5GooyCEM8GKLU
         aye1/MRie2Q9lZAj+olSA/DrOWiKbd+RcJZICZGSYrtagmOTBo+YdfW1qN4eWke1AP
         H6wltL1FWLh/u6ETl6I+pouZMyNig4htQocaLybM8iVCMCwbM3JooUYzQ59hYdF2vM
         hGcdIMpcwhgGrFZGGF8YIVtqM5nVQ9i8cyRoI1xY8oJKNV5WHZv0x7FWuIDP8oyg6g
         cgKvcW7GGgzaQ==
Subject: [PATCH 1/1] generic: fsstress with cpu offlining
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:34 -0700
Message-ID: <163174935421.380813.6102795123954022876.stgit@magnolia>
In-Reply-To: <163174934876.380813.7279783755501552575.stgit@magnolia>
References: <163174934876.380813.7279783755501552575.stgit@magnolia>
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
 tests/generic/726     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/726.out |    2 +
 2 files changed, 76 insertions(+)
 create mode 100755 tests/generic/726
 create mode 100644 tests/generic/726.out


diff --git a/tests/generic/726 b/tests/generic/726
new file mode 100755
index 00000000..1a3f2fad
--- /dev/null
+++ b/tests/generic/726
@@ -0,0 +1,74 @@
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
+	test -n "$stress_dir" && rm -r -f "$stress_dir"
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
+_require_test
+_require_command "$KILLALL_PROG" "killall"
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
+stress_dir="$TEST_DIR/$seq"
+rm -r -f "$stress_dir"
+mkdir -p "$stress_dir"
+
+echo "Silence is golden."
+
+sentinel_file=$tmp.hotplug
+touch $sentinel_file
+exercise_cpu_hotplug &
+
+# Cap the number of fsstress threads at one per hotpluggable CPU if we exceed
+# 1024 IO threads, per maintainer request.
+nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
+test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
+
+nr_ops=$((25000 * TIME_FACTOR))
+$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $stress_dir -n $nr_ops -p $nr_cpus >> $seqres.full
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

