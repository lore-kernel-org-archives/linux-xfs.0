Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B258C1BF31
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710844; cv=none; b=J8l1Tr0ZEH/guvhlHBdsugmBfIIibB47PPwP+ic1Oxt5FBMG1jZxYMz0oj0qfHk66KwnHQWVwUX7QyCh9thpDEREZBdpOebX8zDV4ljBL5KdLXE9xFErecsZf7MWEGxB2uxIGmKz8szcL5sxcMQ7BwHCkSg3HffFePE+gMCROho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710844; c=relaxed/simple;
	bh=8lX92mb7bwk2f/+efzr3V45RsrB6eWAFO4ri9S5+4Y4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0V91+2j4pqWgraMHetHjYRQZV94QffuhSidGfBL/n0JRAjOrl46W/Xsw1UOAHWAbDLTJxDkDluaK/jPys6Kz9oENQNXiEgyGFCbiQF+P13F+cuOXxq/tbTKGXGNEBRXmyR02KcMqPTZdT9Y5kSlaUldRV/JSxdMmjwUx/xZEqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQqJn4Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQqJn4Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A71C116B1;
	Fri,  3 May 2024 04:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710844;
	bh=8lX92mb7bwk2f/+efzr3V45RsrB6eWAFO4ri9S5+4Y4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EQqJn4LrCegrpWQ/eWUwgs9YiTSJR66HxIhclgxciigU+tP7bA0DThmxIGj4YHdXH
	 j8UYUgge8uU49DIoxDnpHn0/wYPt9Arv0E0o6EwywCI4hj4xEr29in6r8S8jAV3RPW
	 ZIu4q2TBqY0SaXctLw+oSPSrFDikq5T84NU1ly4MzBmGsch/a8FEom26UOiAw5Wkok
	 6ARl88RFJ860AfOcXW6sUsEHOPKStFpLK/u7olvqMLgZsOOBy0hnCS3Hu3mjgkuuc8
	 BXBVbQv7yjIloKLU0kTLxGAjmgJR2U1qgxIgunrVzXJtSPA8mFVdGMA5wq+zltszGg
	 RkmJnHgcMYnTQ==
Date: Thu, 02 May 2024 21:34:03 -0700
Subject: [PATCH 2/5] xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171471075352.2662283.1488007652504646705.stgit@frogsfrogsfrogs>
In-Reply-To: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
References: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
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

Turn this into a properly typechecked function, and actually use the
correct blocksize for extended attributes.  The function cannot be
static inline because xfsprogs userspace uses it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   19 ++++++++++++++++---
 fs/xfs/libxfs/xfs_da_format.h   |    4 +---
 2 files changed, 17 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 7c38c6feb8c9..043b837a3ef7 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -43,6 +43,19 @@
  * the logging system and therefore never have a log item.
  */
 
+/* How many bytes can be stored in a remote value buffer? */
+inline unsigned int
+xfs_attr3_rmt_buf_space(
+	struct xfs_mount	*mp)
+{
+	unsigned int		blocksize = mp->m_attr_geo->blksize;
+
+	if (xfs_has_crc(mp))
+		return blocksize - sizeof(struct xfs_attr3_rmt_hdr);
+
+	return blocksize;
+}
+
 /*
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
@@ -53,7 +66,7 @@ xfs_attr3_rmt_blocks(
 	unsigned int		attrlen)
 {
 	if (xfs_has_crc(mp)) {
-		unsigned int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+		unsigned int buflen = xfs_attr3_rmt_buf_space(mp);
 		return (attrlen + buflen - 1) / buflen;
 	}
 	return XFS_B_TO_FSB(mp, attrlen);
@@ -293,7 +306,7 @@ xfs_attr_rmtval_copyout(
 
 	while (len > 0 && *valuelen > 0) {
 		unsigned int hdr_size = 0;
-		unsigned int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
+		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
@@ -342,7 +355,7 @@ xfs_attr_rmtval_copyin(
 
 	while (len > 0 && *valuelen > 0) {
 		unsigned int hdr_size;
-		unsigned int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
+		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 		hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ebde6eb1da65..86de99e2f757 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -880,9 +880,7 @@ struct xfs_attr3_rmt_hdr {
 
 #define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
 
-#define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_has_crc((mp)) ? \
-			sizeof(struct xfs_attr3_rmt_hdr) : 0))
+unsigned int xfs_attr3_rmt_buf_space(struct xfs_mount *mp);
 
 /* Number of bytes in a directory block. */
 static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)

