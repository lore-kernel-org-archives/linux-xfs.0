Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDBFC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C0B164DC3
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBLVso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhBLVsn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Feb 2021 16:48:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9CE064DC3;
        Fri, 12 Feb 2021 21:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613166482;
        bh=PaEhtZNw/6m7RfukWTZDqlnxa7G2EodoUxUING0NStU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J8oT/3k9IgkSAq2xBQV0ZVFPfuFU91b/TUPk2qZ9yKntGHDRbc/AyeQO3+qYZLpDq
         ac6R6rIHz8pauT8KoSoLofiquK6uuJSDkZqMc+94pbn1IkDm4yVUbaUzZ01fP/y5V/
         9M1j3Z07+vtDUgoFEtFIDHDoSqR+DMUCDGgvPvjbIwvzZt4dtoq3S7B9Y+eVvyko2X
         aGD9agXtrTnI1TfnITd6nbHYLk8zb3QG5rbZK76yx1MKWDUWzhsqUm40vOdlMNelKe
         KFlHxplQn4/W4CS6/FlamI3HlqUiF2r3GPO8GipHv+PcHok48KWzYrdVsV2dLNjpQm
         bhdQOFZp0WoxQ==
Date:   Fri, 12 Feb 2021 13:48:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: restore speculative_cow_prealloc_lifetime sysctl
Message-ID: <20210212214802.GN7193@magnolia>
References: <20210212172436.GK7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212172436.GK7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 9669f51de5c0 I tried to get rid of the undocumented cow gc
lifetime knob.  The knob's function was never documented and it now
doesn't really have a function since eof and cow gc have been
consolidated.

Regrettably, xfs/231 relies on it and regresses on for-next.  I did not
succeed at getting far enough through fstests patch review for the fixup
to land in time.

Restore the sysctl knob, document what it did (does?), put it on the
deprecation schedule, and rip out a redundant function.

Fixes: 9669f51de5c0 ("xfs: consolidate the eofblocks and cowblocks workers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: use printk_ratelimited
---
 Documentation/admin-guide/xfs.rst |    4 ++++
 fs/xfs/xfs_sysctl.c               |   35 ++++++++++++++---------------------
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 6178153d3320..e188d0ea7b5b 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -284,6 +284,9 @@ The following sysctls are available for the XFS filesystem:
 	removes unused preallocation from clean inodes and releases
 	the unused space back to the free pool.
 
+  fs.xfs.speculative_cow_prealloc_lifetime
+	This is an alias for speculative_prealloc_lifetime.
+
   fs.xfs.error_level		(Min: 0  Default: 3  Max: 11)
 	A volume knob for error reporting when internal errors occur.
 	This will generate detailed messages & backtraces for filesystem
@@ -361,6 +364,7 @@ Deprecated Sysctls
 ===========================     ================
 fs.xfs.irix_sgid_inherit        September 2025
 fs.xfs.irix_symlink_mode        September 2025
+fs.xfs.speculative_cow_prealloc_lifetime   September 2025
 ===========================     ================
 
 
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 145e06c47744..546a6cd96729 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -51,7 +51,7 @@ xfs_panic_mask_proc_handler(
 #endif /* CONFIG_PROC_FS */
 
 STATIC int
-xfs_deprecate_irix_sgid_inherit_proc_handler(
+xfs_deprecated_dointvec_minmax(
 	struct ctl_table	*ctl,
 	int			write,
 	void			*buffer,
@@ -59,24 +59,8 @@ xfs_deprecate_irix_sgid_inherit_proc_handler(
 	loff_t			*ppos)
 {
 	if (write) {
-		printk_once(KERN_WARNING
-				"XFS: " "%s sysctl option is deprecated.\n",
-				ctl->procname);
-	}
-	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
-}
-
-STATIC int
-xfs_deprecate_irix_symlink_mode_proc_handler(
-	struct ctl_table	*ctl,
-	int			write,
-	void			*buffer,
-	size_t			*lenp,
-	loff_t			*ppos)
-{
-	if (write) {
-		printk_once(KERN_WARNING
-				"XFS: " "%s sysctl option is deprecated.\n",
+		printk_ratelimited(KERN_WARNING
+				"XFS: %s sysctl option is deprecated.\n",
 				ctl->procname);
 	}
 	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
@@ -88,7 +72,7 @@ static struct ctl_table xfs_table[] = {
 		.data		= &xfs_params.sgid_inherit.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= xfs_deprecate_irix_sgid_inherit_proc_handler,
+		.proc_handler	= xfs_deprecated_dointvec_minmax,
 		.extra1		= &xfs_params.sgid_inherit.min,
 		.extra2		= &xfs_params.sgid_inherit.max
 	},
@@ -97,7 +81,7 @@ static struct ctl_table xfs_table[] = {
 		.data		= &xfs_params.symlink_mode.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= xfs_deprecate_irix_symlink_mode_proc_handler,
+		.proc_handler	= xfs_deprecated_dointvec_minmax,
 		.extra1		= &xfs_params.symlink_mode.min,
 		.extra2		= &xfs_params.symlink_mode.max
 	},
@@ -201,6 +185,15 @@ static struct ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.blockgc_timer.min,
 		.extra2		= &xfs_params.blockgc_timer.max,
 	},
+	{
+		.procname	= "speculative_cow_prealloc_lifetime",
+		.data		= &xfs_params.blockgc_timer.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= xfs_deprecated_dointvec_minmax,
+		.extra1		= &xfs_params.blockgc_timer.min,
+		.extra2		= &xfs_params.blockgc_timer.max,
+	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{
