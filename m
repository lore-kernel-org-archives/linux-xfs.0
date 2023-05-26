Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D6EC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbjEZB4J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZB4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:56:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6322E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C06661295
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC88C433D2;
        Fri, 26 May 2023 01:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066165;
        bh=AqjlPCPeU7qmFfu9vxfwVu913uQgPgmeevrbUnL/xUI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=g8c6KHM22hL6bWvZ+Ul1+uLSv6sT0+xPXMUU6ibRPSnBoLLeQOKzts00pmFA2BIF3
         mowYL27UHOES+I1KJanLy3Bi4R/Rt/fZdtJz5i1AaSZQomHcZh8qixKPToeXZ0J6fN
         WXYVF8f0yVzeaxBp/HT8iKnZyuOBqSdfCB88L3jPMs/LSAPtogX4ZlkvjtrCy/UY2M
         /o3cdkDRexha7GAbjq+GiGSQuMXgyVqobrju5o16S4dWbnq5WBTiaZ1K8e9tLoJJ7a
         DuLLEJIAWqk6Qs1PV4n92axNDFPxJsfwouBhqoW410lPCwwK7mCnz35dpzqHOmc/Cn
         k90qPd4+Nsy7Q==
Date:   Thu, 25 May 2023 18:56:05 -0700
Subject: [PATCH 5/5] xfs_scrub_all: tighten up the security on the background
 systemd service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074576.3746099.17270444986190692969.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_all has to run with enough privileges to find
mounted XFS filesystems and the device associated with that mount and to
start xfs_scrub@<mountpoint> sub-services.  Minimize the risk of
xfs_scrub_all escaping its service container or contaminating the rest
of the system by using systemd's sandboxing controls to prohibit as much
access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub_all.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.service.in |   62 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)


diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 5e598fbed0d..7cd5dd68f28 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -18,3 +18,65 @@ SyslogIdentifier=xfs_scrub_all
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# Run scrub_all with minimal CPU and IO priority so that nothing will starve.
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+CPUAccounting=true
+Nice=19
+
+# No realtime scheduling
+RestrictRealtime=true
+
+# No special privileges, but we still have to run as root so that we can
+# contact the service manager to start the sub-units.
+CapabilityBoundingSet=
+NoNewPrivileges=true
+RestrictSUIDSGID=true
+
+# Make the entire filesystem readonly.  We don't want to hide anything because
+# we need to find all mounted XFS filesystems in the host.
+ProtectSystem=strict
+ProtectHome=read-only
+PrivateTmp=false
+
+# No network access except to the systemd control socket
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=AF_UNIX
+IPAddressDeny=any
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Hide everything in /proc, even /proc/mounts
+ProcSubset=pid
+
+# Only allow the default personality Linux
+LockPersonality=true
+
+# No writable memory pages
+MemoryDenyWriteExecute=true
+
+# Don't let our mounts leak out to the host
+PrivateMounts=true
+
+# Restrict system calls to the native arch and only enough to get things going
+SystemCallArchitectures=native
+SystemCallFilter=@system-service
+SystemCallFilter=~@privileged
+SystemCallFilter=~@resources
+SystemCallFilter=~@mount
+
+# Media scan stamp file shouldn't be readable by regular users
+UMask=0077
+
+# lsblk ignores mountpoints if it can't find the device files, so we cannot
+# hide them
+#ProtectClock=true
+#PrivateDevices=true

