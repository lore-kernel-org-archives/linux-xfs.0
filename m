Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADFC3C9EE4
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589961; cv=none; b=AfAYTmSe3g1SvdHaqLsQAru5AbpyoavljxIU0aJksSqnsNXMpZmHOGcq8Gpz9Ny6DnUdZLEAKXwLvy+NOAsQGxDccIWVOwn/fDR8AvpnyHppe3nZvWFbOh0VF7fwdeNWcfYV5VPs+na75Q3fti1MwQ8j7vUQ/ocOQGtlaIrpkuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589961; c=relaxed/simple;
	bh=pZ+nvVnvQ6N3AZ36nohg5hZxUaLFZqK3HmGYCwQkI9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoGzCojn+0CjhvccB8kNgYOG3+ceYP6YE4j/gbhZGVYdrCWLXzp48NKW//ySdtHEzB4v7CsLt+tvtf2Q5/f780lf+QfgwQ3QPi3GjXVbY6l5NOEiJs+vzivF9zF9bAQZ1eenyJ0w402bTDjQbjzGSqoVLudjxIBt2mWww7w6/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bwYcARZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bwYcARZO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E5FE1F000FF;
	Fri,  9 Oct 2026 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589960;
	bh=UDgP7oXuDYu4OCDH+olkoxo1AL8uyjuphcqLSFCD9wc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bwYcARZOjUoYSJtxcLBiIe/7ZC/SMO7gJ34UYd3WYwOcILF7dZT+bLUZQY5bSpbgq
	 IeRd7VIeJNSpf6u63bEigWjgAWqPO//BHeIf7Mua0zlV/Jv2hoqQs2R8fWuW5Uc59M
	 eVxdAnOWbS4o7+fNjKi5v0mcUWxLh04Mj+TSf0JQa/i/7ditPID/shz3RWz7fy52nr
	 maF26Q84t09LSXIPbf5QPk4wM9Dk8ZWR4QevkFIRwXXw/0Iqdnud+QesiNMUBCjAX6
	 6N6WJV2WAgp+S7uVRmwAjVVmhV+P3z1HNvhARauKxOAV3wbI9rTkw+V3VEIRQ9KoQl
	 0MXo7VdaOydug==
Date: Fri, 09 Oct 2026 16:52:39 -0700
Subject: [PATCH 1/2] misc: convert as many xfsquotactl callsites to
 xfrog_quotactl as possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948059.3720791.17480133735576395572.stgit@frogsfrogsfrogs>
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

Convert the two remaining xfsquotactl callsites to use xfrog_quotactl so
that we can refactor that into a bunch of typesafe helpers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 quota/edit.c    |   78 ++++++++++++++++++++++++++++---------------------------
 spaceman/info.c |   15 +++++++----
 2 files changed, 49 insertions(+), 44 deletions(-)


diff --git a/quota/edit.c b/quota/edit.c
index cf4f8cdaeead63..3cd88acc177c37 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -135,41 +135,6 @@ id_from_string(
 	return id;
 }
 
-static void
-set_limits(
-	uint32_t	id,
-	uint		type,
-	uint		mask,
-	int		mnt_fd,
-	char		*dev,
-	uint64_t	*bsoft,
-	uint64_t	*bhard,
-	uint64_t	*isoft,
-	uint64_t	*ihard,
-	uint64_t	*rtbsoft,
-	uint64_t	*rtbhard)
-{
-	fs_disk_quota_t	d;
-
-	memset(&d, 0, sizeof(d));
-	d.d_version = FS_DQUOT_VERSION;
-	d.d_id = id;
-	d.d_flags = type;
-	d.d_fieldmask = mask;
-	d.d_blk_hardlimit = *bhard;
-	d.d_blk_softlimit = *bsoft;
-	d.d_ino_hardlimit = *ihard;
-	d.d_ino_softlimit = *isoft;
-	d.d_rtb_hardlimit = *rtbhard;
-	d.d_rtb_softlimit = *rtbsoft;
-
-	if (xfsquotactl(mnt_fd, dev, XFS_SETQLIM, type, id, (void *)&d) < 0) {
-		exitcode = 1;
-		fprintf(stderr, _("%s: cannot set limits: %s\n"),
-				progname, strerror(errno));
-	}
-}
-
 /* extract number of blocks from an ascii string */
 static int
 extractb(
@@ -311,8 +276,25 @@ limit_f(
 	if (id == -1)
 		return 0;
 
-	set_limits(id, type, mask, fs_path->mnt_fd, fs_path->fs_name,
-		   &bsoft, &bhard, &isoft, &ihard, &rtbsoft, &rtbhard);
+	struct fs_disk_quota		d = {
+		.d_version		= FS_DQUOT_VERSION,
+		.d_id			= id,
+		.d_flags		= type,
+		.d_fieldmask		= mask,
+		.d_blk_hardlimit	= bhard,
+		.d_blk_softlimit	= bsoft,
+		.d_ino_hardlimit	= ihard,
+		.d_ino_softlimit	= isoft,
+		.d_rtb_hardlimit	= rtbhard,
+		.d_rtb_softlimit	= rtbsoft,
+	};
+
+	c = xfrog_quotactl(fs_path, XFS_SETQLIM, type, id, &d);
+	if (c < 0) {
+		exitcode = 1;
+		fprintf(stderr, _("%s: cannot set limits: %s\n"),
+				progname, strerror(errno));
+	}
 	return 0;
 }
 
@@ -357,8 +339,26 @@ restore_file(
 			mask = FS_DQ_ISOFT|FS_DQ_IHARD|FS_DQ_BSOFT|FS_DQ_BHARD;
 			if (cnt == 7)
 				mask |= FS_DQ_RTBSOFT|FS_DQ_RTBHARD;
-			set_limits(id, type, mask, -1, dev, &bsoft, &bhard,
-					&isoft, &ihard, &rtbsoft, &rtbhard);
+
+			struct fs_disk_quota		d = {
+				.d_version		= FS_DQUOT_VERSION,
+				.d_id			= id,
+				.d_flags		= type,
+				.d_fieldmask		= mask,
+				.d_blk_hardlimit	= bhard,
+				.d_blk_softlimit	= bsoft,
+				.d_ino_hardlimit	= ihard,
+				.d_ino_softlimit	= isoft,
+				.d_rtb_hardlimit	= rtbhard,
+				.d_rtb_softlimit	= rtbsoft,
+			};
+			int ret = xfsquotactl(-1, dev, XFS_SETQLIM, type, id, &d);
+
+			if (ret < 0) {
+				exitcode = 1;
+				fprintf(stderr, _("%s: cannot set limits: %s\n"),
+						progname, strerror(errno));
+			}
 		}
 	}
 }
diff --git a/spaceman/info.c b/spaceman/info.c
index 56c7a05c3f81ec..ab43f34ccbba2d 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -115,7 +115,7 @@ static const struct qflags_xlate qsflags_xlate[] = {
 
 static int
 get_qflags(
-	struct fileio		*f,
+	const struct fs_path	*mount,
 	unsigned int		*qflags)
 {
 	struct fs_quota_stat	qstat;
@@ -125,8 +125,7 @@ get_qflags(
 	*qflags = 0;
 
 	/* GETQSTAT returns qflags for all quota types, not just user */
-	ret = xfsquotactl(f->xfd.fd, f->fs_path.fs_name, XFS_GETQSTAT,
-			XFS_USER_QUOTA, 0, (void *)&qstat);
+	ret = xfrog_quotactl(mount, XFS_GETQSTAT, XFS_USER_QUOTA, 0, &qstat);
 	if (ret) {
 		/*
 		 * ENOSYS means quota is not enabled or compiled in; ENODEV
@@ -153,10 +152,12 @@ makecfg_f(
 	char			**argv)
 {
 	struct fsxattr		fsx = { };
+	struct fs_path		*mount;
 	FILE			*fp;
 	bool			close_fp = false;
 	enum fsprop_autofsck	autofsck;
 	unsigned int		qflags;
+	int			old_mnt_fd;
 	int			c;
 	int			ret;
 
@@ -173,7 +174,8 @@ makecfg_f(
 		return makecfg_usage();
 	}
 
-	if (fs_table_lookup_mount(file->name) == NULL) {
+	mount = fs_table_lookup_mount(file->name);
+	if (!mount) {
 		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
 		return 1;
 	}
@@ -193,7 +195,10 @@ makecfg_f(
 		return 1;
 	}
 
-	ret = get_qflags(file, &qflags);
+	old_mnt_fd = mount->mnt_fd;
+	mount->mnt_fd = file->xfd.fd;
+	ret = get_qflags(mount, &qflags);
+	mount->mnt_fd = old_mnt_fd;
 	if (ret) {
 		perror("quotactl");
 		return 1;

