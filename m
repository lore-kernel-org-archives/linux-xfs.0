Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F663433CA
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924414; cv=none; b=h9lcXiIo6SdQwbG+MRqfsmqgFb0/+YYx6FzcDDS3siGP/ONSEv6LA4vf004m1vv/wuf0JBagbGZy03TSaSdj7VbqRLQR5ckdLQV30pvubdntGKONPQmAli+U1Q3kcsw52UsDYilrJoQa+kcnRcREZDKosWWiylnVbeVXn2/4mog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924414; c=relaxed/simple;
	bh=mDfB6FmUeK9ikoz5IKK8Zv6J3ELFKo9YoQQ7CEuWuI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9l6SDGLeKZMOGOGV8siF+fXcuf6WabrUoFC9JQrYG9dnmmL7NhToFoMQETiw6dqJyLKdTIv/GoPBz/eFsmH9Jjj1kzNy0N3ckDQLj53wxIE2UpYjbzL4WEIdEAoHUyoMYhcB/0deMI2ZQplCb+0kTNJgOXMIshGKyMoqLumDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AoVmGdeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AoVmGdeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138DEC2BD10;
	Thu, 20 Jun 2024 23:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924414;
	bh=mDfB6FmUeK9ikoz5IKK8Zv6J3ELFKo9YoQQ7CEuWuI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AoVmGdeuQFHjntSdCUPGcUP3eXwVlWqZNiRC4YHhxHz8Q2M9kp/zJkz+VbVF7ATKE
	 vMNyvAkzs6dy0xm4urqHVmPXiOBBfM7XfKG4oQIfbqu+eLQD++m/sKfzo/m7k9jGA4
	 w1TP+Rijhmjx3ewgBm2ZbrDJPLg/jPz/rvFFeQDwEqFBTEXnHXG6ypaZZLD2EoA73Y
	 le39DMf1byaOT6bkNhWStQ61bjkKZ1cCC/v+n95ZvqPHHPYOes/5jeR4zM4XfedSQx
	 CTQqrZIl82NT70Li4afpZTgukFSuHNXoIF/Gkm69DnE9SxV1HiDlSLtkUiHq75Havf
	 BcbmvTXh6byag==
Date: Thu, 20 Jun 2024 16:00:13 -0700
Subject: [PATCH 07/24] xfs: implement atime updates in xfs_trans_ichgtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418016.3183075.9987831252721662701.stgit@frogsfrogsfrogs>
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

Enable xfs_trans_ichgtime to change the inode access time so that we can
use this function to set inode times when allocating inodes instead of
open-coding it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h      |    1 +
 fs/xfs/libxfs/xfs_trans_inode.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 34f104ed372c0..9a705381f9e4a 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -183,6 +183,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 69fc5b981352b..3c40f37e82c73 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -68,6 +68,8 @@ xfs_trans_ichgtime(
 		inode_set_mtime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CHG)
 		inode_set_ctime_to_ts(inode, tv);
+	if (flags & XFS_ICHGTIME_ACCESS)
+		inode_set_atime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

