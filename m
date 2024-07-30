Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0171E23C9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300483; cv=none; b=F/iY4XXktIwvVq/ElDCnalpiVFST4GlwQ+VRh5QYqvmU2gpfaScjrpAZaUK/x6Db9xFSqpkMztFxOLnGiluJ82PH1sdNE938bL128pWCamb8I8yBrReHMNwS/OGm+vkE1wobURvhM7A4FzigVWIiMvTm90o+OKaOzvjCM4vvW6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300483; c=relaxed/simple;
	bh=YkU+XgTRVDFU+CJS2ghZbrHN6mv1FFbqFE8L6JCxni0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjsWEdUbA2bfKP6LTTJpl/erHsaviG6rJ4VTdeY2p6ykq/gxe/tDXc2qMwou9ayF6EQi1upIPxsVmpym2jjeIRXCYalwp983U0s236cp9ZT6HC8+fn0aSy6kzs1v/fvmFpbG8W15GNdVeXZwbHmk8SvHO4e84yt2DsnVXqcmGN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPD9ntq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPD9ntq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA5DC32786;
	Tue, 30 Jul 2024 00:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300482;
	bh=YkU+XgTRVDFU+CJS2ghZbrHN6mv1FFbqFE8L6JCxni0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RPD9ntq2Vth0FVKsB35QAZp4nr4YwO+b81fZTG5UdLOIbfo/VSvm6WAhEisNHsQ0a
	 XMXc1hRBPFMaDhUyMCrMmnZt1v3DniA8H9f2kb9+mQJHGFjqz1ByLN2WR8RPTyE3hu
	 P+U8XhlqmmncrCBDpMh3Xh2GnRhWxpVRSZRTPQWUGAz/L+5vnZk4TnhK504XLVfoeJ
	 l0YCsck2vBJZWgYzyNjdt6rTlLdIMKUdV9p1sSWy58RjO21xNGyyuI3iuNERhxnr5X
	 j7me+Wu2oRmjtSbun6ZX9ADC8dLmkiRh4Yc6TTfOy5a8nH0f9oUR0gzQAJ6z+6K5MD
	 umV6iZrSfeP3A==
Date: Mon, 29 Jul 2024 17:48:02 -0700
Subject: [PATCH 093/115] xfs: make xfs_bmapi_convert_delalloc() to allocate
 the target offset
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229843774.1338752.17298872330537959183.stgit@frogsfrogsfrogs>
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

From: Zhang Yi <yi.zhang@huawei.com>

Source kernel commit: 2e08371a83f1c06fd85eea8cd37c87a224cc4cc4

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
---
 libxfs/libxfs_priv.h |    5 ++++-
 libxfs/xfs_bmap.c    |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 023444082..90b2db091 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -79,7 +79,10 @@ extern struct kmem_cache *xfs_trans_cache;
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
 /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
-struct iomap;
+struct iomap {
+	unsigned long long	offset;	/* do not use */
+	unsigned long long	length;	/* do not use */
+};
 
 #define cancel_delayed_work_sync(work) do { } while(0)
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 33d0764a0..9fce05e1f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4584,8 +4584,8 @@ xfs_bmapi_write(
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
@@ -4718,6 +4718,36 @@ xfs_bmapi_convert_delalloc(
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

