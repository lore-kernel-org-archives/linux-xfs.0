Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BF9652
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817553; cv=none; b=FW1+7OjAtzJV/QutFu1Gw2pTLfV7dLVd4tMOUTjCWRcw2bzpwRy0fYGlLunVZVQVLCSqER7SSAxg3WXcvqP2o5sjLxrUUkJbkK+JVoQA7PwQCXS/dIO24JMEAibcvwtMHSBsbnhgw9E9W79YtinGyW8/u6r/Cw5pZuHLSViukbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817553; c=relaxed/simple;
	bh=TYtYm/LVlKGEXyt928pmIa6ETqGNtz5Uo2m/EyH0XlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQyXFzTMqZPmcfGp71/h9LGaUIBxqpE4YsGJ6h+RMN7GOaa622jZOJZ85VGAN39UpRUwMFtQ4LsAFP6LsJ0v2gaQsBtbtUp9dOhK/9S/ztxtlmlsR5+5U5ZDabH027duUf2HY+HQMFLVsCj0opyjiFc64s4ZAn+jtrvjq8AEM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKg0AONk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKg0AONk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F961C433F1;
	Thu,  1 Feb 2024 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817553;
	bh=TYtYm/LVlKGEXyt928pmIa6ETqGNtz5Uo2m/EyH0XlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SKg0AONk76cYr3LFVGUsJsev6kDp0/ncCSizR7TeKj7IpNigfkjwjK7iBrPRJayih
	 +EBFWnacntjK/pL/6bbYh2LhfuNMapW0K5wLhy/UwTEgN8dElTR2fuPQbNFdL9iaQV
	 QDV4D1FAbKBZ//LsTKQlafWvbS9X7slQ5hYwxp9kdXWhVoxrQ5oegtDldsIXsE7D3S
	 6EZQ7K0w8EwwjOjsqGhqNdi5f2jZ6bzcyq/aNjg1fTVCtPiBPVUr78d3oTH8uiBIzT
	 PmKm9bwrjd33dItMGRgC7dgqsym6VAb9FMYFqqUS/zerfMrMfX6avZA5NZKMSFYiX8
	 pDy6QN5myNByg==
Date: Thu, 01 Feb 2024 11:59:12 -0800
Subject: [PATCH 2/5] xfs: create agblock bitmap helper to count the number of
 set regions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337456.1608576.11464579397615876665.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
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

In the next patch, the rmap btree repair code will need to estimate the
size of the new ondisk rmapbt.  The size is a function of the number of
records that will be written to disk, and the size of the recordset is
the number of observations made while scanning the filesystem plus the
number of OWN_AG records that will be injected into the rmap btree.

OWN_AG rmap records track the free space btrees, the AGFL, and the new
rmap btree itself.  The repair tool uses a bitmap to record the space
used for all four structures, which is why we need a function to count
the number of set regions.

Christoph Hellwig requested that this be pulled into a separate patch
with its own justification, so here it is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agb_bitmap.h |    5 +++++
 fs/xfs/scrub/bitmap.c     |   14 ++++++++++++++
 fs/xfs/scrub/bitmap.h     |    2 ++
 3 files changed, 21 insertions(+)


diff --git a/fs/xfs/scrub/agb_bitmap.h b/fs/xfs/scrub/agb_bitmap.h
index ed08f76ff4f3a..e488e1f4f63d3 100644
--- a/fs/xfs/scrub/agb_bitmap.h
+++ b/fs/xfs/scrub/agb_bitmap.h
@@ -65,4 +65,9 @@ int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
 int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
 		struct xfs_btree_cur *cur);
 
+static inline uint32_t xagb_bitmap_count_set_regions(struct xagb_bitmap *b)
+{
+	return xbitmap32_count_set_regions(&b->agbitmap);
+}
+
 #endif	/* __XFS_SCRUB_AGB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 1449bb5262d95..0cb8d43912a84 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -566,3 +566,17 @@ xbitmap32_test(
 	*len = bn->bn_start - start;
 	return false;
 }
+
+/* Count the number of set regions in this bitmap. */
+uint32_t
+xbitmap32_count_set_regions(
+	struct xbitmap32	*bitmap)
+{
+	struct xbitmap32_node	*bn;
+	uint32_t		nr = 0;
+
+	for_each_xbitmap32_extent(bn, bitmap)
+		nr++;
+
+	return nr;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 2df8911606d6d..710c1ac5e323e 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -62,4 +62,6 @@ int xbitmap32_walk(struct xbitmap32 *bitmap, xbitmap32_walk_fn fn,
 bool xbitmap32_empty(struct xbitmap32 *bitmap);
 bool xbitmap32_test(struct xbitmap32 *bitmap, uint32_t start, uint32_t *len);
 
+uint32_t xbitmap32_count_set_regions(struct xbitmap32 *bitmap);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

