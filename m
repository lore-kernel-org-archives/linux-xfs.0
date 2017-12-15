Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755663AbdLOUlP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Dec 2017 15:41:15 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] generic/381: enable on systems which allows usernames that begin with digits
Date: Fri, 15 Dec 2017 12:41:07 -0800
Message-Id: <20171215204107.17690-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Some systems are not allowing usernames prefixed with a number now, this
test however relies on the assumption that you can end up with usernames
of such type, given the purpose of the test is to ensure that xfs_quota
can differentiate between UIDs and names beginning with numbers.

systemd >= 232 (circa 2017) no longer allows usernames starting with digits
[0], there is a systemd exploit (CVE-2017-1000082 [1]) for why that was done,
however even upstream shadow useradd also does not allow similar user types
since shadow version v4.0.1 (circa 2007) [2] but there no easy way to check
shadow's useradd's version.

You can still shoehorn in these types of users by manually editing files,
but that's just shooting yourself on the foot given all the precautions
taken now by userspace, so just check for the systemd version for now as
requirement for running this test.

[0] https://github.com/systemd/systemd/issues/6237
[1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-1000082
[2] https://github.com/shadow-maint/shadow/commit/9db6abfa42c946b4046f4b2fe67dc43ba862eb0e

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 README            |  7 +++++--
 common/config     |  1 +
 common/rc         | 42 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/381 |  1 +
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/README b/README
index ed69332e774e..aff7bdae7cb4 100644
--- a/README
+++ b/README
@@ -20,8 +20,11 @@ _______________________
 - run make
 - run make install
 - create fsgqa test user ("sudo useradd fsgqa")
-- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
-	
+- Only on systems which allow usernames that start with a digit (older
+  than  systemd 232 and/or has shadow older than v4.0.1), create the
+  123456-fsgqa test user:
+    sudo useradd 123456-fsgqa
+
 ______________________
 USING THE FSQA SUITE
 ______________________
diff --git a/common/config b/common/config
index d0fbfe55a6d2..88fd5dd455b9 100644
--- a/common/config
+++ b/common/config
@@ -199,6 +199,7 @@ export UBIUPDATEVOL_PROG="`set_prog_path ubiupdatevol`"
 export THIN_CHECK_PROG="$(set_prog_path thin_check)"
 export PYTHON2_PROG="`set_prog_path python2`"
 export SQLITE3_PROG="`set_prog_path sqlite3`"
+export SYSTEMCTL_PROG="`set_prog_path systemctl`"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/rc b/common/rc
index 4c053a53711a..445e3471869e 100644
--- a/common/rc
+++ b/common/rc
@@ -1983,6 +1983,48 @@ _cat_group()
 	cat /etc/group
 }
 
+# requires systemd
+#
+_require_systemd()
+{
+    _require_command "$SYSTEMCTL_PROG" systemctl
+}
+
+# gets your version of systemd
+#
+_get_systemd_version()
+{
+    _require_systemd
+    $SYSTEMCTL_PROG --version | head -1 | awk '{print $2}'
+}
+
+#  checks if you have a version of systemd older than the one specified
+#
+_systemd_version_lessthan()
+{
+    _require_systemd
+    version="$(_get_systemd_version)"
+    test_version=$1
+
+    if [ "$version" -lt "$test_version" ]; then
+        return 0
+    else
+        return 1
+    fi
+}
+
+# check that userames that start with a digit are allowed
+#
+_require_user_digit_allowed()
+{
+    if [ ! -x "$SYSTEMCTL_PROG" ]; then
+	return 0
+    fi
+    req_systemd="232"
+    _systemd_version_lessthan $req_systemd
+    [ "$?" == "0" ] || _notrun "runs only on old systemd version < $req_systemd"
+}
+
 # check for a user on the machine, fsgqa as default
 #
 _require_user()
diff --git a/tests/generic/381 b/tests/generic/381
index 006f0d879638..533ca27125cb 100755
--- a/tests/generic/381
+++ b/tests/generic/381
@@ -54,6 +54,7 @@ _require_quota
 _require_xfs_quota_foreign
 
 # need user and group named 123456-fsgqa
+_require_user_digit_allowed
 _require_user 123456-fsgqa
 _require_group 123456-fsgqa
 
-- 
2.15.0

