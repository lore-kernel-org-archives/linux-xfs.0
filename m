Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2218C8E7
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maRW++zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FDEC433C8;
	Sun, 31 Dec 2023 21:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059434;
	bh=SJKce4HGwJcbnxSceucA7bcghmbQtbaGx7fwItsuGbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=maRW++zrR6EFMgznMrkFM+KDySkxpnlJ3+WKXo7EEE0rdIUsb2u7H5wrB3QYGwt43
	 k2fPhLZABSWp7tvFIFoTNOiaubX8jL/yB4zeQNicbDHXFXWLPswpiLyAMHuI9k5Fhb
	 d/Ab0j1EW3gcQ2oLhw54WgCyhCBPjFwq3C2GdaCKrMPVc/cFdMro7Tuzq1dfD0p1Sb
	 7McHSdd2sUVglKerKHpBkaY4kvXfEUb9uK8NIngoMP4dVvtpx592Ku1pZ1t7TeUt10
	 I+YrfXAhET7eLVqOAgL0EdfcTTXzNupChicTzNo2iMma2poRsYurOnHeKiNYn8Jr8B
	 ZbFWyDxR399Lw==
Date: Sun, 31 Dec 2023 13:50:33 -0800
Subject: [PATCH 23/44] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851951.1766284.12589916918123658780.stgit@frogsfrogsfrogs>
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

Currently, we (ab)use xfs_get_extsz_hint so that it always returns a
nonzero value for realtime files.  This apparently was done to disable
delayed allocation for realtime files.

However, once we enable realtime reflink, we can also turn on the
alwayscow flag to force CoW writes to realtime files.  In this case, the
logic will incorrectly send the write through the delalloc write path.

Fix this by adjusting the logic slightly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 27f992dc6d2d6..316b574b34b8a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6384,9 +6384,8 @@ xfs_get_extsz_hint(
 	 * No point in aligning allocations if we need to COW to actually
 	 * write to them.
 	 */
-	if (xfs_is_always_cow_inode(ip))
-		return 0;
-	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+	if (!xfs_is_always_cow_inode(ip) &&
+	    (ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
 		return ip->i_mount->m_sb.sb_rextsize;

