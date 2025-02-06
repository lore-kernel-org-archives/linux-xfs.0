Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA2C1F78E6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881716; cv=none; b=jtUX1eVsd7N4bv00VaJcHnM9Zxpg7qW9UQKQcukyX7I6Op7RHHLezbs0ugYmAZMsnO3/cMzTBPkPZGi3JCnmSY7wDBofHDFsSwgpXe1I6qs7TUio7hjhdhZsafZWghlWC+49zxmyESsSxUWGPHlKNVUuVTrzFs8Ir9f2KM0V/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881716; c=relaxed/simple;
	bh=YH3fxmWNWly0CHSe3+nNM+aJuWmbyjgZcvMesyctj8c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RR5svMmrtnCm0prdGeREYJ7lg+mbOQvky50RsNQgkMbKSYCRZzHFj6a7iwBGPirLX9l48tp/bs588m6UrW62/ooT/BZ8InP4iiRpe1QVxyMGki0MEXCXzuWprsaBacTzXr740ofKFOLU9LdeH+Zr0r5BYzEEpvKkxg1Sy7gTbew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwUpGYbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwUpGYbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E27C4CEDD;
	Thu,  6 Feb 2025 22:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881713;
	bh=YH3fxmWNWly0CHSe3+nNM+aJuWmbyjgZcvMesyctj8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZwUpGYbLDXbKiQmSYyJul1uwCA4xriY4A74KWRRbeCSAIwALUuLGLrD2L+C+UEwVu
	 CPrSI+D/6iM8zD1nB7m9ey9SMuBXKHSf8t31cxurL1YJ+6X77FpG4YhFDTUF2IBE2A
	 WoUwgDAjinl1crx4wajzrrKlDGssEcy/vy4WEwZOF9PAgY/U7lMW5PzdBRrVd2nAFH
	 Uw64CZztEP5yasTFjMNT2VvjcGTSZZplS+ggW4d26w/UCaVZZzM7QLZGaCz7HqYVkC
	 nQfplCktRSJDPKSxil/kEjx+UR00uXNHglKk1lypDJ5Wj4bLtltVhaLXCTcmY+Xexa
	 YbjU9QQwHFm6A==
Date: Thu, 06 Feb 2025 14:41:53 -0800
Subject: [PATCH 26/56] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087189.2739176.9033435138466485684.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9a6cc4f6d081fddc0d5ff96744a2507d3559f949

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7cca458ff81245..34fcbcd0bcd5e3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -737,9 +737,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
+#define XFS_SCRUB_TYPE_RTRMAPBT	31	/* rtgroup reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	31
+#define XFS_SCRUB_TYPE_NR	32
 
 /*
  * This special type code only applies to the vectored scrub implementation.

