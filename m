Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E7F35893;
	Thu, 15 Oct 2026 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025538; cv=none; b=ekg604wa+8CPP6L8vrcuIrrWCeqLOzA4hINvhqBCTHExUYxPdJIm7a1OMTi0Mggu1PDxc3HzxAFmAewI+rCBLVR2DTpcjG7Lz3keSsDDcn8wjj7qWLKjFg267CSerlbez8yRvch+sjVJv1VqfjAZ3Ypu/ur7uK+2n8ApoXis2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025538; c=relaxed/simple;
	bh=0haTVgGVbYHrrMIc6AOCXejVigf4nKCqP78sTfD8aa0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hyKhK9W0mqH5hg1milHPnaE0+HPbiKH/DegZGmS92K0tfNh8WVR8edqJsURpPpwTUHmTADyuHdiWBTA7o6ynSaP4e5Z0Q5TP2IL9F7PyQoLbCeSAmDW2cLZ7ZMmASuKMEIthZES4rxVdKQzJ83Am7fXtbZnHXwM2MbcngbuSNi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMJxPK8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMJxPK8o"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 77EDC1F000C4;
	Thu, 15 Oct 2026 00:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025533;
	bh=Ys/hr+kpw56FvkhYO1hc0Q6vQ/L3olLYpEPaRvLSCBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NMJxPK8onGvjno2FTZwHo03RviS98XRaxJqAFVG6yJVKNXm5e1tcv2SP6/sSJEgYx
	 kHWrjRbGbCkQl1DbMjHjn5H11ISHehQJA/7PXfdhv2G1bXBql9C1u+qKRko6fqrqMl
	 OOWTcxbtqvZ1NodDkYT/N8i4Oy/IQboLEw/h1rSRZqMPRQ1wMevGAS5+Zwn5OSnR4z
	 fceReYS5nCtu+YV74x6Ef9Z+ofv3WzMVNzxRHyqfKnnn9fev7UZQALGiFF+AZBjbxA
	 i4BsDba0xfF7okEiZRl9oaNrviFNU5mLpcgDdl8jsPvsC2zSyidsUotU9EkO7YDoIp
	 CR2jdf0m734ig==
Date: Wed, 14 Oct 2026 17:52:13 -0700
Subject: [PATCH 4/6] matrix: add web dashboard for collected test results
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org
Message-ID: <179202481256.3448668.11056936492065178590.stgit@frogsfrogsfrogs>
In-Reply-To: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
References: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Create a web dashboard that summarizes the test results from the sqlite
database.  This enables a maintainer to look at a glance at how their
QA fleet are performing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 matrix/dashboard/all.html                       |   31 +
 matrix/dashboard/config-fstests-dashboard.8     |   20 +
 matrix/dashboard/config-fstests-dashboard.in    |   38 +
 matrix/dashboard/create_dashboard.in            |   77 +++
 matrix/dashboard/fstests.css.in                 |  183 ++++++
 matrix/dashboard/fstests.js                     |  670 +++++++++++++++++++++++
 matrix/dashboard/fstmatrix-dashboard.service.in |   17 +
 matrix/dashboard/index.html                     |   31 +
 matrix/dashboard/stow_dashboard.in              |   56 ++
 matrix/dashboard/x.big.png                      |  Bin
 matrix/dashboard/x.png                          |  Bin
 11 files changed, 1123 insertions(+)
 create mode 100644 matrix/dashboard/all.html
 create mode 100644 matrix/dashboard/config-fstests-dashboard.8
 create mode 100644 matrix/dashboard/config-fstests-dashboard.in
 create mode 100644 matrix/dashboard/create_dashboard.in
 create mode 100644 matrix/dashboard/fstests.css.in
 create mode 100644 matrix/dashboard/fstests.js
 create mode 100644 matrix/dashboard/fstmatrix-dashboard.service.in
 create mode 100644 matrix/dashboard/index.html
 create mode 100644 matrix/dashboard/stow_dashboard.in
 create mode 100644 matrix/dashboard/x.big.png
 create mode 100644 matrix/dashboard/x.png


diff --git a/matrix/dashboard/all.html b/matrix/dashboard/all.html
new file mode 100644
index 00000000000000..1ee4d070fffa6b
--- /dev/null
+++ b/matrix/dashboard/all.html
@@ -0,0 +1,31 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
+<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
+	<head>
+		<!--
+			SPDX-License-Identifier: GPL-2.0-or-later
+			Copyright (C) 2018-2026 Oracle.
+		-->
+		<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
+		<meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
+		<meta name="ROBOTS" content="NOINDEX, NOFOLLOW"/>
+		<link rel="icon" href="x.png"/>
+		<!-- component libraries -->
+		<script type="text/javascript" src="jquery.js"></script>
+		<!-- stuff specific to us -->
+		<link rel="stylesheet" href="fstests.css"/>
+		<link rel="alternate" type="application/atom+xml" href="fstestsall.rss.br"/>
+		<script type="text/javascript" src="fstests.js"></script>
+		<script type="text/javascript">
+window.addEventListener("load", function() {loadFstestsAllCtl();}, false);
+		</script>
+		<title>fstests Status</title>
+	</head>
+	<body>
+		<div id="test_status"><div id="loading">Loading slowly...
+		<noscript>
+			or not; this page requires JavaScript. Please enable it.
+		</noscript>
+		</div></div>
+	</body>
+</html>
diff --git a/matrix/dashboard/config-fstests-dashboard.8 b/matrix/dashboard/config-fstests-dashboard.8
new file mode 100644
index 00000000000000..421fc0948c2a7d
--- /dev/null
+++ b/matrix/dashboard/config-fstests-dashboard.8
@@ -0,0 +1,20 @@
+.TH CONFIG-DASHBOARD "1" "June 2025" "fstests-dashboard"
+.SH NAME
+config-fstests-dashboard - Configure fstests dashboard live feed
+.SH SYNOPSYS
+.B
+config-fstests-dashboard [urlprefix|--disable]
+.SH DESCRIPTION
+Configure the fstests dashboard and enable automatic reporting of raw test
+results (aka json data file regeneration).
+If the
+.B --disable
+option is given, then the automatic reporting is disabled and the configuration
+removed.
+Otherwise, the first argument is treated as a URL prefix.
+Automatic reporting is configured to point to that URL prefix, and begun.
+
+.SH AUTHOR
+Oracle
+.SH COPYRIGHT
+Copyright ©2026 Oracle.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
diff --git a/matrix/dashboard/config-fstests-dashboard.in b/matrix/dashboard/config-fstests-dashboard.in
new file mode 100644
index 00000000000000..2b9d5bbfee2836
--- /dev/null
+++ b/matrix/dashboard/config-fstests-dashboard.in
@@ -0,0 +1,38 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018-2026 Oracle.
+# Configure fstests dashboard regeneration
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 [urlprefix|--disable]"
+	exit 1
+fi
+
+override_dir="%systemd_services_conf_dir%/fstmatrix-dashboard.service.d"
+override_file="${override_dir}/override.conf"
+
+if [ "$1" = "--disable" ]; then
+	systemctl stop fstmatrix-dashboard.service
+	systemctl disable fstmatrix-dashboard.service
+
+	rm -f "${override_file}"
+	rmdir --ignore-fail-on-non-empty "${override_dir}"
+	systemctl daemon-reload
+
+	exit
+fi
+
+mkdir -p "${override_dir}"
+cat > "${override_file}" << ENDL
+# Configured with config-fstests-dashboard
+
+[Service]
+Environment=URLPREFIX=$1
+
+[Install]
+WantedBy=multi-user.target
+ENDL
+
+systemctl daemon-reload
+systemctl enable fstmatrix-dashboard.service
+systemctl restart fstmatrix-dashboard.service
diff --git a/matrix/dashboard/create_dashboard.in b/matrix/dashboard/create_dashboard.in
new file mode 100644
index 00000000000000..3e6878597bf054
--- /dev/null
+++ b/matrix/dashboard/create_dashboard.in
@@ -0,0 +1,77 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Create a web dashboard directory
+# Usage: $0 fsmatrix-dir webdir
+
+srcdir="$(dirname "$0")"
+fsmatrix="$1"
+webdir="$2"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+print_help() {
+	echo "Create a web dashboard directory."
+	echo "Usage: $0 database_dir webdir"
+}
+
+if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "--help" ]; then
+	print_help
+	exit 1
+fi
+
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+
+owner_str="%fstmatrix_user%:%fstmatrix_user%"
+
+try_chown() {
+	local tgt_str="$(stat -c '%U:%G' "$2")"
+	if [ "$tgt_str" != "$1" ]; then
+		chown -R "$1" "$2"
+	fi
+}
+
+mkdir -p "${webdir}"
+test "${webdir}/../database" -ef "${fsmatrix}" || \
+	die "${fsmatrix}: not the same dir as ${webdir}"
+
+for i in %dash_files%; do
+	ln -s -f "%pkg_share_dir%/$i" "${webdir}/"
+done
+if [ ! -e "${webdir}/output" ]; then
+	ln -s -f "../database/machines" "${webdir}/output"
+fi
+
+try_chown "${owner_str}" "${webdir}"
+
+# Make sure we have at least a stub of json and rss files
+jsfile="${webdir}/fstestsbot.js"
+if [ ! -f "${jsfile}" ]; then
+	rm -r -f "${jsfile}"
+	echo "[ ]" > "${jsfile}"
+	chown "${owner_str}" "${jsfile}"
+fi
+
+rssfile="${webdir}/fstestsbot.rss"
+if [ ! -f "${rssfile}" ]; then
+	rm -r -f "${rssfile}"
+	echo "<?xml version='1.0' encoding='UTF-8'?><rss version="2.0"></rss>" > "${rssfile}"
+	chown "${owner_str}" "${rssfile}"
+fi
+jsfile="${webdir}/fstestsall.js.br"
+if [ ! -f "${jsfile}" ]; then
+	rm -r -f "${jsfile}"
+	echo "[ ]" | brotli -9 > "${jsfile}"
+	chown "${owner_str}" "${jsfile}"
+fi
+
+rssfile="${webdir}/fstestsall.rss.br"
+if [ ! -f "${rssfile}" ]; then
+	rm -r -f "${rssfile}"
+	echo "<?xml version='1.0' encoding='UTF-8'?><rss version="2.0"></rss>" | brotli -9 > "${rssfile}"
+	chown "${owner_str}" "${rssfile}"
+fi
diff --git a/matrix/dashboard/fstests.css.in b/matrix/dashboard/fstests.css.in
new file mode 100644
index 00000000000000..7556875da86e84
--- /dev/null
+++ b/matrix/dashboard/fstests.css.in
@@ -0,0 +1,183 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ * Copyright (c) 2018-2026 Oracle.
+ */
+body {
+	margin: 0px;
+	padding: 0px;
+	font-family: %dashboard_fonts%;
+	background: #f7f7f7;
+}
+h2 {
+	margin: 0em;
+}
+.resultslink {
+	text-decoration: none;
+}
+.balloontab {
+	display: grid;
+	grid-template-columns: repeat(auto-fit, minmax(min-content, 24em));
+	gap: 1em;
+	padding: 1em;
+	justify-content: center;
+}
+.balloon {
+	padding: 0.7em;
+	border: 1px solid #c0c0c0;
+	border-radius: 8px;
+	vertical-align: top;
+	background: white;
+	box-shadow: 0px 0px 7px #c0c0c0;
+}
+.last {
+	margin-right: 1em;
+	margin-left: 1em;
+}
+.failed {
+	color: red;
+	font-weight: bold;
+}
+.passed {
+	color: #00C000;
+	font-weight: bold;
+}
+.running {
+	color: black;
+	font-weight: bold;
+}
+.late {
+	color: blue;
+	font-weight: bold;
+}
+.propgrid {
+	display: grid;
+	grid-template-columns: fit-content(0.5%) fit-content(99.5%);
+	gap: 0.2em;
+}
+.propkey {
+	white-space: nowrap;
+	text-align: right;
+	vertical-align: top;
+	padding-top: 0px;
+	padding-bottom: 0.15em;
+	padding-right: 0.5em;
+}
+.propval {
+	padding: 0px;
+	padding-bottom: 0.15em;
+}
+#loading {
+	padding: 0.5em;
+}
+.lastmod {
+	padding: 0px;
+	padding-left: 0.4em;
+	padding-bottom: 0.4em;
+	font-style: italic;
+}
+.progress_bar {
+	margin-top: 0.5em;
+	margin-bottom: 0.5em;
+	width: 100%;
+	font-family: 'Arial';
+	font-size: 8pt;
+}
+.progress_rect {
+	display: inline-block;
+	padding-top: 0.6em;
+	padding-bottom: 0.6em;
+}
+.progress_pass {
+	background: #7BDB7B;	/* light green #00C00080 */
+}
+.progress_fail {
+	background: #FB7B7B;	/* light red #FF000080 */
+}
+.progress_skip {
+	background: #D8D8F0;	/* light blue #0000C020 */
+}
+.progress_nosel {
+	background: #E8E8E8;	/* light gray #00000010 */
+}
+.pager {
+	margin: 1em auto;
+	margin-top: 0px;
+	max-width: 800px;
+	text-align: center;
+	color: #303030;
+}
+.pager_button {
+	border: none;
+	background-color: inherit;
+	cursor: pointer;
+	color: #303030;
+	text-decoration: none;
+	padding: 0.3em;
+	padding-top: 0.1em;
+	padding-bottom: 0.1em;
+	font-size: 150%;
+}
+.pager_button:disabled {
+	color: #a0a0a0;
+	cursor: inherit;
+}
+#pager_form {
+	display: inline;
+}
+#pager_page {
+	font-family: %dashboard_fonts%;
+	background: inherit;
+	border: 1px solid #c0c0c0;
+	text-align: center;
+}
+
+details.propval[open] summary span.ellipse {
+	display: none;
+}
+details.propval summary {
+	display: inline list-item;
+	cursor: pointer;
+}
+
+@media (prefers-color-scheme: dark) {
+	body {
+		color: white; /* #e0e0e0; */
+		background: black; /* #202020; */
+	}
+	a {
+		color: #69f;
+	}
+	a:visited {
+		color: #96f;
+	}
+	.balloon {
+		border: 1px solid #404040;
+		background: #141414;
+		box-shadow: 0px 0px 7px #404040;
+	}
+	.running {
+		color: white;
+	}
+	.late {
+		color: #09f;
+	}
+	.progress_nosel {
+		background: #303030; /* dark gray */
+	}
+	.progress_skip {
+		background: #505050;
+	}
+	.pager_button {
+		color: white; /* #a0a0a0; */
+	}
+	.pager_button:disabled {
+		color: #303030;
+	}
+	#pager_page {
+		color: white; /* #a0a0a0; */
+		border: 1px solid #505050;
+	}
+	.pager {
+		color: white; /* #a0a0a0; */
+	}
+}
diff --git a/matrix/dashboard/fstests.js b/matrix/dashboard/fstests.js
new file mode 100644
index 00000000000000..b702ddf9ebe841
--- /dev/null
+++ b/matrix/dashboard/fstests.js
@@ -0,0 +1,670 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ * Copyright (C) 2018-2026 Oracle.
+ */
+var DEBUG = document.location.hash.indexOf('debug') >= 0;
+var MAX_PER_PAGE = 120; /* lcm of 2, 3, 4, 5, 6 that's greater than 100 */
+
+function log(msg) {
+	if (!DEBUG)
+		return;
+
+	var dateopts = {
+		hour12: false,
+		weekday: 'short',
+		year: 'numeric',
+		month: 'short',
+		day: 'numeric',
+		hour: 'numeric',
+		minute: 'numeric',
+		timeZoneName: 'short',
+	};
+
+	var d = new Date();
+	s = d.toLocaleString('en-US', dateopts) + ":";
+	console.log(s, msg);
+}
+
+class TestRun {
+	constructor()
+	{
+	}
+
+	absorb(raw, dateopts)
+	{
+		this.data = raw;
+		this.dateopts = dateopts;
+
+		/*
+		 * From the junit xml reports, we have some summary counters:
+		 *  - failed/failures: # of real test failures;
+		 *  - tried/tests: # of tests we chose for this test run;
+		 *  - skipped: # of tests that declined to run;
+		 *  - counted: # of tests in the fingerprint file.
+		 *
+		 * # of tests attempted so far is (tried - skipped).
+		 * # of tests that passed so far is (attempted - failed).
+		 */
+		this.data.attempted = this.data.tried - this.data.skipped;
+		this.data.passed = this.data.attempted - this.data.failed;
+		this.data.notsel = this.data.counted - this.data.tried;
+	}
+
+	/* Render a fraction as a human-readable percentage. */
+	_human_pct(n, d) {
+		if (n <= 0)
+			return '0%';
+		if (d == 0)
+			d += 1;
+		var pct = 100.0 * n / d;
+		if (pct >= 10)
+			return pct.toFixed(0) + '%';
+		if (pct >= 1)
+			return pct.toFixed(1) + '%';
+		if (pct >= 0.1)
+			return pct.toFixed(2) + '%';
+		return pct.toFixed(3) + '%';
+	}
+
+	_num(nr) {
+		try {
+			/* Not supported on Safari 9 */
+			return Intl.NumberFormat().format(nr);
+		} catch (err) {
+			return nr;
+		}
+	}
+
+	/* Render numerical status. */
+	_summary(nr) {
+		var raw = this.data;
+		var status1 = this._num(nr) + ' of ' + this._num(raw.attempted);
+		status1 += ' (' + this._human_pct(nr, raw.attempted) + ') tests';
+		if (raw.run_time == null)
+			status1 += ' so far';
+
+		/*
+		 * If we ran fewer than 100 tests then assume we weren't trying
+		 * for a comprehensive QA run.  Coverage here is defined as
+		 * tests that passed, failed, or weren't appropriate for the
+		 * fs configuration (i.e. _notrun).
+		 */
+		if (raw.attempted >= 100) {
+			status1 += ', covering ';
+			status1 += this._human_pct(raw.tried, raw.counted);
+			status1 += ' of ' + this._num(raw.counted);
+		}
+
+		/* Estimate the amount of time elapsed so far. */
+		if (raw.run_time == null) {
+			var elapsed = (Date.now() / 1000) - raw.start_time;
+			status1 += ' after ';
+		} else {
+			var elapsed = raw.run_time;
+			status1 += ' in ';
+		}
+		if (elapsed >= 86400) {
+			status1 += (elapsed / 86400).toFixed(1) + ' days.';
+		} else if (elapsed >= 3600) {
+			status1 += (elapsed / 3600).toFixed(1) + ' hours.';
+		} else if (elapsed >= 60) {
+			status1 += (elapsed / 60).toFixed(0) + ' mins.';
+		} else {
+			status1 += elapsed.toFixed(0) + ' secs.';
+		}
+		return status1;
+	}
+
+	/* Render status message. */
+	_status()
+	{
+		var raw = this.data;
+		var p = $('<span>');
+
+		/* Still running... */
+		if (raw.run_time == null) {
+			var ctx = this._summary(raw.passed);
+			var stat = $('<span>');
+			if (raw.late) {
+				stat.attr('class', 'late');
+				stat.text('Running Late');
+			} else {
+				stat.attr('class', 'running');
+				stat.text('Running');
+			}
+			return p.append(stat).append(', passed ').append(ctx);
+		}
+
+		/* Finished without running anything. */
+		if (raw.attempted < 1)
+			return p.text('Did not run any tests.');
+
+		/* Finished with failures. */
+		if (raw.failed > 0) {
+			var ctx = this._summary(raw.failed);
+			var stat = $('<span>');
+			stat.attr('class', 'failed');
+			stat.text('Failed');
+			return p.append(stat).append(' ').append(ctx);
+		}
+
+		/* Everything passed! */
+		ctx = this._summary(raw.passed);
+		var stat = $('<span>');
+		stat.attr('class', 'passed');
+		stat.text('Passed');
+		return p.append(stat).append(' all ').append(ctx);
+	}
+
+	/* Render tooltip for progress bar. */
+	_tooltip(n, tag) {
+		var ret = this._num(n) + ' ' + tag + ' (';
+		ret += this._human_pct(n, this.data.counted) + ')';
+		return ret;
+	}
+
+	/* Create a HTML progressbar. */
+	_progressbar() {
+		function pct(n, d) {
+			return (100.0 * n / d) + '%';
+		}
+		var pb = $('<div>');
+		pb.attr('class', 'progress_bar');
+
+		var raw = this.data;
+		var ppass = $('<div>');
+		ppass.attr('class', 'progress_rect progress_pass');
+		var pstr = pct(raw.passed, raw.counted);
+		ppass.css('width', pstr);
+		var tstr = this._tooltip(raw.passed, 'Passed');
+		ppass.attr('title', tstr);
+		pb.append(ppass);
+
+		var pfail = $('<div>');
+		pfail.attr('class', 'progress_rect progress_fail');
+		var pstr = pct(raw.failed, raw.counted);
+		pfail.css('width', pstr);
+		var tstr = this._tooltip(raw.failed, 'Failed');
+		pfail.attr('title', tstr);
+		pb.append(pfail);
+
+		var pskip = $('<div>');
+		pskip.attr('class', 'progress_rect progress_skip');
+		var pstr = pct(raw.skipped, raw.counted);
+		pskip.css('width', pstr);
+		var tstr = this._tooltip(raw.skipped, 'Skipped');
+		pskip.attr('title', tstr);
+		pb.append(pskip);
+
+		var pnosel = $('<div>');
+		pnosel.attr('class', 'progress_rect progress_nosel');
+		var pstr = pct(raw.notsel, raw.counted);
+		pnosel.css('width', pstr);
+		var tstr = this._tooltip(raw.notsel, 'Not Selected');
+		pnosel.attr('title', tstr);
+		pb.append(pnosel);
+
+		return pb;
+	}
+
+	/* Generate a html status balloon. */
+	render_html()
+	{
+		function mkfrob(str, tag) {
+			if (tag === undefined || tag == null)
+				tag = '<p>';
+			var x = $(tag);
+			x.html(str);
+			return x;
+		}
+		function fixstring(str) {
+			var s = str;
+			s = s.replace(/-/g, '-<wbr/>');
+			s = s.replace(/,/g, ',<wbr/>');
+			s = s.replace(/=/g, '=<wbr/>');
+			return s;
+		}
+
+		var raw = this.data;
+		var cell = $('<div>');
+		cell.attr('class', 'balloon');
+		cell.append(mkfrob(raw.name, '<h2>'));
+		cell.append(this._progressbar());
+
+		var table = $('<div>');
+		table.attr('class', 'propgrid');
+
+		function longtablerow(table, key, value, longvalue) {
+			var ltd = $('<div>');
+			ltd.attr('class', 'propkey');
+			ltd.text(key);
+			var rtd = $('<div>');
+			rtd.attr('class', 'propval');
+			var details = $('<details>');
+			details.attr('class', 'propval');
+			var summary = $('<summary>');
+			summary.html(value);
+			var ellipse = $('<span>');
+			ellipse.attr('class', 'ellipse');
+			ellipse.html('…');
+			summary.append(' ');
+			summary.append(ellipse);
+			details.append(summary);
+			details.append(longvalue);
+			rtd.append(details);
+			table.append(ltd);
+			table.append(rtd);
+		}
+
+		function tablerow(table, key, value, valueobj) {
+			var ltd = $('<div>');
+			ltd.attr('class', 'propkey');
+			ltd.text(key);
+			var rtd = $('<div>');
+			rtd.attr('class', 'propval');
+			rtd.html(value);
+			if (valueobj != undefined) {
+				rtd.append(' ');
+				rtd.append(valueobj);
+			}
+			table.append(ltd);
+			table.append(rtd);
+		}
+
+		var link = $('<a>');
+		link.attr('class', 'resultslink');
+		link.attr('target', '_blank');
+		link.attr('rel', 'noopener');
+		link.attr('href', 'output/.' + raw.machine_hash + '/.' + raw.test_run_hash + '/?C=M;O=A');
+		link.html('🔗');
+
+		var d = new Date(raw.time * 1000);
+		tablerow(table, 'Updated:',
+				d.toLocaleString('en-US', this.dateopts), link);
+
+		/*
+		 * Older versions of the reporter didn't consistently capture
+		 * these datapoints, with the exception of FSTYP.
+		 */
+		if (raw.kernel != null)
+			tablerow(table, 'Kernel:', fixstring(raw.kernel));
+		if (raw.mkfs_opts != null)
+			tablerow(table, 'Format:', 'mkfs.' + raw.fstyp + ' ' + fixstring(raw.mkfs_opts));
+		if (raw.mount_opts != null)
+			tablerow(table, 'Mount:', fixstring(raw.mount_opts));
+		if (raw.testing != null)
+			tablerow(table, 'Testing:', fixstring(raw.testing));
+		if (raw.failed > 20) {
+			var farray = raw.failures.split(" ");
+			longtablerow(table, 'Failures:',
+				fixstring(farray.slice(0, 20).join(" ")),
+				fixstring(farray.slice(20).join(" ")));
+		} else if (raw.failed > 0)
+			tablerow(table, 'Failures:', fixstring(raw.failures));
+
+		var ltd = $('<div>');
+		ltd.attr('class', 'propkey');
+		ltd.text('Status:');
+		var rtd = $('<div>');
+		rtd.attr('class', 'propval');
+		rtd.append(this._status());
+		table.append(ltd);
+		table.append(rtd);
+
+		cell.append(table);
+		return cell;
+	}
+}
+
+/* fstests status controller */
+class FstestsCtl {
+	constructor(url, other_url, other_link, refresh_s)
+	{
+		var that = this;
+		this.div = $('#test_status');
+		this.url = url;
+		this.refreshTimer = null;
+		this.dateopts = {
+			hour12: false,
+			weekday: 'short',
+			year: 'numeric',
+			month: 'short',
+			day: 'numeric',
+			hour: 'numeric',
+			minute: 'numeric',
+			timeZoneName: 'short',
+		};
+		this.other_url = other_url;
+		this.other_link = other_link;
+		this.data = [];
+		this.curr_page = 1;	/* 1 to nr_pages */
+		this.nr_pages = 0;
+		this.pager_div = null;
+		this.refresh_s = refresh_s;
+		this.mtime = null;
+
+		/* fetch data now that we've finished building */
+		this.fetch_data();
+	}
+
+	/* Set the automatic reload timeout. */
+	_set_refresh_timer()
+	{
+		if (this.refreshTimer != null)
+			window.clearTimeout(this.refreshTimer);
+
+		if (this.refresh_s > 0) {
+			var that = this;
+			function timer_fn() {
+				that.fetch_data(false);
+			}
+			this.refreshTimer = window.setTimeout(timer_fn,
+					this.refresh_s * 1000);
+		}
+	}
+
+	/* Load new test status data. */
+	fetch_data()
+	{
+		log('load ' + this.url);
+		var that = this;
+		function kick(data, stat, xhr) {
+			that.__load_data(data, stat, xhr);
+			that._set_refresh_timer();
+		}
+		function fail() {
+			that._set_refresh_timer();
+		}
+		$.getJSON(this.url, kick).fail(fail);
+	}
+
+	/* Install a new dataset into the control. */
+	__set_data(data)
+	{
+		this.data = data;
+		this.nr_pages = Math.ceil(data.length / MAX_PER_PAGE);
+
+		/* Update the pager UI state. */
+		this.pageinput.attr('max', this.nr_pages);
+		this.pageinput.css('width', (1 + String(this.nr_pages).length) + 'em');
+		this.pager_max.html(this.nr_pages);
+		this.pager.show_if(this.nr_pages > 1);
+	}
+
+	/* Set the currently visible page. */
+	__set_page(pagenr)
+	{
+		/* Negative pagenr is an offset from the end */
+		if (pagenr < 0)
+			pagenr = (pagenr + 1) + this.nr_pages;
+
+		/* Clamp pagenr to 1..nr_pages */
+		if (pagenr < 1)
+			pagenr = 1;
+		if (pagenr > this.nr_pages)
+			pagenr = this.nr_pages;
+
+		log('start_render ' + pagenr);
+
+		/* Fill the page with html for just this part of the dataset */
+		var page = $('<div>');
+		page.attr('class', 'balloontab');
+
+		/* Convert pagenr (1-based) to data[] (0-based) */
+		var i = (pagenr - 1) * MAX_PER_PAGE;
+		var max_i = Math.min(i + MAX_PER_PAGE, this.data.length);
+		var tr = new TestRun();
+		for (; i < max_i; i++) {
+			tr.absorb(this.data[i], this.dateopts);
+			page.append(tr.render_html());
+		}
+
+		this.pager_div.replaceWith(page);
+		this.pager_div = page;
+		this.curr_page = pagenr;
+
+		log('finish_render ' + pagenr);
+
+		/* Update the pager UI state. */
+		this.rew.enable_if(this.curr_page > 1);
+		this.prev.enable_if(this.curr_page > 1);
+		this.next.enable_if(this.curr_page != this.nr_pages);
+		this.ffwd.enable_if(this.curr_page != this.nr_pages);
+		this.pageinput.val(this.curr_page);
+	}
+
+	/* Create the UI elements for where we display the test results */
+	__render_balloons()
+	{
+		this.pager_div = $('<div>');
+		this.div.empty();
+		this.div.append(this.pager_div);
+	}
+
+	/* Render pager UI. */
+	__render_pager()
+	{
+		var that = this;
+		var enable_if = function(pred) {
+			if (pred) {
+				this.removeAttr('disabled');
+			} else {
+				this.attr('disabled', 'disabled');
+			}
+		};
+		var show_if = function(pred) {
+			if (pred) {
+				this.show();
+			} else {
+				this.hide();
+			}
+		};
+
+		var pager = $('<div>', {
+			class: 'pager',
+			disabled: true
+		});
+		pager.attr('class', 'pager');
+		pager.show_if = show_if;
+		pager.hide();
+
+		/* Rewind to the start. */
+		var rew = $('<button>', {
+			class: 'pager_button',
+			disabled: true
+		});
+		rew.html('&laquo;');
+		rew.click(function() {
+			that.__set_page(1);
+			return false;
+		});
+		rew.enable_if = enable_if;
+		pager.append(rew);
+		this.rew = rew;
+
+		/* Go back one page */
+		var prev = $('<button>', {
+			class: 'pager_button',
+			disabled: true
+		});
+		prev.html('&lsaquo;');
+		prev.click(function() {
+			that.__set_page(that.curr_page - 1);
+			return false;
+		});
+		prev.enable_if = enable_if;
+		pager.append(prev);
+		this.prev = prev;
+
+		pager.append(' ');
+
+		/* Where are we now? */
+		var f = $('<form>', {
+			id: 'pager_form',
+			action: ''
+		});
+		f.submit(function() {
+			var a = parseInt($('#pager_page').val());
+			that.__set_page(a);
+			return false;
+		});
+		var i = $('<input>', {
+			type: 'number',
+			value: this.curr_page,
+			id: 'pager_page',
+			min: 1,
+			max: 1
+		});
+		i.css('width', '2em');
+		this.pageinput = i;
+		f.append(i);
+		pager.append(f);
+		pager.append(' of ');
+		var np = $('<span>');
+		this.pager_max = np;
+		pager.append(np);
+		pager.append(' ');
+
+		/* Go forward one page. */
+		var next = $('<button>', {
+			class: 'pager_button',
+			disabled: true
+		});
+		next.html('&rsaquo;');
+		next.click(function() {
+			that.__set_page(that.curr_page + 1);
+			return false;
+		});
+		next.enable_if = enable_if;
+		pager.append(next);
+		this.next = next;
+
+		/* Go to the end. */
+		var ffwd = $('<button>', {
+			class: 'pager_button',
+			disabled: true
+		});
+		ffwd.html('&raquo;');
+		ffwd.click(function() {
+			that.__set_page(-1);
+			return false;
+		});
+		ffwd.enable_if = enable_if;
+		pager.append(ffwd);
+		this.ffwd = ffwd;
+
+		this.pager = pager;
+		this.div.append(pager);
+	}
+
+	/* Create the last modified UI area. */
+	__render_statusbar()
+	{
+		var hr = $('<hr/>');
+		this.div.append(hr);
+		var lastupdate = $('<div>', {
+			class: "lastmod"
+		});
+
+		lastupdate.append('Last modified on ');
+		var timestamp = $('<span>');
+		lastupdate.append(timestamp);
+		this.timestamp = timestamp;
+		lastupdate.append('; also see ');
+		var olink = $('<a>');
+		olink.attr('href', this.other_url);
+		olink.html(this.other_link);
+		lastupdate.append(olink);
+		lastupdate.append('.');
+
+		this.div.append(lastupdate);
+	}
+
+	/* Fill out last modified timestamp. */
+	__update_statusbar(mtime)
+	{
+		if (mtime == null)
+			mtime = new Date();
+		var timestamp = mtime.toLocaleString('en-US', this.dateopts);
+		this.timestamp.html(timestamp);
+	}
+
+	/* Update UI with new status data. */
+	__load_data(data, stat, xhr)
+	{
+		var mtime = null;
+
+		log('nr_items ' + data.length);
+
+		/* Define lateness as being more than 35 minutes out of date. */
+		var late = Math.floor(Date.now() / 1000) - (35 * 60);
+
+		/* Do we really need to update anything? */
+		var lmtime = xhr.getResponseHeader('last-modified');
+		if (lmtime != null)
+			mtime = new Date(lmtime);
+		log('old_mtime ' + this.mtime + '; mtime ' + mtime + '; equal ' + (this.mtime - mtime == 0));
+
+		/*
+		 * Oddly, '==' returns false for two separate Date objects
+		 * that represent the same timestamp.  Subtracting them seems
+		 * to work?
+		 */
+		if (this.mtime != null && mtime != null && this.mtime - mtime == 0) {
+			/* update lateness data and re-render */
+			var need_render = false;
+			for (var testrun of this.data) {
+				/* finished runs cannot be late */
+				if (testrun.run_time != null)
+					continue;
+				var late_now = testrun.time < late;
+				if (testrun.late == late_now)
+					continue;
+				log('now late: ' + testrun.name);
+				testrun.late = testrun.time < late;
+				need_render = true;
+			}
+			if (need_render)
+				this.__set_page(this.curr_page);
+			return;
+		}
+
+		/* Sort test results newest to oldest */
+		data.sort(function c(a, b) {return b.time - a.time;});
+		for (var testrun of data)
+			testrun.late = testrun.time < late;
+
+		log('processed_items ' + data.length);
+
+		/* Create all UI elements */
+		if (this.pager_div == null) {
+			this.__render_balloons();
+			this.__render_pager();
+			this.__render_statusbar();
+		}
+
+		/* Replace any old dataset with the new dataset */
+		this.mtime = mtime;
+		this.__set_data(data);
+		this.__set_page(this.curr_page);
+		this.__update_statusbar(mtime);
+	}
+}
+
+function loadFstestsAllCtl()
+{
+	/* no need to refresh this more than once per day */
+	var timeout = 86400;
+	if (DEBUG)
+		timeout = 60;
+	app = new FstestsCtl('fstestsall.js.br', './', 'most recent', timeout);
+}
+
+function loadFstestsBotCtl()
+{
+	/* refresh live results every few minutes */
+	var timeout = 180;
+	if (DEBUG)
+		timeout = 60;
+	app = new FstestsCtl('fstestsbot.js', 'all.html', 'full results', timeout);
+}
diff --git a/matrix/dashboard/fstmatrix-dashboard.service.in b/matrix/dashboard/fstmatrix-dashboard.service.in
new file mode 100644
index 00000000000000..13fdda84c24d95
--- /dev/null
+++ b/matrix/dashboard/fstmatrix-dashboard.service.in
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Update fstests Dashboard
+
+[Service]
+User=fstmatrix
+Group=fstmatrix
+PrivateTmp=yes
+Environment=HOME=%fstmatrix_home_dir%/
+Nice=19
+ExecStart=%bin_dir%/every 5m %pkg_libexec_dir%/stow_dashboard %fstmatrix_inst_dir%/database %fstmatrix_inst_dir%/www $URLPREFIX
+
+# Note: Please add a unit override file to define Environment=URLPREFIX=
diff --git a/matrix/dashboard/index.html b/matrix/dashboard/index.html
new file mode 100644
index 00000000000000..52ceb6b8698bb8
--- /dev/null
+++ b/matrix/dashboard/index.html
@@ -0,0 +1,31 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
+<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
+	<head>
+		<!--
+			SPDX-License-Identifier: GPL-2.0-or-later
+			Copyright (C) 2018-2026 Oracle.
+		-->
+		<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
+		<meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
+		<meta name="ROBOTS" content="NOINDEX, NOFOLLOW"/>
+		<link rel="icon" href="x.png"/>
+		<!-- component libraries -->
+		<script type="text/javascript" src="jquery.js"></script>
+		<!-- stuff specific to us -->
+		<link rel="stylesheet" href="fstests.css"/>
+		<link rel="alternate" type="application/atom+xml" href="fstestsbot.rss"/>
+		<script type="text/javascript" src="fstests.js"></script>
+		<script type="text/javascript">
+window.addEventListener("load", function() {loadFstestsBotCtl();}, false);
+		</script>
+		<title>fstests Status</title>
+	</head>
+	<body>
+		<div id="test_status"><div id="loading">Loading...
+		<noscript>
+			or not; this page requires JavaScript. Please enable it.
+		</noscript>
+		</div></div>
+	</body>
+</html>
diff --git a/matrix/dashboard/stow_dashboard.in b/matrix/dashboard/stow_dashboard.in
new file mode 100644
index 00000000000000..85fa724df27da7
--- /dev/null
+++ b/matrix/dashboard/stow_dashboard.in
@@ -0,0 +1,56 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018-2026 Oracle.
+# Generate json file for dashboard from database
+
+dbdir="$1"
+dashdir="$2"
+urlprefix="$3"
+
+# Exit if no database or no url prefix
+test -e "${dbdir}/fstests.db" || exit 0
+test -n "${urlprefix}" || exit 0
+
+# If the database is newer than the output files (if they're missing, -nt
+# returns 0) and more than a day has gone by, generate the bot files
+# Regenerate the -all files if more than a day has gone by since we did that.
+want_generate_all() {
+	local db_mtime js_mtime rss_mtime
+	local spd=$((60 * 60 * 24))	# seconds per day
+
+	db_mtime="$(stat -c '%Y' "${dbdir}/fstests.db" 2>/dev/null)"
+	js_mtime="$(stat -c '%Y' "${dashdir}/fstestsall.js.br" 2>/dev/null)"
+	test -z "${js_mtime}" && js_mtime=0
+	rss_mtime="$(stat -c '%Y' "${dashdir}/fstestsall.rss.br" 2>/dev/null)"
+	test -z "${rss_mtime}" && rss_mtime=0
+
+	test "$(( (js_mtime / spd) ))" -lt "$(( (db_mtime / spd) ))" && return 0
+	test "$(( (rss_mtime / spd) ))" -lt "$(( (db_mtime / spd) ))" && return 0
+
+	return 1
+}
+
+if want_generate_all; then
+	"%pkg_libexec_dir%/query_all_test_runs" \
+		--json "${dashdir}/fstestsall.js" \
+		--rss  "${dashdir}/fstestsall.rss" \
+		--urlprefix "${urlprefix}" \
+		--compress \
+		"${dbdir}"
+fi
+
+# If the database is newer than the output files (if they're missing, -nt
+# returns 0), generate the bot files
+want_generate_bot() {
+	test "${dbdir}/fstests.db" -nt "${dashdir}/fstestsbot.js" && return 0
+	test "${dbdir}/fstests.db" -nt "${dashdir}/fstestsbot.rss" && return 0
+	return 1
+}
+
+if want_generate_bot; then
+	"%pkg_libexec_dir%/query_recent_test_runs" --max-age %bot_age% \
+		--json "${dashdir}/fstestsbot.js" \
+		--rss  "${dashdir}/fstestsbot.rss" \
+		--urlprefix "${urlprefix}" \
+		"${dbdir}"
+fi
diff --git a/matrix/dashboard/x.big.png b/matrix/dashboard/x.big.png
new file mode 100644
index 0000000000000000000000000000000000000000..a22316328fc0f3c83462fc96b7964926ac85048c
GIT binary patch
literal 15189
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

literal 0
HcmV?d00001

diff --git a/matrix/dashboard/x.png b/matrix/dashboard/x.png
new file mode 100644
index 0000000000000000000000000000000000000000..5addc8d7565911f8b0f06e0207c8c4ed7737383c
GIT binary patch
literal 14889
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
bLJIyLVvBj`;iP(100000NkvXXu0mjfj(+d2

literal 0
HcmV?d00001


