Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956D9134BC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000843; cv=none; b=aqaO9Ua/i7hapC9HRJahPVbvmfbkavkQrvDDKu9FBuDkaF/UjXbLEjaciKi+soM5E4G7IlopSJZS2THQPbkSliLgHZsSOIdCNENzsJV5n3kxsjw++v5+9IHJqoqnbLrxbESNNSryzCQBeeihqlWNNQbd31Z6YvT+OlYYtz76mWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000843; c=relaxed/simple;
	bh=0PUlb3sIN/3rPW+RtRNW4EkJMqh0sPN95Bm9VneLfqs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MjALLs3HrKkUVsIWLQDwZ+scK5fpJJEpWf6wkkjOnnAzcafxTecC2BF32lRi97MmsVkavnLvz9w9wVXaD0TUu40hYj1ZmLofNb/QNTKZP3f7Of6O8q+OTn8xzPZcQe4G07vyDidUuIUcEZhH7wMiaf/ugJwatSdf9lKdTQCydF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqYCHuXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqYCHuXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2075FC433C7;
	Tue, 27 Feb 2024 02:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000843;
	bh=0PUlb3sIN/3rPW+RtRNW4EkJMqh0sPN95Bm9VneLfqs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PqYCHuXLFS/0tJxiJZt81u68voH3Mw8WRBkWimcsvl1ewvl/Bp98PT04dgSu4ftJ7
	 5w85c5fErY63Cp3xxKLT9FtujFErYpAf6uZtb/cPn1aVQsXzAueGoY5Vw62wanoe1Q
	 ShR5kh5U6kqSEnernm/vK1GUIFPQ99YVFWzwtj87Dpn1W0rSdbJyoijaR6jow3abC8
	 weU8xX4sliIP2kjbr6VKL5AKywpzk1iqLxBlv3RLmaVBfoaNTK7LKXZtBZVtZqs7T5
	 OsdQWusUQpi2N60eGD36nypZUoWw6JgQ+IMxB3hbfRAsVazxHwxjFUSGR0Lz/fZHqW
	 H+BIA293eXVPQ==
Date: Mon, 26 Feb 2024 18:27:22 -0800
Subject: [PATCH 4/9] xfs: validate attr remote value buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013160.938940.3980607749296840778.stgit@frogsfrogsfrogs>
In-Reply-To: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
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

Check the owner field of xattr remote value blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index b8cdd15c4e1af..3dd0b6b0956c0 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -280,12 +280,12 @@ xfs_attr_rmtval_copyout(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	int			*offset,
 	int			*valuelen,
 	uint8_t			**dst)
 {
 	char			*src = bp->b_addr;
-	xfs_ino_t		ino = dp->i_ino;
 	xfs_daddr_t		bno = xfs_buf_daddr(bp);
 	int			len = BBTOB(bp->b_length);
 	int			blksize = mp->m_attr_geo->blksize;
@@ -299,11 +299,11 @@ xfs_attr_rmtval_copyout(
 		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_has_crc(mp)) {
-			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
+			if (xfs_attr3_rmt_hdr_ok(src, owner, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
-					bno, *offset, byte_cnt, ino);
+					bno, *offset, byte_cnt, owner);
 				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
@@ -427,8 +427,7 @@ xfs_attr_rmtval_get(
 				return error;
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
-							&offset, &valuelen,
-							&dst);
+					args->owner, &offset, &valuelen, &dst);
 			xfs_buf_relse(bp);
 			if (error)
 				return error;

