Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51272 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdK2BJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:09:42 -0500
Date: Tue, 28 Nov 2017 17:09:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] common/rc: report kmemleak errors
Message-ID: <20171129010937.GB31372@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If kmemleak is enabled, scan and report memory leaks after every test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check     |    2 ++
 common/rc |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/check b/check
index b2d251a..469188e 100755
--- a/check
+++ b/check
@@ -497,6 +497,7 @@ _check_filesystems()
 	fi
 }
 
+_init_kmemleak
 _prepare_test_list
 
 if $OPTIONS_HAVE_SECTIONS; then
@@ -793,6 +794,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		    n_try=`expr $n_try + 1`
 		    _check_filesystems
 		    _check_dmesg || err=true
+		    _check_kmemleak || err=true
 		fi
 
 	    fi
diff --git a/common/rc b/common/rc
index cb83918..6dc77d5 100644
--- a/common/rc
+++ b/common/rc
@@ -3339,6 +3339,57 @@ _check_dmesg()
 	fi
 }
 
+# set up kmemleak
+_init_kmemleak()
+{
+	local _kern_knob="/sys/kernel/debug/kmemleak"
+
+	if [ ! -w "${_kern_knob}" ]; then
+		return 0
+	fi
+
+	# Scan for all the memory leaks that have happened to date and
+	# clear them so that we can pinpoint leaks to tests accurately.
+	# Scan twice because the first write finishes before the scan
+	# does....
+	echo "scan" > "${_kern_knob}"
+	cat "${_kern_knob}" > /dev/null
+	echo "scan" > "${_kern_knob}"
+	cat "${_kern_knob}" > /dev/null
+	echo "clear" > "${_kern_knob}"
+}
+
+# check kmemleak log
+_check_kmemleak()
+{
+	local _kern_knob="/sys/kernel/debug/kmemleak"
+	local _leak_file="${RESULT_DIR}/check_kmemleak"
+
+	if [ ! -w "${_kern_knob}" ]; then
+		return 0
+	fi
+
+	# Tell the kernel to scan for memory leaks.  Apparently the write
+	# returns before the scan is complete, so do it twice in the hopes
+	# that twice is enough to capture all the leaks.
+	echo "scan" > "${_kern_knob}"
+	sed -e 's/age [0-9\.]*s/age XXXX/g' < "${_kern_knob}" > "${_leak_file}.new"
+	echo "scan" > "${_kern_knob}"
+	sed -e 's/age [0-9\.]*s/age XXXX/g' < "${_kern_knob}" > "${_leak_file}.new"
+
+	diff -u -N "${_leak_file}" "${_leak_file}.new" > $seqres.kmemleak
+	res=$?
+	mv "${_leak_file}.new" "${_leak_file}"
+
+	if [ $res -ne 0 ]; then
+		_dump_err "_check_kmemleak: something found in kmemleak (see $seqres.kmemleak)"
+		return 1
+	else
+		rm -f $seqres.kmemleak
+		return 0
+	fi
+}
+
 # don't check dmesg log after test
 _disable_dmesg_check()
 {
