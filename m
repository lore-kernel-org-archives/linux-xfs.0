Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4103418BC1C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837995; cv=none; b=TOw9SxhZgUEtUGIJlpqdCCVp5LCf1BPX6XwFKf4XtiyW9NUn2IPyzs8fVgDoXIQCQGHyG4xRiVnSN03onkTSdLOa+tqxQSrZ54lfs/MsobChGXvt7kP9yjMI+I66p1vgWsid3Gm23BKXshMLzcVZ3QQnIt548Z+QYR9iw341FB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837995; c=relaxed/simple;
	bh=4DS8L5WVIa4gPNTrXKdfv8k0OFViohtUcUB3oluJjQQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAz2kkgA+lpwGn6r/hSyAk9Ao+rL1h13s0mFuoxIL8LZBLJh4NPT6sUm+2v01JgUZFErOMj9TS46Kt6BrvCeMVXAW2nHVgV3AME4AXIiE8Cw66JWALrzu8DIDbSIy/LNiuGIKbjxIXMOfLXYpavLu1dHRgEIVV//dYh9uD+pspQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A68byGc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A68byGc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B74C4CEC3;
	Fri, 25 Oct 2024 06:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837994;
	bh=4DS8L5WVIa4gPNTrXKdfv8k0OFViohtUcUB3oluJjQQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A68byGc6kg3SK92WP4910LDeTdZL+FKKEhk+CXY9i0tJSSaFMltdsrZHHbnMqmbGr
	 SwO0SNqQ23TSjnn/0RVNzHsxoRc9EIadyt25qP1dWqjDUUwuwMQJtA02qUkgI94wuq
	 0i9QmHslGw/rvLW9YuaF30BDctGJXI18gST82pjasqvAuImu5pL5ygWCIJFSQ3G7PR
	 qbSWpxcCJEdAkxgi+fVhi4zdi4Lafeji3Y+90BhgzdfIIFkxhWl82nZQgiuGbx2jpc
	 RdZLSVWh6ZKpwKNj/MQp2xPfCr1vM71DrRE5pILLyElZ5pZs097cJTUx4pcQkiEznw
	 1D0Hf18iyXCmw==
Date: Thu, 24 Oct 2024 23:33:14 -0700
Subject: [PATCH 3/7] libxfs: remove unused xfs_inode fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773375.3040944.3625887079395000900.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove these unused fields; on the author's system this reduces the
struct size from 560 bytes to 448.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h |    4 ----
 1 file changed, 4 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 170cc5288d3645..f250102ff19d65 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -215,7 +215,6 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
@@ -239,9 +238,6 @@ typedef struct xfs_inode {
 	xfs_agino_t		i_next_unlinked;
 	xfs_agino_t		i_prev_unlinked;
 
-	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
-	unsigned int		i_cformat;	/* format of cow fork */
-
 	xfs_fsize_t		i_size;		/* in-memory size */
 	struct inode		i_vnode;
 } xfs_inode_t;

