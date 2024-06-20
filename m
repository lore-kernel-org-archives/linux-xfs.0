Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2116F085
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924321; cv=none; b=QWBJ42sy9dkxSewCQ8GjPJsnCC4V0iS1dDO+jqehTGcyQyHyzQoZ4iAwIoCvQnHu4n4fousCp6o0djtH6kry1eG5s518jc6bx0Pz9oOMKwgB07YCFvV7M1dcA86+iR1BWBNjnTi/XYNwQBmV/WZ+/sMMUj8AV17DzI6tFEkLOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924321; c=relaxed/simple;
	bh=FQKasbbOJh4eUgQswplqIC0wbIsww8Q1E681u8rygOc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UV5BInvUj1yhXGz2AAO2Reouc11VAEM3xtwxq92ECWlV16jB6ODT1AynBrSXDAjgZIkXanCwEd+7nCgnVckLKdjVXUHbLSM79ygMb/CUTgZA3Fq/SeNPUGjzUx8Bq+BMoVENurBhl3jLt/veCdXNj0dBlwtc+XFi+EabuCyTCSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToATMcCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToATMcCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40298C2BD10;
	Thu, 20 Jun 2024 22:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924320;
	bh=FQKasbbOJh4eUgQswplqIC0wbIsww8Q1E681u8rygOc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ToATMcChXtHBwyNULKwFrhl0S41cdy4TqwdC/sNvR9GC3B3tgLNc2VUC97i36Auwt
	 GeVGVwnpHVaAh5k3FEl0lUglTBXN7iCjjaEKX4wrJTV1P/nCNybur93Iob3Ku10Kj1
	 AwowOfzeAgCetFwdpGvk8BLTEP7HPrm1NtDc7VEQWw341yEazwlCU+m0UTtZU0ObKs
	 0Ltkwhm0mg4vI65j6hq118/6sMIsubC+Z7WZp94njeSj6FTPtFl5D03wvLvbV8Y+Y4
	 PsRHQuOENiF3IfyA7quyT+bXgfopXKiYfavux+hTkkrXpIlamfmBfEY91n0I8sYOGY
	 TBUHf1OKtE5xQ==
Date: Thu, 20 Jun 2024 15:58:39 -0700
Subject: [PATCH 01/24] xfs: use consistent uid/gid when grabbing dquots for
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417910.3183075.14464477192227662952.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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

I noticed that callers of xfs_qm_vop_dqalloc use the following code to
compute the anticipated uid of the new file:

	mapped_fsuid(idmap, &init_user_ns);

whereas the VFS uses a slightly different computation for actually
assigning i_uid:

	mapped_fsuid(idmap, i_user_ns(inode));

Technically, these are not the same things.  According to Christian
Brauner, the only time that inode->i_sb->s_user_ns != &init_user_ns is
when the filesystem was mounted in a new mount namespace by an
unpriviledged user.  XFS does not allow this, which is why we've never
seen bug reports about quotas being incorrect or the uid checks in
xfs_qm_vop_create_dqattach tripping debug assertions.

However, this /is/ a logic bomb, so let's make the code consistent.

Link: https://lore.kernel.org/linux-fsdevel/20240617-weitblick-gefertigt-4a41f37119fa@brauner/
Fixes: c14329d39f2d ("fs: port fs{g,u}id helpers to mnt_idmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |   16 ++++++++++------
 fs/xfs/xfs_symlink.c |    8 +++++---
 2 files changed, 15 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aa134687027ca..5039509785090 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1059,10 +1059,12 @@ xfs_create(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1234,10 +1236,12 @@ xfs_create_tmpfile(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 17aee806ec2e1..53ed512c6f211 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -122,10 +122,12 @@ xfs_symlink(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)

