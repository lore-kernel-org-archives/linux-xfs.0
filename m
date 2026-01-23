Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226FD31D36B
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 07:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151709; cv=none; b=APWAKmDaO5rd1hMFxk/7RDX6rpzCl4zKgQoNQ3j44ZdsRVUO15C6+Wmwm7EQ+C5JSCM4nN5xcIVaoM7XedyCISxFYMF8W2lxMxsX0TcQ+1Fd31t+uSUR1nJVoL8bEws+utI4b09EEr8tmjreIi87X6ZviaTOUQGO/+SVT5O1EsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151709; c=relaxed/simple;
	bh=YziOloBGNUZuCuj3d41OMnjoOJFlZfCIMKVtIPBzu/k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iK/c2q6NmmAfTiC4lYB3oKuy7W+seJ91ABPLMvRGWONgwl79gX4Y1Bxet2tZ1uVIZZ0Wfp9HSelOuy6gnWHLnoGMKppoTeMijnTiIZ9g+FmPz3NcYATuX+o7bAGeaGfp4zr3n25KwNi6jpP1lxqkeb0hlQIP5zEPqGMxOiGbHMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0JDEvpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0JDEvpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88D1C4CEF1;
	Fri, 23 Jan 2026 07:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151708;
	bh=YziOloBGNUZuCuj3d41OMnjoOJFlZfCIMKVtIPBzu/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s0JDEvpJjzXSsUM3nCLOezYu5drb57qrEpu/NoU1XIxHVLfPBOz36BdtCm7iYFYKz
	 PJ7xvpmUIghcMaRRy4IYUIfZ5KLfJFEBSNjeC1hXgyV6PE44d2NLFRBS3P5oRe8+Gk
	 vct4jN018LWIMvL56l0G9aM64pVR3NczcHe/SqwH+ax/cHG4GpS3OA+9aHJXs+lAfo
	 F1PCkcPKXNpRGbtxVVAwu/1ySanonZLjuwQyaSOMBCcdJ0OGXZXd6u5SAK9qNpUamX
	 wPtbKliEKGRm0m06detWiox/mB+vrtidQxv5h9IBSoWaUzHwxxdVrC0BChPxRGLOE5
	 tDM4jhOaH71hg==
Date: Thu, 22 Jan 2026 23:01:48 -0800
Subject: [PATCH 4/6] xfs: strengthen attr leaf block freemap checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176915153096.1677392.8671208552384124901.stgit@frogsfrogsfrogs>
In-Reply-To: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
References: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check for erroneous overlapping freemap regions and collisions between
freemap regions and the xattr leaf entry array.

Note that we must explicitly zero out the extra freemaps in
xfs_attr3_leaf_compact so that the in-memory buffer has a correctly
initialized freemap array to satisfy the new verification code, even if
subsequent code changes the contents before unlocking the buffer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   55 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 776064eac5a090..f10479bf0c8f2b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -85,6 +85,49 @@ xfs_attr_leaf_entries_end(
 			xfs_attr3_leaf_hdr_size(leaf);
 }
 
+static inline bool
+ichdr_freemaps_overlap(
+	const struct xfs_attr3_icleaf_hdr	*ichdr,
+	unsigned int				x,
+	unsigned int				y)
+{
+	const unsigned int			xend =
+		ichdr->freemap[x].base + ichdr->freemap[x].size;
+	const unsigned int			yend =
+		ichdr->freemap[y].base + ichdr->freemap[y].size;
+
+	/* empty slots do not overlap */
+	if (!ichdr->freemap[x].size || !ichdr->freemap[y].size)
+		return false;
+
+	return ichdr->freemap[x].base < yend && xend > ichdr->freemap[y].base;
+}
+
+static inline xfs_failaddr_t
+xfs_attr_leaf_ichdr_freemaps_verify(
+	const struct xfs_attr3_icleaf_hdr	*ichdr,
+	const struct xfs_attr_leafblock		*leaf)
+{
+	unsigned int				entries_end =
+		xfs_attr_leaf_entries_end(ichdr->count, leaf);
+	int					i;
+
+	if (ichdr_freemaps_overlap(ichdr, 0, 1))
+		return __this_address;
+	if (ichdr_freemaps_overlap(ichdr, 0, 2))
+		return __this_address;
+	if (ichdr_freemaps_overlap(ichdr, 1, 2))
+		return __this_address;
+
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (ichdr->freemap[i].size > 0 &&
+		    ichdr->freemap[i].base < entries_end)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 /*
  * attr3 block 'firstused' conversion helpers.
  *
@@ -228,6 +271,8 @@ xfs_attr3_leaf_hdr_to_disk(
 			hdr3->freemap[i].base = cpu_to_be16(from->freemap[i].base);
 			hdr3->freemap[i].size = cpu_to_be16(from->freemap[i].size);
 		}
+
+		ASSERT(xfs_attr_leaf_ichdr_freemaps_verify(from, to) == NULL);
 		return;
 	}
 	to->hdr.info.forw = cpu_to_be32(from->forw);
@@ -243,6 +288,8 @@ xfs_attr3_leaf_hdr_to_disk(
 		to->hdr.freemap[i].base = cpu_to_be16(from->freemap[i].base);
 		to->hdr.freemap[i].size = cpu_to_be16(from->freemap[i].size);
 	}
+
+	ASSERT(xfs_attr_leaf_ichdr_freemaps_verify(from, to) == NULL);
 }
 
 static xfs_failaddr_t
@@ -395,6 +442,10 @@ xfs_attr3_leaf_verify(
 			return __this_address;
 	}
 
+	fa = xfs_attr_leaf_ichdr_freemaps_verify(&ichdr, leaf);
+	if (fa)
+		return fa;
+
 	return NULL;
 }
 
@@ -1664,6 +1715,10 @@ xfs_attr3_leaf_compact(
 	ichdr_dst->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_src);
 	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
 						ichdr_dst->freemap[0].base;
+	ichdr_dst->freemap[1].base = 0;
+	ichdr_dst->freemap[2].base = 0;
+	ichdr_dst->freemap[1].size = 0;
+	ichdr_dst->freemap[2].size = 0;
 
 	/* write the header back to initialise the underlying buffer */
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf_dst, ichdr_dst);

