Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F419C540
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497059; cv=none; b=BhQcMOVkU/vur4rNhrFgJp3umDiU4CT6VhJ5Y2kSqDOrbfFvqG0w5Mwrt598DNgqRX7Is/g4UskbyrBD4pxY5/gNbjuUu/uYUE6JmGQub5+S0NqpECJ7TAzciTViaGUR3KFMY04WH4frFz+LQrnJ6WOmIR4INHNZJc8/GFJHp/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497059; c=relaxed/simple;
	bh=oaKd7fVZzogP7aL9d1E1mAcf0zUSCvzh51Nxzdij1ro=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozpFIyi2wptHLh+gWIE8h4z65lAIVGG/yaQ+/o8G8NqdCIy77O22L7hfTScA54ViDEMR9A2xf7WgZYbbiSWypLi/j44uneL95xxlDGN0vONjDrzS1lePIkG52ifn2cLJ6vrP5qTL41NzdxSt1wMpXq4okrBC1EgbobGQvVNHDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agJe7Y/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agJe7Y/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AED2C2BC86;
	Tue,  3 Mar 2026 00:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497059;
	bh=oaKd7fVZzogP7aL9d1E1mAcf0zUSCvzh51Nxzdij1ro=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=agJe7Y/OV2Q+2CcRFzE6AuHfpJy7IV+wBqzsY1wPeINQOmnWL+BocFVn7+4JMZ9GF
	 E/MctKF4lbLxGLDg37QzobQ493lhOGiuyIrn6FGXB7DkZYkJgafq6mfSMn0JaMV2pz
	 FGKE6am5z+0LLxj7wd9pkeFAq3NTj1Y60rMXSdNOtqiLt2vs9H44lXGEJmvUwr4VG/
	 F7TxDO8PDCbcwA2p3OUheaKwn0eDwkQsC9Yft4UehiGlatfuu/Q3q1BRcFqHWawNhe
	 LNf+egPIcqUg7k+PKyG0EiImyNV//EvqNT7tr79VnaMdQvyNniBm6ErQJTeM7Ggtct
	 4+ff9ef+fG6bQ==
Date: Mon, 02 Mar 2026 16:17:38 -0800
Subject: [PATCH 21/36] xfs: strengthen attr leaf block freemap checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638164.457970.15632258495528603684.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 27a0c41f33d8d31558d334b07eb58701aab0b3dd

Check for erroneous overlapping freemap regions and collisions between
freemap regions and the xattr leaf entry array.

Note that we must explicitly zero out the extra freemaps in
xfs_attr3_leaf_compact so that the in-memory buffer has a correctly
initialized freemap array to satisfy the new verification code, even if
subsequent code changes the contents before unlocking the buffer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_leaf.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 158864249c8888..f591984c3748ff 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -82,6 +82,49 @@ xfs_attr_leaf_entries_end(
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
@@ -225,6 +268,8 @@ xfs_attr3_leaf_hdr_to_disk(
 			hdr3->freemap[i].base = cpu_to_be16(from->freemap[i].base);
 			hdr3->freemap[i].size = cpu_to_be16(from->freemap[i].size);
 		}
+
+		ASSERT(xfs_attr_leaf_ichdr_freemaps_verify(from, to) == NULL);
 		return;
 	}
 	to->hdr.info.forw = cpu_to_be32(from->forw);
@@ -240,6 +285,8 @@ xfs_attr3_leaf_hdr_to_disk(
 		to->hdr.freemap[i].base = cpu_to_be16(from->freemap[i].base);
 		to->hdr.freemap[i].size = cpu_to_be16(from->freemap[i].size);
 	}
+
+	ASSERT(xfs_attr_leaf_ichdr_freemaps_verify(from, to) == NULL);
 }
 
 static xfs_failaddr_t
@@ -392,6 +439,10 @@ xfs_attr3_leaf_verify(
 			return __this_address;
 	}
 
+	fa = xfs_attr_leaf_ichdr_freemaps_verify(&ichdr, leaf);
+	if (fa)
+		return fa;
+
 	return NULL;
 }
 
@@ -1661,6 +1712,10 @@ xfs_attr3_leaf_compact(
 	ichdr_dst->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_src);
 	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
 						ichdr_dst->freemap[0].base;
+	ichdr_dst->freemap[1].base = 0;
+	ichdr_dst->freemap[2].base = 0;
+	ichdr_dst->freemap[1].size = 0;
+	ichdr_dst->freemap[2].size = 0;
 
 	/* write the header back to initialise the underlying buffer */
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf_dst, ichdr_dst);

