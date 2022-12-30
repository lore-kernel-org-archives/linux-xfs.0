Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C40C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiLaAhC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbiLaAgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:36:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C1E1EAC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:36:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10A4E61CF1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D6BC433D2;
        Sat, 31 Dec 2022 00:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447012;
        bh=yYLA/WWglwQAwiwi9u3fDtHGUtZL56FWgE/IomGSDDY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RRkpv4SYOMHNEjXDmdixNzf8lMJLHGfMrzyMeBA+yx6kwifIayZ+Y64cO8MZu2Q6S
         Mxi8o8QLJselOQHKPsYCIF3RV4dz8JL0oIHGhuStwhQo6ji2XdHiZuEVmWzglj9xzR
         gdY6myTrwQVkj5SkjmsiMmVMFPNRAYSkU7ktjif6wRrkV3GLM927KQXgQV0WzcE7qf
         9OLmP3HcRHp6yUcslveVNp4rVJvpxyruNC//FzF6fIB4N5qoEy+obApGsgaDgy+hUI
         3dW+iiXVRrLq6YBto5mj/9Bbi5vSnFba0OAjSbnFk/DE3m91R/4ApX+mw++D+kKUaP
         j87LDIv8+rJzw==
Subject: [PATCH 4/5] xfs_scrub_fail: tighten up the security on the background
 systemd service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:35 -0800
Message-ID: <167243871517.718298.1106619899786924335.stgit@magnolia>
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
index 591486599ce..2c36c47ab02 100644
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

