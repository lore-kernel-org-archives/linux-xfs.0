Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B533C819C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589977; cv=none; b=QS8HHmSneeMXpxntFBTtbJ96DtIsIhh3VH9nfmGLUtOPWvD3kaPeIkDrXVIAz2JsAvvJm/pXOIZG1LvSPnxNFKNK1EWdjWS98BQ6xmrlrUbM6+hV88Yc/hsFAYOM/rhq5rKgTLoa1csuW8pMnEc+DEwcDi33gvb43Eld7htM+1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589977; c=relaxed/simple;
	bh=xBMTI2N3+B5T9Kz5qhnzG3lhBx+/I39whAKZcGMvZXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIWGQMHaupVFWjbab7IknteWGXiCGJMZuKLrGox87UROkO0DS+e4AXsua1KSYgylGmkNZAjVe04qugt1gQecPhXdAvgRT6dLWKnDWmF5vBMI5gNkovRFNoaWgvIpronWLTCThBT2WxjDH2uYZimbN3lNwUcgQU7Rr8L5ssjFFY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jmf6R/le; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jmf6R/le"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B96201F000FF;
	Fri,  9 Oct 2026 23:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589975;
	bh=tZyoJNnJzzD167A0sJmsAeDGP7wEa4koeR2B4elM/+A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Jmf6R/lezESJ/WWJFnGlvDSNxcESa6ciDQeMkpOmP0MsvmscbFNXqgz7qF2OKs3Ss
	 hQi93b+f0zcpGNtuWU/2iFwxgAkAypVUxrXB/H5PmALNjbQJAjC3jvabJNLCKkoygk
	 HO44BLEC+ZuQc27UqAXPRnn5tZ5zYyr25DWlQYiURTb0Apm4zyaHO7S3F/hKhJoNdA
	 bTQxU2rMLxc1snKbNVwqJ7C1hMg3ulfSBkdizo8Qoh/zQhIS2ew6p9LQrVg2MTbCHs
	 bLQJ04cOV+Qhq3zPTnUr7W4jwVjvg6WtnUONSRsbQv/aMLHVYay20tY3CG3RmtkILV
	 6ApNvMHJtP/+g==
Date: Fri, 09 Oct 2026 16:52:55 -0700
Subject: [PATCH 2/2] quotactl: deploy typechecked helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948078.3720791.2234654108960438102.stgit@frogsfrogsfrogs>
In-Reply-To: <179158948034.3720791.6624320009127284341.stgit@frogsfrogsfrogs>
References: <179158948034.3720791.6624320009127284341.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create some type-checked helpers because void pointer arguments are
nasty.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/quotactl.h |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 quota/edit.c       |   10 ++++-----
 quota/free.c       |    6 +++--
 quota/path.c       |    2 +-
 quota/quota.c      |    4 ++-
 quota/report.c     |   22 +++++++------------
 quota/state.c      |   12 +++++-----
 spaceman/info.c    |    2 +-
 8 files changed, 86 insertions(+), 32 deletions(-)


diff --git a/libfrog/quotactl.h b/libfrog/quotactl.h
index 9df9327402726d..bef54d0fa1261f 100644
--- a/libfrog/quotactl.h
+++ b/libfrog/quotactl.h
@@ -23,8 +23,68 @@ enum xfs_quota_cmd {
 int xfsquotactl(int mnt_fd, const char *device, enum xfs_quota_cmd xcommand,
 		unsigned int xtype, unsigned int id, void *addr);
 
+static inline int xfssetqlim(const char *device, uint xtype, uint id,
+		struct fs_disk_quota *addr)
+{
+	return xfsquotactl(-1, device, XFS_SETQLIM, xtype, id, addr);
+}
+
 struct fs_path;
 int xfrog_quotactl(const struct fs_path *mount, enum xfs_quota_cmd xcommand,
 		uint xtype, uint id, void *addr);
 
+static inline int xfrog_getquota(const struct fs_path *mount, uint xtype,
+		uint id, struct fs_disk_quota *addr)
+{
+	return xfrog_quotactl(mount, XFS_GETQUOTA, xtype, id, addr);
+}
+
+static inline int xfrog_getnextquota(const struct fs_path *mount, uint xtype,
+		uint id, struct fs_disk_quota *addr)
+{
+	return xfrog_quotactl(mount, XFS_GETNEXTQUOTA, xtype, id, addr);
+}
+
+static inline int xfrog_setqlim(const struct fs_path *mount, uint xtype,
+		uint id, struct fs_disk_quota *addr)
+{
+	return xfrog_quotactl(mount, XFS_SETQLIM, xtype, id, addr);
+}
+
+static inline int xfrog_getqstat(const struct fs_path *mount, uint xtype,
+		uint id, struct fs_quota_stat *addr)
+{
+	return xfrog_quotactl(mount, XFS_GETQSTAT, xtype, id, addr);
+}
+
+static inline int xfrog_getqstatv(const struct fs_path *mount, uint xtype,
+		uint id, struct fs_quota_statv *addr)
+{
+	return xfrog_quotactl(mount, XFS_GETQSTATV, xtype, id, addr);
+}
+
+static inline int xfrog_qsync(const struct fs_path *mount, uint xtype,
+		uint id)
+{
+	return xfrog_quotactl(mount, XFS_QSYNC, xtype, id, NULL);
+}
+
+static inline int xfrog_quotaon(const struct fs_path *mount, uint xtype,
+		uint id, uint *qflags)
+{
+	return xfrog_quotactl(mount, XFS_QUOTAON, xtype, id, qflags);
+}
+
+static inline int xfrog_quotaoff(const struct fs_path *mount, uint xtype,
+		uint id, uint *qflags)
+{
+	return xfrog_quotactl(mount, XFS_QUOTAOFF, xtype, id, qflags);
+}
+
+static inline int xfrog_quotarm(const struct fs_path *mount, uint xtype,
+		uint id, uint *type)
+{
+	return xfrog_quotactl(mount, XFS_QUOTARM, xtype, id, type);
+}
+
 #endif /* LIBFROG_QUOTACTL_H_ */
diff --git a/quota/edit.c b/quota/edit.c
index 3cd88acc177c37..d0af0fac8fd4ba 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -289,7 +289,7 @@ limit_f(
 		.d_rtb_softlimit	= rtbsoft,
 	};
 
-	c = xfrog_quotactl(fs_path, XFS_SETQLIM, type, id, &d);
+	c = xfrog_setqlim(fs_path, type, id, &d);
 	if (c < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set limits: %s\n"),
@@ -352,7 +352,7 @@ restore_file(
 				.d_rtb_hardlimit	= rtbhard,
 				.d_rtb_softlimit	= rtbsoft,
 			};
-			int ret = xfsquotactl(-1, dev, XFS_SETQLIM, type, id, &d);
+			int ret = xfssetqlim(dev, type, id, &d);
 
 			if (ret < 0) {
 				exitcode = 1;
@@ -487,7 +487,7 @@ set_timer(
 		time_t	now;
 
 		/* Get quota to find out whether user is past soft limits */
-		ret = xfrog_quotactl(mount, XFS_GETQUOTA, type, id, &d);
+		ret = xfrog_getquota(mount, type, id, &d);
 		if (ret < 0) {
 			exitcode = 1;
 			fprintf(stderr, _("%s: cannot get quota: %s\n"),
@@ -520,7 +520,7 @@ set_timer(
 	d.d_id = id;
 	encode_timers(&d, btimer, itimer, rtbtimer);
 
-	ret = xfrog_quotactl(mount, XFS_SETQLIM, type, id, &d);
+	ret = xfrog_setqlim(fs_path, type, id, &d);
 	if (ret < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set timer: %s\n"),
@@ -629,7 +629,7 @@ set_warnings(
 	d.d_bwarns = value;
 	d.d_rtbwarns = value;
 
-	ret = xfrog_quotactl(mount, XFS_SETQLIM, type, id, &d);
+	ret = xfrog_setqlim(mount, type, id, &d);
 	if (ret < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set warnings: %s\n"),
diff --git a/quota/free.c b/quota/free.c
index 5793885c44fd1e..2cddfb61c0e8fe 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -139,7 +139,7 @@ projects_free_space_data(
 	int			fd;
 	int			ret;
 
-	ret = xfrog_quotactl(path, XFS_GETQSTAT, type, 0, &qfs);
+	ret = xfrog_getqstat(path, type, 0, &qfs);
 	if (ret < 0 || !(qfs.qs_flags & XFS_QUOTA_PDQ_ACCT))
 		return 0;
 
@@ -174,8 +174,8 @@ projects_free_space_data(
 		return 0;
 	}
 
-	xfrog_quotactl(path, XFS_QSYNC, type, fsx.fsx_projid, NULL);
-	ret = xfrog_quotactl(path, XFS_GETQUOTA, type, fsx.fsx_projid, &d);
+	xfrog_qsync(path, type, fsx.fsx_projid);
+	ret = xfrog_getquota(path, type, fsx.fsx_projid, &d);
 	if (ret < 0) {
 		perror("XFS_GETQUOTA");
 		close(fd);
diff --git a/quota/path.c b/quota/path.c
index 4654f1553c65e0..d4d0518a46933f 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -39,7 +39,7 @@ printpath(
 		if (prj)
 			printf(_(", %s"), prj->pr_name);
 		printf(")");
-	} else if (xfrog_quotactl(path, XFS_GETQSTAT, 0, 0, &qstat) == 0 &&
+	} else if (xfrog_getqstat(path, 0, 0, &qstat) == 0 &&
 			qstat.qs_flags) {
 		c = 0;
 		printf(" (");
diff --git a/quota/quota.c b/quota/quota.c
index e1dfad62b9d762..462f11cd54279b 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -55,8 +55,8 @@ quota_mount(
 	int		count;
 	int		ret;
 
-	xfrog_quotactl(mount, XFS_QSYNC, type, id, NULL);
-	ret = xfrog_quotactl(mount, XFS_GETQUOTA, type, id, &d);
+	xfrog_qsync(mount, type, id);
+	ret = xfrog_getquota(mount, type, id, &d);
 	if (ret < 0)
 		return 0;
 
diff --git a/quota/report.c b/quota/report.c
index 86eaa50f84c20b..5a76f7eed82305 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -67,19 +67,16 @@ get_dquot(
 	const struct fs_path	*mount,
 	int			flags)
 {
-	int			cmd;
 	int			ret;
 
-	if (flags & GETNEXTQUOTA_FLAG)
-		cmd = XFS_GETNEXTQUOTA;
-	else
-		cmd = XFS_GETQUOTA;
-
 	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
-	ret = xfrog_quotactl(mount, cmd, type, id, d);
+	if (flags & GETNEXTQUOTA_FLAG)
+		ret = xfrog_getnextquota(mount, type, id, d);
+	else
+		ret = xfrog_getquota(mount, type, id, d);
 	if (ret < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
-		    cmd == XFS_GETQUOTA)
+		    !(flags & GETNEXTQUOTA_FLAG))
 			perror("XFS_GETQUOTA");
 		return 0;
 	}
@@ -610,8 +607,7 @@ report_any_type(
 		while ((mount = fs_cursor_next_entry(&cursor))) {
 			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
 				continue;
-			ret = xfrog_quotactl(mount, XFS_QSYNC, XFS_USER_QUOTA,
-					0, NULL);
+			ret = xfrog_qsync(mount, XFS_USER_QUOTA, 0);
 			if (ret < 0 && errno != ENOENT && errno != ENOSYS)
 				perror("XFS_QSYNC user quota");
 			report_user_mount(fp, form, mount,
@@ -623,8 +619,7 @@ report_any_type(
 		while ((mount = fs_cursor_next_entry(&cursor))) {
 			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
 				continue;
-			ret = xfrog_quotactl(mount, XFS_QSYNC, XFS_GROUP_QUOTA,
-					0, NULL);
+			ret = xfrog_qsync(mount, XFS_GROUP_QUOTA, 0);
 			if (ret < 0 && errno != ENOENT && errno != ENOSYS)
 				perror("XFS_QSYNC group quota");
 			report_group_mount(fp, form, mount,
@@ -636,8 +631,7 @@ report_any_type(
 		while ((mount = fs_cursor_next_entry(&cursor))) {
 			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
 				continue;
-			ret = xfrog_quotactl(mount, XFS_QSYNC, XFS_PROJ_QUOTA,
-					0, NULL);
+			ret = xfrog_qsync(mount, XFS_PROJ_QUOTA, 0);
 			if (ret < 0 && errno != ENOENT && errno != ENOSYS)
 				perror("XFS_QSYNC proj quota");
 			report_project_mount(fp, form, mount,
diff --git a/quota/state.c b/quota/state.c
index 239b513125518d..5136b72bc60caf 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -204,9 +204,9 @@ state_quotafile_stat(
 	char			*dev = mount->fs_name;
 	int			ret;
 
-	ret = xfrog_quotactl(mount, XFS_GETQSTATV, type, 0, sv);
+	ret = xfrog_getqstatv(mount, type, 0, sv);
 	if (ret < 0) {
-		ret = xfrog_quotactl(mount, XFS_GETQSTAT, type, 0, s);
+		ret = xfrog_getqstat(mount, type, 0, s);
 		if (ret < 0) {
 			if (flags & VERBOSE_FLAG)
 				fprintf(fp,
@@ -362,7 +362,7 @@ enable_enforcement(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	ret = xfrog_quotactl(mount, XFS_QUOTAON, type, 0, &qflags);
+	ret = xfrog_quotaon(mount, type, 0, &qflags);
 	if (ret < 0) {
 		if (errno == EEXIST)
 			fprintf(stderr,
@@ -393,7 +393,7 @@ disable_enforcement(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	ret = xfrog_quotactl(mount, XFS_QUOTAOFF, type, 0, &qflags);
+	ret = xfrog_quotaoff(mount, type, 0, &qflags);
 	if (ret < 0) {
 		if (errno == EEXIST)
 			fprintf(stderr,
@@ -424,7 +424,7 @@ quotaoff(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	ret = xfrog_quotactl(mount, XFS_QUOTAOFF, type, 0, &qflags);
+	ret = xfrog_quotaoff(mount, type, 0, &qflags);
 	if (ret) {
 		if (errno == EEXIST || errno == ENOSYS)
 			fprintf(stderr, _("Quota already off.\n"));
@@ -442,7 +442,7 @@ remove_qtype_extents(
 {
 	int			error;
 
-	error = xfrog_quotactl(mount, XFS_QUOTARM, type, 0, &type);
+	error = xfrog_quotarm(mount, type, 0, &type);
 	if (error < 0)
 		perror("XFS_QUOTARM");
 	return error;
diff --git a/spaceman/info.c b/spaceman/info.c
index ab43f34ccbba2d..e1753e96126b5a 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -125,7 +125,7 @@ get_qflags(
 	*qflags = 0;
 
 	/* GETQSTAT returns qflags for all quota types, not just user */
-	ret = xfrog_quotactl(mount, XFS_GETQSTAT, XFS_USER_QUOTA, 0, &qstat);
+	ret = xfrog_getqstat(mount, XFS_USER_QUOTA, 0, &qstat);
 	if (ret) {
 		/*
 		 * ENOSYS means quota is not enabled or compiled in; ENODEV

