Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8726DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbiLaAgl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6522F12A9B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1908AB80883
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04A8C433EF;
        Sat, 31 Dec 2022 00:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446996;
        bh=xy18g4wuD3ySapQDCLPeEQVkt6IvM8/lkW6E35+ksHE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VVsvtVFEAdxQzOunkCcim5cfcHurvg+hz9rnt+VO2aRlLb41Sf075tMfTrd0USs4V
         itQmr5P9fhMPQ4Eoh4eSUNKVVvdN5iAT7a4DHs3axFcHY0E02jI6LSSZws4Fmokxcy
         8vJY8mByKJrk/SW87QWZJmadzMplPdUgzsNW06hcNfd66oUBOYC5D3nBDUr1oNniHc
         xoWm3g6/kEPidFkFclYFLL1UDTKH4y0I1mbi+T4USXhS8EeikRBb75mJzu7ZKtue+o
         4fL24fZA9kvIOt9UWJtJbfzNBO6Mt4UADRY/wG8faQvmu3Qek+cVqvtnWpK/Dq0UhN
         eK/8ChT5PajYw==
Subject: [PATCH 3/5] xfs_scrub: tighten up the security on the background
 systemd service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:35 -0800
Message-ID: <167243871504.718298.11721955751660856262.stgit@magnolia>
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

Currently, xfs_scrub has to run with some elevated privileges.  Minimize
the risk of xfs_scrub escaping its service container or contaminating
the rest of the system by using systemd's sandboxing controls to
prohibit as much access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub@.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in |   73 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 8 deletions(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 3c64252de49..39af00d4b73 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -10,15 +10,8 @@ Documentation=man:xfs_scrub(8)
 
 [Service]
 Type=oneshot
-PrivateNetwork=true
-ProtectSystem=full
-ProtectHome=read-only
-# Disable private /tmp just in case %i is a path under /tmp.
-PrivateTmp=no
-AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
-NoNewPrivileges=yes
-User=nobody
 Environment=SERVICE_MODE=1
+Environment=SERVICE_MOUNTPOINT=/tmp/scrub
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %I
 SyslogIdentifier=%N
 
@@ -31,3 +24,67 @@ Nice=19
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# Dynamically create a user that isn't root
+DynamicUser=true
+
+# Make the entire filesystem readonly and /home inaccessible, then bind mount
+# the filesystem we're supposed to be checking into our private /tmp dir.
+# 'norbind' means that we don't bind anything under that original mount.
+ProtectSystem=strict
+ProtectHome=yes
+PrivateTmp=true
+BindPaths=/%I:/tmp/scrub:norbind
+
+# Don't let scrub complain about paths in /etc/projects that have been hidden
+# by our sandboxing.  scrub doesn't care about project ids anyway.
+InaccessiblePaths=-/etc/projects
+
+# No network access
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=none
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
+# xfs_scrub needs these privileges to run, and no others
+CapabilityBoundingSet=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
+NoNewPrivileges=true
+
+# xfs_scrub doesn't create files
+UMask=7777
+
+# No access to hardware /dev files except for block devices
+ProtectClock=true
+DevicePolicy=closed
+DeviceAllow=block-*

