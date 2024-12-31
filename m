Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0213FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688582; cv=none; b=TAdTMhJ6fFoOO2LNmKNe5OT+7zr/zZRYyTlW7XPl6FHV0yF36fZN0tLAOvTWsUMrTa6mdgGIieXSSzfKmTZTd9CxzqoE4Qn4uWgQm71jOCauxSof5nskiLDYvtfrIz0JRzOeZ4fWFxVI7lNMKsUqjN/WnN7R5ohKAqmDd1FqI40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688582; c=relaxed/simple;
	bh=DyQCFuX9wn5lqFA6ydSy3TPmRCcPxsAQWzVXYhdSUe0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dkz0HLfL0RkCqTMJveZK/R3QOu9fQRz0E2va7ORkke6ogzyY/J+ZrBO/eo4gTaxc0Qq+6PwXhAE2VPWdeLBZJCj4+DxCPu/t9CXXESgQ8iundQ+en3+T7sDEXwtOZMJYODzMaUqYv6pFd+nr4vUeCi0GWMJLmxW1OCMsW8ljJC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCwLwFJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCwLwFJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA63C4CED2;
	Tue, 31 Dec 2024 23:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688581;
	bh=DyQCFuX9wn5lqFA6ydSy3TPmRCcPxsAQWzVXYhdSUe0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lCwLwFJ12Uj7h8tIHHqbNhMCosCJE8p/Agh1W47240bu3QfKm1D73WLsM9AnMFh/Q
	 P2jwowPIUhuZuvftfdqLJ3VhsRCIfwczYCVTJZef+EK1LvvnLpwBXHklZq39bxCYhq
	 P3owTGig3RGr+zCCnb6pAHQJp5C53HS4h2ncLD6Q5DWNC/SkNlB2t+Qo1SDFWpSGaZ
	 HEg6WdOO66pVkvRlRtdlsh/hIspCVpsd694Pi7K1wTVXoQA9LncjY65Yj6BjzCqO6y
	 +0GUEhsDj9Kx0JtXcMAikLXNmyVuUkfOiEleMXUDyrK2i034bp8L0gXxIxamjpShSm
	 TmpEAlKLFVH/w==
Date: Tue, 31 Dec 2024 15:43:01 -0800
Subject: [PATCH 16/16] xfs: send uevents when mounting and unmounting a
 filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568755020.2704911.17739206325953827170.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Send uevents when we mount and unmount the filesystem, so that we can
trigger systemd services.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index df6afcf8840948..1d295991e08047 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1197,12 +1197,28 @@ xfs_inodegc_free_percpu(
 	free_percpu(mp->m_inodegc);
 }
 
+static void
+xfs_send_unmount_uevent(
+	struct xfs_mount	*mp)
+{
+	char			sid[256] = "";
+	char			*env[] = {
+		"TYPE=mount",
+		sid,
+		NULL,
+	};
+
+	snprintf(sid, sizeof(sid), "SID=%s", mp->m_super->s_id);
+	kobject_uevent_env(&mp->m_kobj.kobject, KOBJ_REMOVE, env);
+}
+
 static void
 xfs_fs_put_super(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	xfs_send_unmount_uevent(mp);
 	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
@@ -1590,6 +1606,29 @@ xfs_debugfs_mkdir(
 	return child;
 }
 
+/*
+ * Send a uevent signalling that the mount succeeded so we can use udev rules
+ * to start background services.
+ */
+static void
+xfs_send_mount_uevent(
+	struct fs_context	*fc,
+	struct xfs_mount	*mp)
+{
+	char			source[256] = "";
+	char			sid[256] = "";
+	char			*env[] = {
+		"TYPE=mount",
+		source,
+		sid,
+		NULL,
+	};
+
+	snprintf(source, sizeof(source), "SOURCE=%s", fc->source);
+	snprintf(sid, sizeof(sid), "SID=%s", mp->m_super->s_id);
+	kobject_uevent_env(&mp->m_kobj.kobject, KOBJ_ADD, env);
+}
+
 static int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1904,6 +1943,7 @@ xfs_fs_fill_super(
 		mp->m_debugfs_uuid = NULL;
 	}
 
+	xfs_send_mount_uevent(fc, mp);
 	return 0;
 
  out_filestream_unmount:

