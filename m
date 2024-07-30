Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBE6440C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299543; cv=none; b=PKCUUQZHavgMlGXrrNBErHxbFgJRGgYZ6qK2vzTYdaprpT4KRF4LayjL3iEPfktohVYD+GcM1UWfAXhgQDFF84DUrc3e/04ZdlQt2HuEWyjmR6yzGbg+rxuT5wuzEcpBwuJSgiFc9+m0rWrVfRxOlDSmodhA9071a1DopSIoP68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299543; c=relaxed/simple;
	bh=hz6GOwHmDLAJZ0FkdRqc258xzmkjss5VLBz90c0+9VE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6DDEeYezo39RB3AuC5fD89GXl2Gbv69n8rxAKXIpMtz0QVM5W32v0b3JPmtWvWkyp3a5gOFhMIumIdAlqRO5JxLbAZVqt7tmkOrURa7TLsHdoE+6R4Llw4Ra20FLgdsfqv31RgsejAm7xb8Jg86pD4gmmoFMd3qR7sR8uiMWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiQSeNnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiQSeNnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B934C4AF07;
	Tue, 30 Jul 2024 00:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299543;
	bh=hz6GOwHmDLAJZ0FkdRqc258xzmkjss5VLBz90c0+9VE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CiQSeNnuw6x4udjWcp3FXpHDF1xsOqFkblYLLiCO48vdAYc/k43sav7108OrL3gZH
	 wTvfBb9QAbxQG2Ft1R/UrHexSosGC0aICFd5/vfPfaee2SRVSS5JQ/EVQJzycKre9l
	 eeEVirzPOb88GxtEVIjXSwe/tYzFHygXCwB30F20HxerSuPg3JFW00GA7ymC+eYIFo
	 ZtgMa26NIUxVphUcvGOCnja1jrWUrqjzJCvOVmTE2zIHBxY2uM12AbSaiI+OZPXcOA
	 X82MbYDGZUvNgoHzS1IO7+oQGmIi/FMrN1w/FezZt7AARZ5t0jI/AUbX6HPQc+ScKl
	 2sCBvZtbjAMMQ==
Date: Mon, 29 Jul 2024 17:32:22 -0700
Subject: [PATCH 033/115] xfs: free RT extents after updating the bmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842908.1338752.7701114659633869238.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 9871d0963751293bf0587759a9b6b8f808e35c7c

Currently xfs_bmap_del_extent_real frees RT extents before updating
the bmap btree, while it frees regular blocks after performing the bmap
btree update for convoluted historic reasons.  Switch to free the RT
blocks in the same place as the regular data blocks instead to simply
the code and fix a very theoretical bug.

A short history of this code researched by Dave Chiner below:

The truncate for data device extents was originally a two-phase
operation. First it removed the bmapbt record, but because this can
free BMBT extents, it can use up all the free space tree reservation
space. So the transaction gets rolled to commit the BMBT change and
the xfs_bmap_finish() call that frees the data extent runs with a
new transaction reservation that allows different free space btrees
to be logged without overrun.

However, on crash, this could lose the free space because there was
nothing to tell recovery about the extents removed from the BMBT,
hence EFIs were introduced. They tie the extent free operation to the
bmapbt record removal commit for recovery of the second phase of the
extent removal process.

Then RT extents came along. RT extent freeing does not require a
free space btree reservation because the free space metadata is
static and transaction size is bound. Hence we don't need to care if
the BMBT record removal modifies the per-ag free space trees and we
don't need a two-phase extent remove transaction. The only thing we
have to care about is not losing space on crash.

Hence instead of recording the extent for freeing in the bmap list
for xfs_bmap_finish() to process in a new transaction, it simply
freed the rtextent directly. So the original code (from 1994) simply
replaced the "free AG extent later" queueing with a direct free.

This code was originally at the start of xfs_dmap_del_extent(), but
the xfs_bmap_add_free() got moved to the end of the function via the
"do_fx" flag (the current code logic) in 1997 (commit c4fac74eaa58
in the historic xfs-import tree) because there was a shutdown occurring
because of a case where splitting the extent record failed because the
BMBT split and the filesystem didn't have enough space for the split to
be done. (FWIW, I'm not sure this can happen anymore.)

The commit backed out the BMBT change on ENOSPC error, and in doing
so I think this actually breaks RT free space tracking. However, it
then returns an ENOSPC error, and we have a dirty transaction in the
RT case so this will shut down the filesysetm when the transaction
is cancelled. Hence the corrupted "bmbt now points at freed rt dev
space" condition never make it to disk, but it's still the wrong way
to handle the issue.

IOWs, this proposed change fixes that "shutdown at ENOSPC on rt
devices" situation that was introduced by the above commit back in
1997.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f339e16a1..dd91fb2aa 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5103,8 +5103,7 @@ xfs_bmap_del_extent_real(
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			do_fx;	/* free extent at end of routine */
-	int			error;	/* error return value */
+	int			error = 0;	/* error return value */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5147,20 +5146,10 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (xfs_ifork_is_realtime(ip, whichfork)) {
-		if (!(bflags & XFS_BMAPI_REMAP)) {
-			error = xfs_rtfree_blocks(tp, del->br_startblock,
-					del->br_blockcount);
-			if (error)
-				return error;
-		}
-
-		do_fx = 0;
+	if (xfs_ifork_is_realtime(ip, whichfork))
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
-	} else {
-		do_fx = 1;
+	else
 		qfield = XFS_TRANS_DQ_BCOUNT;
-	}
 	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
@@ -5308,18 +5297,21 @@ xfs_bmap_del_extent_real(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
+	if (!(bflags & XFS_BMAPI_REMAP)) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
+		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 		} else {
 			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					XFS_AG_RESV_NONE,
 					((bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN));
-			if (error)
-				return error;
 		}
+		if (error)
+			return error;
 	}
 
 	/*

