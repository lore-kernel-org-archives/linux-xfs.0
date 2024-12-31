Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DB11B0414
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688347; cv=none; b=ZuCnGqMzn8NE6V+SvcYx+hUtifBZxXF/ubCGNr8ay0dWOWICPXAJuo+yB/dLSuFfdukwahjQDShpDd3+U7obkheKVI3y6KwCduJl5mM0KSoypn0qlIHJUY2QHgWkUX7PmGxmOQOls19ZoHRXZOKr67Il7Yn3Y/SPnrAlIAEMn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688347; c=relaxed/simple;
	bh=KfYyJzj7UDXvK1znlTYbQ5MZ94Z9lnYsOh+s1c95FtE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+Jh1HBnn7mcQ1ZSmgkLUdfvOPk9ehYsEzWAFHQfuFd3jVpP0C3lWujnHRHDPzpWyVcGKkLdQIbY/D4VeebTYNZw/7fWPaSkMG8t5a9ic6EIs4O8bwJTPUICJwFV1hCXkVxz5OgC2A21jZ3FbmZWTRKX+YvKiXUr+7pfYJWNLic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNuFuQG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNuFuQG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69996C4CED2;
	Tue, 31 Dec 2024 23:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688347;
	bh=KfYyJzj7UDXvK1znlTYbQ5MZ94Z9lnYsOh+s1c95FtE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RNuFuQG+o+a1287MDaYkQ6+m9uL5MjFnkE6DwOpPjg/bm+oERZy+QAUc3V/F6PlX5
	 sfoomBRv+lFvL6wE/Tk/7Jypit+ffQj+vZvszFUuaFh6n+325kpCEFwcNWUgQLYljN
	 6DK6v8DNVkodYV7PsSs37f0YhkqaDoZkQWIkvlxWeexeYeasiNe/YC66GUK3SCBcGv
	 V+G/5llGijzSh6aG32Z+1LR6WJNSEUgZjBB5kl2mpN/UWPa92IVr5Z8DmLtlbSWqW1
	 ldSD0WKI2KF/mb3MdcwqeVTOlIQ02563rI8lL4q8rOZOkyV+kvDzkgW8z6qDeeSAAl
	 vRkCEYzeSAd+g==
Date: Tue, 31 Dec 2024 15:39:06 -0800
Subject: [PATCH 01/16] xfs: create debugfs uuid aliases
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754759.2704911.1231694481039541264.stgit@frogsfrogsfrogs>
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

Create an alias for the debugfs dir so that we can find a filesystem by
uuid.  Unless it's mounted nouuid.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   11 +++++++++++
 2 files changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 87007d9de5d9d0..d73e76e36bfc10 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -292,6 +292,7 @@ typedef struct xfs_mount {
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct xfs_zone_info	*m_zone_info;	/* zone allocator information */
 	struct dentry		*m_debugfs;	/* debugfs parent */
+	struct dentry		*m_debugfs_uuid; /* debugfs symlink */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 099c30339e8f9d..fd641853fe3595 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -780,6 +780,7 @@ xfs_mount_free(
 	if (mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_ddev_targp);
 
+	debugfs_remove(mp->m_debugfs_uuid);
 	debugfs_remove(mp->m_debugfs);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
@@ -1893,6 +1894,16 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	if (xfs_debugfs && mp->m_debugfs && !xfs_has_nouuid(mp)) {
+		char	name[UUID_STRING_LEN + 1];
+
+		snprintf(name, UUID_STRING_LEN + 1, "%pU", &mp->m_sb.sb_uuid);
+		mp->m_debugfs_uuid = debugfs_create_symlink(name, xfs_debugfs,
+				mp->m_super->s_id);
+	} else {
+		mp->m_debugfs_uuid = NULL;
+	}
+
 	return 0;
 
  out_filestream_unmount:

