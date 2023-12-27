Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C4C1370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BO9QWw9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3EFC433C7;
	Mon,  1 Jan 2024 00:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069035;
	bh=lCVF5RLdOQltvxlgsPzE/9FGeKBglWYXN1BY6Xjd+yo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BO9QWw9+v848VodQCNxamzVDhzo3fyLkmYQMFbGoaMBHiAIn6j+vPi68hC1DyDruv
	 YfpshfAPptYWn3wzs1YCfO6oZRC9BdJnGWdlPVx92lY+d/eWBBaUz6iQUfkNXOCEBI
	 CH2TtnzyC6ONAOFqXZ3vzu7+L4zqfIr5qPUkkwPRt3yJD1PMSdRzHNQXHRgPDtsyBq
	 rz+B7SdTsM0BpxGB2pHXtTFUjwEcthwm3vrnnSIF0SAIkYod57WxsoBTfREzSns7Gu
	 DVK05/FbL8CD3kQMMuqXeU7vzvzZ1OFY3z27xOxi7RrF5U+MaakHKRgHHxdHbNgYP1
	 oZIVr+cKl/oKg==
Date: Sun, 31 Dec 2023 16:30:34 +9900
Subject: [PATCH 17/42] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017352.1817107.13522881012218951368.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_bmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9e30b4441c1..c87ca1938ec 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6378,9 +6378,8 @@ xfs_get_extsz_hint(
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

