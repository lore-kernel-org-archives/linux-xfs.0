Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2E1F3B98
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393155; cv=none; b=GxTEnr09tvC9kTRWGYVMf+aK99KW2TNhaytSCfMJtnAjIYFsYYmSYSJw/xSP5DRSdcoN1LXGveGYDymokbAZPIUJP40G/zzQBUprGSE+U76udXwgvyqw8fRJg0ygktq47tbKlI3FrPHFQCNARqnRr8hBMNFZcY1SQCYt+iI0CPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393155; c=relaxed/simple;
	bh=4yKl9Jfzm/Luy//bvyd36gZQVIGLGo9tNOPZ8NLoYjI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2WumZw91AKAN/CKeIolDSVhab2XHSdX7PVHum0XaHZEzFPNZCaZN7AY3i8RkUTSq6J0N/6GdpOgZ0S6eH7ZXqJdQTtTH3cxGwRsd6ol/jKn+BpZ5UcMXGuAGadUmGl8WEfdDPMr0SyZVjgh85LKkTzQAeQ5XB+2PFDVeD2GSH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tugokgcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tugokgcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF36C4CEEF;
	Tue,  1 Jul 2025 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393154;
	bh=4yKl9Jfzm/Luy//bvyd36gZQVIGLGo9tNOPZ8NLoYjI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tugokgcw+oi6+0zoL/b5rSz4AkXOjrvO+YWHUp3oSU/FkZDuZkMWilASw6nOqmwdr
	 oFvjA4eIvoUcogdcB/F+6euwOpDnYtlVZxvd+BBrKp2FmrDiYdihDwLAxAlCBv/jU9
	 5wJASBdJqQkUq8OCsH3FtPH5iNz9c//vTBLAj3Bilms1pCXWsDjPF2HveSbAONQi6V
	 jfrb8twI+XU3mGSV1W5I7gtysphlVm7hTaJrqO/Em00DgNDhLezysZmspxifevQf+6
	 B5wCy7AXyaGQiu1FjFGFilBGyHZs8kdX9WllMb9rSVWFktKq03donRYRyDMSHu1Yy1
	 Xqt0cPV3OzWag==
Date: Tue, 01 Jul 2025 11:05:54 -0700
Subject: [PATCH 2/6] xfs: allow block allocator to take an alignment hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175139303530.915889.1612902381629024819.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
References: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: John Garry <john.g.garry@oracle.com>

Source kernel commit: 6baf4cc47a741024d37e6149d5d035d3fc9ed1fe

Add a BMAPI flag to provide a hint to the block allocator to align extents
according to the extszhint.

This will be useful for atomic writes to ensure that we are not being
allocated extents which are not suitable (for atomic writes).

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 libxfs/xfs_bmap.h |    6 +++++-
 libxfs/xfs_bmap.c |    5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index b4d9c6e0f3f9b6..d5f2729305fada 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -87,6 +87,9 @@ struct xfs_bmalloca {
 /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
 #define XFS_BMAPI_NORMAP	(1u << 10)
 
+/* Try to align allocations to the extent size hint */
+#define XFS_BMAPI_EXTSZALIGN	(1u << 11)
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -98,7 +101,8 @@ struct xfs_bmalloca {
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
-	{ XFS_BMAPI_NORMAP,	"NORMAP" }
+	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
+	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3cb47c3c8707db..99f5e6f9d545a4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3306,6 +3306,11 @@ xfs_bmap_compute_alignments(
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (ap->datatype & XFS_ALLOC_USERDATA)
 		align = xfs_get_extsz_hint(ap->ip);
+
+	/* Try to align start block to any minimum allocation alignment */
+	if (align > 1 && (ap->flags & XFS_BMAPI_EXTSZALIGN))
+		args->alignment = align;
+
 	if (align) {
 		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev, align, 0,
 					ap->eof, 0, ap->conv, &ap->offset,

