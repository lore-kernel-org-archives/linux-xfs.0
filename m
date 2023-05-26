Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E20C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbjEZBzx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZBzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:55:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1514E18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F66F64C45
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDC8C433EF;
        Fri, 26 May 2023 01:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066150;
        bh=vTxDmhA97Eap2OBIWg8e1D8iOPPVWpHdpw7QhdBqJkI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MplkQu2BXKOniht1xRWhmDEyRDLT/6HeqJ0qrd7BCep5/PzVoscc7sMw3SEdrAAN9
         doZe5spwFmCPs1u+AbVsn4kwnkGgw7w5voi+zm2MC3+hE/FrKo8K3LUmMrl77/x92H
         yz3Y2xbg6hB0NfQr9t70DGQ1TijAXbM7aV1irMfZjzYaMn6NBrVcPgAbH0oZ096hOs
         N13xGFCD0ikvZhFt3N8/uehPahsjdo45mKNP8ayPJJvTn3ryR0CpRt4a4CT3HyL1eB
         qJx0AwXxUHJ8F9wctls68picq8aJOPcB++EXCajeELStDh4LXMOfefvkJ+zajy2g11
         Ph+VE35lqJp9w==
Date:   Thu, 25 May 2023 18:55:49 -0700
Subject: [PATCH 4/5] xfs_scrub_fail: tighten up the security on the background
 systemd service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074563.3746099.10092807792455987217.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub_fail has to run with enough privileges to access
the journal contents for a given scrub run and to send a report via
email.  Minimize the risk of xfs_scrub_fail escaping its service
container or contaminating the rest of the system by using systemd's
sandboxing controls to prohibit as much access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub_fail@.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail@.service.in |   56 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)


diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 2441832f3e8..7bc1463bf1f 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -18,3 +18,59 @@ SupplementaryGroups=systemd-journal
 # Create the service underneath the scrub background service slice so that we
 # can control resource usage.
 Slice=system-xfs_scrub.slice
+
+# No realtime scheduling
+RestrictRealtime=true
+
+# Make the entire filesystem readonly and /home inaccessible, then bind mount
+# the filesystem we're supposed to be checking into our private /tmp dir.
+ProtectSystem=full
+ProtectHome=yes
+PrivateTmp=true
+RestrictSUIDSGID=true
+
+# Emailing reports requires network access, but not the ability to change the
+# hostname.
+ProtectHostname=true
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+
+# Can't hide /proc because journalctl needs it to find various pieces of log
+# information
+#ProcSubset=pid
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
+CapabilityBoundingSet=
+NoNewPrivileges=true
+
+# Failure reporting shouldn't create world-readable files
+UMask=0077
+
+# Clean up any IPC objects when this unit stops
+RemoveIPC=true
+
+# No access to hardware device files
+PrivateDevices=true
+ProtectClock=true

