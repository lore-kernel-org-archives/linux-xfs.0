Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E017BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pDcXCOVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B54C433C8;
	Sun, 31 Dec 2023 21:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056539;
	bh=DPAiD8aK7Ishw8emOMqMUgDUKAdEX7faC1/+Y4RVxPg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pDcXCOVOertIIykdK8uTMVVIWu6CaU127qPS53muZmH/RoeFcXbKVcr9NHkSkReqw
	 YpLJuKKHSWmYLD/0O3CWaA9MYlO6i4XGtREsv8siL5Fl+BVJ+i9ltEGUxXvINhrdvG
	 dUNT+rmcB+y3STiRtmvT4ay5/6sIpBvs8Rh5qISzO2dwV70j+ciseTMVodeDgjczm1
	 DcRjT9QXINXu0+OJfYowXDdnIeJSZozVZ/5d+e1g+cOkmjXXXdlssoi11SSgGKOESx
	 kL9FtTvUWI+CU6N9jpzuJD8Ip5RxHRteeDDz1XKtlk8Z00wqV3deTpVQTyw+6isJeI
	 G+MV0qsHBNITg==
Date: Sun, 31 Dec 2023 13:02:19 -0800
Subject: [PATCH 06/21] xfs: implement atime updates in xfs_trans_ichgtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844149.1759932.1825493424849305743.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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
index 7509c1406a355..1d327685f6ee3 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -136,6 +136,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 70e97ea6eee7c..94c235fff7461 100644
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

