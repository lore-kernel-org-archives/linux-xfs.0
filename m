Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7078AC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3BB61A43
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCZAWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhCZAWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6476619F3;
        Fri, 26 Mar 2021 00:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718126;
        bh=esGM0xUAgACj770/bAMJgwSaga6rT5uwVs+5joG4Pic=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GBlFFO8XGhmKEGJ88YaJYlrelG/i8jZwyRLY50grnrQ5YN/uXHmPD6q2LUCDZJZhH
         GmZi+UrJJyhXoTC+LUArVzZ7/q3rsMvMMjyeoGD6zYvXuVPbE0vhV0o5g6CqW1SviO
         72BPgrjsOG4LrYHhvtjZFAhfKSq5gsXmAp1mS3wfpEgbIs8WYsHCIQHFB0UQo6QocH
         YCM5yz72qK/EU+rkiSI64gWpehtt7xA69XwiT7ps2XEZjHn0iC5Lqek37QhphUA6A0
         i1ZyZBEbrC79O2Oo1kIcJCuSABuza1lsKYMAL41HW6Ld4bjzSaHhCiTa1C9UxiiL6j
         mRnwVO4H1t2ZA==
Subject: [PATCH 3/9] xfs: expose sysfs knob to control inode inactivation
 delay
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:05 -0700
Message-ID: <161671812555.622901.16473251954083643080.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow administrators to control the length that we defer inode
inactivation.  By default we'll set the delay to 2 seconds, as an
arbitrary choice between allowing for some batching of a deltree
operation, and not letting too many inodes pile up in memory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    7 +++++++
 fs/xfs/xfs_globals.c              |    3 +++
 fs/xfs/xfs_icache.c               |    3 ++-
 fs/xfs/xfs_linux.h                |    1 +
 fs/xfs/xfs_sysctl.c               |    9 +++++++++
 fs/xfs/xfs_sysctl.h               |    1 +
 6 files changed, 23 insertions(+), 1 deletion(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index f9b109bfc6a6..9dd62b155fda 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -277,6 +277,13 @@ The following sysctls are available for the XFS filesystem:
 	references and returns timed-out AGs back to the free stream
 	pool.
 
+  fs.xfs.inode_gc_delay
+	(Units: centiseconds   Min: 0  Default: 1  Max: 360000)
+	The amount of time to delay cleanup work that happens after a file is
+	closed by all programs.  This involves clearing speculative
+	preallocations from linked files and freeing unlinked files.  A higher
+	value here increases batching at a risk of background work storms.
+
   fs.xfs.speculative_prealloc_lifetime
 	(Units: seconds   Min: 1  Default: 300  Max: 86400)
 	The interval at which the background scanning for inodes
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f62fa652c2fd..8c359b0b8fd3 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -28,6 +28,9 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
+	.inodegc_timer	= {	0,		1,		3600*100},
+
+	/* Values below here are measured in seconds */
 	.blockgc_timer	= {	1,		300,		3600*24},
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 287a1500b9b2..803f1241f867 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -310,7 +310,8 @@ xfs_inodegc_queue(
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+				msecs_to_jiffies(xfs_inodegc_centisecs * 10));
 	rcu_read_unlock();
 }
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 7688663b9773..3d6b0a407d52 100644
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

