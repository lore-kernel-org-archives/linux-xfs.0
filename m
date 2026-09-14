Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EB837F8DC
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365048; cv=none; b=TCCqpzXbbCFZD/JB60+6eCWTojQsmX2qBDO25hb3u+d7yH4uvSL+FzTkSoBpzq+ZF0aQKDmQftU+DD0eTWJVBIzgndZfB9oHqKGi6ISx26HM+5JqROP2MXFfRAbPx2eb1ouKjVAojTqtvq1Qvg/83KwvxwvznZDXflaVG50yi0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365048; c=relaxed/simple;
	bh=I8rrLnd3vjtoG5IyKKwHMxNY70VazVVgwokkXzQcGOM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YoftJ0+PIXx6JSMvdgg3e5oe/DWO7IuS2E8hUaOggnfRZynrVqFd4AGPILMqUZfb9Cs425yrIE3VlPqS73Kg9WlUnC6fvajz2ez+Rq1GBr/q+Q5xUpFB44fauu8TwUN9CxCpUKKlP6rLYaiBbWOdMf5jtDQ2Ee7580+C290H18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoSMgA/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoSMgA/r"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DDBDE1F000FF;
	Mon, 14 Sep 2026 05:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365038;
	bh=XkkfiMxSAhCjdZ7mQC2gsxhq8tDHHKfyaPcjE6Z3i40=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WoSMgA/rUwKAY9SSlFfsP/6Mzd6EWMFfkDceteWovlK6MPp0DyeCHLvnaP6dt3KeE
	 T4w6lEYlH+ftGrpl/VyErF8T3rBzjQMjhJqQa0FDZu+l36pj6uBH9xOjanApCLMZ7l
	 rprUG3qBOn+yCTxQ01R1+Z4eERsqCtPTLOSHWecASwvUE8lNgua8JAYTXcaEqmqVC4
	 6TWWGSZnGAP0v1E2w5jhiOHwzgb6Fm/DPg//DrLxbwchh+h3h45bIssYqVBS7ReORi
	 OuXiyjXNsA8s7LG4wbKp3c6/iP2J8eYYiWI/1Ca9AGs6/8uxMEcMFzZ6d12AojbrwP
	 FP7h66/53idxw==
Date: Sun, 13 Sep 2026 22:50:37 -0700
Subject: [PATCH 4/7] libfrog: try to pass struct fs_path objects to quotactl
 wrapper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484880.2108717.3928521689854404034.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're going to adapt xfs_quota to use quotactl_fd(), so to prepare for
that, we need to pass fs_path pointers as deep into the stack as we can
so that xfs_quota can open the associated mountpoint(s) and stash the
fds in the fs_path objects; and then pass that to our quotactl wrapper.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/quotactl.h |    4 +++
 libfrog/quotactl.c |   12 ++++++++++
 quota/edit.c       |   29 ++++++++++++++-----------
 quota/free.c       |   11 +++++----
 quota/path.c       |    4 ++-
 quota/quota.c      |    6 +++--
 quota/report.c     |   61 ++++++++++++++++++++++++++--------------------------
 quota/state.c      |   38 +++++++++++++++++++-------------
 8 files changed, 97 insertions(+), 68 deletions(-)


diff --git a/libfrog/quotactl.h b/libfrog/quotactl.h
index 5e351d53bb4b1e..dae03b787b7663 100644
--- a/libfrog/quotactl.h
+++ b/libfrog/quotactl.h
@@ -23,4 +23,8 @@ enum xfs_quota_cmd {
 int xfsquotactl(enum xfs_quota_cmd xcommand, const char *device,
 		unsigned int xtype, unsigned int id, void *addr);
 
+struct fs_path;
+int xfrog_quotactl(const struct fs_path *mount, enum xfs_quota_cmd xcommand,
+		uint xtype, uint id, void *addr);
+
 #endif /* LIBFROG_QUOTACTL_H_ */
diff --git a/libfrog/quotactl.c b/libfrog/quotactl.c
index 81df2baf4a76b4..6129fa155ce75e 100644
--- a/libfrog/quotactl.c
+++ b/libfrog/quotactl.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 
+#include "libfrog/paths.h"
 #include "libfrog/quotactl.h"
 #include <sys/quota.h>
 
@@ -66,3 +67,14 @@ xfsquotactl(
 
 	return quotactl(op, device, id, addr);
 }
+
+int
+xfrog_quotactl(
+	const struct fs_path	*mount,
+	enum xfs_quota_cmd	xcommand,
+	uint			xtype,
+	uint			id,
+	void			*addr)
+{
+	return xfsquotactl(xcommand, mount->fs_name, xtype, id, addr);
+}
diff --git a/quota/edit.c b/quota/edit.c
index 1a3b2d9f959be8..d28a4319024038 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -469,11 +469,12 @@ set_timer(
 	uint32_t		id,
 	uint			type,
 	uint			mask,
-	char			*dev,
+	const struct fs_path	*mount,
 	time64_t		value)
 {
 	struct fs_disk_quota	d;
 	time64_t		btimer, itimer, rtbtimer;
+	int			ret;
 
 	memset(&d, 0, sizeof(d));
 
@@ -485,7 +486,8 @@ set_timer(
 		time_t	now;
 
 		/* Get quota to find out whether user is past soft limits */
-		if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
+		ret = xfrog_quotactl(mount, XFS_GETQUOTA, type, id, &d);
+		if (ret < 0) {
 			exitcode = 1;
 			fprintf(stderr, _("%s: cannot get quota: %s\n"),
 					progname, strerror(errno));
@@ -517,7 +519,8 @@ set_timer(
 	d.d_id = id;
 	encode_timers(&d, btimer, itimer, rtbtimer);
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
+	ret = xfrog_quotactl(mount, XFS_SETQLIM, type, id, &d);
+	if (ret < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set timer: %s\n"),
 				progname, strerror(errno));
@@ -601,19 +604,20 @@ timer_f(
 	if (id == -1)
 		return 0;
 
-	set_timer(id, type, mask, fs_path->fs_name, value);
+	set_timer(id, type, mask, fs_path, value);
 	return 0;
 }
 
 static void
 set_warnings(
-	uint32_t	id,
-	uint		type,
-	uint		mask,
-	char		*dev,
-	uint		value)
+	uint32_t		id,
+	uint			type,
+	uint			mask,
+	const struct fs_path	*mount,
+	uint			value)
 {
-	fs_disk_quota_t	d;
+	struct fs_disk_quota	d;
+	int			ret;
 
 	memset(&d, 0, sizeof(d));
 	d.d_version = FS_DQUOT_VERSION;
@@ -624,7 +628,8 @@ set_warnings(
 	d.d_bwarns = value;
 	d.d_rtbwarns = value;
 
-	if (xfsquotactl(XFS_SETQLIM, dev, type, id, (void *)&d) < 0) {
+	ret = xfrog_quotactl(mount, XFS_SETQLIM, type, id, &d);
+	if (ret < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set warnings: %s\n"),
 				progname, strerror(errno));
@@ -699,7 +704,7 @@ warn_f(
 	if (id == -1)
 		return 0;
 
-	set_warnings(id, type, mask, fs_path->fs_name, value);
+	set_warnings(id, type, mask, fs_path, value);
 	return 0;
 }
 
diff --git a/quota/free.c b/quota/free.c
index ea9c112f314a12..5793885c44fd1e 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -136,11 +136,11 @@ projects_free_space_data(
 	fs_disk_quota_t		d;
 	struct fsxattr		fsx;
 	uint			type = XFS_PROJ_QUOTA;
-	char			*dev = path->fs_name;
 	int			fd;
+	int			ret;
 
-	if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, &qfs) < 0 ||
-			!(qfs.qs_flags & XFS_QUOTA_PDQ_ACCT))
+	ret = xfrog_quotactl(path, XFS_GETQSTAT, type, 0, &qfs);
+	if (ret < 0 || !(qfs.qs_flags & XFS_QUOTA_PDQ_ACCT))
 		return 0;
 
 	if ((fd = open(path->fs_dir, O_RDONLY)) < 0) {
@@ -174,8 +174,9 @@ projects_free_space_data(
 		return 0;
 	}
 
-	xfsquotactl(XFS_QSYNC, dev, type, fsx.fsx_projid, NULL);
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, fsx.fsx_projid, &d) < 0) {
+	xfrog_quotactl(path, XFS_QSYNC, type, fsx.fsx_projid, NULL);
+	ret = xfrog_quotactl(path, XFS_GETQUOTA, type, fsx.fsx_projid, &d);
+	if (ret < 0) {
 		perror("XFS_GETQUOTA");
 		close(fd);
 		return 0;
diff --git a/quota/path.c b/quota/path.c
index 16b8bec4d883c0..4654f1553c65e0 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -39,8 +39,8 @@ printpath(
 		if (prj)
 			printf(_(", %s"), prj->pr_name);
 		printf(")");
-	} else if (xfsquotactl(XFS_GETQSTAT, path->fs_name, 0, 0,
-			       (void *)&qstat) == 0 && qstat.qs_flags) {
+	} else if (xfrog_quotactl(path, XFS_GETQSTAT, 0, 0, &qstat) == 0 &&
+			qstat.qs_flags) {
 		c = 0;
 		printf(" (");
 		if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
diff --git a/quota/quota.c b/quota/quota.c
index 08a07b2088817b..e1dfad62b9d762 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -53,9 +53,11 @@ quota_mount(
 	char		c[8], h[8], s[8];
 	uint		qflags;
 	int		count;
+	int		ret;
 
-	xfsquotactl(XFS_QSYNC, dev, type, 0, NULL);
-	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0)
+	xfrog_quotactl(mount, XFS_QSYNC, type, id, NULL);
+	ret = xfrog_quotactl(mount, XFS_GETQUOTA, type, id, &d);
+	if (ret < 0)
 		return 0;
 
 	dquot_fudge_numbers(&d);
diff --git a/quota/report.c b/quota/report.c
index 2acf81b81ba612..86eaa50f84c20b 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -61,13 +61,14 @@ report_help(void)
 
 static int
 get_dquot(
-	struct fs_disk_quota *d,
-	uint		id,
-	uint		type,
-	char		*dev,
-	int		flags)
+	struct fs_disk_quota	*d,
+	uint			id,
+	uint			type,
+	const struct fs_path	*mount,
+	int			flags)
 {
-	int		cmd;
+	int			cmd;
+	int			ret;
 
 	if (flags & GETNEXTQUOTA_FLAG)
 		cmd = XFS_GETNEXTQUOTA;
@@ -75,7 +76,8 @@ get_dquot(
 		cmd = XFS_GETQUOTA;
 
 	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
-	if (xfsquotactl(cmd, dev, type, id, (void *)d) < 0) {
+	ret = xfrog_quotactl(mount, cmd, type, id, d);
+	if (ret < 0) {
 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
 		    cmd == XFS_GETQUOTA)
 			perror("XFS_GETQUOTA");
@@ -140,8 +142,7 @@ dump_limits_any_type(
 		return;
 	}
 
-	while (get_dquot(&d, id, type, mount->fs_name,
-				flags | GETNEXTQUOTA_FLAG) &&
+	while (get_dquot(&d, id, type, mount, flags | GETNEXTQUOTA_FLAG) &&
 			!(upper && (d.d_id > upper))) {
 		dump_file(fp, &d, mount->fs_name);
 		id = d.d_id + 1;
@@ -157,8 +158,7 @@ dump_limits_any_type(
 			struct group *g;
 			setgrent();
 			while ((g = getgrent()) != NULL) {
-				if (get_dquot(&d, g->gr_gid, type,
-							mount->fs_name, 0) &&
+				if (get_dquot(&d, g->gr_gid, type, mount, 0) &&
 						!(lower && (d.d_id < lower)) &&
 						!(upper && (d.d_id > upper)))
 					dump_file(fp, &d, mount->fs_name);
@@ -170,8 +170,7 @@ dump_limits_any_type(
 			struct fs_project *p;
 			setprent();
 			while ((p = getprent()) != NULL) {
-				if (get_dquot(&d, p->pr_prid, type,
-							mount->fs_name, 0) &&
+				if (get_dquot(&d, p->pr_prid, type, mount, 0) &&
 						!(lower && (d.d_id < lower)) &&
 						!(upper && (d.d_id > upper)))
 					dump_file(fp, &d, mount->fs_name);
@@ -183,8 +182,7 @@ dump_limits_any_type(
 			struct passwd *u;
 			setpwent();
 			while ((u = getpwent()) != NULL) {
-				if (get_dquot(&d, u->pw_uid, type,
-							mount->fs_name, 0) &&
+				if (get_dquot(&d, u->pw_uid, type, mount, 0) &&
 						!(lower && (d.d_id < lower)) &&
 						!(upper && (d.d_id > upper)))
 					dump_file(fp, &d, mount->fs_name);
@@ -466,7 +464,7 @@ report_user_mount(
 	struct fs_disk_quota	d;
 	uint		id = lower;
 
-	while (get_dquot(&d, id, XFS_USER_QUOTA, mount->fs_name,
+	while (get_dquot(&d, id, XFS_USER_QUOTA, mount,
 				flags | GETNEXTQUOTA_FLAG) &&
 			!(upper && (d.d_id > upper))) {
 		report_mount(fp, &d, NULL, form, XFS_USER_QUOTA, mount, flags);
@@ -480,7 +478,7 @@ report_user_mount(
 		setpwent();
 		while ((u = getpwent()) != NULL) {
 			if (get_dquot(&d, u->pw_uid, XFS_USER_QUOTA,
-						mount->fs_name, flags) &&
+						mount, flags) &&
 					!(lower && (d.d_id < lower)) &&
 					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, u->pw_name, form,
@@ -508,7 +506,7 @@ report_group_mount(
 	struct fs_disk_quota	d;
 	uint		id = lower;
 
-	while (get_dquot(&d, id, XFS_GROUP_QUOTA, mount->fs_name,
+	while (get_dquot(&d, id, XFS_GROUP_QUOTA, mount,
 				flags | GETNEXTQUOTA_FLAG) &&
 			!(upper && (d.d_id > upper))) {
 		report_mount(fp, &d, NULL, form, XFS_GROUP_QUOTA, mount, flags);
@@ -522,7 +520,7 @@ report_group_mount(
 		setgrent();
 		while ((g = getgrent()) != NULL) {
 			if (get_dquot(&d, g->gr_gid, XFS_GROUP_QUOTA,
-						mount->fs_name, flags) &&
+						mount, flags) &&
 					!(lower && (d.d_id < lower)) &&
 					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, g->gr_name, form,
@@ -549,7 +547,7 @@ report_project_mount(
 	struct fs_disk_quota	d;
 	uint		id = lower;
 
-	while (get_dquot(&d, id, XFS_PROJ_QUOTA, mount->fs_name,
+	while (get_dquot(&d, id, XFS_PROJ_QUOTA, mount,
 				flags | GETNEXTQUOTA_FLAG) &&
 			!(upper && (d.d_id > upper))) {
 		report_mount(fp, &d, NULL, form, XFS_PROJ_QUOTA, mount, flags);
@@ -565,7 +563,7 @@ report_project_mount(
 			 * Print default project quota, even if projid 0
 			 * isn't defined
 			 */
-			if (get_dquot(&d, 0, XFS_PROJ_QUOTA, mount->fs_name,
+			if (get_dquot(&d, 0, XFS_PROJ_QUOTA, mount,
 						flags) &&
 					!(lower && (d.d_id < lower)) &&
 					!(upper && (d.d_id > upper))) {
@@ -578,7 +576,7 @@ report_project_mount(
 		setprent();
 		while ((p = getprent()) != NULL) {
 			if (get_dquot(&d, p->pr_prid, XFS_PROJ_QUOTA,
-						mount->fs_name, flags) &&
+						mount, flags) &&
 					!(lower && (d.d_id < lower)) &&
 					!(upper && (d.d_id > upper))) {
 				report_mount(fp, &d, p->pr_name, form,
@@ -605,15 +603,16 @@ report_any_type(
 {
 	fs_cursor_t	cursor;
 	fs_path_t	*mount;
+	int		ret;
 
 	if (type & XFS_USER_QUOTA) {
 		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
 		while ((mount = fs_cursor_next_entry(&cursor))) {
 			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
 				continue;
-			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
-						XFS_USER_QUOTA, 0, NULL) < 0
-					&& errno != ENOENT && errno != ENOSYS)
+			ret = xfrog_quotactl(mount, XFS_QSYNC, XFS_USER_QUOTA,
+					0, NULL);
+			if (ret < 0 && errno != ENOENT && errno != ENOSYS)
 				perror("XFS_QSYNC user quota");
 			report_user_mount(fp, form, mount,
 						lower, upper, flags);
@@ -624,9 +623,9 @@ report_any_type(
 		while ((mount = fs_cursor_next_entry(&cursor))) {
 			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
 				continue;
-			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
-						XFS_GROUP_QUOTA, 0, NULL) < 0
-					&& errno != ENOENT && errno != ENOSYS)
+			ret = xfrog_quotactl(mount, XFS_QSYNC, XFS_GROUP_QUOTA,
+					0, NULL);
+			if (ret < 0 && errno != ENOENT && errno != ENOSYS)
 				perror("XFS_QSYNC group quota");
 			report_group_mount(fp, form, mount,
 						lower, upper, flags);
@@ -637,9 +636,9 @@ report_any_type(
 		while ((mount = fs_cursor_next_entry(&cursor))) {
 			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
 				continue;
-			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
-						XFS_PROJ_QUOTA, 0, NULL) < 0
-					&& errno != ENOENT && errno != ENOSYS)
+			ret = xfrog_quotactl(mount, XFS_QSYNC, XFS_PROJ_QUOTA,
+					0, NULL);
+			if (ret < 0 && errno != ENOENT && errno != ENOSYS)
 				perror("XFS_QSYNC proj quota");
 			report_project_mount(fp, form, mount,
 						lower, upper, flags);
diff --git a/quota/state.c b/quota/state.c
index 43fb700f9a7317..3679c247ea6204 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -202,9 +202,12 @@ state_quotafile_stat(
 	bool			accounting, enforcing;
 	struct fs_qfilestatv	*qsv;
 	char			*dev = mount->fs_name;
+	int			ret;
 
-	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)sv) < 0) {
-		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)s) < 0) {
+	ret = xfrog_quotactl(mount, XFS_GETQSTATV, type, 0, sv);
+	if (ret < 0) {
+		ret = xfrog_quotactl(mount, XFS_GETQSTAT, type, 0, sv);
+		if (ret < 0) {
 			if (flags & VERBOSE_FLAG)
 				fprintf(fp,
 					_("%s quota are not enabled on %s\n"),
@@ -351,6 +354,7 @@ enable_enforcement(
 	uint		flags)
 {
 	fs_path_t	*mount;
+	int		ret;
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
@@ -358,8 +362,8 @@ enable_enforcement(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0) {
+	ret = xfrog_quotactl(mount, XFS_QUOTAON, type, 0, &qflags);
+	if (ret < 0) {
 		if (errno == EEXIST)
 			fprintf(stderr,
 				_("Quota enforcement already enabled.\n"));
@@ -381,6 +385,7 @@ disable_enforcement(
 	uint		flags)
 {
 	fs_path_t	*mount;
+	int		ret;
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
@@ -388,8 +393,8 @@ disable_enforcement(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+	ret = xfrog_quotactl(mount, XFS_QUOTAOFF, type, 0, &qflags);
+	if (ret < 0) {
 		if (errno == EEXIST)
 			fprintf(stderr,
 				_("Quota enforcement already disabled.\n"));
@@ -411,6 +416,7 @@ quotaoff(
 	uint		flags)
 {
 	fs_path_t	*mount;
+	int		ret;
 
 	mount = fs_table_lookup(dir, FS_MOUNT_POINT);
 	if (!mount) {
@@ -418,8 +424,8 @@ quotaoff(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	dir = mount->fs_name;
-	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
+	ret = xfrog_quotactl(mount, XFS_QUOTAOFF, type, 0, &qflags);
+	if (ret) {
 		if (errno == EEXIST || errno == ENOSYS)
 			fprintf(stderr, _("Quota already off.\n"));
 		else
@@ -431,12 +437,13 @@ quotaoff(
 
 static int
 remove_qtype_extents(
-	char		*dir,
-	uint		type)
+	const struct fs_path	*mount,
+	uint			type)
 {
-	int	error = 0;
+	int			error;
 
-	if ((error = xfsquotactl(XFS_QUOTARM, dir, type, 0, (void *)&type)) < 0)
+	error = xfrog_quotactl(mount, XFS_QUOTARM, type, 0, &type);
+	if (error < 0)
 		perror("XFS_QUOTARM");
 	return error;
 }
@@ -455,17 +462,16 @@ remove_extents(
 		fprintf(stderr, "%s: unknown mount point %s\n", progname, dir);
 		return;
 	}
-	dir = mount->fs_name;
 	if (type & XFS_USER_QUOTA) {
-		if (remove_qtype_extents(dir, XFS_USER_QUOTA) < 0)
+		if (remove_qtype_extents(mount, XFS_USER_QUOTA) < 0)
 			return;
 	}
 	if (type & XFS_GROUP_QUOTA) {
-		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
+		if (remove_qtype_extents(mount, XFS_GROUP_QUOTA) < 0)
 			return;
 	}
 	if (type & XFS_PROJ_QUOTA) {
-		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
+		if (remove_qtype_extents(mount, XFS_PROJ_QUOTA) < 0)
 			return;
 	}
 	if (flags & VERBOSE_FLAG)

