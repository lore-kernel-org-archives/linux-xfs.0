Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618324A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299559; cv=none; b=RwFeCifaNDRtO9R0S1B3bSUPz8Q+mNkRHsIjnM850BJVCBBY7+/fK7R/KM+abTn9pECOu6FdGFNf0uZ+hJ0Y4zJf5wWxfTsbnpOgthUJgozgAlcOg1Fx1+v7R6YJ0alan/qccgvILx5kWdXvK9Z7v6+kvemQhwuIjcOM67BVkjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299559; c=relaxed/simple;
	bh=RMQW7FFEM7BTBipyRUnDR6sMuVu68TokOZjWMNRqAME=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UqjprOk5qmxPlWOE8Ci0FoWYmGGoLMlEImHXbykGzJaN8KtqvG1cKmAy/jymSyAKmbZnXR4i5UAb8vFhXJKaRRK9VxsuByaMQUWN5VPDjWzlEYuzRrhpoxJSDkSJcYtuS2Pb074R1wtEkQWIYuz8lBR7XmTAsDkUKlPYWLUrs7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCcfyhuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCcfyhuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EFFC32786;
	Tue, 30 Jul 2024 00:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299558;
	bh=RMQW7FFEM7BTBipyRUnDR6sMuVu68TokOZjWMNRqAME=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UCcfyhuZwgcOUXDjmw8wcHn+PeIgiBeL+XTsgmhsugf9hyMJKVgk/s7Rdr1qvQvcE
	 1xDa7Mx3HHQR0ZDPvsqulDc/2z//tbhP3+J2akO/goytxoEtj1zXLQmntU+pDBqk+R
	 aER2Vf6KtOGmhNxQZ2tPLkDed/O71yOXVcVB5fhAyzMbIlL4Pxt8WO6+YMZVJS7qFQ
	 X8rQCCTSvk3AZsprG3C4zL12i45iDtPPAZWNFjuK9I9/3Rd0UKP6q+08taqLnTJccq
	 PDTfty8tzOJNaDqcnMeCQc03Tx76//XnKLc/RyWSUL8flIwdeOACpWJCUHwCOqVtQI
	 CQB0NhWTRd9iA==
Date: Mon, 29 Jul 2024 17:32:38 -0700
Subject: [PATCH 034/115] xfs: move RT inode locking out of __xfs_bunmapi
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842920.1338752.15891282023588871061.stgit@frogsfrogsfrogs>
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

Source kernel commit: de37dbd0ccc6933fbf4bd7b3ccbc5ac640e80b28

__xfs_bunmapi is a bit of an odd place to lock the rtbitmap and rtsummary
inodes given that it is very high level code.  While this only looks ugly
right now, it will become a problem when supporting delayed allocations
for RT inodes as __xfs_bunmapi might end up deleting only delalloc extents
and thus never unlock the rt inodes.

Move the locking into xfs_bmap_del_extent_real just before the call to
xfs_rtfree_blocks instead and use a new flag in the transaction to ensure
that the locking happens only once.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c   |   15 ++++++++-------
 libxfs/xfs_shared.h |    3 +++
 2 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index dd91fb2aa..c16db82a2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5301,6 +5301,14 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
+			/*
+			 * Ensure the bitmap and summary inodes are locked
+			 * and joined to the transaction before modifying them.
+			 */
+			if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
+				tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
+				xfs_rtbitmap_lock(tp, mp);
+			}
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 		} else {
@@ -5402,13 +5410,6 @@ __xfs_bunmapi(
 	} else
 		cur = NULL;
 
-	if (isrt) {
-		/*
-		 * Synchronize by locking the realtime bitmap.
-		 */
-		xfs_rtbitmap_lock(tp, mp);
-	}
-
 	extno = 0;
 	while (end != (xfs_fileoff_t)-1 && end >= start &&
 	       (nexts == 0 || extno < nexts)) {
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index f35640ad3..34f104ed3 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -137,6 +137,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  */
 #define XFS_TRANS_LOWMODE		(1u << 8)
 
+/* Transaction has locked the rtbitmap and rtsum inodes */
+#define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
+
 /*
  * Field values for xfs_trans_mod_sb.
  */

