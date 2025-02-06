Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1302417C1
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882982; cv=none; b=mQhVRvKScGQo8xIU5fmn0jWBJzHGdoq10opG5om6Z71FJPhB8DZHDLTN8dmUHO7kigcQBc3zYtNhqPRTr0QYh/EUz1h6mtiU2bImRuqOX7+hK7B7VSzz0XW00ODwmCNMj7IICd8qyiSa+dbyrrwGiNVPL/E3LpoFraU/PZVq6qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882982; c=relaxed/simple;
	bh=kZXwu8SBPkpvp3juig83VzN80kQh0vylPI2V9HzKSwc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ya6hQOHhV7W2I//9gHJ+5pKN7GvvZTuAbI3SZnzkEIe1soWDpKZfKDcujtNG48y0gGg8ojZntbgkFn96yNTzwzm3TxUtE7c9oCNhHJfIW1ulhZup2vHepP+6xccTIyZSeIkqGrH4SB+Cxo/sm/tfWUlGZgC+Rukbp8LCeWPvzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzrCYYqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzrCYYqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD673C4CEDF;
	Thu,  6 Feb 2025 23:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882981;
	bh=kZXwu8SBPkpvp3juig83VzN80kQh0vylPI2V9HzKSwc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GzrCYYqiusMWQ/lrbDAw2qFe+tnH28kKt/Bsz+K7LqxvF2E+48wIj2C/+BTE8esXZ
	 Idny/NAOod/ZJXuuyk+3McPg3LYEyH412rjf5A0WXHuA6zUJ7EqCvhuol+QY1c4xDv
	 Voq0RNuUA1lxaEoVNSL2szzJm/GScrS31sEwZVkKgzKGIRssA68n3eDMT7ebPKhPjk
	 r98arrm2fjXNztrlN6Lh1QYHPOQokTs28lwr1XkcD25BSnhIKVn5TbR2Px9/KZ+Vxn
	 BUwOGubPoRzU1gjzEVb/KuQY7xaLYxaS6c6afoIdHceBdvRuBlZ0Gh8rgEFFxa5N/D
	 JlrZ1qDPHRCPg==
Date: Thu, 06 Feb 2025 15:03:01 -0800
Subject: [PATCH 2/4] xfs_db: use an empty transaction to try to prevent
 livelocks in path_navigate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089633.2742734.3613652081068410996.stgit@frogsfrogsfrogs>
In-Reply-To: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A couple of patches from now we're going to reuse the path_walk code in
a new xfs_db subcommand that tries to recover directory trees from
old/damaged filesystems.  Let's pass around an empty transaction to try
too avoid livelocks on malicious/broken metadata.  This is not
completely foolproof, but it's quick enough for most purposes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/namei.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 00610a54af527e..22eae50f219fd0 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -87,15 +87,20 @@ path_navigate(
 	xfs_ino_t		rootino,
 	struct dirpath		*dirpath)
 {
+	struct xfs_trans	*tp;
 	struct xfs_inode	*dp;
 	xfs_ino_t		ino = rootino;
 	unsigned int		i;
 	int			error;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &dp);
+	error = -libxfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		return error;
 
+	error = -libxfs_iget(mp, tp, ino, 0, &dp);
+	if (error)
+		goto out_trans;
+
 	for (i = 0; i < dirpath->depth; i++) {
 		struct xfs_name	xname = {
 			.name	= (unsigned char *)dirpath->path[i],
@@ -104,35 +109,37 @@ path_navigate(
 
 		if (!S_ISDIR(VFS_I(dp)->i_mode)) {
 			error = ENOTDIR;
-			goto rele;
+			goto out_rele;
 		}
 
-		error = -libxfs_dir_lookup(NULL, dp, &xname, &ino, NULL);
+		error = -libxfs_dir_lookup(tp, dp, &xname, &ino, NULL);
 		if (error)
-			goto rele;
+			goto out_rele;
 		if (!xfs_verify_ino(mp, ino)) {
 			error = EFSCORRUPTED;
-			goto rele;
+			goto out_rele;
 		}
 
 		libxfs_irele(dp);
 		dp = NULL;
 
-		error = -libxfs_iget(mp, NULL, ino, 0, &dp);
+		error = -libxfs_iget(mp, tp, ino, 0, &dp);
 		switch (error) {
 		case EFSCORRUPTED:
 		case EFSBADCRC:
 		case 0:
 			break;
 		default:
-			return error;
+			goto out_trans;
 		}
 	}
 
 	set_cur_inode(ino);
-rele:
+out_rele:
 	if (dp)
 		libxfs_irele(dp);
+out_trans:
+	libxfs_trans_cancel(tp);
 	return error;
 }
 

