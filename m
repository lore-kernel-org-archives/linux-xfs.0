Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1643C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjEZBzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZBzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:55:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC31BE7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC5664043
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE313C433D2;
        Fri, 26 May 2023 01:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066118;
        bh=Q0+P/u5mE8QWwZ7yixqLJbX8Kk1ASPuOTT/D2kIo4IA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hyPdnFRHAmdq3XswDoFDon0cQlEl2DReuUQE9R3waIApZfF2nlQxXm5tgZfJ3QK1g
         hAHy04zbvsJ5SaY64V/od+yXsmdTT9b+gixjY75TvC326IbTvJiF0Dq0DSP7zEUDjt
         5VnxAfvxYpR8g74umcKwf1jWpRUYygYcQYeZgb2uZYluFurHh8J2eDEnG0ctodfjyb
         owC35/MiWAWa4vmHtDVhE2rjlKF6iAGsrbUrLkfdIwOAlQ3knHf2AzjKadA7tJEYpi
         K95eTDrS+SM94nzzyvORoYWiCLYjN+oad0TiP3587xKaAaTOcBMxv+xBl+S2aQ9jWp
         ah9QG5dnb5ZCg==
Date:   Thu, 25 May 2023 18:55:18 -0700
Subject: [PATCH 2/5] xfs_scrub.service: reduce CPU usage to 60% when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074536.3746099.6775557055565988745.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
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
index 0cba97dcddc..db2b94feb12 100644
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
index 00000000000..a2f248963bd
--- /dev/null
+++ b/scrub/system-xfs_scrub.slice
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
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
index 81ca2043a82..1fafcfd37f1 100644
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
index c2620781573..5e598fbed0d 100644
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
index 93e06a74410..2441832f3e8 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -14,3 +14,7 @@ ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %f
 User=mail
 Group=mail
 SupplementaryGroups=systemd-journal
+
+# Create the service underneath the scrub background service slice so that we
+# can control resource usage.
+Slice=system-xfs_scrub.slice

