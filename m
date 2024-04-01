Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15CF1C0DE7;
	Mon,  1 Apr 2024 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990153; cv=none; b=q8B5J4GSB5x1V7LWdR8pIK6+74k+vVrPLd46t7sGsXBOLoWS/dGv973sQ79xg3tdmfZDgqtfP9cMvhN8BgWpGg8JJ4wRDQDnjO7Al5k3qHM9uYcArP5iBKE9N2BKuQZa7ofv3us5HkLRdiIftAQR1yZw5gI7tI/Iphx7bA3IM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990153; c=relaxed/simple;
	bh=E3gflaPC6++OQWj3LKVlfdapx5cNF5n9x7D1XuH3ZNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUck5U2XKI59GeO8wKae3n4jiXv14NaE6/bkzih6pOt/Rqk/ISL4VolI5ay2AhCBmF5G4fszLRdOwlxsCEZDP+yx2HO3gzzveu7Z+sWrHPfCVHtEelY1/aI3lei8rci6eXR52kTSWsBDHElHEqTG0zuHPdFBwIGdtwI8ulqGsDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzYO9iuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzYO9iuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C6FC433F1;
	Mon,  1 Apr 2024 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990152;
	bh=E3gflaPC6++OQWj3LKVlfdapx5cNF5n9x7D1XuH3ZNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzYO9iuT+/NlFuPLNZLLQr7+If81N6lrhYmtqY+5M++Z3j+rm2GLPhj7FScERm/Ut
	 SV1fvjD5q8WZS6GHpkTgaZFwJ7wQ8WsbL/LP5jsmAQIWbW/e5v3rxLUMo43eSQhhL/
	 +K43DMZ7qsr6l36DO63F+cuvx/w8KpXC8t5Y+2us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 262/396] xfs: dont allow overly small or large realtime volumes
Date: Mon,  1 Apr 2024 17:45:11 +0200
Message-ID: <20240401152555.718025388@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit e14293803f4e84eb23a417b462b56251033b5a66 upstream.

[backport: resolve merge conflicts due to refactoring rtbitmap/summary
macros and accessors]

Don't allow realtime volumes that are less than one rt extent long.
This has been broken across 4 LTS kernels with nobody noticing, so let's
just disable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   13 +++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |    3 ++-
 fs/xfs/xfs_rtalloc.c         |    2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -73,6 +73,18 @@ int xfs_rtfree_blocks(struct xfs_trans *
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -81,6 +93,7 @@ uint8_t xfs_compute_rextslog(xfs_rtbxlen
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_compute_rextslog(rtx)			(0)
+# define xfs_validate_rtextents(rtx)			(false)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -509,7 +509,8 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (sbp->sb_rextents != rexts ||
+		if (!xfs_validate_rtextents(rexts) ||
+		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -998,6 +998,8 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
+	if (!xfs_validate_rtextents(nrextents))
+		return -EINVAL;
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;


