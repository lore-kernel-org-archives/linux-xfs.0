Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B8B5680
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301419; cv=none; b=qoU/GQ+D3Idgg0nhAN5pRUsHGcr5NiqMw1vtLsYDrB18Nunp6v2e4jutSCuRzuipvPoKKlFo1KkdcBYTAnDq1Yu6BV9F3IJGMGf4YT75kYDZwvmhzmunSlHDsFR1IjrzAy6b08f1W2Bb7QLAwe8NWilvFXzGDUQ3+TrYL8talYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301419; c=relaxed/simple;
	bh=zvvHylj8DN9zNqk6frhvIz34CSS4wSiIWoAauOBQ7ws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9pBaGUWjxlJVCmypYhCkfoj4s6UlQ49CvxkrcTV8as5q0oAAXvx8xaybWs50LL4yZM5q+ii6NHVcGAP1X8tw1Oo3ToQz8Yl1Dv7GDE6vVcImjZxV05sRGvNcQUtVwGKqPKw1c/5Gz05YIObkjAMGjEb7cjnhKR43gkI9wRVCJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5pZ8f7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5pZ8f7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF17C4CEC2;
	Mon,  2 Sep 2024 18:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301419;
	bh=zvvHylj8DN9zNqk6frhvIz34CSS4wSiIWoAauOBQ7ws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q5pZ8f7hDl2XqZxpH/dNFGekE0zMZz8WQJhGh3Fwc914iD/2nAAw7a/41dlfgUkon
	 5ep0YpAu8SZZGZCYwTks9uf4oWS46vYbwmI+5R1B89lslngcZR5KhPKhUH7FSJbbYW
	 HGxYdNzE1sXxZ5+g/Y4QlBLCHuxQLJ33pXWeFhECxnk/Ec4btnCUBbsOhkGy68ERZR
	 wAfzAzaKcab6Kv3phhqLYle/yxS4SCO+/9J7kxOIcbvTM6Ha26z0fkUSxcvOz7xU5U
	 1jBcLERaJG9E3Ym6NbntjhZrLoUfZPgfdv91uvLp7TAWLkDHjVixzUcEBGcyO+DURN
	 gTJ3FzpCd6VYQ==
Date: Mon, 02 Sep 2024 11:23:38 -0700
Subject: [PATCH 2/3] xfs: match on the global RT inode numbers in
 xfs_is_metadata_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105339.3324987.3663743222940678218.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
References: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Match the inode number instead of the inode pointers, as the inode
pointers in the superblock will go away soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: port to my tree, make the parameter a const pointer]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 51defdebef30..1908409968db 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -276,12 +276,13 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
-static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
+static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	return ip == mp->m_rbmip || ip == mp->m_rsumip ||
-		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
+	return ip->i_ino == mp->m_sb.sb_rbmino ||
+	       ip->i_ino == mp->m_sb.sb_rsumino ||
+	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
 bool xfs_is_always_cow_inode(struct xfs_inode *ip);

