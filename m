Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB66155C87;
	Wed, 18 Dec 2024 19:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734551484; cv=none; b=GJEh9jSeWYlwmKXQP4jMA/33+hag/zTLj6HrY0eaJ0z4g4lUIKPvKJaXoHe+ubSKPNaJI6oRA53BBfSCqteIXqxn2bgw1u5qUos7cmGEyje4i+YFE4LAWCzMVimGffmq96HsuNkslQ7NnCgAWo7Z/dMnpp+jX3tusAcifbnh17s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734551484; c=relaxed/simple;
	bh=qhYporBeqPCMQnPqEVYxLDJqj1HPniraK8ToDLq9N5s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nn0pzVyJEmhZG994yH6tNdUmJJ7e5jnEjjOnb7MOFCbdpNSIlfscay/FSv413OgLkewFOkykHaSgjttHpb4avS2WbHuy2BOMj0bk7qUFtYHUWsXppElIwj0MMsIi81X/MpYyCO8Jbkz76BrrKjlhsTwBNbidiZfQ3BgiC28qEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tFPjXnzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tFPjXnzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA98C4CECD;
	Wed, 18 Dec 2024 19:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734551484;
	bh=qhYporBeqPCMQnPqEVYxLDJqj1HPniraK8ToDLq9N5s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tFPjXnzFBuO/zrilmsvFquLUNAHPWiAcZwVJgUC52txU78rU7JS/bRU3g5uTOlZS7
	 pIz003k65qSqUVXlV0Z9Bn9V+eZmx0elUE5H+P4qxIY7PRJTQSUxM6f0PIUWIGz/SP
	 RpwZFWKluRqdbllQ8WRiRcGdOVD+CA0bkXOOrfAFtzKicrC+wpL/64h5YUGHLjMhcL
	 ZH02zQwsanwtAKNNH2kzpO/1z7jgESd7ooIZj89SnMLni+E7Fq8yeM61LFTrZPmd3G
	 xsqI35aO3CXwrCR/6sNs16l+JtfD903kht7/Kf8aRjddDgtjlvui+m3LOhZpf1z+5M
	 g6INOuQgh+wyw==
Date: Wed, 18 Dec 2024 11:51:23 -0800
Subject: [PATCH 5/5] xfs: fix zero byte checking in the superblock scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: stable@vger.kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173455093579.305755.3960848373109465926.stgit@frogsfrogsfrogs>
In-Reply-To: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
References: <173455093488.305755.7686977865497104809.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit c004a793e0ec34047c3bd423bcd8966f5fac88dc upstream.

The logic to check that the region past the end of the superblock is all
zeroes is wrong -- we don't want to check only the bytes past the end of
the maximally sized ondisk superblock structure as currently defined in
xfs_format.h; we want to check the bytes beyond the end of the ondisk as
defined by the feature bits.

Port the superblock size logic from xfs_repair and then put it to use in
xfs_scrub.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 21fb4cb1981ef7 ("xfs: scrub the secondary superblocks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index da30f926cbe66d..0f2f1852d58fe7 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -59,6 +59,30 @@ xchk_superblock_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+/*
+ * Calculate the ondisk superblock size in bytes given the feature set of the
+ * mounted filesystem (aka the primary sb).  This is subtlely different from
+ * the logic in xfs_repair, which computes the size of a secondary sb given the
+ * featureset listed in the secondary sb.
+ */
+STATIC size_t
+xchk_superblock_ondisk_size(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_metauuid(mp))
+		return offsetofend(struct xfs_dsb, sb_meta_uuid);
+	if (xfs_has_crc(mp))
+		return offsetofend(struct xfs_dsb, sb_lsn);
+	if (xfs_sb_version_hasmorebits(&mp->m_sb))
+		return offsetofend(struct xfs_dsb, sb_bad_features2);
+	if (xfs_has_logv2(mp))
+		return offsetofend(struct xfs_dsb, sb_logsunit);
+	if (xfs_has_sector(mp))
+		return offsetofend(struct xfs_dsb, sb_logsectsize);
+	/* only support dirv2 or more recent */
+	return offsetofend(struct xfs_dsb, sb_dirblklog);
+}
+
 /*
  * Scrub the filesystem superblock.
  *
@@ -75,6 +99,7 @@ xchk_superblock(
 	struct xfs_buf		*bp;
 	struct xfs_dsb		*sb;
 	struct xfs_perag	*pag;
+	size_t			sblen;
 	xfs_agnumber_t		agno;
 	uint32_t		v2_ok;
 	__be32			features_mask;
@@ -350,8 +375,8 @@ xchk_superblock(
 	}
 
 	/* Everything else must be zero. */
-	if (memchr_inv(sb + 1, 0,
-			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
+	sblen = xchk_superblock_ondisk_size(mp);
+	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
 		xchk_block_set_corrupt(sc, bp);
 
 	xchk_superblock_xref(sc, bp);

