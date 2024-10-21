Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2531E47CD;
	Mon, 21 Oct 2024 10:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506941; cv=none; b=pb4PGi4smtDjLXe1U00uu7yHh0a99mpkPQA5QY6gATE2lKRrNuFqW6blxSICVEtfR5QofouNsjze8KQyDqi/RlI/c6memAjm4xRctAzrSr4SYpIDOiHCfrTIEu6DhgwL6J291N5ax1oRZB8HYGlqKZtVtmF0xULeSuixVS4Zv00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506941; c=relaxed/simple;
	bh=/A04r/7fFt7deqdltVQn0QhbUeux1Lf4/w9bCKURNq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuC+3vfccFDt+oLIu9cbVR9lTmY4tsqymqlBn8xkVTO6IlUwNv/UnTW08q9WVMTCvHtnG/lhFaS6L/0mU2hW1hJzTTU7VKupQ8zAg7vy12uWqZWKklM+3/tICSm3yaR7Pi7ohd9SI0KBpPPn9dYzoqc01tAq1SYwzN/e2i0HR9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBLWA+Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBLWA+Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB83C4CEC3;
	Mon, 21 Oct 2024 10:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506941;
	bh=/A04r/7fFt7deqdltVQn0QhbUeux1Lf4/w9bCKURNq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBLWA+Ui334UUQ7wASJtVDokf+wmjT9eMgmumxuRg3yfdvrJRr/kaUjvyt1Vdsjt0
	 PDlt6Kf3fazUpK1zXnmMhAOR5eclKxOyEfNY4vJAPhavbKXcgVKOZAGT9PdG+kbpJ3
	 0Jn4aeoIGdV7ZlzpBaT/ekwGna6H2zmJU2RbAfn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 037/124] xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
Date: Mon, 21 Oct 2024 12:24:01 +0200
Message-ID: <20241021102258.162033952@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 2e08371a83f1c06fd85eea8cd37c87a224cc4cc4 upstream.

Since xfs_bmapi_convert_delalloc() only attempts to allocate the entire
delalloc extent and require multiple invocations to allocate the target
offset. So xfs_convert_blocks() add a loop to do this job and we call it
in the write back path, but xfs_convert_blocks() isn't a common helper.
Let's do it in xfs_bmapi_convert_delalloc() and drop
xfs_convert_blocks(), preparing for the post EOF delalloc blocks
converting in the buffered write begin path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   34 +++++++++++++++++++++++++++--
 fs/xfs/xfs_aops.c        |   54 ++++++++++++-----------------------------------
 2 files changed, 46 insertions(+), 42 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4537,8 +4537,8 @@ error0:
  * invocations to allocate the target offset if a large enough physical extent
  * is not available.
  */
-int
-xfs_bmapi_convert_delalloc(
+static int
+xfs_bmapi_convert_one_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		offset,
@@ -4666,6 +4666,36 @@ out_trans_cancel:
 	return error;
 }
 
+/*
+ * Pass in a dellalloc extent and convert it to real extents, return the real
+ * extent that maps offset_fsb in iomap.
+ */
+int
+xfs_bmapi_convert_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	loff_t			offset,
+	struct iomap		*iomap,
+	unsigned int		*seq)
+{
+	int			error;
+
+	/*
+	 * Attempt to allocate whatever delalloc extent currently backs offset
+	 * and put the result into iomap.  Allocate in a loop because it may
+	 * take several attempts to allocate real blocks for a contiguous
+	 * delalloc extent if free space is sufficiently fragmented.
+	 */
+	do {
+		error = xfs_bmapi_convert_one_delalloc(ip, whichfork, offset,
+					iomap, seq);
+		if (error)
+			return error;
+	} while (iomap->offset + iomap->length <= offset);
+
+	return 0;
+}
+
 int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -233,45 +233,6 @@ xfs_imap_valid(
 	return true;
 }
 
-/*
- * Pass in a dellalloc extent and convert it to real extents, return the real
- * extent that maps offset_fsb in wpc->iomap.
- *
- * The current page is held locked so nothing could have removed the block
- * backing offset_fsb, although it could have moved from the COW to the data
- * fork by another thread.
- */
-static int
-xfs_convert_blocks(
-	struct iomap_writepage_ctx *wpc,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	loff_t			offset)
-{
-	int			error;
-	unsigned		*seq;
-
-	if (whichfork == XFS_COW_FORK)
-		seq = &XFS_WPC(wpc)->cow_seq;
-	else
-		seq = &XFS_WPC(wpc)->data_seq;
-
-	/*
-	 * Attempt to allocate whatever delalloc extent currently backs offset
-	 * and put the result into wpc->iomap.  Allocate in a loop because it
-	 * may take several attempts to allocate real blocks for a contiguous
-	 * delalloc extent if free space is sufficiently fragmented.
-	 */
-	do {
-		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
-				&wpc->iomap, seq);
-		if (error)
-			return error;
-	} while (wpc->iomap.offset + wpc->iomap.length <= offset);
-
-	return 0;
-}
-
 static int
 xfs_map_blocks(
 	struct iomap_writepage_ctx *wpc,
@@ -289,6 +250,7 @@ xfs_map_blocks(
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
 	int			error = 0;
+	unsigned int		*seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -386,7 +348,19 @@ retry:
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
+	/*
+	 * Convert a dellalloc extent to a real one. The current page is held
+	 * locked so nothing could have removed the block backing offset_fsb,
+	 * although it could have moved from the COW to the data fork by another
+	 * thread.
+	 */
+	if (whichfork == XFS_COW_FORK)
+		seq = &XFS_WPC(wpc)->cow_seq;
+	else
+		seq = &XFS_WPC(wpc)->data_seq;
+
+	error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
+				&wpc->iomap, seq);
 	if (error) {
 		/*
 		 * If we failed to find the extent in the COW fork we might have


