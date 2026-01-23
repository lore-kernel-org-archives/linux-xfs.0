Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B98A32939D;
	Fri, 23 Jan 2026 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151679; cv=none; b=LHy/uEOnbTWDkHlF5vHecGfpSZLk7Z4aoDbmZR8zrtfAtvBbtxTmel9tgnBATsokNYkL1/QDIHZCRuy6FfkUhRS3egXHx+hEWj6gWuQ2ZDMAuuUj1Evu4Ds8wECI+Sl6mYGY0NKZum0q9fxJFi/Ni8EBXaz7fa5fUaJPY6H8jZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151679; c=relaxed/simple;
	bh=HYxWYWRmXyj98LkZuPDNklezGxy2gyYRKyn4NS0IATQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iOxKFjvZP9GclCwfQVIof+xW1hI2PlcZb2coxdHKY5iZOhxawguFtbTuMFf4knivCystcjICAgOGKNdDIc/zSIXhOYGzD6UNmgeZJJmEv/wvKPRdenaGF84QAdfdOvYcpmOg8JehW4zvuTePmRC1unXygzAD3OYUm7l5BQShx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Do94IyCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Do94IyCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD36C4CEF1;
	Fri, 23 Jan 2026 07:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151677;
	bh=HYxWYWRmXyj98LkZuPDNklezGxy2gyYRKyn4NS0IATQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Do94IyCDQUCzmiDe+lrffQ/WqWSw4AorAW0XHJ6mwt9iVkiEiB7OeIdyZStrhr3Xr
	 nvV7Mc1we6CmLlT8dweY0jl/Ta/SjAUQIeT664e1hn3jVu1opYl8UDJGk2T5CiwSaj
	 2Oqg4KU24CVeV7GPE2KnkB/Yvron1J2ULnTEpawaJBEYJVZ6L/wBQLxwaMmSkBXZuQ
	 dB2qQ5phnxeIaAtaRm64FTW4IiAb01F2F7fMWEUFAVq2wzjryw5oYXwcfwIFqMJ4Od
	 faf6IhPqOx+E7Qxd4AkibK9GNmzr2Sxxhcu3dxMOAZDgJ3o9EB7DpPEwiYHPG6Dhk9
	 ll1XLQgTobwuw==
Date: Thu, 22 Jan 2026 23:01:17 -0800
Subject: [PATCH 2/6] xfs: fix freemap adjustments when adding xattrs to leaf
 blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176915153055.1677392.7504772308180930601.stgit@frogsfrogsfrogs>
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

xfs/592 and xfs/794 both trip this assertion in the leaf block freemap
adjustment code after ~20 minutes of running on my test VMs:

 ASSERT(ichdr->firstused >= ichdr->count * sizeof(xfs_attr_leaf_entry_t)
					+ xfs_attr3_leaf_hdr_size(leaf));

Upon enabling quite a lot more debugging code, I narrowed this down to
fsstress trying to set a local extended attribute with namelen=3 and
valuelen=71.  This results in an entry size of 80 bytes.

At the start of xfs_attr3_leaf_add_work, the freemap looks like this:

i 0 base 448 size 0 rhs 448 count 46
i 1 base 388 size 132 rhs 448 count 46
i 2 base 2120 size 4 rhs 448 count 46
firstused = 520

where "rhs" is the first byte past the end of the leaf entry array.
This is inconsistent -- the entries array ends at byte 448, but
freemap[1] says there's free space starting at byte 388!

By the end of the function, the freemap is in worse shape:

i 0 base 456 size 0 rhs 456 count 47
i 1 base 388 size 52 rhs 456 count 47
i 2 base 2120 size 4 rhs 456 count 47
firstused = 440

Important note: 388 is not aligned with the entries array element size
of 8 bytes.

Based on the incorrect freemap, the name area starts at byte 440, which
is below the end of the entries array!  That's why the assertion
triggers and the filesystem shuts down.

How did we end up here?  First, recall from the previous patch that the
freemap array in an xattr leaf block is not intended to be a
comprehensive map of all free space in the leaf block.  In other words,
it's perfectly legal to have a leaf block with:

 * 376 bytes in use by the entries array
 * freemap[0] has [base = 376, size = 8]
 * freemap[1] has [base = 388, size = 1500]
 * the space between 376 and 388 is free, but the freemap stopped
   tracking that some time ago

If we add one xattr, the entries array grows to 384 bytes, and
freemap[0] becomes [base = 384, size = 0].  So far, so good.  But if we
add a second xattr, the entries array grows to 392 bytes, and freemap[0]
gets pushed up to [base = 392, size = 0].  This is bad, because
freemap[1] hasn't been updated, and now the entries array and the free
space claim the same space.

The fix here is to adjust all freemap entries so that none of them
collide with the entries array.  Note that this fix relies on commit
2a2b5932db6758 ("xfs: fix attr leaf header freemap.size underflow") and
the previous patch that resets zero length freemap entries to have
base = 0.

Cc: <stable@vger.kernel.org> # v2.6.12
Fixes: 1da177e4c3f415 ("Linux-2.6.12-rc2")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 33c6c468ad8d55..b858e3c2ad50a2 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1476,6 +1476,7 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_mount	*mp;
+	int			old_end, new_end;
 	int			tmp;
 	int			i;
 
@@ -1568,17 +1569,36 @@ xfs_attr3_leaf_add_work(
 	if (be16_to_cpu(entry->nameidx) < ichdr->firstused)
 		ichdr->firstused = be16_to_cpu(entry->nameidx);
 
-	ASSERT(ichdr->firstused >= ichdr->count * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf));
-	tmp = (ichdr->count - 1) * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf);
+	new_end = ichdr->count * sizeof(struct xfs_attr_leaf_entry) +
+					xfs_attr3_leaf_hdr_size(leaf);
+	old_end = new_end - sizeof(struct xfs_attr_leaf_entry);
+
+	ASSERT(ichdr->firstused >= new_end);
 
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
-		if (ichdr->freemap[i].base == tmp) {
-			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
+		int		diff = 0;
+
+		if (ichdr->freemap[i].base == old_end) {
+			/*
+			 * This freemap entry starts at the old end of the
+			 * leaf entry array, so we need to adjust its base
+			 * upward to accomodate the larger array.
+			 */
+			diff = sizeof(struct xfs_attr_leaf_entry);
+		} else if (ichdr->freemap[i].size > 0 &&
+			   ichdr->freemap[i].base < new_end) {
+			/*
+			 * This freemap entry starts in the space claimed by
+			 * the new leaf entry.  Adjust its base upward to
+			 * reflect that.
+			 */
+			diff = new_end - ichdr->freemap[i].base;
+		}
+
+		if (diff) {
+			ichdr->freemap[i].base += diff;
 			ichdr->freemap[i].size -=
-				min_t(uint16_t, ichdr->freemap[i].size,
-						sizeof(xfs_attr_leaf_entry_t));
+				min_t(uint16_t, ichdr->freemap[i].size, diff);
 		}
 
 		/*

