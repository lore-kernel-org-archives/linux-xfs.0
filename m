Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB17122653F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882059; cv=none; b=IYVj85OjwvDPaG/KiAXnkgtTk/uQkfAG3Fi4CkSnbAS43NoRdWCqdqguXeBSN9JOFVzWds7BZRPaMglBFljKoUQTuPbdKOWbzWdXnQy6fo03CQidpOCxg0oEBhTAFBPaP2d25P3sRtNJzMiS4dQJrFlZMct7vS5Wb4UTOuBBtng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882059; c=relaxed/simple;
	bh=7La1qUEJH4hMa1KDsb341J2pilQK3Tcqxd+1lMrjhIo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YkY2YTV1hNXe17gbxa3JFrfWWg4h1UyPF5tABx0ZpkSbS9oRtLu+9ZRFdoxooMU4S2dul5msxAgDFwcf7GJbovGSBYYeuEnmjQsjJQNQcPZ7GfZdpd+HIMc4xuOJrzMcCaAs99iCVWo0JNxL49wpQZ8dVnWjdlLLKncLs+KfMPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kM92KPW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kM92KPW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1DEC4CEDD;
	Thu,  6 Feb 2025 22:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882059;
	bh=7La1qUEJH4hMa1KDsb341J2pilQK3Tcqxd+1lMrjhIo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kM92KPW4ipj0rmCF8Msu26hJ4tHwv64qO3ziDYoaqo+RZlSipxhUNBVACfW1nJINN
	 lHkXL5UnRjkbmuxy9emaz52MsWMYWh7RNMTU1ljUt2UXq1Tb4TDP67n6h2BT0T+xZ0
	 7584FtvD3ZwbxbKi7icdto3Fp81jMyUXWDKj8e5vlp1mLUdjmNfGBwwohtEBWbuCfe
	 bosob54nSx2gN257GTVdFWhNNWhfSN8WTSKXzZ9Na5j3YLDBgQxRrrbvuwEDthtRrk
	 1KOEahqmesep3OmFMs8TyOdsLtK7OW+75SdjlZNJks7iwAwtYtvqo9tVEJ1FntdDKC
	 HNFoqzpbPqaMg==
Date: Thu, 06 Feb 2025 14:47:38 -0800
Subject: [PATCH 48/56] xfs: enable extent size hints for CoW operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087528.2739176.98861749480447172.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8e84e8052bc283ebb37f929eb9fb97483ea7385e

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ed969983cccd1b..1f7326acbf7cb2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6518,7 +6518,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)

