Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926E331D730
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087910; cv=none; b=WQncfbJrYJ3ya3MlbI3FRhD97otAyIj/a5uGJhB9rqR5ZgyXwpov2fp/WXpo8OazERVMwSm8Lz94OcXMcQp+dXbWKECoDgepWDrOSEN8jWHtBGyf0isoCnFyOF3UrS1H1vCuuBRqw8+NviEAPwYA9ltMH5AVx+ilwcnCyIyDSOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087910; c=relaxed/simple;
	bh=CVNjdPHUXtwcgwjHgIwW21r3apjWAxxMbmayvhdOAPs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYxNh5Qg8m0yEOAMZm4veWpzVc1sCDkLet8Zmhtpx2dJFdYhqm5IVztjEi1eKsyo40nuN3P/4q3b3X1eek96dw00PS/fVrWzfhNCKaabYS2lHUfZI4iBpaLerBMFQU9zPzI37bv1xIDZzFey746JlH1hYJsQq8Oby6c+Qxhla6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r5m4w0zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5m4w0zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF81C4CEF1;
	Fri,  5 Sep 2025 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087910;
	bh=CVNjdPHUXtwcgwjHgIwW21r3apjWAxxMbmayvhdOAPs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r5m4w0zwc6/Y2qE7DOImNzFGxabMtRtlPZVxM6qM0po6Kz3930EIEIez9sm2nrl6W
	 izQB+zxS+Z20cQ5TAINpA6w1GxHKNSn3QdZdTCf/64UZ+a9dw6YuCuiJF2LBUzaS9x
	 FiC/Il/8FeXCOU6HQzZ7KhaHGZcrALWlEGLfNRetKbkHcQGRAob0TxVctDcQeTXU47
	 ZaDBPYV8dfyAEdkx3ZO9VmHwrLozxElDIIjuKzOq5PXU/LsjtLpFjEz89Z293/DEcB
	 SHoMwNyJ3MYMdZGd/J4cIpQH5THd/i3JwthrMZU+hX4IavKPzhUcKDsgtYO8cyBBA+
	 SX9p2vtCtIiUA==
Date: Fri, 05 Sep 2025 08:58:29 -0700
Subject: [PATCH 3/4] xfs: remove deprecated sysctl knobs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <175708765549.3402932.16708597847385446983.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765462.3402932.11803651576398863761.stgit@frogsfrogsfrogs>
References: <175708765462.3402932.11803651576398863761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

These sysctl knobs were scheduled for removal in September 2025.  That
time has come, so remove them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_linux.h                |    2 --
 fs/xfs/xfs_sysctl.h               |    3 ---
 Documentation/admin-guide/xfs.rst |   26 ++++----------------------
 fs/xfs/libxfs/xfs_inode_util.c    |   11 -----------
 fs/xfs/xfs_globals.c              |    2 --
 fs/xfs/xfs_iops.c                 |   12 +++++-------
 fs/xfs/xfs_sysctl.c               |   29 +----------------------------
 7 files changed, 10 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9a2221b4aa21ed..4dd747bdbccab2 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -89,8 +89,6 @@ typedef __u32			xfs_nlink_t;
 #undef XFS_NATIVE_HOST
 #endif
 
-#define irix_sgid_inherit	xfs_params.sgid_inherit.val
-#define irix_symlink_mode	xfs_params.symlink_mode.val
 #define xfs_panic_mask		xfs_params.panic_mask.val
 #define xfs_error_level		xfs_params.error_level.val
 #define xfs_syncd_centisecs	xfs_params.syncd_timer.val
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 51646f066c4f7d..ed9d896079c1a8 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -19,9 +19,6 @@ typedef struct xfs_sysctl_val {
 } xfs_sysctl_val_t;
 
 typedef struct xfs_param {
-	xfs_sysctl_val_t sgid_inherit;	/* Inherit S_ISGID if process' GID is
-					 * not a member of parent dir GID. */
-	xfs_sysctl_val_t symlink_mode;	/* Link creat mode affected by umask */
 	xfs_sysctl_val_t panic_mask;	/* bitmask to cause panic on errors. */
 	xfs_sysctl_val_t error_level;	/* Degree of reporting for problems  */
 	xfs_sysctl_val_t syncd_timer;	/* Interval between xfssyncd wakeups */
diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 7ad746a3e66c25..d6f531f2c0e694 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -289,9 +289,6 @@ The following sysctls are available for the XFS filesystem:
 	removes unused preallocation from clean inodes and releases
 	the unused space back to the free pool.
 
-  fs.xfs.speculative_cow_prealloc_lifetime
-	This is an alias for speculative_prealloc_lifetime.
-
   fs.xfs.error_level		(Min: 0  Default: 3  Max: 11)
 	A volume knob for error reporting when internal errors occur.
 	This will generate detailed messages & backtraces for filesystem
@@ -318,17 +315,6 @@ The following sysctls are available for the XFS filesystem:
 
 	This option is intended for debugging only.
 
-  fs.xfs.irix_symlink_mode	(Min: 0  Default: 0  Max: 1)
-	Controls whether symlinks are created with mode 0777 (default)
-	or whether their mode is affected by the umask (irix mode).
-
-  fs.xfs.irix_sgid_inherit	(Min: 0  Default: 0  Max: 1)
-	Controls files created in SGID directories.
-	If the group ID of the new file does not match the effective group
-	ID or one of the supplementary group IDs of the parent dir, the
-	ISGID bit is cleared if the irix_sgid_inherit compatibility sysctl
-	is set.
-
   fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "sync" flag set
 	by the **xfs_io(8)** chattr command on a directory to be
@@ -364,14 +350,7 @@ The following sysctls are available for the XFS filesystem:
 Deprecated Sysctls
 ==================
 
-===========================================     ================
-  Name                                          Removal Schedule
-===========================================     ================
-fs.xfs.irix_sgid_inherit                        September 2025
-fs.xfs.irix_symlink_mode                        September 2025
-fs.xfs.speculative_cow_prealloc_lifetime        September 2025
-===========================================     ================
-
+None currently.
 
 Removed Sysctls
 ===============
@@ -381,6 +360,9 @@ Removed Sysctls
 =============================	=======
   fs.xfs.xfsbufd_centisec	v4.0
   fs.xfs.age_buffer_centisecs	v4.0
+  fs.xfs.irix_symlink_mode      v6.18
+  fs.xfs.irix_sgid_inherit      v6.18
+  fs.xfs.speculative_cow_prealloc_lifetime      v6.18
 =============================	=======
 
 Error handling
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 48fe49a5f050f3..309ce6dd555383 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -299,17 +299,6 @@ xfs_inode_init(
 		} else {
 			inode_init_owner(args->idmap, inode, dir, args->mode);
 		}
-
-		/*
-		 * If the group ID of the new file does not match the effective
-		 * group ID or one of the supplementary group IDs, the S_ISGID
-		 * bit is cleared (and only if the irix_sgid_inherit
-		 * compatibility variable is set).
-		 */
-		if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
-			inode->i_mode &= ~S_ISGID;
-
 		ip->i_projid = xfs_get_initial_prid(pip);
 	}
 
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f6f628c01febaf..566fd663c95bba 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -14,8 +14,6 @@
  */
 xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
-	.sgid_inherit	= {	0,		0,		1	},
-	.symlink_mode	= {	0,		0,		1	},
 	.panic_mask	= {	0,		0,		XFS_PTAG_MASK},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 603effabe1ee12..afd041e28bb26a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -431,14 +431,12 @@ xfs_vn_symlink(
 	struct dentry		*dentry,
 	const char		*symname)
 {
-	struct inode	*inode;
-	struct xfs_inode *cip = NULL;
-	struct xfs_name	name;
-	int		error;
-	umode_t		mode;
+	struct inode		*inode;
+	struct xfs_inode	*cip = NULL;
+	struct xfs_name		name;
+	int			error;
+	umode_t			mode = S_IFLNK | S_IRWXUGO;
 
-	mode = S_IFLNK |
-		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
 	error = xfs_dentry_mode_to_name(&name, dentry, mode);
 	if (unlikely(error))
 		goto out;
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 751dc74a30671a..9918f14b4874fd 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -50,7 +50,7 @@ xfs_panic_mask_proc_handler(
 }
 #endif /* CONFIG_PROC_FS */
 
-STATIC int
+static inline int
 xfs_deprecated_dointvec_minmax(
 	const struct ctl_table	*ctl,
 	int			write,
@@ -67,24 +67,6 @@ xfs_deprecated_dointvec_minmax(
 }
 
 static const struct ctl_table xfs_table[] = {
-	{
-		.procname	= "irix_sgid_inherit",
-		.data		= &xfs_params.sgid_inherit.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= xfs_deprecated_dointvec_minmax,
-		.extra1		= &xfs_params.sgid_inherit.min,
-		.extra2		= &xfs_params.sgid_inherit.max
-	},
-	{
-		.procname	= "irix_symlink_mode",
-		.data		= &xfs_params.symlink_mode.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= xfs_deprecated_dointvec_minmax,
-		.extra1		= &xfs_params.symlink_mode.min,
-		.extra2		= &xfs_params.symlink_mode.max
-	},
 	{
 		.procname	= "panic_mask",
 		.data		= &xfs_params.panic_mask.val,
@@ -185,15 +167,6 @@ static const struct ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.blockgc_timer.min,
 		.extra2		= &xfs_params.blockgc_timer.max,
 	},
-	{
-		.procname	= "speculative_cow_prealloc_lifetime",
-		.data		= &xfs_params.blockgc_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= xfs_deprecated_dointvec_minmax,
-		.extra1		= &xfs_params.blockgc_timer.min,
-		.extra2		= &xfs_params.blockgc_timer.max,
-	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{

