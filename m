Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC71BF31
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710876; cv=none; b=oGl3VGOxX67SMe2XuFolf65MEx2m3dX0mLliY5fFnXm1SVmIcnMPBLnEW+HFCzchBlOKrmS0Lp+V3gW1eitaq8wKkuQnCrElHpWWUioyHf5NI+AJLTq1Uxeq3fq+nx6aIOSLbXV05CMZ2vluZ++nDge3zdssh5185CC2MnUzXhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710876; c=relaxed/simple;
	bh=R1bWA+fJgKyZvywGLYnNLMpok09McYWUvIl02tVhOoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9Ya1aNGO0FI76oibypHnY6JxNo+OeUeD4vh6jytBPts0+YvXDLlkff5tMTHClCUoRVKVR2xeSNxBmhqMiF6GccuPDTbB+bEXhP3bXJv8Z3TcSNwF9aIOXa3Kppc5+zriC2X5ToUFryBYJZWyt17VJFnP0WGdH/5XtalrzfOIM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsl6usuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsl6usuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DF7C116B1;
	Fri,  3 May 2024 04:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710875;
	bh=R1bWA+fJgKyZvywGLYnNLMpok09McYWUvIl02tVhOoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lsl6usuRofNPgw9tqJvbPRNXMnoP5I0Oz6VWeZUlVuxgvt4HpJNNrXa549/knr2bp
	 Pupk3jc5v5tr2jKa815bzzpExgvT8Z5xpVQ3jS/sLnffxpr/jo0tQMSap8K0rd6GmJ
	 uJOa1r5NPea39BlxDufnDdf7TqH+MU3ySNazH1nXPx/kcSRg7C+ZwIOqNMXB0KM4PM
	 n2oZKgblIvz1HYjDa7CV2VgD6ItrjkmkD1sCnqvw/aRXwaR2VKS9/w8pnl2RuIBwfn
	 6U913Q7ZsRpBogEw867bvNU2d+jwR+reR+0umqJYVHeVQL3nygzIRUlOaRJHQ8cRl+
	 TbrwaiUSlvUQw==
Date: Thu, 02 May 2024 21:34:35 -0700
Subject: [PATCH 4/5] xfs: minor cleanups of xfs_attr3_rmt_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171471075388.2662283.11538844431569293483.stgit@frogsfrogsfrogs>
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

Clean up the type signature of this function since we don't have
negative attr lengths or block counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 043b837a3ef7..4c44ce1c8a64 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -56,19 +56,19 @@ xfs_attr3_rmt_buf_space(
 	return blocksize;
 }
 
-/*
- * Each contiguous block has a header, so it is not just a simple attribute
- * length to FSB conversion.
- */
+/* Compute number of fsblocks needed to store a remote attr value */
 unsigned int
 xfs_attr3_rmt_blocks(
 	struct xfs_mount	*mp,
 	unsigned int		attrlen)
 {
-	if (xfs_has_crc(mp)) {
-		unsigned int buflen = xfs_attr3_rmt_buf_space(mp);
-		return (attrlen + buflen - 1) / buflen;
-	}
+	/*
+	 * Each contiguous block has a header, so it is not just a simple
+	 * attribute length to FSB conversion.
+	 */
+	if (xfs_has_crc(mp))
+		return howmany(attrlen, xfs_attr3_rmt_buf_space(mp));
+
 	return XFS_B_TO_FSB(mp, attrlen);
 }
 

