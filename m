Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CEEC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06C9260249
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhG2Sol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhG2Sol (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F150460F4B;
        Thu, 29 Jul 2021 18:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584278;
        bh=tC6OU5s8507E2zw9sdddpGx+mlgIrFfckK7XqinTn2s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eNikYDVZLtyVw4mcd04zr1KEJj82A6LNK1U1A8rAavLipgrilM5Pyw9hP2UwADGUd
         6wDsP7dsfNGDj0u0si8yqUuI4kXuv276iYDo1eMcPBXYtIx4QAcF0kOA3iEmg/DF/Y
         gUhuvNJymyAkXgS6qY970OeITWdLrnqIbn3NKAgNlFTNNpkCoFGxcpqcXyKKLjJIfq
         E8gCPkdojjctHccIPtw+QxNw126WTOS0vyP9DPCyVsEcTSvoLlU5vI0BFrsUIZEF3m
         4mGTpW6ijiO3lEcRNeqhNShNZLFPqXktmSr1i54hX1cIP7s3KIVbfwdsxLOasjXu/P
         +HNwLrO5g4b6Q==
Subject: [PATCH 08/20] xfs: expose sysfs knob to control inode inactivation
 delay
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:37 -0700
Message-ID: <162758427769.332903.2425925308388258381.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow administrators to control the length that we defer inode
inactivation.  By default we'll set the delay to 5 seconds, as an
arbitrary choice between allowing for some batching of a deltree
operation, and not letting too many inodes pile up in memory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    7 +++++++
 fs/xfs/xfs_globals.c              |    5 +++++
 fs/xfs/xfs_icache.c               |    6 +++++-
 fs/xfs/xfs_linux.h                |    1 +
 fs/xfs/xfs_sysctl.c               |    9 +++++++++
 fs/xfs/xfs_sysctl.h               |    1 +
 6 files changed, 28 insertions(+), 1 deletion(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index f9b109bfc6a6..11d3103890dc 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -277,6 +277,13 @@ The following sysctls are available for the XFS filesystem:
 	references and returns timed-out AGs back to the free stream
 	pool.
 
+  fs.xfs.inode_gc_delay_ms
+	(Units: milliseconds   Min: 0  Default: 2000  Max: 3600000)
+	The amount of time to delay cleanup work that happens after a file is
+	closed by all programs.  This involves clearing speculative
+	preallocations from linked files and freeing unlinked files.  A higher
+	value here increases batching at a risk of background work storms.
+
   fs.xfs.speculative_prealloc_lifetime
 	(Units: seconds   Min: 1  Default: 300  Max: 86400)
 	The interval at which the background scanning for inodes
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f62fa652c2fd..e81f3a39bebc 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -28,6 +28,11 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
+
+	/* Values below here are measured in milliseconds */
+	.inodegc_ms	= {	0,		5000,		3600*1000},
+
+	/* Values below here are measured in seconds */
 	.blockgc_timer	= {	1,		300,		3600*24},
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e0803544ea19..69f7fb048116 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -221,8 +221,12 @@ xfs_gc_delay_ms(
 	struct xfs_mount	*mp,
 	unsigned int		tag)
 {
+	unsigned int		default_ms;
+
 	switch (tag) {
 	case XFS_ICI_INODEGC_TAG:
+		default_ms = xfs_inodegc_ms;
+
 		/* If we're in a shrinker, kick off the worker immediately. */
 		if (current->reclaim_state != NULL) {
 			trace_xfs_inodegc_delay_mempressure(mp,
@@ -235,7 +239,7 @@ xfs_gc_delay_ms(
 		return 0;
 	}
 
-	return 0;
+	return default_ms;
 }
 
 /*
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c174262a074e..89bafcce3579 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -99,6 +99,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
 #define xfs_blockgc_secs	xfs_params.blockgc_timer.val
+#define xfs_inodegc_ms		xfs_params.inodegc_ms.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_set_flags_nested(sp, f)		\
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 546a6cd96729..6495887f4f00 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -176,6 +176,15 @@ static struct ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
+	{
+		.procname	= "inode_gc_delay_ms",
+		.data		= &xfs_params.inodegc_ms.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inodegc_ms.min,
+		.extra2		= &xfs_params.inodegc_ms.max
+	},
 	{
 		.procname	= "speculative_prealloc_lifetime",
 		.data		= &xfs_params.blockgc_timer.val,
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 7692e76ead33..9a867b379a1f 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -36,6 +36,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
 	xfs_sysctl_val_t blockgc_timer;	/* Interval between blockgc scans */
+	xfs_sysctl_val_t inodegc_ms;	/* Inode inactivation scan interval */
 } xfs_param_t;
 
 /*

