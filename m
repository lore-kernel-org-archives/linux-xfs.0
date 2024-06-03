Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6246259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441255; cv=none; b=GD61uaBgevumTY+Wf4zxhmZW4b7R/qGRWsBpddy9XWbTnX5LRQGNNai8Al280ToFvG93y680Av20iPp/WhDDQK1Ydy7M46Wt0KC31NuIu5wV0pTNr8EF7dq2Dzkd1hBOZl3qqUVY/dw+VzwBX/fwWe60ngdvyKUfd0QYWNRuD/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441255; c=relaxed/simple;
	bh=eqdgk3ZukKnH0BUviZhYwku7zc+mdxLStTgZ8sABuHY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sko3LA7wNnNuuN+aBpaAGnjKKqqlhDmQRa1dTtroroMOSJkPf2SUJLsowNSVOHktwSGjrRd9Sdvjfib98HSH5MzWKzDpkKvhYg1oYNMBb5UOXv85ieILewO7GWDSxiQ8SaP5lkQPZlXOx1ss4o7qRXD0YBzhNVlW2xvUyc/T4Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTTQ+o8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTTQ+o8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF902C2BD10;
	Mon,  3 Jun 2024 19:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441255;
	bh=eqdgk3ZukKnH0BUviZhYwku7zc+mdxLStTgZ8sABuHY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aTTQ+o8Ro7Gn9gRCRBj60NMy006pDXiaaijy6B9S9gcqSZZzv4Bl7rp73x9WTmFbQ
	 /rHbbMLXCbWAkKUhjD0NrYNfJKZM0zQU6Fqz19vLqVfoLW4lWlLTtjUzT3bRIVhC7g
	 COwoBMMuVbm+u0utr/qIpWcBfeEGLT+j6+Xv11VPqXv7H62MSDsryabkFjpGlv2vXZ
	 EldfMCVDGt4IldLUa4u70BRHmA+F/HFoZpOus9P+WpeoXmd9AKF+J5PhzJrSMaY+qe
	 27rIepzRQaGTgyoSlVN5rg7/feWTTI1KNvTA0DX7/ZhnvK9sAQrKr54+kWbGMQAbQi
	 AIQkC/+r4Fw9Q==
Date: Mon, 03 Jun 2024 12:00:55 -0700
Subject: [PATCH 034/111] xfs: consolidate the xfs_alloc_lookup_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039882.1443973.6363205776295128653.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 73a8fd93c421c4a6ac2c581c4d3478d3d68a0def

Add a single xfs_alloc_lookup helper to sort out the argument passing and
setting of the active flag instead of duplicating the logic three times.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_alloc.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3d7686ead..458436166 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -147,23 +147,35 @@ xfs_alloc_ag_max_usable(
 	return mp->m_sb.sb_agblocks - blocks;
 }
 
+
+static int
+xfs_alloc_lookup(
+	struct xfs_btree_cur	*cur,
+	xfs_lookup_t		dir,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	int			*stat)
+{
+	int			error;
+
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	error = xfs_btree_lookup(cur, dir, stat);
+	cur->bc_ag.abt.active = (*stat == 1);
+	return error;
+}
+
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
-STATIC int				/* error */
+static inline int				/* error */
 xfs_alloc_lookup_eq(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
-	int			error;
-
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
-	return error;
+	return xfs_alloc_lookup(cur, XFS_LOOKUP_EQ, bno, len, stat);
 }
 
 /*
@@ -177,13 +189,7 @@ xfs_alloc_lookup_ge(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
-	int			error;
-
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
-	return error;
+	return xfs_alloc_lookup(cur, XFS_LOOKUP_GE, bno, len, stat);
 }
 
 /*
@@ -197,12 +203,7 @@ xfs_alloc_lookup_le(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
-	int			error;
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
-	return error;
+	return xfs_alloc_lookup(cur, XFS_LOOKUP_LE, bno, len, stat);
 }
 
 static inline bool

