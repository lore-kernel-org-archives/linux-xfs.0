Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeACTWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 14:22:05 -0500
Date: Wed, 3 Jan 2018 11:22:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/8] xfs: find libxfs api violations
Message-ID: <20180103192200.GA4854@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

New test to run tools/find-api-violations.sh in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/708     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/708.out |    2 ++
 tests/xfs/group   |    1 +
 3 files changed, 59 insertions(+)
 create mode 100755 tests/xfs/708
 create mode 100644 tests/xfs/708.out

diff --git a/tests/xfs/708 b/tests/xfs/708
new file mode 100755
index 0000000..4877bcf
--- /dev/null
+++ b/tests/xfs/708
@@ -0,0 +1,56 @@
+#! /bin/bash
+# FS QA Test No. 708
+#
+# find-api-violations test
+#
+# The purpose of this test is ensure that the xfsprogs programs use the
+# libxfs_ symbols (in libxfs-api-defs.h) instead of raw xfs_ functions.
+# This is for the maintainers; it's not a functionality test.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle, Inc.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
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
+[ -z "$WORKAREA" ] && \
+	_notrun "Can't run find-api-violations.sh without WORKAREA set"
+[ -f "$WORKAREA/tools/find-api-violations.sh" ] || \
+	_notrun "Can't find find-api-violations.sh tool under \"$WORKAREA\""
+
+echo "Silence is golden."
+
+# Look for API usage problems.  Old versions of the script have an improperly
+# specified grep pattern that is mistaken for a (broken) range specifier in
+# LC_ALL=C, so use English instead.
+(cd "$WORKAREA" ; LC_ALL="en_US.UTF-8" bash ./tools/find-api-violations.sh ) | tee -a $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/708.out b/tests/xfs/708.out
new file mode 100644
index 0000000..b40823e
--- /dev/null
+++ b/tests/xfs/708.out
@@ -0,0 +1,2 @@
+QA output created by 708
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index d230060..e1b1582 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -434,3 +434,4 @@
 434 auto quick clone fsr
 435 auto quick clone
 436 auto quick clone fsr
+708 auto quick other
