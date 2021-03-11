Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4763BC43332
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB2E64FCE
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhCKDGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhCKDGU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD9B464FC4;
        Thu, 11 Mar 2021 03:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431979;
        bh=i4dmjEdoS7xy4Ki0UaA2HJNEhsRGN/N/3/8XRDW2frY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i8qYy1oA/jvAto2S22YG/yfSHQz+vf1qfhDyhAKUNmd8o4lf6wXhMw3Qz83LULNoF
         crna4rdkSyWg/2vS4rSu/qHfAhhJ/6Q6eChw96oE3lAqC/xgoUJ53pu35vuLWrSNKM
         p0Xi0oh71eGLAGJwdnHKbORM38si1dp/vEZbngXhkbMr3DkgxXo/3DrsOEtGXRLF0z
         xN2XD2HcoHNE1Cz28qNI6WZYb5y4eWQIM3jt00lEi3WpN12RTxCU5FnirbSMlpJrIY
         XU8Jl2+iOMct0etaVoIpTfTfhEfxC3Q1leuPxwv09JgMqaOYWpZ0rskTnizRfujifg
         3CwLKfnP5e2kQ==
Subject: [PATCH 07/11] xfs: expose sysfs knob to control inode inactivation
 delay
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:19 -0800
Message-ID: <161543197945.1947934.7946093923141335693.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
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
 Documentation/admin-guide/xfs.rst |    9 +++++++++
 fs/xfs/xfs_globals.c              |    3 +++
 fs/xfs/xfs_icache.c               |    2 +-
 fs/xfs/xfs_linux.h                |    1 +
 fs/xfs/xfs_sysctl.c               |    9 +++++++++
 fs/xfs/xfs_sysctl.h               |    1 +
 6 files changed, 24 insertions(+), 1 deletion(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index f9b109bfc6a6..608d0ba7a86e 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -277,6 +277,15 @@ The following sysctls are available for the XFS filesystem:
 	references and returns timed-out AGs back to the free stream
 	pool.
 
+  fs.xfs.inode_gc_delay
+	(Units: centiseconds   Min: 1  Default: 200  Max: 360000)
+	The amount of time to delay garbage collection of inodes that
+	have been closed or have been unlinked from the directory tree.
+	Garbage collection here means clearing speculative preallocations
+	from linked files and freeing unlinked inodes.  A higher value
+	here enables more batching at a cost of delayed reclamation of
+	incore inodes.
+
   fs.xfs.speculative_prealloc_lifetime
 	(Units: seconds   Min: 1  Default: 300  Max: 86400)
 	The interval at which the background scanning for inodes
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f62fa652c2fd..2945c2c54cf0 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -28,6 +28,9 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
+	.inodegc_timer	= {	1,		2*100,		3600*100},
+
+	/* Values below here are measured in seconds */
 	.blockgc_timer	= {	1,		300,		3600*24},
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1b7652af5ee5..6081bba3c6ce 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -250,7 +250,7 @@ xfs_inodegc_queue(
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INACTIVE_TAG))
 		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
-				2 * HZ);
+				msecs_to_jiffies(xfs_inodegc_centisecs * 10));
 	rcu_read_unlock();
 }
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index af6be9b9ccdf..b4c5a2c71f43 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -99,6 +99,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
 #define xfs_blockgc_secs	xfs_params.blockgc_timer.val
+#define xfs_inodegc_centisecs	xfs_params.inodegc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_set_flags_nested(sp, f)		\
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 546a6cd96729..878f31d3a587 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -176,6 +176,15 @@ static struct ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
+	{
+		.procname	= "inode_gc_delay",
+		.data		= &xfs_params.inodegc_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.inodegc_timer.min,
+		.extra2		= &xfs_params.inodegc_timer.max
+	},
 	{
 		.procname	= "speculative_prealloc_lifetime",
 		.data		= &xfs_params.blockgc_timer.val,
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 7692e76ead33..a045c33c3d30 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -36,6 +36,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
 	xfs_sysctl_val_t blockgc_timer;	/* Interval between blockgc scans */
+	xfs_sysctl_val_t inodegc_timer;	/* Inode inactivation scan interval */
 } xfs_param_t;
 
 /*

