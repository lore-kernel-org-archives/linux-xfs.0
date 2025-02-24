Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3020C16CD1D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 19:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424079; cv=none; b=XKT4cnW4VpLZQgYK0os/YGfA6ev+WAeQHjNgklXMK1v8G8EtYdMJjRGy0c/CQqVQe3M3TOuRmQ7m27gQ/iHEbpCjJ/RWnQuKI5XMREqDKHm+AZCHxUqGg0/DyRET0+ASwe0TqUx0NVPRsOHowu71jAiyqFX53FB9eRTstHUu/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424079; c=relaxed/simple;
	bh=+h/k9FYFwvOJp5nvbip9NvGb6DSd/vwhpWiVkIlSbjc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSwozQhOV9LJ+wm5UBLyO3HfF7FSUPf1Y8fdpHpgdseR/T0bmLcdZ3KzO6jA2gMHLGoRpCPqjLXSuZ4+swnKxwSBVMhqOwRpM/jaOB5HuxrO2Dk5sI8h295Ya7Hcl8JITFFtdpuCmsGRulcT5gQdC/sn1CtjwtX4P4GYqzktakA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjN+ot2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjN+ot2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E65C4CED6;
	Mon, 24 Feb 2025 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424078;
	bh=+h/k9FYFwvOJp5nvbip9NvGb6DSd/vwhpWiVkIlSbjc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cjN+ot2WvOcvA0Djjyt5+dM+EYDxQ5gA5v3Nni6MMYR/vI1bYBCBiTqSUVu6Tqjwk
	 3Aj7mvLnS3Vncf1NDmgQMuWqZdSTuVFrzjGnSwuOgviopy0CAmZt+X0VZP/NZMXGN7
	 vUoOMQdF4sQJElXM+L9z+9tOiT6YDXjlUgO9Ni4jqsgtt/SSXMZjvk7SjfZ0pVSbBI
	 uo/jLNjAOG5stXWDYTkfkvnYH4KYEi8qN137oumzhvW2DwVwmgbEZ8BkbD8BK7BoxC
	 a6cpz0VsoCLpgwaoa7MBg/bBkD1UlkWY5P1I4MBl0aYMzLpsAfVa33LnFJbUuA/nvy
	 qYj+sn5Ulf+bQ==
Date: Mon, 24 Feb 2025 11:07:58 -0800
Subject: [PATCH 3/3] xfs_scrub: use the display mountpoint for reporting file
 corruptions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174042401327.1205942.4120060381904924599.stgit@frogsfrogsfrogs>
In-Reply-To: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
References: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In systemd service mode, we make systemd bind-mount the target
mountpoint onto /tmp/scrub (/tmp is private to the service) so that
updates to the global mountpoint in the shared mount namespace don't
propagate into our service container and vice versa, and pass the path
to the bind mount to xfs_scrub via -M.  This solves races such as
unmounting of the target mount point after service container creation
but before process invocation that result in the wrong filesystem being
scanned.

IOWs, to scrub /usr, systemd runs "xfs_scrub -M /tmp/scrub /usr".
Pretend that /usr is a separate filesystem.

However, when xfs_scrub snapshots the handle of /tmp/scrub, libhandle
remembers that /tmp/scrub the beginning of the path, not the pathname
that we want to use for reporting (/usr).  This means that
handle_to_path returns /tmp/scrub and not /usr as well, with the
unfortunate result that file corrupts are reported with the pathnames in
the xfs_scrub@ service container, not the global ones.

Put another way, xfs_scrub should complain that /usr/bin/X is corrupt,
not /tmp/scrub/bin/X.

Therefore, modify scrub_render_ino_descr to manipulate the path buffer
during error reporting so that the user always gets the mountpoint
passed in, even if someone tells us to use another path for the actual
open() call in phase 1.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 9a8b09762f9a52 ("xfs_scrub: use parent pointers when possible to report file operations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/common.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)


diff --git a/scrub/common.c b/scrub/common.c
index 2b2d4a67bc47a2..14cd677ba5e9c4 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -418,15 +418,59 @@ scrub_render_ino_descr(
 
 	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) {
 		struct xfs_handle handle;
+		char		*pathbuf = buf;
+		size_t		used = 0;
 
 		handle_from_fshandle(&handle, ctx->fshandle, ctx->fshandle_len);
 		handle_from_inogen(&handle, ino, gen);
 
+		/*
+		 * @actual_mntpoint is the path we used to open the filesystem,
+		 * and @mntpoint is the path we use for display purposes.  If
+		 * these aren't the same string, then for reporting purposes
+		 * we must fix the start of the path string.  Start by copying
+		 * the display mountpoint into buf, except for trailing
+		 * slashes.  At this point buf will not be null-terminated.
+		 */
+		if (ctx->actual_mntpoint != ctx->mntpoint) {
+			used = strlen(ctx->mntpoint);
+			while (used && ctx->mntpoint[used - 1] == '/')
+				used--;
+
+			/* If it doesn't fit, report the handle instead. */
+			if (used >= buflen) {
+				used = 0;
+				goto report_inum;
+			}
+
+			memcpy(buf, ctx->mntpoint, used);
+			pathbuf += used;
+		}
+
 		ret = handle_to_path(&handle, sizeof(struct xfs_handle), 4096,
-				buf, buflen);
+				pathbuf, buflen - used);
 		if (ret)
 			goto report_inum;
 
+		/*
+		 * Now that handle_to_path formatted the full path (including
+		 * the actual mount point, stripped of any trailing slashes)
+		 * into the rest of pathbuf, slide down the contents by the
+		 * length of the actual mount point.  Don't count any trailing
+		 * slashes because handle_to_path uses libhandle, which strips
+		 * trailing slashes.  Copy one more byte to ensure we get the
+		 * terminating null.
+		 */
+		if (ctx->actual_mntpoint != ctx->mntpoint) {
+			size_t	len = strlen(ctx->actual_mntpoint);
+
+			while (len && ctx->actual_mntpoint[len - 1] == '/')
+				len--;
+
+			pathlen = strlen(pathbuf);
+			memmove(pathbuf, pathbuf + len, pathlen - len + 1);
+		}
+
 		/*
 		 * Leave at least 16 bytes for the description of what went
 		 * wrong.  If we can't do that, we'll use the inode number.

