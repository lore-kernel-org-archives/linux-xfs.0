Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB0D1A4F09
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637173; cv=none; b=r4LtkRWwHsvOuC+Wt/Qqb4HsJPCLX2nY7Hsqk18isCC4KvJA7hfkNUUk0pdJAflra/LqG+MqB1u+1eCzeu1A9c28rPTNzsojFnG0hTE2eNLd2VF+Fmg1/0dc460h8xIwi04vojqqrO17nyBFPcQG0ss0JkubsB6LuHP4uxJefJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637173; c=relaxed/simple;
	bh=XfLvvQd0zYfgque//5sEmPpK2/NcGcBrEB9ZcfHi8eo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOv7b12dIRKcPs3F/+RiVlVTiMfX9SvUp0N9o9mfB29iZHMl0ChvJ1vmXrkWAwaiON+yZ64YI0P20IhZk/5va8o92WzVSN3AUegjgANNKUeD6ZG7Byyx1qahZsxjyRw4/HfBcYzhAPpv7AWw5DXdfguZVP2tqxDNcPy8cBqD4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOCoA6Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOCoA6Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EB7C4CECE;
	Thu, 19 Dec 2024 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637173;
	bh=XfLvvQd0zYfgque//5sEmPpK2/NcGcBrEB9ZcfHi8eo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OOCoA6Do16LC6tX/T+ipfXHaY19RRVdSW8gXAtiFtjnT91BLTDssxWdh1QP3By6Wv
	 8OXdxhaeeQ5rR9qL3IJ7kjuvRaCe39oaeSo3cHCmd9DGvoKM8/1QpSuUWVnLqCELzH
	 IeR7L4TvsKOrF8wD18BpP+iWNkkd28JygVdglyFgu/dCllWpKLIGUFdPb3DUIA4eCJ
	 WCfCcnL6bNB/CSP8n5T6E76rlOAaw9lEQCJTAEeg3RadZm90Zo+2mhXEe9sCYNbup7
	 f4fs5+EnDHoGN/zdc0yiGm2LLiynKScfactPTzn70D0HMI8UUvAaXokSmX3gCQk6Nz
	 rOyJenXgJEjUw==
Date: Thu, 19 Dec 2024 11:39:32 -0800
Subject: [PATCH 25/43] xfs: enable extent size hints for CoW operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581406.1572761.12345015352845968214.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 +++++++-
 fs/xfs/xfs_rtalloc.c     |    5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ae3d33d6076102..40ad22fb808b95 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6524,7 +6524,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 294aa0739be311..f5a3d5f8c948d8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2021,7 +2021,10 @@ xfs_rtallocate_align(
 	if (*noalign) {
 		align = mp->m_sb.sb_rextsize;
 	} else {
-		align = xfs_get_extsz_hint(ap->ip);
+		if (ap->flags & XFS_BMAPI_COWFORK)
+			align = xfs_get_cowextsz_hint(ap->ip);
+		else
+			align = xfs_get_extsz_hint(ap->ip);
 		if (!align)
 			align = 1;
 		if (align == mp->m_sb.sb_rextsize)

