Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55448 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbeLRUgO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:36:14 -0500
Subject: [PATCH 4/5] xfs: look for stringified constants in ftrace formats
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:36:09 -0800
Message-ID: <154516536986.31115.738289589511424146.stgit@magnolia>
In-Reply-To: <154516534392.31115.7010578395334646479.stgit@magnolia>
References: <154516534392.31115.7010578395334646479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Look for uninterpretable stringified constants in the ftrace format
description for xfs tracepoints.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/735     |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/735.out |    3 ++
 tests/xfs/group   |    1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/xfs/735
 create mode 100644 tests/xfs/735.out


diff --git a/tests/xfs/735 b/tests/xfs/735
new file mode 100755
index 00000000..d5f4eba0
--- /dev/null
+++ b/tests/xfs/735
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 735
+#
+# Look for stringified constants in the __print_symbolic format strings,
+# which suggest that we forgot to TRACE_DEFINE_ENUM somewhere, which causes
+# incomplete ftrace reporting.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+
+cprog=$tmp.ftrace.c
+oprog=$tmp.ftrace
+sedprog=$tmp.ftrace.sed
+
+ftrace_dir=/sys/kernel/debug/tracing/events/xfs
+
+test -d $ftrace_dir || _notrun "ftrace not enabled"
+
+# The second argument to __print_symbolic is stringified in the tracepoint's
+# fmt file, so we look for "{ NUM, STRING }" and try to separate each of them
+# into single lines so that we can build a C structure.  This will (we hope)
+# catch non-constant numbers that the compiler won't know about.
+cat > $sedprog << ENDL
+s/}, /},\n/g
+s/}),/},\n/g
+s/})/},\n/g
+s/, {/\n{/g
+ENDL
+
+cat > $cprog << ENDL
+struct ftrace_chk {
+	unsigned long long	num;
+	char			*str;
+} syms[] = {
+ENDL
+egrep '(__print_flags|__print_symbolic)' $ftrace_dir*/*/format | \
+	sed -f $sedprog | grep '^{' | sort | uniq >> $cprog
+cat >> $cprog << ENDL
+};
+
+int main(int argc, char *argv[]) { return 0; }
+ENDL
+
+cat $cprog >> $seqres.full
+echo Compiler errors imply missing TRACE_DEFINE_ENUM.
+cc -o $oprog $cprog
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/735.out b/tests/xfs/735.out
new file mode 100644
index 00000000..844cea1d
--- /dev/null
+++ b/tests/xfs/735.out
@@ -0,0 +1,3 @@
+QA output created by 735
+Compiler errors imply missing TRACE_DEFINE_ENUM.
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index dfaae2bc..4a986af3 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -496,3 +496,4 @@
 496 dangerous_fuzzers dangerous_scrub dangerous_repair
 497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 498 dangerous_fuzzers dangerous_norepair
+735 auto quick
