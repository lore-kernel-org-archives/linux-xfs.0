Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC35C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiLaAg0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:36:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF5112A9B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B643CB81DCF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502E9C433EF;
        Sat, 31 Dec 2022 00:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446981;
        bh=O3uUCjKJzQlH10kn+DlvqbqN7inSc81HH1d2Xt9Rer4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Uut3/c9ppS0ukw3TDWmZRX/ZNw4+NYNZaIt2tM2uMG89O8vYqlemWw5O6OzKLYs7G
         K3ZTpbpXHqDvk7+VFw7Y2Q9DpuTmpJ1ihb1obCYO3ZDUJkseV9b0r832AcVxIijttp
         Ch3A8v6nSqlg/Av+XASD/614O5S7adKRqpxsysmB/AX9h3uBZvuj3BErJ4TrwABCAC
         K/czqvWSAe+nGoT1urSWJ5aLf8kudmXmN2mgTisDGWQw7Z2is5H4sVICsZKE0Ds0jB
         BmJpX8RAI1ohbqvzW0E3MZiQwhU1jUpm9WBAFlQ+KcaYHF2eaSWJKW4gcAw4Pdd6QZ
         E02QRyIqTsqaQ==
Subject: [PATCH 2/5] xfs_scrub.service: reduce CPU usage to 60% when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871491.718298.15672577969573659238.stgit@magnolia>
In-Reply-To: <167243871464.718298.4729609315819255063.stgit@magnolia>
References: <167243871464.718298.4729609315819255063.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the xfs_scrub background service is configured to use -b,
which means that the program runs completely serially.  However, even
using 100% of one CPU with idle priority may be enough to cause thermal
throttling and unwanted fan noise on smaller systems (e.g. laptops) with
fast IO systems.

Let's try to avoid this (at least on systemd) by using cgroups to limit
the program's usage to 60% of one CPU and lowering the nice priority in
the scheduler.  What we /really/ want is to run steadily on an
efficiency core, but there doesn't seem to be a means to ask the
scheduler not to ramp up the CPU frequency for a particular task.

While we're at it, group the resource limit directives together.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                   |    7 ++++++-
 scrub/system-xfs_scrub.slice     |   30 ++++++++++++++++++++++++++++++
 scrub/xfs_scrub@.service.in      |   12 ++++++++++--
 scrub/xfs_scrub_all.service.in   |    4 ++++
 scrub/xfs_scrub_fail@.service.in |    4 ++++
 5 files changed, 54 insertions(+), 3 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice


diff --git a/scrub/Makefile b/scrub/Makefile
index 2dc0fe1935c..1c36621b400 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -15,7 +15,12 @@ XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_ARGS = -b -n
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
-SYSTEMD_SERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
+SYSTEMD_SERVICES=\
+	xfs_scrub@.service \
+	xfs_scrub_fail@.service \
+	xfs_scrub_all.service \
+	xfs_scrub_all.timer \
+	system-xfs_scrub.slice
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
 endif
 ifeq ($(HAVE_CROND),yes)
diff --git a/scrub/system-xfs_scrub.slice b/scrub/system-xfs_scrub.slice
new file mode 100644
index 00000000000..051cbb14108
--- /dev/null
+++ b/scrub/system-xfs_scrub.slice
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022 Oracle.  All Rights Reserved.
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
index c8662fc85a6..3c64252de49 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -18,8 +18,16 @@ PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
 User=nobody
-IOSchedulingClass=idle
-CPUSchedulingPolicy=idle
 Environment=SERVICE_MODE=1
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %I
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
index b874eb6f757..ae4135033dd 100644
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
index ac0cb2e283b..591486599ce 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -14,3 +14,7 @@ ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %I
 User=mail
 Group=mail
 SupplementaryGroups=systemd-journal
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice

