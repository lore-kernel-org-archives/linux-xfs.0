Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2CBE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vHs4HvX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C5CC433C7;
	Sun, 31 Dec 2023 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059497;
	bh=eIsKs7fnOAuY3pD6cqbmmFfP7whr98u+fYHBGpjxzpA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vHs4HvX5gth7ivzkNvAhSaqD8FAO5tz2OXgcqGP5EgwS1mtthcAjnmMv69hz3dMRr
	 Zn9leB+zA/hPUZR+3XrbNpKJ+XUPenEGo6lKbBsqTiftMTn8HwvAFwZTtWxYfGHWdu
	 9RFhK9Hq1LDnx9y8Qjl92UGAtQzZRP7C3q3h+XHoyMGz6g0gsC0kz4tZUct26PLFta
	 fq0Y+0M34YYh/BPcG+UM17XYSb5c8lX1svieS5gcbVdvdIV2tVIYqp5HJnfXZWzz1F
	 oUXjnWRJlily7VYO+yB/ZrsRenA9+pJYXCLCf3WIXWLUgJjRuaXFzIj6Pyjh30GdI6
	 bf56SIMkprcUA==
Date: Sun, 31 Dec 2023 13:51:36 -0800
Subject: [PATCH 27/44] xfs: add realtime refcount btree when adding rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852016.1766284.14171174568346315649.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

If we're adding enough space to the realtime section to require the
creation of new realtime groups, create the rt refcount btree inode
before we start adding the space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 54859b32d37fc..1dd76cb757534 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1090,6 +1090,59 @@ xfs_growfsrt_create_rtrmap(
 	return error;
 }
 
+/* Add a metadata inode for a realtime refcount btree. */
+static int
+xfs_growfsrt_create_rtrefcount(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp) || rtg->rtg_refcountip)
+		return 0;
+
+	error = xfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = xfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		goto out_path;
+
+	error = xfs_imeta_start_create(mp, path, &upd);
+	if (error)
+		goto out_path;
+
+	error = xfs_rtrefcountbt_create(&upd, &ip);
+	if (error)
+		goto out_cancel;
+
+	lockdep_set_class(&ip->i_lock.mr_lock, &xfs_rrefcountip_key);
+
+	error = xfs_imeta_commit_update(&upd);
+	if (error)
+		goto out_path;
+
+	xfs_imeta_free_path(path);
+	xfs_finish_inode_setup(ip);
+	rtg->rtg_refcountip = ip;
+	return 0;
+
+out_cancel:
+	xfs_imeta_cancel_update(&upd, error);
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+out_path:
+	xfs_imeta_free_path(path);
+	return error;
+}
+
 /*
  * Check that changes to the realtime geometry won't affect the minimum
  * log size, which would cause the fs to become unusable.
@@ -1196,9 +1249,11 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (!xfs_has_rtgroups(mp) && xfs_has_rmapbt(mp))
+	if (!xfs_has_rtgroups(mp) && (xfs_has_rmapbt(mp) || xfs_has_reflink(mp)))
 		return -EOPNOTSUPP;
-	if (xfs_has_reflink(mp) || xfs_has_quota(mp))
+	if (xfs_has_quota(mp))
+		return -EOPNOTSUPP;
+	if (xfs_has_reflink(mp) && in->extsize != 1)
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
@@ -1349,6 +1404,12 @@ xfs_growfs_rt(
 					xfs_rtgroup_rele(rtg);
 					break;
 				}
+
+				error = xfs_growfsrt_create_rtrefcount(rtg);
+				if (error) {
+					xfs_rtgroup_rele(rtg);
+					break;
+				}
 			}
 		}
 

