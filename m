Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E792D3758
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556615; cv=none; b=O3ai2zunmnM7cHH7Ad/5NMnVSvXoNKtGo4ilwr+u2/jIzWk4rZy3WP0pregAyItrEzO6zSd52oTFLzEQuvXvUH4ZnXYEpB8d0H0/URwQoNQUkdafF1j/buWGt/amKcY9OJ0194AXmhGTlWOZ2JOug5SRSMu0E/PrSIyC6eUmBVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556615; c=relaxed/simple;
	bh=4yKl9Jfzm/Luy//bvyd36gZQVIGLGo9tNOPZ8NLoYjI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjGfIRmgybKq0GFYSZYhdCDaZWKvrXhdtOK4+X3lQMGUfugpNaHB40HHy9TzeaVBTVR7m/grzbeShQP8r8hWbHBPjuVEELr8ntbRPOsYXW3sJiWf/Aii8dh3JtswW2j+r/iJhZFKs3jTGHEF5YpOyL9y4BdzDT96VuDaZ3ZCreg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ce//c1Tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ce//c1Tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B50C4CEE3;
	Tue, 15 Jul 2025 05:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556613;
	bh=4yKl9Jfzm/Luy//bvyd36gZQVIGLGo9tNOPZ8NLoYjI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ce//c1TjnmtpG/jhXv/eIeF3HCtCE/3ZanWiviDk8J2UFG4iXrrWAuhTRp9tqJLMa
	 wTgjlQFV44lPF9XRIJewNfu0iuFA21jlhBqeK4+FmLDn8w35glFqcNzxNfZUm0u6rl
	 UxXTn/k2Mk9BcmB+/DOv0r+TU97wOOJ5baBdEPPVNytoCFHIdEfHFwfsACTp8BPk84
	 wATmZp4PNwZzQg0gjquhGFUK2ekf0OFIaH/WeUb/XpDv8meePDtsk3i1tcsDGmdY3H
	 leEXhymUMMTBpUxc7RYXmkziKqO+uN58+hFKY+qfEMvtDdF8IizdkYNLKx/d6HAzeR
	 SG/mPypu71WoA==
Date: Mon, 14 Jul 2025 22:16:53 -0700
Subject: [PATCH 2/6] xfs: allow block allocator to take an alignment hint
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652148.1830720.13532788787241368159.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
References: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
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

