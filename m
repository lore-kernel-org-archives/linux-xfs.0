Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A133F195B1A
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 05:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791263359; cv=none; b=sDO2dSgR3q6erJ1D1NjxoXkHVAJQo/5AFpjVbZB4XrZ1rZV7VnblA8NPk4CYzNXgHBnSHuGxcU8BX+zVgs1tS+E8pXx9RVcseAXZt3tzvlsnOO/RNPendt2k9/0wIMHEPSSLSxOoqYtGvba5ZINBWtaFKthfc/oezaD36v24osU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791263359; c=relaxed/simple;
	bh=+dKv975MyPVJ8U3SkEVnYN8ZQ6FSDwz8aZXfmx9mzAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Urst9ZV9K4qdP+HSnHlctEwov6KeQbC/Q1Xm0Q883za/8h+2XxlALcrNBq839/ZQhrl6oa1HvvNisQVT9UBDfaaF+N8zznZAsjJPkWbznWatJO/aZvvapcjfWnzfUTLvfjMKGa6iSy/PP6QPEOXyebfIFFHaMnPeATk5uwjKKkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbOnz8I2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbOnz8I2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E72E51F000FF;
	Tue,  6 Oct 2026 05:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791263355;
	bh=+DosiBf59/HOmIZKVYzqPIdSB6ciTpPRoVyIgWhWpjw=;
	h=Date:From:To:Cc:Subject;
	b=kbOnz8I2czd2+ycLBjsJc1HIT47Q21XoFmKw9G8WoCMylMv8lELeFnUvyXYm9HQ2U
	 OOg8jrsAFWsbtx8G4xS44L4AXqD5zliFQZGVyorKngMF5VUxgQzCN2sQkciuid53Wg
	 pa1ZNt7qltD4aCsiuPY3vt1DeEiZuvXMX0PBLcaIOLE9Esaf7FDS1ZNIFJ8okkKByg
	 fRd6XcP9ebUb3s3JjlTTKRNqDwNewrWAPCzAzVxB13Qnd5nANF4aagcqYRoFO+ZLfG
	 Z+oy1Jy+R9Y754cIpkyfsYIAIgJi2x2+cjPQEuWpxPkgT0Qd1qRZlxh8SytfmvgVEL
	 /S9T63B2REbiA==
Date: Mon, 5 Oct 2026 22:09:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Norbert Szetei <norbert@doyensec.com>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix exchange-range-to-eof file size exchange
Message-ID: <20261006050914.GU2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Norbert Szetei posted a patch containing an incomplete description of a
bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
exchange-range into modifying a file so that it has shared blocks
starting beyond EOF, which is never allowed because files never have
written data beyond EOF, and you can only share written data blocks.
This is key to all the incorrect behavior that follows.

Eventually I got from Norbert a description of what's going wrong:

> Fair. Here it is with physical block numbers, 4k blocks. peer is the file
> that gets rewritten and file1 is the one that ends up with the flag
> cleared.
>
> Start, nothing shared:
>
>	peer size 4096   -> [100]
>	file1 size 12288 -> [200] [201] [202]
>	donor1 size 4096 -> [300]
>	donor2 size 4096 -> [400]
>
> 1. FICLONERANGE peer's block into file1's middle slot:
>
>	peer size 4096   -> [100]
>	file1 size 12288 -> [200] [100] [202] reflink flag set
>                             ^^^^^ both files own block 100
>
> 2. XFS_IOC_EXCHANGE_RANGE file1 against donor1, file1_offset 0,
> file2_offset 8192, length 0, TO_EOF. One block is exchanged, and the sizes
> are exchanged with it:
>
>	file1 size 4096   -> [200] [100] [300] reflink flag set
>                              ^^^^^^^^^^^ still owned, now past the size
>	donor1 size 12288 -> [202]
>
> file1 says it is one block long while it still owns three. Nothing was
> unmapped. file2_offset is block 2, so this exchange cannot clear a flag.
>
> 3. XFS_IOC_EXCHANGE_RANGE file1 against donor2, both offsets 0, length 4096.
> By i_disk_size this is two one-block files exchanging everything, so
> xmi_can_exchange_reflink_flags() agrees and the flag is cleared:
>
>	file1 size 4096   -> [400] [100] [300] reflink flag CLEARED
>	donor2 size 4096  -> [200]
>
> Block 100 is still shared with peer.
>
> 4. pwrite(file1, 4096, 4096), which is file1's second slot, block 100.
> xfs_is_cow_inode(file1) is false, so no CoW:
>
>	peer size 4096 -> [100] same block, new contents
>
> Block 100 is the only one that matters here. PoC below, it reads a file
> called peer in the current directory. The filesystem needs reflink and
> exchange-range, which mkfs.xfs 7.x turns on by default.

So yes, TO_EOF is screwing up the file size even if it's actually
exchanging the data block correctly.  The following is the intended
behavior of XFS_EXCHANGE_RANGE_TO_EOF, as described by its manpage:

"Ignore the length parameter.  All bytes in file1_fd from file1_offset
 to EOF are moved to file2_fd, and file2's size is set to
 (file2_offset+(file1_length-file1_offset)).  Meanwhile, all bytes in
 file2 from file2_offset to EOF are moved to file1 and file1's size is
 set to (file1_offset+(file2_length-file2_offset))."

In other words, if we only exchange a portion of the file data, then we
should only exchange the portion of the file size that relates to the
exchanged data.  Unfortunately, the code swaps the ondisk file size and
the incore file sizes, which is incorrect if the caller passes in a
nonzero offset.

Having confused the file sizes, the PoC uses a second exchange-range
call on what looks like a non-reflinked single-block file.  Because the
file size is set incorrectly, exchange-range thinks it's exchanging the
full contents of two files and clears the reflink flag on the broken
file.  That enables an extending write of the broken file to rewrite the
shared block that's just past EOF.  This has become known colloquially
as refluxfs.

Once the file sizes are set correctly, the second exchange-range no
longer thinks that it's doing a full-contents swap, so it won't clear
the reflink flag on either of its file arguments.

Link: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
Reported-by: Norbert Szetei <norbert@doyensec.com>
Cc: <stable@vger.kernel.org> # v6.10
Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
 fs/xfs/xfs_exchrange.c       |   10 ++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 6a66b6075e0af4..c9d9464e9d39f5 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
 	const struct xfs_exchmaps_req	*req)
 {
 	struct xfs_exchmaps_intent	*xmi;
+	struct xfs_mount		*mp = req->ip1->i_mount;
 	unsigned int			rs = 0;
 
 	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
@@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
 	}
 
 	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
+		loff_t	off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
+		loff_t	off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
+
 		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
-		xmi->xmi_isize1 = req->ip2->i_disk_size;
-		xmi->xmi_isize2 = req->ip1->i_disk_size;
+		xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
+		xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
 	}
 
 	/* Record the state of each inode's reflink flag before the op. */
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index fafb4e3f065c75..a4016116f5f1a9 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -296,11 +296,13 @@ xfs_exchrange_mappings(
 	 * the mappings, and updated the ondisk sizes.
 	 */
 	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) {
-		loff_t	temp;
+		loff_t	old_ip1_size = i_size_read(VFS_I(ip1));
+		loff_t	old_ip2_size = i_size_read(VFS_I(ip2));
 
-		temp = i_size_read(VFS_I(ip2));
-		i_size_write(VFS_I(ip2), i_size_read(VFS_I(ip1)));
-		i_size_write(VFS_I(ip1), temp);
+		i_size_write(VFS_I(ip2), fxr->file2_offset +
+				(old_ip1_size - fxr->file1_offset));
+		i_size_write(VFS_I(ip1), fxr->file1_offset +
+				(old_ip2_size - fxr->file2_offset));
 	}
 
 out_unlock:
