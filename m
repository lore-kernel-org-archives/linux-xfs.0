Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F044A13A402
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441131; cv=none; b=Lf7VpGooZiMkA/ZB8crBTR9fzfMKoKJPvdHJl9uWfOhXaYiYtvP9hICMrHiBSYFic75mxc9IAWGc4HovH+QLG11isi86NsiL7sDB4Ryddad+OVlgpxf4PyFkcu5q/bacd0sBlP7QMwqfKlEzI9/Q7nn0QxfDDaHoxmMjBdP7wAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441131; c=relaxed/simple;
	bh=IbD85zCOTmOvEUJeLcQy8+IhZk/nadMjI/+gy8Bj+IY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+Tugc7Ok6gRR40gQ/dkMTV9c/QK/QRQ0npUzTFLz9Ag41dp67CX1z2v7EptwLzqnp0q3hVNbMfs6l2oLwu1ATSrhLTFZwROb6osrSgyV2Wl9PhnSuhP6qpyEjd75JPtaGK377TqbmrDs+PUmHIAWCLLu3cPTD6FyyPd8YkBL7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILyJ2gp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILyJ2gp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60124C2BD10;
	Mon,  3 Jun 2024 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441130;
	bh=IbD85zCOTmOvEUJeLcQy8+IhZk/nadMjI/+gy8Bj+IY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ILyJ2gp2bNhI/yXzePgG2Pr4suzAJZM4aYYAfRkvyF6fjFHS5/q2ajB2kXVajzcsz
	 nqh142zmTQlmXU8lg2csae3xMo51LyrcwJNoVy19vztOm+SVColiV77dVbeZezwRk1
	 4sAqkzLyZ7n1jpowUz+OCcpzZ5a38RPU58tjWV8tWDPX0DuRSKBJi99r71kXePiT5V
	 WRD0ax2Nmt2T/M2a6N5c7mdb4oJOE0pRmzFrGZrUXh2KAv/pHPXX6KGVDsfosX/7Zz
	 g4zOy73x7/OifQs+ZEtq53VpYxfH72u+LW4AWjzEJ0IrQqlTICjDco7bhAmhNJXH4S
	 F/w/79zwiVB8w==
Date: Mon, 03 Jun 2024 11:58:49 -0700
Subject: [PATCH 026/111] xfs: remember sick inodes that get inactivated
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039761.1443973.1881665188275821661.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0e24ec3c56fbc797b34fc94073320c336336b4f9

If an unhealthy inode gets inactivated, remember this fact in the
per-fs health summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_fs.h        |    1 +
 libxfs/xfs_health.h    |    8 ++++++--
 libxfs/xfs_inode_buf.c |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 515cd27d3..b5c8da7e6 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -294,6 +294,7 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
+#define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 032d45fcb..3c64b5f9b 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -76,6 +76,7 @@ struct xfs_da_args;
 #define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+#define XFS_SICK_AG_INODES	(1 << 10) /* inactivated bad inodes */
 
 /* Observable health issues for inode metadata. */
 #define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
@@ -92,6 +93,9 @@ struct xfs_da_args;
 #define XFS_SICK_INO_DIR_ZAPPED		(1 << 10) /* directory erased */
 #define XFS_SICK_INO_SYMLINK_ZAPPED	(1 << 11) /* symlink erased */
 
+/* Don't propagate sick status to ag health summary during inactivation */
+#define XFS_SICK_INO_FORGET	(1 << 12)
+
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
@@ -132,12 +136,12 @@ struct xfs_da_args;
 #define XFS_SICK_FS_SECONDARY	(0)
 #define XFS_SICK_RT_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
-#define XFS_SICK_INO_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
 #define XFS_SICK_RT_INDIRECT	(0)
-#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 83d936981..82cf64db9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -136,7 +136,7 @@ xfs_imap_to_bp(
 			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
-				XFS_SICK_AG_INOBT);
+				XFS_SICK_AG_INODES);
 	return error;
 }
 

