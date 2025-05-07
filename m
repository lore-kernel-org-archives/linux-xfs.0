Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC8328AAE0
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746655189; cv=none; b=ZG8SB+wNU/NWaHEELieldpV8XniZ0H3DTftBaJkr9AjwP+r8vSiibbRiqyAlCth5jfno6TD/YUUkoKOpv7OBbl/bxpbTKQWFvki7YggkQIGvQIGmnSZ2dS8gyUol7Dl/cnCySIfgH+xOB5nkk5VsIy9gDtrXSrTX8PCuWRy/MkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746655189; c=relaxed/simple;
	bh=UscFw4CA+OtmNSjYQIdIPQpuAYBinsLuKXUuv6D5ewY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAIkhKc8XshhitfrnH1nCqeQTHHoaHq1RuB3TxtQdjc9KKHQgqGlZueP9nvU5G2Xu0m02Pk/qm43NBaMn43/U/+9JZ01MyhzhHiDflpZPnAnjSc3m7tetyEPwF2W7E1jA9jah9GZpXWaKML/+jmWLvYoK2qQ7bMVvz7q0r/nzok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBYSO756; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBYSO756"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F66AC4CEE2;
	Wed,  7 May 2025 21:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746655189;
	bh=UscFw4CA+OtmNSjYQIdIPQpuAYBinsLuKXUuv6D5ewY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QBYSO756Rb1AtiOK6uZO8C26nhzq3AfAfZRVKWH0DSRlOR6VvweSquoB4wpme8nGr
	 Udn0mxqiJnrizKTeaw/7QHPv1FtSHB6dCtpdhdy7qs64/OrahZI1YM7f208jd3sYf2
	 h9yGILRPpJBi5aANngFgOnGFwJVJJcGA7PqQrp2xF/Wh8wyJWA5CsdKW29qHsBK2Uy
	 /QPO5RYIHKXx4rTRIacaxRmH3ulae4+b60Okz31MKDocgHsBSHPu9eO3nd8DMUrc7s
	 wWmtFPi+EQPMb7DumTAVKYMbVVRAK+1VkrmsnBqSNBYAvboWX4So8nJZ6VWPL8pSq3
	 ma/MDtFx+Nfxg==
Date: Wed, 07 May 2025 14:59:48 -0700
Subject: [PATCH 1/3] xfs: kill XBF_UNMAPPED
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174665514955.2713379.4199575331246748410.stgit@frogsfrogsfrogs>
In-Reply-To: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
References: <174665514924.2713379.3228083459035002170.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a2f790b28512c22f7cf4f420a99e1b008e7098fe

Unmapped buffer access is a pain, so kill it. The switch to large
folios means we rarely pay a vmap penalty for large buffers,
so this functionality is largely unnecessary now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_priv.h   |    1 -
 libxfs/xfs_ialloc.c    |    2 +-
 libxfs/xfs_inode_buf.c |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d5f7d28e08e268..48a84a1089ee47 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -359,7 +359,6 @@ static inline unsigned long long mask64_if_power2(unsigned long b)
 
 /* buffer management */
 #define XBF_TRYLOCK			0
-#define XBF_UNMAPPED			0
 #define XBF_DONE			0
 #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b401299ad933f7..fa9d94abb69862 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -359,7 +359,7 @@ xfs_ialloc_inode_init(
 				(j * M_IGEO(mp)->blocks_per_cluster));
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 				mp->m_bsize * M_IGEO(mp)->blocks_per_cluster,
-				XBF_UNMAPPED, &fbuf);
+				0, &fbuf);
 		if (error)
 			return error;
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5ca753465b9626..4eca3d6dd6a71a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -134,7 +134,7 @@ xfs_imap_to_bp(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
+			imap->im_len, 0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
 				XFS_SICK_AG_INODES);

