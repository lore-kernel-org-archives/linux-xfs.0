Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A393806CA
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365034; cv=none; b=CenKqkIMyF5pkVNcVZNByltgBZ+gzDJsA5cy3jMBbWvbmsUYjj1AvmFPA+UH/kFRkEr+aodGv9MtgKM25BBzBbX8EZIoAE1f9wyV0EMV04m8tE0YSEqgRv1mTguqYv7sIT11M31a82t1+l3005PVU83EocFHMotDQ7N2ax0jB7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365034; c=relaxed/simple;
	bh=dZyUF40b1EKUBPHJIeoiRvyVaoLBZGcDtz5TB5HGVfE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P7YmkIAuihvXpplxXs4AqBhhYUPT0urLifpqXfdIgQli10vRr41Thha51Da2HGhlafhec3Ck8akEAieCE7MFOGG9BYaY7zCe9YI8RmN1Wva9ZruR6kFZfSX6WIYzxMnQwWW8D8Gps6huNHpvN8LIc2PaUJGGFmNwLK8QKUfJ8Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hw6/loAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hw6/loAc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 45F5E1F000FF;
	Mon, 14 Sep 2026 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365022;
	bh=QCpd/5daWyRpe56BNpxhdW5fnwMsWP3zXOarOBr8Ax8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hw6/loAcc77Q67OlbEXmYNRPWvpKPF9Fiixoi3TCoEsrVE1h+UqvmC4nOwqGzpm1i
	 Eufy0F2H66eqzCfouczuweISMtYE7bVxcDixUQ4pdCuhq30E0SybefQLOEuoiIX3UG
	 IcU5l8w/QM0d981QhEW4es4YOBjmlLJ4V6kuxgp1LTfROul9IuoZzra0PLNmvpXi8e
	 zGy5JNF/6SSAJZKv1Csog6fdG/DQ2KDt57YVQftj7LxQnfLPhAdpyFk1U0RU2h7xMn
	 lgTS3xM7Kq4iCWUBM9lrZydCYKI0zukHBdEX9Yq+Qfe00r2WJ6zGtbkhWxzOWPnKJD
	 NEAqJ4JSMiHhw==
Date: Sun, 13 Sep 2026 22:50:21 -0700
Subject: [PATCH 3/7] libfrog: enhance struct fs_path to store optional mount
 fd
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484862.2108717.5940087474719549167.stgit@frogsfrogsfrogs>
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

The fs_path object stores information about various mounted XFS(?)
filesystems.  We'd like to be able to store an fd to an open file on
each mounted filesystem, so add a mnt_fd field to fs_path for that
purpose.  Users can store a fd in here if they want, and it'll get
cleaned up when the fs_table is destroyed.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/paths.h |    1 +
 libfrog/paths.c |    3 +++
 2 files changed, 4 insertions(+)


diff --git a/libfrog/paths.h b/libfrog/paths.h
index 306fd3cb8fde57..90689e7ab69fe8 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -29,6 +29,7 @@ typedef struct fs_path {
 	char		*fs_dir;	/* Directory / mount point	*/
 	uint		fs_flags;	/* FS_{MOUNT_POINT,PROJECT_PATH}*/
 	uint		fs_prid;	/* Project ID for tree root	*/
+	int		mnt_fd;		/* optional fd for mountpoint	*/
 } fs_path_t;
 
 extern int fs_count;		/* number of entries in fs table */
diff --git a/libfrog/paths.c b/libfrog/paths.c
index a5dfab48ec1e2a..d4cf65810c0029 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -206,6 +206,7 @@ fs_table_insert(
 	fs_path->fs_datadev = datadev;
 	fs_path->fs_logdev = logdev;
 	fs_path->fs_rtdev = rtdev;
+	fs_path->mnt_fd = -1;
 	fs_count++;
 	if (!(flags & FS_FOREIGN))
 		xfs_fs_count++;
@@ -232,6 +233,8 @@ fs_table_destroy(void)
 	struct fs_path	*fsp;
 
 	for (i = 0, fsp = fs_table; i < fs_count; i++, fsp++) {
+		if (fsp->mnt_fd >= 0)
+			close(fsp->mnt_fd);
 		free(fsp->fs_name);
 		free(fsp->fs_dir);
 		free(fsp->fs_log);

