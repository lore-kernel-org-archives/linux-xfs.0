Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6350B37C913
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 03:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776052611; cv=none; b=OgKEDFWCBwWAqsnnMvOGXZKPT/8t/iGIDjjb0eCG2ZJv5stR6D5SLzRTSOebXj5CoruvuuBcpRmB6WGmwwkxnK8axuiXzPKyr8z4nXaS0dVc6Cv/OXlfjTDLiP3Fp8126gOpirupoJfRHkdddiK4vyd+qFuNCT9I2omZllhUhjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776052611; c=relaxed/simple;
	bh=hSLbnZ2Ya4WZ4Xa9vE+dFa+9roDPwtsWFtXXXlNs/JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tifnwAxcoz7YYX7trNdT0x6ou2xXW/6WGatUpAWX4bdnz85jSo7BkRCTZj8cdOpodfGhW6PxVfdiDhmurwdXr4vJcEI2jW8+Zb6TU40lKkOhFbXeMS1R2JAtKL9V46Na951s16XPyhVuMlftX8udkm9KoF8Jn8WU1PZ8faF+XCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpFIVkUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpFIVkUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB8C116C6;
	Mon, 13 Apr 2026 03:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776052611;
	bh=hSLbnZ2Ya4WZ4Xa9vE+dFa+9roDPwtsWFtXXXlNs/JQ=;
	h=Date:From:To:Cc:Subject:From;
	b=dpFIVkUkS5kaWc7px1Oqzv/ZrMXKRToTjyRBwR+tNi30IIiJs907qdwTEARtJPeip
	 wkxxAK07tpLXRS7y75bd3gvaF1nGKBtofh5krMxni6kVy3zNfHuLD7UajnM3NOPq7x
	 qYVvntYpM+JkZTi03zpA19x3ABp9r1GhCc8u8ZWVcUw2Wtzrw+xTOgNqg/QXxwQvAR
	 a0tHngUxJx/i8Q/AfN7jt5lAN78TI/8EF/jegSc783Oh7G/whYN5rYYtotyvyknoHy
	 Oom/rk9i8tIAliNf08P1KT9IBi+0VY1EIW6XoV2fMIi66fWBbw93bjfiJLjtDMRQF0
	 lq3/PW9xMd9dQ==
Date: Sun, 12 Apr 2026 20:56:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_healer: update weakhandle mountpoint when reconnecting
Message-ID: <20260413035650.GG1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

If we have to reconnect a weakhandle to a different mount point, we
should update the internal mountpoint string to that new value so we
don't have to keep reconnecting it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/weakhandle.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 7b8cef0a63f971..d659cbd63b5176 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -18,8 +18,8 @@
 #include "xfs_healer.h"
 
 struct weakhandle {
-	/* Shared reference to the user's mountpoint for logging */
-	const char		*mntpoint;
+	/* Owned reference to the user's mountpoint for logging */
+	char			*mntpoint;
 
 	/* Shared reference to the getmntent fsname for reconnecting */
 	const char		*fsname;
@@ -55,7 +55,9 @@ weakhandle_alloc(
 	if (!wh)
 		return -1;
 
-	wh->mntpoint = mountpoint;
+	wh->mntpoint = strdup(mountpoint);
+	if (!wh->mntpoint)
+		goto out_wh;
 	wh->mnt_id = mnt_id;
 	wh->fsname = fsname;
 
@@ -71,6 +73,28 @@ weakhandle_alloc(
 	return -1;
 }
 
+static void
+try_update_mntpoint(
+	struct weakhandle	*wh,
+	const char		*path)
+{
+	static pthread_mutex_t	lock = PTHREAD_MUTEX_INITIALIZER;
+	char			*s = strdup(path);
+
+	if (!s)
+		return;
+
+	pthread_mutex_lock(&lock);
+	if (path != wh->mntpoint) {
+		free(wh->mntpoint);
+		wh->mntpoint = s;
+		s = NULL;
+	}
+	pthread_mutex_unlock(&lock);
+
+	free(s);
+}
+
 /*
  * Reopen a file handle obtained via weak reference, using the given path to a
  * mount point.
@@ -108,6 +132,9 @@ weakhandle_reopen_from(
 		goto out_handle;
 	}
 
+	if (path != wh->mntpoint)
+		try_update_mntpoint(wh, path);
+
 	free_handle(hanp, hlen);
 	*fd = mnt_fd;
 	return 0;
@@ -193,6 +220,7 @@ weakhandle_free(
 
 	if (wh) {
 		free_handle(wh->hanp, wh->hlen);
+		free(wh->mntpoint);
 		free(wh);
 	}
 
