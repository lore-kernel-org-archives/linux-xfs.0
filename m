Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CAEC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbjEZBzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZBzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:55:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B99B194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1909E64C45
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792D8C433D2;
        Fri, 26 May 2023 01:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066134;
        bh=3aa9slIZqskLhJm9QwNHFoIHU9JSlZEyzCIR5JE0D8Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QhYAQsx3W1DL3zfI0etwcp9EujG0Q1zHh2oLRgrPi3hG9rsgJyJv7pKF34Q8U97ge
         potsdGUmwn3i4JjXGn5SDCQ0fcvzXdLVUTIFivIf1eu1LCERurMUectypDMA+i21ly
         lkbOx/cyMsPQccR+MqPs7sZ3pENgQFvVDUqkhxDFfxp888UTF6b/0LVB+fJ0/0Kn+m
         6UK68b0urR2SrSVrlj431tIt9emPFrkea7xWfFlP6jkVIdMyYkChj4Q5T8z3qyJKmr
         dOUuInoUl/a5D4Fqgoqn/JH6CJoYYC03yhMNBeXo1v/JuT1z4Al5WfacItDdS5En+0
         bv0s0SLLPOLaQ==
Date:   Thu, 25 May 2023 18:55:34 -0700
Subject: [PATCH 3/5] xfs_scrub: tighten up the security on the background
 systemd service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074549.3746099.6129822996056625257.stgit@frogsfrogsfrogs>
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

Currently, xfs_scrub has to run with some elevated privileges.  Minimize
the risk of xfs_scrub escaping its service container or contaminating
the rest of the system by using systemd's sandboxing controls to
prohibit as much access as possible.

The directives added by this patch were recommended by the command
'systemd-analyze security xfs_scrub@.service' in systemd 249.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in |   78 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 8 deletions(-)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 1fafcfd37f1..e306216bb91 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -7,18 +7,16 @@
 Description=Online XFS Metadata Check for %f
 OnFailure=xfs_scrub_fail@%i.service
 Documentation=man:xfs_scrub(8)
+ConditionCapability=CAP_SYS_ADMIN
+ConditionCapability=CAP_FOWNER
+ConditionCapability=CAP_DAC_OVERRIDE
+ConditionCapability=CAP_DAC_READ_SEARCH
+ConditionCapability=CAP_SYS_RAWIO
 
 [Service]
 Type=oneshot
-PrivateNetwork=true
-ProtectSystem=full
-ProtectHome=read-only
-# Disable private /tmp just in case %f is a path under /tmp.
-PrivateTmp=no
-AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
-NoNewPrivileges=yes
-User=nobody
 Environment=SERVICE_MODE=1
+Environment=SERVICE_MOUNTPOINT=/tmp/scrub
 ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
 SyslogIdentifier=%N
 
@@ -31,3 +29,67 @@ Nice=19
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
+BindPaths=%f:/tmp/scrub:norbind
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

