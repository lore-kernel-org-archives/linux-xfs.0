Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdLMGDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:03:24 -0500
Subject: [PATCH 1/8] common/rc: report kmemleak errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:03:18 -0800
Message-ID: <151314499847.18893.9855359031542704591.stgit@magnolia>
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If kmemleak is enabled, scan and report memory leaks after every test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check     |    2 ++
 common/rc |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)


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
index cb83918..a2bed36 100644
--- a/common/rc
+++ b/common/rc
@@ -3339,6 +3339,58 @@ _check_dmesg()
 	fi
 }
 
+# capture the kmemleak report
+_capture_kmemleak()
+{
+	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
+	local _leak_file="$1"
+
+	# Tell the kernel to scan for memory leaks.  Apparently the write
+	# returns before the scan is complete, so do it twice in the hopes
+	# that twice is enough to capture all the leaks.
+	echo "scan" > "${_kern_knob}"
+	cat "${_kern_knob}" > /dev/null
+	echo "scan" > "${_kern_knob}"
+	cat "${_kern_knob}" > "${_leak_file}"
+	echo "clear" > "${_kern_knob}"
+}
+
+# set up kmemleak
+_init_kmemleak()
+{
+	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
+
+	if [ ! -w "${_kern_knob}" ]; then
+		return 0
+	fi
+
+	# Disable the automatic scan so that we can control it completely,
+	# then dump all the leaks recorded so far.
+	echo "scan=off" > "${_kern_knob}"
+	_capture_kmemleak /dev/null
+}
+
+# check kmemleak log
+_check_kmemleak()
+{
+	local _kern_knob="${DEBUGFS_MNT}/kmemleak"
+	local _leak_file="${seqres}.kmemleak"
+
+	if [ ! -w "${_kern_knob}" ]; then
+		return 0
+	fi
+
+	# Capture and report any leaks
+	_capture_kmemleak "${_leak_file}"
+	if [ -s "${_leak_file}" ]; then
+		_dump_err "_check_kmemleak: something found in kmemleak (see ${_leak_file})"
+		return 1
+	else
+		rm -f "${_leak_file}"
+		return 0
+	fi
+}
+
 # don't check dmesg log after test
 _disable_dmesg_check()
 {

