Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F008238B;
	Sat,  7 Dec 2024 00:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531515; cv=none; b=kiBwTGi9r9Q1jC3T/O+oRGXwz8fPeE11Gui4TzVUuS8pn1Ja2v3uZ0XheuRXDWjF2VBYataw+AbjJq9Krrpyc42yuDT2+BII9BTLiq7XJ65EJ/b03C50S9SMH7dcRS5JCJ9eKNBW/u7k3goLf4ZbjQhxMqDyfUyiG8gB3Ce8T08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531515; c=relaxed/simple;
	bh=iI19QR/L/ukXQi3tmndHRmdDiNI7qXxqZWOMoPhxsL8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zgq4D21IQoPDKLSP6PnQUjIkAVMIy3J0iUmk0XGlXWHnOlZeSBTmWdsj4i53Pk9CpPTYz7D5QWvrtWpagEcMIf8cqVmBdneh8tl6upZP3YngRbXQ8mJoF5pqHRCLrC/NBK7BBnDKCY+ejiwS9IxAv/tDw48TIEZT+ZgOLkFfHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PctVzXtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PctVzXtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E6DC4CED1;
	Sat,  7 Dec 2024 00:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531514;
	bh=iI19QR/L/ukXQi3tmndHRmdDiNI7qXxqZWOMoPhxsL8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PctVzXtRG1/zMev7CLDGOCU+cigrxWpGTfIcDyQ5DLwj2mcFkZX+mg2wPTaEy76mb
	 vAO21xqK5fL8cTbRPEj8CUz6p7lv0edhB4D5WQlycrl/ikAehnUhKlIFQL2a2rAWAN
	 w2MqZvcik3+YX3DcjLrB/65FxL8obyt42RU1B7JoZPlBR88/kj7FUUdt0cdGocnWRE
	 l07wiGlfN+U2wCZo8DMDh0ZYaIEryPMdqVQgSEe7fnyMcBTbMq0kFTa0YxKuzvg/PI
	 7VTLiGABcYy6UU+C2mR6imWDSnrbPoFCkZ9MxgSkGtHku3hYJNYygfOw97xPkjBwtb
	 N1RgpzOmGH6gQ==
Date: Fri, 06 Dec 2024 16:31:53 -0800
Subject: [PATCH 4/6] xfs: fix zero byte checking in the superblock scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173353139368.192136.9553326949796475388.stgit@frogsfrogsfrogs>
In-Reply-To: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
References: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
 fs/xfs/scrub/agheader.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 88063d67cb5fd4..9f8c312dfd3c82 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -59,6 +59,32 @@ xchk_superblock_xref(
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
+	if (xfs_has_metadir(mp))
+		return offsetofend(struct xfs_dsb, sb_pad);
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
@@ -75,6 +101,7 @@ xchk_superblock(
 	struct xfs_buf		*bp;
 	struct xfs_dsb		*sb;
 	struct xfs_perag	*pag;
+	size_t			sblen;
 	xfs_agnumber_t		agno;
 	uint32_t		v2_ok;
 	__be32			features_mask;
@@ -388,8 +415,8 @@ xchk_superblock(
 	}
 
 	/* Everything else must be zero. */
-	if (memchr_inv(sb + 1, 0,
-			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
+	sblen = xchk_superblock_ondisk_size(mp);
+	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
 		xchk_block_set_corrupt(sc, bp);
 
 	xchk_superblock_xref(sc, bp);

