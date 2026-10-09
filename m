Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29B73C819C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589945; cv=none; b=jzF6NqWE9v5MisAoeLaG/IB/8ZIKBMfq5cN1YX2St18/G/0LLTOvd0yQ6PUZueymuWoY5ebNrM307UaNbK+OVUjKwyNbz3P2Plp7IY18M4aCdF5jsfky4qRrr4ccGtWjZrCITjjswWTjk0gtUFFiDfRW2jh67jefV2f92O74LUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589945; c=relaxed/simple;
	bh=b70NelmSwVvGcF7kHoCHwUNiUIKZJ5BtLQohrzWWAWc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qAfrGo4ejIi7mhrZ/d3zrGmh2wrWqinnzIBVPqPWmo2z8vkXlt97IcRIEu7OspO1eXlByJLF/0H1HdSOcqemNtkFLs/TtfkECUGKlGaZhQ7wQ0mVbFKG4sEk/7w0nPgA0JFD43EA2CS140r3SVxRcMJn+pjRHWPtpzFNtzg0KU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFE1LPup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFE1LPup"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 771B01F000FF;
	Fri,  9 Oct 2026 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589944;
	bh=aaMxs9z064txA+3vosXkRKbJtIOJJ3AwrmGONw97oNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UFE1LPupJpVLh9pX6ECoQj8KFlhkguriPDgNwkG77yylGZlWqK4iE5UVZpPSGtzct
	 NqbLo+YbMTUO23n+JeGcWlDBdfUSb452sWZbKFeimdbaGYx/iGfGX4LJwwobXdtzXE
	 flOzM91Wo7NJzRbja+H9sqrFpSZFlWPCu0VsBoqiW8DbngM2jIY9DRl35uacJ5NNK+
	 r3NUtJdi5LbhlmQAR6LY5xTJUrBwV5+P8byUGYzIEKhuYVtScC5RWZDyY48IOAx4J1
	 quZDblZoeYthfr1wG6Ho7cuYJmXY5rYkNRPBRhQquPVxfIwJpOZXwPOHL+Solk5/ZX
	 KXzN40YUTxbNA==
Date: Fri, 09 Oct 2026 16:52:24 -0700
Subject: [PATCH 26/26] xfs: fix wild memcpy access when formatting ondisk
 rtrefcount btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947846.3719791.7187049858613978192.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: fe2f9135df43db849e74f03956d322ac20b59af7

LOLLM noticed that the inode btree root formatting methods copy too many
bytes -- there's only one set of keys in node blocks, not two.  This
causes memory corruption of whatever's beyond the buffers.

Fixes: f0415af60f482a ("xfs: wire up a new metafile type for the realtime refcount")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index e2950dbe20681b..dcc89b8e149b05 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -617,7 +617,7 @@ xfs_rtrefcountbt_from_disk(
 		fpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		tpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		numrecs = be16_to_cpu(dblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
@@ -703,7 +703,7 @@ xfs_rtrefcountbt_to_disk(
 		fpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		tpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		numrecs = be16_to_cpu(rblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_rec_addr(rblock, 1);

