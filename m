Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88B63DF;
	Sat, 24 Feb 2024 01:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737584; cv=none; b=ekCGKHAakSf+dCgGGEC4ffsUgNB10R5NvaBV8Hl+aZeQD2xTQsdcuD3SFqIEaFdNKjrPFbEybVkI7M3eOxv/dH6A2cvfbXCrnZCjWTziiqLhOFZUjhIJng3lCikKHrWD7hYk2PHB6LZTskmjQEE8tB9aXwlda4AyszI7zXhGsg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737584; c=relaxed/simple;
	bh=U+YdoO2DM8uIKb1ZjbD8XDBMJ18tpX3m2cgKff6+ek0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCd+deVO8ELU5FMLokGchNTSsVYtjxrzP3v/YtWI6BFCiRRMnDJSKoO3cN/1SKOX+c/9Vw3GuIok1mA7AaZNBdmnxmL2Z5fRKr+lNG8jXTK2ULMjFtt0tQbE8uziJNP37b+zmMVf0fyWrSNl4Qd6KZGGj7HEwqj7g0op33pcw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZ/NO1zN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZ/NO1zN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71632C433C7;
	Sat, 24 Feb 2024 01:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737584;
	bh=U+YdoO2DM8uIKb1ZjbD8XDBMJ18tpX3m2cgKff6+ek0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eZ/NO1zNMpsjpS97ksJkCxo3JnnJwRdO4iQFB840W4G0+eOZxdMHTVUQJWmA9wg83
	 ySn1/67mKv4F7ZNMyL1wxuAUwD+3PDaCiEkl7pZqnMH7cMTNdduvKulrO7F6jtGgg0
	 da25qWdBpOOVYGywnXp0PnkchDl7Smw+D/wKxaulrF85Y/rtePnhcuC7Sw2Z7gd/u8
	 7sEFtRU0u0kgfq/KrBplnbNHosGqAZs4Le5bXwrcnDPPWGqvFC9B0+V5OndhPPOQfC
	 Hv1Qg1R++cfeW4lXDIDB+BFjczioeOQyQHUW/5MBj1DB3DqA43neiBCC4dmV8qk/fM
	 hvsM11MabKjcA==
Date: Fri, 23 Feb 2024 17:19:44 -0800
Subject: [PATCH 8/8] xfs: send uevents when mounting and unmounting a
 filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669995.1861872.14133497048269679722.stgit@frogsfrogsfrogs>
In-Reply-To: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
References: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5aa51d5402809..06f0c00988fc8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1136,12 +1136,28 @@ xfs_inodegc_free_percpu(
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
@@ -1504,6 +1520,29 @@ xfs_debugfs_mkdir(
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
@@ -1810,6 +1849,7 @@ xfs_fs_fill_super(
 		mp->m_debugfs_uuid = NULL;
 	}
 
+	xfs_send_mount_uevent(fc, mp);
 	return 0;
 
  out_filestream_unmount:

