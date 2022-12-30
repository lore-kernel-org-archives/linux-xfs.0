Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BE7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbiLaAhK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:37:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046711E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:37:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9547A61CF1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02140C433D2;
        Sat, 31 Dec 2022 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447028;
        bh=CWYkcDjmuCYanAa5NSUJAbgh3lrsl8DtS8Jo2ChSEig=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tahRgNEZkRDlED4X9/lVEqERkDz2neMfjNldbFjNl/A0h/hb+Ni3trlOvWT/Don1p
         vW4WNhBuCBVoUt3c0IYTY3XqJwPsSlQuWQ3ELXvGWxUAnEVZZQobK5+qqIkf/WsPQP
         K6bk4WWmJf3EoO6PqNJ4s0p+Wn9znm96Imom/mYzA/z9F60wt3tm+cuPtRLH6wqPOb
         Cm6n3OZYvshMV2OeX4e0hZAwHsvhmI2JI2QiWTPshOI3Yt458sMoJfEDE74wxJC+e+
         /ApVBhqEm9uyJD6cx71EiIVGhqTIYZ7zpvHWcpzlcDc3HMZasWH3dGqqP4oKTFqit5
         zf2YlLoqBuC6Q==
Subject: [PATCH 5/5] xfs_scrub_all: tighten up the security on the background
 systemd service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:35 -0800
Message-ID: <167243871531.718298.13745628368000596845.stgit@magnolia>
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
index ae4135033dd..c1c6012b47d 100644
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

