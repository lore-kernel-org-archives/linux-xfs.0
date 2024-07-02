Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BBA2F46
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882313; cv=none; b=B1a5DD6XxcJ0zPg1LC6GShA8wpFIQX4S0dpcWJEJ7qhPN1CjEmXNq7mKaApdQd68xZRnyWQvaOX2djcKHssHnBl08Wjb8TvuBPRDeqbEtqjj/0E+JvnjFv8Mh0IpJQabAPcZWB5i7IeoCK9fzISuitJFWjPmBcamdYQTnGy0WOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882313; c=relaxed/simple;
	bh=yWMZ0LAO779jmvfwNT/un+V1b9ILdbRGI9TVW7T0M7U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jntzfV4V/ob1v23XfBIqUkytVzNvPdfQRVoIkqI4875E/LJ67MTZgKu78g+mji37Hf14QMHtcSp2igodquhugbiGknGz5uIVrjZJJ7S0+3zbn3WdGRAGkoP0xrF57OWfeBNi41jwfNQ31QZT0X+HNLB24WL5wjX9cqX+Yq51OPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0LJmWlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0LJmWlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF2CC4AF0C;
	Tue,  2 Jul 2024 01:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882313;
	bh=yWMZ0LAO779jmvfwNT/un+V1b9ILdbRGI9TVW7T0M7U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b0LJmWlQE3dhY9CkYzwn7/VZUXYL7lcetKHfDZK8oXqX7JF2+7Hw7HuasTbDGfcdK
	 a/022aknqPoTHhqkPrS9kHT6m52ghDZD5XvtX9RzmhMSEeWl4pCsoZbvBZNe9Bpmf1
	 s6MjcrQXpxzn59DEGTRVr+/HU4a8EelGKWbgzAe4BK/L3z2/czvOlcWa2U5lqxTZry
	 T1kgBxDnHWGjR6U+TTNmgegK8NKe+VNs1XdeIvymSXTUmhNzHAZKvaCYuhCD74x5O4
	 /BRvTBjD/30EgAHXUjP2TUz+8tM5lTuUAdE6lEuOlZ0xjiNCJWvNXVYq80D8SAfPFR
	 FlRvGQPSX+mtw==
Date: Mon, 01 Jul 2024 18:05:13 -0700
Subject: [PATCH 2/6] xfs_scrub.service: reduce background CPU usage to less
 than one core if possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119036.2008208.12375299031312294476.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
References: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, the xfs_scrub background service is configured to use -b,
which means that the program runs completely serially.  However, even
using all of one CPU core with idle priority may be enough to cause
thermal throttling and unwanted fan noise on smaller systems (e.g.
laptops) with fast IO systems.

Let's try to avoid this (at least on systemd) by using cgroups to limit
the program's usage to slghtly more than half of one CPU and lowering
the nice priority in the scheduler.  What we /really/ want is to run
steadily on an efficiency core, but there doesn't seem to be a means to
ask the scheduler not to ramp up the CPU frequency for a particular
task.

While we're at it, group the resource limit directives together.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/Makefile                   |    7 ++++++-
 scrub/system-xfs_scrub.slice     |   30 ++++++++++++++++++++++++++++++
 scrub/xfs_scrub@.service.in      |   12 ++++++++++--
 scrub/xfs_scrub_all.service.in   |    4 ++++
 scrub/xfs_scrub_fail@.service.in |    4 ++++
 5 files changed, 54 insertions(+), 3 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice


diff --git a/scrub/Makefile b/scrub/Makefile
index 8ccc67d01df3..2a257e0805cd 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,7 +18,12 @@ XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -b -n
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
-SYSTEMD_SERVICES = $(scrub_svcname) xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
+SYSTEMD_SERVICES=\
+	$(scrub_svcname) \
+	xfs_scrub_fail@.service \
+	xfs_scrub_all.service \
+	xfs_scrub_all.timer \
+	system-xfs_scrub.slice
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
 endif
 ifeq ($(HAVE_CROND),yes)
diff --git a/scrub/system-xfs_scrub.slice b/scrub/system-xfs_scrub.slice
new file mode 100644
index 000000000000..95cd4f74526f
--- /dev/null
+++ b/scrub/system-xfs_scrub.slice
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=xfs_scrub background service slice
+Before=slices.target
+
+[Slice]
+
+# If the CPU usage cgroup controller is available, don't use more than 60% of a
+# single core for all background processes.
+CPUQuota=60%
+CPUAccounting=true
+
+[Install]
+# As of systemd 249, the systemd cgroupv2 configuration code will drop resource
+# controllers from the root and system.slice cgroups at startup if it doesn't
+# find any direct dependencies that require a given controller.  Newly
+# activated units with resource control directives are created under the system
+# slice but do not cause a reconfiguration of the slice's resource controllers.
+# Hence we cannot put CPUQuota= into the xfs_scrub service units directly.
+#
+# For the CPUQuota directive to have any effect, we must therefore create an
+# explicit definition file for the slice that systemd creates to contain the
+# xfs_scrub instance units (e.g. xfs_scrub@.service) and we must configure this
+# slice as a dependency of the system slice to establish the direct dependency
+# relation.
+WantedBy=system.slice
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 05e5293ee1ac..855fe4de4dcf 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -18,8 +18,16 @@ PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
 User=nobody
-IOSchedulingClass=idle
-CPUSchedulingPolicy=idle
 Environment=SERVICE_MODE=1
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
 SyslogIdentifier=%N
+
+# Run scrub with minimal CPU and IO priority so that nothing else will starve.
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+CPUAccounting=true
+Nice=19
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 347cd6e66228..96be90e74ee6 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -14,3 +14,7 @@ Type=oneshot
 Environment=SERVICE_MODE=1
 ExecStart=@sbindir@/xfs_scrub_all
 SyslogIdentifier=xfs_scrub_all
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 96a2ed5da31e..32012ec35366 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -14,3 +14,7 @@ ExecStart=@pkg_libexec_dir@/xfs_scrub_fail "${EMAIL_ADDR}" %f
 User=mail
 Group=mail
 SupplementaryGroups=systemd-journal
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice

