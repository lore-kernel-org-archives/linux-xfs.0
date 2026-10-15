Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0331938DD3;
	Thu, 15 Oct 2026 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025566; cv=none; b=HO/KPWtaoLDvuDLcvaeO/bQ6PoOnYc1EfrV9lyMDtTQYhM0h5XyHWdC5p0jMlIaW/sLcBCc5YcKgTgpjip7tgbN1JHRTetkeFEyGGmj1aJ6GBnZhzuoB2FOl+OcIoEPTgAm0y7qtCR7Nr5e45ZNphXT8UaWf7F+2qHnyde06Q8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025566; c=relaxed/simple;
	bh=sSYY79ecjwOkkgBkyZVbwdUdEurK1F69qqqMNjI2Ahc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pz3yHKjqVsyBebbVWnLwPf/Ij8Sqd7Mw3FXh1lJkVLcGIkuU2WuND+no5KpfnDVO6NZfXnjcQCxVlEP6g8/7JeXpTdTAgNbwnr06GccFkMYrmZwyIxg/a7YzwXO9CDd7iqZNHhOvzsUIbeJJuU2xQFkiwhaolWT1CCN76rYOQ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIl+RZzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIl+RZzU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CCEF01F000C4;
	Thu, 15 Oct 2026 00:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025564;
	bh=pDiTg1/IuwviU/npeXaSxneIO6w+KXiClfkOZ2QacKc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KIl+RZzUxUM3WMR41vXZayppJXBV6ZXRnA314npYFMk+9bHKqpMQzPG2Z1emR3Fw+
	 /R9pl/+CkbCj4nPdpMMP1mbGEzv14hIGtEKd/mkTBbZT9TmydsAlC6EDZoLSAoY47C
	 fzkxqpUe8aqJelzlp0cFHbm9u+7uA/2EAIo62OwlTByay9ugzBNC1DAHWTGGk+MZLm
	 gX0LTEyjGvxGjpYaHjzV1WF4tJ8WBUOnOA2UPPYTzhWKf/ghxpklMdIK8jTl596gIe
	 SdTP8s0brgv0D3N1TOfFPEeN/o0DD9+Ft9a05tM4M5O9+2ilCVom63Y8t5SwZAXTma
	 6KRBTKjFQyHlg==
Date: Wed, 14 Oct 2026 17:52:44 -0700
Subject: [PATCH 6/6] matrix: debian packaging
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org
Message-ID: <179202481293.3448668.9047758004897934673.stgit@frogsfrogsfrogs>
In-Reply-To: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
References: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Package all the software for Debian.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 matrix/Makefile                             |    8 +++++-
 matrix/debian/changelog                     |    5 +++
 matrix/debian/control                       |   39 +++++++++++++++++++++++++++
 matrix/debian/copyright                     |   22 +++++++++++++++
 matrix/debian/docs                          |    0 
 matrix/debian/fstests-collector.install     |   10 +++++++
 matrix/debian/fstests-collector.postinst.in |   22 +++++++++++++++
 matrix/debian/fstests-dashboard.install     |   13 +++++++++
 matrix/debian/fstests-dashboard.postinst.in |   10 +++++++
 matrix/debian/fstests-matrix.install        |   18 ++++++++++++
 matrix/debian/fstests-reporter.install      |   16 +++++++++++
 matrix/debian/rules                         |   15 ++++++++++
 matrix/debian/source/format                 |    1 +
 13 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100644 matrix/debian/changelog
 create mode 100644 matrix/debian/control
 create mode 100644 matrix/debian/copyright
 create mode 100644 matrix/debian/docs
 create mode 100644 matrix/debian/fstests-collector.install
 create mode 100644 matrix/debian/fstests-collector.postinst.in
 create mode 100644 matrix/debian/fstests-dashboard.install
 create mode 100644 matrix/debian/fstests-dashboard.postinst.in
 create mode 100644 matrix/debian/fstests-matrix.install
 create mode 100644 matrix/debian/fstests-reporter.install
 create mode 100755 matrix/debian/rules
 create mode 100644 matrix/debian/source/format


diff --git a/matrix/Makefile b/matrix/Makefile
index 23c4bc423a3f71..075f9f28a411f6 100644
--- a/matrix/Makefile
+++ b/matrix/Makefile
@@ -125,6 +125,10 @@ service_files=\
 sysusers_files=\
 	collector/fstmatrix.conf
 
+debian=\
+	debian/fstests-collector.postinst \
+	debian/fstests-dashboard.postinst
+
 dash_files=\
 	index.html \
 	all.html \
@@ -158,6 +162,8 @@ built_files=\
 	database/query_recent_test_runs \
 	database/query_test_run \
 	database/upsert_test_run \
+	debian/fstests-collector.postinst \
+	debian/fstests-dashboard.postinst \
 	reporter/collect-results \
 	reporter/copy-failure-info \
 	reporter/fstests-reporter \
@@ -173,7 +179,7 @@ built_files=\
 	collector/create-fstests-collector \
 	collector/fstmatrix.conf
 
-all: $(libprogs) $(libfiles) $(progs) $(service_files) $(wwwfiles) $(configfiles) $(sbinprogs) $(sysusers_files)
+all: $(libprogs) $(libfiles) $(debian) $(progs) $(service_files) $(wwwfiles) $(configfiles) $(sbinprogs) $(sysusers_files)
 
 clean:;
 	rm -f $(built_files)
diff --git a/matrix/debian/changelog b/matrix/debian/changelog
new file mode 100644
index 00000000000000..a597b688e3109c
--- /dev/null
+++ b/matrix/debian/changelog
@@ -0,0 +1,5 @@
+fstmatrix (1.0) trixie; urgency=medium
+
+  * Initial packaging.
+
+ -- Darrick J. Wong <djwong@djwong.org>  Wed, 14 Oct 2026 17:28:17 -0700
diff --git a/matrix/debian/control b/matrix/debian/control
new file mode 100644
index 00000000000000..8ebdf6bce5d398
--- /dev/null
+++ b/matrix/debian/control
@@ -0,0 +1,39 @@
+Source: fstmatrix
+Section: devel
+Priority: optional
+Maintainer: Darrick J. Wong <djwong@djwong.org>
+Build-Depends: debhelper-compat (= 12), dh-python, libsqlite3-dev, python3:any, wget
+Standards-Version: 4.1.1
+Homepage: https://djwong.org/
+
+Package: fstests-matrix
+Priority: optional
+Architecture: all
+Depends: ${misc:Depends}, ${python3:Depends}, python3:any, zstd, fstests-libmatrix, brotli, sqlite3
+Description: Test matrix to show collected results of fstests runs.
+
+Package: fstests-libmatrix
+Priority: optional
+Architecture: any
+Depends: ${misc:Depends}, ${python3:Depends}
+Description: Libraries for test matrix.
+
+Package: fstests-collector
+Priority: optional
+Architecture: any
+Depends: ${misc:Depends}, ${python3:Depends}, python3:any, php, fstests-matrix
+Description: Program files to collect the uploaded output of fstests runs.
+
+Package: fstests-dashboard
+Priority: optional
+Architecture: all
+Depends: ${misc:Depends}, fstests-matrix
+Description: Program files to collect the uploaded output of fstests runs.
+
+Package: fstests-reporter
+Architecture: all
+Depends: ${misc:Depends}, ${python3:Depends}, bash, curl, hostname, pciutils, python3, ssh, tar, util-linux, brotli, zstd
+Conflicts: xfsreporter
+Replaces: xfsreporter
+Provides: xfsreporter
+Description: Reports incremental fstests results to a central server.
diff --git a/matrix/debian/copyright b/matrix/debian/copyright
new file mode 100644
index 00000000000000..cd5d38e846ba59
--- /dev/null
+++ b/matrix/debian/copyright
@@ -0,0 +1,22 @@
+Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
+Upstream-Name: fstmatrix
+Source: https://djwong.org/
+
+Files: *
+Copyright: 2018-2026 Oracle
+License: GPL-2-or-later
+ This package is free software; you can redistribute it and/or modify
+ it under the terms of the GNU General Public License as published by
+ the Free Software Foundation; either version 2 of the License, or
+ (at your option) any later version.
+ .
+ This package is distributed in the hope that it will be useful,
+ but WITHOUT ANY WARRANTY; without even the implied warranty of
+ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ GNU General Public License for more details.
+ .
+ You should have received a copy of the GNU General Public License
+ along with this program. If not, see <http://www.gnu.org/licenses/>
+ .
+ On Debian systems, the complete text of the GNU General
+ Public License version 2 can be found in "/usr/share/common-licenses/GPL-2".
diff --git a/matrix/debian/docs b/matrix/debian/docs
new file mode 100644
index 00000000000000..e69de29bb2d1d6
diff --git a/matrix/debian/fstests-collector.install b/matrix/debian/fstests-collector.install
new file mode 100644
index 00000000000000..4c7f7449ff0733
--- /dev/null
+++ b/matrix/debian/fstests-collector.install
@@ -0,0 +1,10 @@
+/usr/lib/systemd/system/fstmatrix-receive.socket
+/usr/lib/systemd/system/fstmatrix-receive.service
+/usr/lib/systemd/system/fstmatrix-stow.service
+/usr/lib/systemd/system/fstmatrix-stow.timer
+/usr/libexec/fstmatrix/receive_tarball
+/usr/libexec/fstmatrix/create_collector
+/usr/share/fstmatrix/uploader.php
+/usr/sbin/create-fstests-collector
+/usr/share/man/man8/create-fstests-collector.8
+/usr/lib/sysusers.d/fstmatrix.conf
diff --git a/matrix/debian/fstests-collector.postinst.in b/matrix/debian/fstests-collector.postinst.in
new file mode 100644
index 00000000000000..66888e3040d2a0
--- /dev/null
+++ b/matrix/debian/fstests-collector.postinst.in
@@ -0,0 +1,22 @@
+#!/bin/sh -e
+
+#DEBHELPER#
+
+# If socky is running, the (noaccept) socket restart may fail because the
+# service is still running (and hence still hanging on to the socket).  Force
+# the service to stop, and *then* we can restart the socket.
+if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
+        if [ -d /run/systemd/system ] && [ "$(systemctl is-active djwong-sensors-update.socket 2>/dev/null)" != "active" ]; then
+                if [ -n "$2" ]; then
+                        _dh_action=restart
+                else
+                        _dh_action=start
+                fi
+                deb-systemd-invoke stop 'djwong-sensors-update.service' >/dev/null || true
+                deb-systemd-invoke $_dh_action 'djwong-sensors-update.socket' >/dev/null || true
+        fi
+fi
+
+create-fstests-collector "%fstmatrix_inst_dir%"
+
+exit 0
diff --git a/matrix/debian/fstests-dashboard.install b/matrix/debian/fstests-dashboard.install
new file mode 100644
index 00000000000000..a850b9b8f1ac2e
--- /dev/null
+++ b/matrix/debian/fstests-dashboard.install
@@ -0,0 +1,13 @@
+/usr/libexec/fstmatrix/create_dashboard
+/usr/libexec/fstmatrix/stow_dashboard
+/usr/share/fstmatrix/fstests.css
+/usr/share/fstmatrix/fstests.js
+/usr/share/fstmatrix/all.html
+/usr/share/fstmatrix/index.html
+/usr/share/fstmatrix/jquery.js
+/usr/share/fstmatrix/x.big.png
+/usr/share/fstmatrix/x.png
+/usr/share/fstmatrix/.htaccess
+/usr/lib/systemd/system/fstmatrix-dashboard.service
+/usr/sbin/config-fstests-dashboard
+/usr/share/man/man8/config-fstests-dashboard.8
diff --git a/matrix/debian/fstests-dashboard.postinst.in b/matrix/debian/fstests-dashboard.postinst.in
new file mode 100644
index 00000000000000..702519fb4fa501
--- /dev/null
+++ b/matrix/debian/fstests-dashboard.postinst.in
@@ -0,0 +1,10 @@
+#!/bin/sh -e
+
+test -d "%fstmatrix_inst_dir%/database" && \
+	"%pkg_libexec_dir%/create_dashboard" "%fstmatrix_inst_dir%/database" "%fstmatrix_inst_dir%/www"
+
+systemctl daemon-reload || true
+
+#DEBHELPER#
+
+exit 0
diff --git a/matrix/debian/fstests-matrix.install b/matrix/debian/fstests-matrix.install
new file mode 100644
index 00000000000000..0e926f593c3ebd
--- /dev/null
+++ b/matrix/debian/fstests-matrix.install
@@ -0,0 +1,18 @@
+/usr/libexec/fstmatrix/archive
+/usr/libexec/fstmatrix/create_db
+/usr/libexec/fstmatrix/create_views
+/usr/libexec/fstmatrix/db
+/usr/libexec/fstmatrix/find_new_tarballs
+/usr/libexec/fstmatrix/query_checktime
+/usr/libexec/fstmatrix/query_machines
+/usr/libexec/fstmatrix/query_all_test_runs
+/usr/libexec/fstmatrix/query_recent_test_runs
+/usr/libexec/fstmatrix/query_test_run
+/usr/libexec/fstmatrix/stow_tarball
+/usr/libexec/fstmatrix/stow_tarballs
+/usr/libexec/fstmatrix/test_runtime
+/usr/libexec/fstmatrix/upsert_test_run
+/usr/lib/fstmatrix/database.sql
+/usr/lib/fstmatrix/index.sql
+/usr/lib/fstmatrix/fstestdb.py
+/usr/lib/fstmatrix/views.sql
diff --git a/matrix/debian/fstests-reporter.install b/matrix/debian/fstests-reporter.install
new file mode 100644
index 00000000000000..0e931f072df320
--- /dev/null
+++ b/matrix/debian/fstests-reporter.install
@@ -0,0 +1,16 @@
+/usr/lib/systemd/system/fstmatrix-reporter.service
+/usr/lib/systemd/system/fstmatrix-reporter.timer
+/usr/bin/fstests-reporter
+/usr/libexec/fstmatrix/collect-all-results
+/usr/libexec/fstmatrix/collect-results
+/usr/libexec/fstmatrix/copy-failure-info
+/usr/libexec/fstmatrix/fingerprint-machine
+/usr/libexec/fstmatrix/fingerprint-tests
+/usr/libexec/fstmatrix/fstmatrix-reporter
+/usr/libexec/fstmatrix/fstmatrix-want-reporter
+/usr/libexec/fstmatrix/starttime
+/usr/libexec/fstmatrix/upload-all-results
+/usr/lib/fstmatrix/xunit_failed.awk
+/usr/lib/fstmatrix/xunit_rollup.awk
+/usr/share/man/man1/fstests-reporter.1
+/etc/fstmatrix-reporter
diff --git a/matrix/debian/rules b/matrix/debian/rules
new file mode 100755
index 00000000000000..1b4573e50bc83c
--- /dev/null
+++ b/matrix/debian/rules
@@ -0,0 +1,15 @@
+#!/usr/bin/make -f
+# -*- makefile -*-
+
+# Uncomment this to turn on verbose mode.
+export DH_VERBOSE=1
+
+%:
+	dh $@ --with python3 --with installsysusers
+
+# restart the collector socket and service because systemd can't handle
+# restarting the socket if the service doesn't also terminate
+override_dh_installsystemd:
+	dh_installsystemd -p fstests-reporter --no-enable --no-start --no-restart-after-upgrade --no-restart-on-upgrade fstmatrix-reporter.timer
+	dh_installsystemd -p fstests-dashboard fstmatrix-dashboard.service
+	dh_installsystemd -p fstests-collector fstmatrix-receive.socket
diff --git a/matrix/debian/source/format b/matrix/debian/source/format
new file mode 100644
index 00000000000000..89ae9db8f88b82
--- /dev/null
+++ b/matrix/debian/source/format
@@ -0,0 +1 @@
+3.0 (native)

