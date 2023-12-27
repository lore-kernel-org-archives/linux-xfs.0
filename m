Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF3384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+kEKekY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE364C433C8;
	Mon,  1 Jan 2024 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068128;
	bh=6yD+AX0UYzhIM5pACBzdVjbHZnp1sv4EAZB1/esRCiw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L+kEKekYJxRI8tGt4p/R0DoHZPC8G1nF2njTReVGjbmeo3tetbBWCmqqeyHij03JW
	 uFO/3OYKXe+A0Oq+CpN9sewiEwL0Sr+T9GstyWGR1OfFcdCjNWCmTVMdIEjgj9HvYN
	 YMwT9F4PsZnCVhaWsY1ngpttvQ6pfuyFGDGMUuIPzRCGxvPIagQ3Lq8fahyFmcNcZX
	 6XPvHeG/xGXoZTDFHGTlMp/T311+4TQhhQqH8GNTK6RSfJxJVonlzyIPczZMC5uqR3
	 wlR7lxgRYgyXvmvfmoiCWemJl+GceKvxQkRdSq9OkCH8DtGd1eX8Fi273DjBIcP/9P
	 h4M7xlhv7MV2A==
Date: Sun, 31 Dec 2023 16:15:28 +9900
Subject: [PATCH 19/47] xfs: online repair of the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015565.1815505.17932573368038110051.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Repair the realtime rmap btree while mounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtrmap_btree.c |    2 +-
 libxfs/xfs_rtrmap_btree.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 5a25791baa5..0393da8837a 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -703,7 +703,7 @@ xfs_rtrmapbt_create_path(
 }
 
 /* Calculate the rtrmap btree size for some records. */
-static unsigned long long
+unsigned long long
 xfs_rtrmapbt_calc_size(
 	struct xfs_mount	*mp,
 	unsigned long long	len)
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 108ab8c0aea..5aec719be05 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -202,4 +202,7 @@ struct xfs_imeta_update;
 
 int xfs_rtrmapbt_create(struct xfs_imeta_update *upd, struct xfs_inode **ipp);
 
+unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

