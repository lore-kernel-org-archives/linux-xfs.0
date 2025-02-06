Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC0123C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881245; cv=none; b=Z3H8V9NA1CnN+CS1C0mH6LB33WwO4oIYi0J0VoX8tLfq/WG3gb4nz/y/vQ1wXuZQPr01cvYnDNhlGNdlX74NIji8OVZhejlPOkXBDC/0akEqW4nUXjnBFeLKtP/6aRAR7Gb04xS+doqOMR3TlEsRAJ3w6THp8f8GkzQ+sj/ROxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881245; c=relaxed/simple;
	bh=qx2h7EohY71q2EzGD1FSfRVwcF4uUrwl3GKRnLdXBvY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vBDJeNMpkBKjnBYki4WklUxqU3SDP6Hn1L/VnxzWg7OmHyHDp+TyF+FPKXLleNqtdnjrsx7/lREkUULUBCTzU/Tsd04Wr5uiBmCjuYeJNId0PForvL+Tj+17GSrsrO+JtjHQbQ/j+Rwn9/hgXO2GjgBpwzYLKbxZAebWxcVbtM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3IxWVBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3IxWVBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ADEC4CEDD;
	Thu,  6 Feb 2025 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881244;
	bh=qx2h7EohY71q2EzGD1FSfRVwcF4uUrwl3GKRnLdXBvY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y3IxWVBFNQLVj72OahZhgOVhe4BybITJ3JN1EaPf6/JghbUT6Wnwoik6UB2uad60W
	 F+OqlS18RLab4S/sCGDczHk9IecRsND+5ApCzk+i35ZTUxRfHCnTalHjGIk/uhg11l
	 gUq11R+zOKG80zzhef3mho+aL3eBiA4jfVZ6GC5jJbGFs4NzSOebSV5fxZnXWs6bY/
	 bBklomMZE2Auoi+2g/Y/Z+e+i5qHE9SQHjhdVv4HZdD6moU4taAbLw07h56aks4Bny
	 BNu6WndnmhoxLuKCVl8iOPqmpv9Xvq8bYpKxrizmj35icGNADXCAJekJuysXjwsyXt
	 tOVbj42hUEHOg==
Date: Thu, 06 Feb 2025 14:34:04 -0800
Subject: [PATCH 13/17] xfs_scrub: return early from bulkstat_for_inumbers if
 no bulkstat data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086259.2738568.15642483253868951064.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If bulkstat doesn't return an error code or any bulkstat records, we've
hit the end of the filesystem, so return early.  This can happen if the
inumbers data came from the very last inobt record in the filesystem and
every inode in that inobt record is freed immediately after INUMBERS.
There's no bug here, it's just a minor optimization.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 4d3ec07b2d9862..3b9026ce8fa2f4 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -65,7 +65,9 @@ bulkstat_for_inumbers(
 
 	/* First we try regular bulkstat, for speed. */
 	breq->hdr.ino = inumbers->xi_startino;
-	xfrog_bulkstat(&ctx->mnt, breq);
+	error = -xfrog_bulkstat(&ctx->mnt, breq);
+	if (!error && !breq->hdr.ocount)
+		return;
 
 	/*
 	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce

