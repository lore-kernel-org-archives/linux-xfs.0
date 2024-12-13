Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7158918EA2
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053013; cv=none; b=cKbpZMMag2lC+qviRynFSs+ZNcpb5HiTJRgbjLUL0m5Cz4/Zumd1p/02/5fK4FXGmZDSCjrBVe3fv1Vhloicc+w/lolcTslvd9VsxCXKdyH+Uh9KSr7ZYFr0/sgRLKl+JNvbWDNyddLcze6Ik9nL2XDsu7T5unUXhYlmpcUhDU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053013; c=relaxed/simple;
	bh=tryhAMq0YVG3vdMS3dD/LVsVxxAycb49ibeO25iUKRU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DauRkGezXzArJSBoB44ayX/sz1afxKG1beBFB0mgqeF8t1xhHAiZ3vTVKpIFYRg1qiTYziNYCR6vfQyeQm6sssS3unAa8s7C5CY1zHhbQtScJFRo+lvSN3a1jfOXUKSaTUh7/gdbXBHr6sosoXtkgOr4A9p+cDayOj9yv/laZg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCoyzNzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCoyzNzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49182C4CECE;
	Fri, 13 Dec 2024 01:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734053013;
	bh=tryhAMq0YVG3vdMS3dD/LVsVxxAycb49ibeO25iUKRU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JCoyzNzRQ/hKpyBu3OHStJFJSE4Ttx4xmp9hc6/5SvPSV0xMRXNKWCQdGQRqEenrm
	 8wLeFQbnD4eghi6GaX4eFM6ZGETcmj1fgENjPzihq0iJj7TOZLe3NZHvW6y1jaho9S
	 vnN57avg4mKrPkLrEYrP5/EuLlhKNyZSSxavsQ08Jt9qY4DKYD0LRbyu1UoLkaLTpW
	 AVKGi7cu2bDh5V4t/nLapcFSnKyEykt46aaxYuS40XOXXvViTp0yAqLwa/LN6p89SJ
	 K4AOV8JhhUdVxSnlMVebzp+++gQ21C09piuVyXXw3tnNhgkFwkVkv9IiwOY2iDAWN8
	 yZj7mwRwgAErQ==
Date: Thu, 12 Dec 2024 17:23:32 -0800
Subject: [PATCH 08/11] xfs: enable extent size hints for CoW when rtextsize >
 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125880.1184063.8755676628520114568.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

CoW extent size hints are not allowed on filesystems that have large
realtime extents because we only want to perform the minimum required
amount of write-around (aka write amplification) for shared extents.

On filesystems where rtextsize > 1, allocations can only be done in
units of full rt extents, which means that we can only map an entire rt
extent's worth of blocks into the data fork.  Hole punch requests become
conversions to unwritten if the request isn't aligned properly.

Because a copy-write fundamentally requires remapping, this means that
we also can only do copy-writes of a full rt extent.  This is too
expensive for large hint sizes, since it's all or nothing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 40ad22fb808b95..e1aac1711f553f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6525,6 +6525,28 @@ xfs_get_cowextsz_hint(
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
 	if (XFS_IS_REALTIME_INODE(ip)) {
+		/*
+		 * For realtime files, the realtime extent is the fundamental
+		 * unit of allocation.  This means that data sharing and CoW
+		 * remapping can only be done in those units.  For filesystems
+		 * where the extent size is larger than one block, write
+		 * requests that are not aligned to an extent boundary employ
+		 * an unshare-around strategy to ensure that all pages for a
+		 * shared extent are fully dirtied.
+		 *
+		 * Because the remapping alignment requirement applies equally
+		 * to all CoW writes, any regular overwrites that could be
+		 * turned (by a speculative CoW preallocation) into a CoW write
+		 * must either employ this dirty-around strategy, or be smart
+		 * enough to ignore the CoW fork mapping unless the entire
+		 * extent is dirty or becomes shared by writeback time.  Doing
+		 * the first would dramatically increase write amplification,
+		 * and the second would require deeper insight into the state
+		 * of the page cache during a writeback request.  For now, we
+		 * ignore the hint.
+		 */
+		if (ip->i_mount->m_sb.sb_rextsize > 1)
+			return ip->i_mount->m_sb.sb_rextsize;
 		b = 0;
 		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
 			b = ip->i_extsize;

