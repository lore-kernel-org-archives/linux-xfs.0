Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50611C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qBTbPK08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB06FC433C8;
	Sun, 31 Dec 2023 23:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065047;
	bh=zfqWetWiw9Jgn1B6HYOwjphWYbGfJsoo2wvF4AkHkBE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qBTbPK08AE1jj+hdv1tgYAswkHsC+J/Nprfef0pXhl2Tcb7/oNxWOC1xWkUFDQrAH
	 HLh97MijWI/VjLk5Ge8BC2cjubjWym0sIZ3WgTSjwYeX3CF8hZrT+joWLLZM8YmzrW
	 v7V+gW1CH53yCONb1TSe8ZzesEsXyrnEkqT/Mka51n9s5nD2mPEy1D3XikPE7kIs5v
	 B/HqI2I/OB9IqrishFEgmoK0eruhp1OnjlRG00v6JVyluZm08oeg1tFE940naIx7hL
	 6FdTdRt+x3zZWPB9txOitNkUKEzP9Hbsleaua90u2sDywKz/P23Y3G2Pyj+ErkyQIu
	 WMdOw6dZFGuOQ==
Date: Sun, 31 Dec 2023 15:24:07 -0800
Subject: [PATCH 07/28] xfs: implement atime updates in xfs_trans_ichgtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009271.1808635.15703237161852483883.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_shared.h      |    1 +
 libxfs/xfs_trans_inode.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 7509c1406a3..1d327685f6e 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -136,6 +136,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index c171a525cef..c2e5cb26004 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -65,6 +65,8 @@ xfs_trans_ichgtime(
 		inode_set_mtime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CHG)
 		inode_set_ctime_to_ts(inode, tv);
+	if (flags & XFS_ICHGTIME_ACCESS)
+		inode_set_atime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

