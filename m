Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C209038E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJf96t/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EBEC433C8;
	Mon,  1 Jan 2024 00:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068019;
	bh=w8Jcte42nf5N/qdTClHFlMoIWWqI9LWRUI9I/jzdjiA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AJf96t/ciITuDIngW+7vbB5HbkEpxqlXDnjrtSSXZ2TYdClpmpTk2gpBvIkEgZW1m
	 AdcOPZX60nPS4N1SFeTtsoKbBxADltobIOGX3kgHTq++sS/ADadmaBdf7pbOd5tPlL
	 rllfKdhmppY1SdPTnYdHg+KEpJLUOU2grFk9oKWEf/EXPiGpasFeHuU0kw8hQLgFW5
	 Dij8C8FX5D0l5EtuxQ6ZrXtHu30CiBZTkoWva0thyAUIsoef62lw5Nf7Bm75QLjYhW
	 QpJca7TbcJy/DkzSZTCm76erzvsjjhetELijMyRxCgk4seHHPdg6CV7rwxNDpFz+oZ
	 1xbh02VMGdZCw==
Date: Sun, 31 Dec 2023 16:13:38 +9900
Subject: [PATCH 12/47] xfs: use realtime EFI to free extents when realtime
 rmap is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015473.1815505.14379564509326274179.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

When rmap is enabled, XFS expects a certain order of operations, which
is: 1) remove the file mapping, 2) remove the reverse mapping, and then
3) free the blocks.  xfs_bmap_del_extent_real tries to do 1 and 3 in the
same transaction, which means that when rtrmap is enabled, we have to
use realtime EFIs to maintain the expected order.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 323f60b1128..b84d1ad57f1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5051,7 +5051,6 @@ xfs_bmap_del_extent_real(
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
@@ -5064,6 +5063,8 @@ xfs_bmap_del_extent_real(
 	uint			qfield;	/* quota field to update */
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
+	bool			want_free = !(bflags & XFS_BMAPI_REMAP);
 
 	*logflagsp = 0;
 
@@ -5095,18 +5096,24 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (xfs_ifork_is_realtime(ip, whichfork)) {
-		if (!(bflags & XFS_BMAPI_REMAP)) {
+	if (isrt) {
+		/*
+		 * Historically, we did not use EFIs to free realtime extents.
+		 * However, when reverse mapping is enabled, we must maintain
+		 * the same order of operations as the data device, which is:
+		 * Remove the file mapping, remove the reverse mapping, and
+		 * then free the blocks.  This means that we must delay the
+		 * freeing until after we've scheduled the rmap update.
+		 */
+		if (want_free && !xfs_has_rtrmapbt(mp)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
 				return error;
+			want_free = false;
 		}
-
-		do_fx = 0;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
-		do_fx = 1;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
 	nblks = del->br_blockcount;
@@ -5256,7 +5263,7 @@ xfs_bmap_del_extent_real(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
+	if (want_free) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
@@ -5265,6 +5272,8 @@ xfs_bmap_del_extent_real(
 			if ((bflags & XFS_BMAPI_NODISCARD) ||
 			    del->br_state == XFS_EXT_UNWRITTEN)
 				efi_flags |= XFS_FREE_EXTENT_SKIP_DISCARD;
+			if (isrt)
+				efi_flags |= XFS_FREE_EXTENT_REALTIME;
 
 			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,

