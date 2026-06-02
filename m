Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A6244692
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376394; cv=none; b=VRyqBRnNfNwQqpJOHDUI8xCsVH2AZYGED/OqnHFtY/kUej3hVjBTBQ00LNo5awPqvbUgKMW5SSIzVKITyIoTatiMMxbLKjtFG8AlAyTFM3Jc2sY1X7YAnaPFssUl1JRJEeYz2Xk8g4LWrYMf1yV1542GFSbevUNP1ur3oQRZ/KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376394; c=relaxed/simple;
	bh=1rzOwPeLWekjpiX9MKTqx5KRW4l6NQnnWlz9FfpApXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kaBzdcZs48tMBeixVsT4Z5RjrbdXH2IdbEn1V8bD/oFInXLAAsRlnvE/nGL4z8TgBuhFISDqkGMDJBOFXFOTSjCEKmyCBy1W5HGxtBE9HByZT02ZBUOKPYRi5fjP1xIeZnuwPViBSDVdFAzS6t3rBJIER5p4ZFLsTAWuILmJ740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UbKsr/sd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UbKsr/sd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6441B1F00893;
	Tue,  2 Jun 2026 04:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376393;
	bh=TZ5lQsQm56uC49XXgIBZs3EZpiZy8xoq4QEzTdJonRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UbKsr/sdYh1I/45S2W1nXq4PJzss+wgQiShDKekPed0HBnZHNwDH4tBWoGop62yLA
	 5oBZmnXhTA+/5fNL53NLEI3Gu3I7V/u5G8uUf+yXWhfY4WOm8BSzUKUYFda9pHXIry
	 aPJKVTqpSTbVpSMoY011xD2wbv55KysHLR3nv+SxAVILS1W4iYhI3pZn5k1qHw/aBJ
	 7NLS6HM9YsfG+cdI/Bh3AQnQEAPIkcSw9lGCqRYmuBLnCr84bFGYAFl2fqJUMBJUHI
	 2cMfrBGtp/5OY+Wj+K/Q8+Y0nTprPiW/CKgFU+M+QT7Y+X8Oc8+7cIHffl24PODuVN
	 Zmr3B0sIFm1QA==
Date: Mon, 01 Jun 2026 21:59:53 -0700
Subject: [PATCH 7/7] xfs_healer: coordinate access to weakhandle::mntpoint
 correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627172.588879.10288701801654311276.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complained about a potential UAF in the weakhandle code if one
thread is walking weakhandle::mntpoint at exactly the same instant that
another thread calls try_update_mntpoint to update the mntpoint pointer
and free the old mntpoint string.  This can only happen if the sysadmin
decides to move the mountpoint while the kernel is logging runtime
errors and healer is trying to fix them, but it /is/ a UAF.

Fix this by transforming the existing static lock into a rwlock and
hoisting it to struct weakhandle.  Then make sure that we take it for
all accesses to the mntpoint string.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 1a5eeddf738c80 ("xfs_healer: update weakhandle mountpoint when reconnecting")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/weakhandle.c |   61 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 18 deletions(-)


diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 6c0dbb301c4f7d..9aa8859881481b 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -18,6 +18,9 @@
 #include "xfs_healer.h"
 
 struct weakhandle {
+	/* Synchronizes accesses to mntpoint */
+	pthread_rwlock_t	lock;
+
 	/* Owned reference to the user's mountpoint for logging */
 	char			*mntpoint;
 
@@ -61,13 +64,21 @@ weakhandle_alloc(
 	wh->mnt_id = mnt_id;
 	wh->fsname = fsname;
 
-	ret = fd_to_handle(fd, &wh->hanp, &wh->hlen);
-	if (ret)
+	ret = pthread_rwlock_init(&wh->lock, NULL);
+	if (ret) {
+		errno = ret;
 		goto out_mntpt;
+	}
+
+	ret = fd_to_handle(fd, &wh->hanp, &wh->hlen);
+	if (ret)
+		goto out_rwlock;
 
 	*whp = wh;
 	return 0;
 
+out_rwlock:
+	pthread_rwlock_destroy(&wh->lock);
 out_mntpt:
 	free(wh->mntpoint);
 out_wh:
@@ -80,19 +91,18 @@ try_update_mntpoint(
 	struct weakhandle	*wh,
 	const char		*path)
 {
-	static pthread_mutex_t	lock = PTHREAD_MUTEX_INITIALIZER;
 	char			*s = strdup(path);
 
 	if (!s)
 		return;
 
-	pthread_mutex_lock(&lock);
+	pthread_rwlock_wrlock(&wh->lock);
 	if (path != wh->mntpoint) {
 		free(wh->mntpoint);
 		wh->mntpoint = s;
 		s = NULL;
 	}
-	pthread_mutex_unlock(&lock);
+	pthread_rwlock_unlock(&wh->lock);
 
 	free(s);
 }
@@ -134,9 +144,6 @@ weakhandle_reopen_from(
 		goto out_handle;
 	}
 
-	if (path != wh->mntpoint)
-		try_update_mntpoint(wh, path);
-
 	free_handle(hanp, hlen);
 	*fd = mnt_fd;
 	return 0;
@@ -164,7 +171,9 @@ weakhandle_reopen(
 	int			ret;
 
 	/* First try reopening using the original mountpoint */
+	pthread_rwlock_rdlock(&wh->lock);
 	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd, is_acceptable, data);
+	pthread_rwlock_unlock(&wh->lock);
 	if (!ret)
 		return 0;
 
@@ -180,8 +189,10 @@ weakhandle_reopen(
 		goto fallback;
 	ret = weakhandle_reopen_from(wh, smbuf->str + smbuf->mnt_point, fd,
 			is_acceptable, data);
-	if (!ret)
+	if (!ret) {
+		try_update_mntpoint(wh, smbuf->str + smbuf->mnt_point);
 		return 0;
+	}
 
 fallback:
 	/*
@@ -200,8 +211,10 @@ weakhandle_reopen(
 
 		ret = weakhandle_reopen_from(wh, mnt->mnt_dir, fd,
 				is_acceptable, data);
-		if (!ret)
+		if (!ret) {
+			try_update_mntpoint(wh, mnt->mnt_dir);
 			break;
+		}
 	}
 
 	if (*fd < 0) {
@@ -221,6 +234,7 @@ weakhandle_free(
 	struct weakhandle	*wh = *whp;
 
 	if (wh) {
+		pthread_rwlock_destroy(&wh->lock);
 		free_handle(wh->hanp, wh->hlen);
 		free(wh->mntpoint);
 		free(wh);
@@ -230,25 +244,30 @@ weakhandle_free(
 }
 
 struct bufvec {
-	char	*buf;
-	size_t	len;
+	struct weakhandle	*wh;
+	char			*buf;
+	size_t			len;
 };
 
 static int
 render_path(
-	const char		*mntpt,
+	const char		*donotuse,
 	const struct path_list	*path,
 	void			*arg)
 {
 	struct bufvec		*args = arg;
-	int			mntpt_len = strlen(mntpt);
+	struct weakhandle	*wh = args->wh;
+	int			mntpt_len;
 	ssize_t			ret;
 
 	/* Trim trailing slashes from the mountpoint */
-	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+	pthread_rwlock_rdlock(&wh->lock);
+	mntpt_len = strlen(wh->mntpoint);
+	while (mntpt_len > 0 && wh->mntpoint[mntpt_len - 1] == '/')
 		mntpt_len--;
 
-	ret = snprintf(args->buf, args->len, "%.*s", mntpt_len, mntpt);
+	ret = snprintf(args->buf, args->len, "%.*s", mntpt_len, wh->mntpoint);
+	pthread_rwlock_unlock(&wh->lock);
 	if (ret < 0 || ret >= args->len)
 		return 0;
 
@@ -271,6 +290,7 @@ weakhandle_getpath_for(
 {
 	struct xfs_handle	fakehandle;
 	struct bufvec		bv = {
+		.wh		= wh,
 		.buf		= path,
 		.len		= pathlen,
 	};
@@ -295,7 +315,7 @@ weakhandle_getpath_for(
 	 * path that goes to the rootdir?  With a max filename length of 255
 	 * bytes, we pick 600 for the buffer size.
 	 */
-	ret = handle_walk_paths_fd(wh->mntpoint, mnt_fd, &fakehandle,
+	ret = handle_walk_paths_fd(NULL, mnt_fd, &fakehandle,
 			sizeof(fakehandle), 600, render_path, &bv);
 	switch (ret) {
 	case ECANCELED:
@@ -321,6 +341,11 @@ weakhandle_instance_unit_name(
 	char			*unitname,
 	size_t			unitnamelen)
 {
-	return systemd_path_instance_unit_name(template, wh->mntpoint,
+	int			ret;
+
+	pthread_rwlock_rdlock(&wh->lock);
+	ret = systemd_path_instance_unit_name(template, wh->mntpoint,
 			unitname, unitnamelen);
+	pthread_rwlock_unlock(&wh->lock);
+	return ret;
 }

