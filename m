Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987FF22653F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882090; cv=none; b=ZgEgQbampTxySGPHuV5yVWI6Hs2YmkC/jj3X5B1IeflMx4vnQbu201ozTMV96dOt9uQuQbGm5nLoOTCxr46mrJCOCONFv+jPp/SCa0OjX575TB714o8qEq6+tt5tOnNdEW/Nokb7bk0vsGA+M3OTbWMGU/4pn2RA9n5VeORZzh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882090; c=relaxed/simple;
	bh=BLWaOt7xYXfND77ue0bbybGsY2lSxd8AQ2dbLBm/2AE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XoQaykIW5EaYeX2EXuu1mOxJVmiZ80SCXeqEZGo00ZbSevMWBnbRqKKikxhocaSc71CCj/NnByfKXos44VHRORTYhvbEx8CCcubNq3TaNSFs3aof6glQulnVYEzRCB+RNFAUw3zYSa0rIf7hUqsyAEKA4J9Yt17mYRo0x66KLm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfmam4pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfmam4pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EDCC4CEDD;
	Thu,  6 Feb 2025 22:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882090;
	bh=BLWaOt7xYXfND77ue0bbybGsY2lSxd8AQ2dbLBm/2AE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qfmam4pzDmUD9NuKHl9f6zPssD5LqOKhDqKzrKNb2BwbSexTl8n/YOtUc86grjDcp
	 WGHZm+rQlfWpcKgg5jDDfwzWCBlsR8ZMV5VEZnlrdng5dIigo5tGJhUrIqkIgIatMn
	 i1Epio7SRstc9sPi2lyiTAPnieuskG8SjXa3LyUcrlPOQTalbN/j9+P481pHod6cGh
	 kv5XCXyNQnjqI6lqHkzDr/pAG7J/1yfSKzbinD7Re+iLGGE+LBAETj3S0052l7mayc
	 Dvyl7Qg/LcFA466rNNO/BVVCx8w/8k71I8Odf+z4HNpdxpqKuaGZO2/DbGJyiDQH/t
	 Pz9GDMknoi4dA==
Date: Thu, 06 Feb 2025 14:48:10 -0800
Subject: [PATCH 50/56] xfs: scrub the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087558.2739176.10474686975417803390.stgit@frogsfrogsfrogs>
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

Source kernel commit: c27929670de144ec76a0dab2f3a168cb4897b314

Add code to scrub realtime refcount btrees.  Similar to the refcount
btree checking code for the data device, we walk the rmap btree for each
refcount record to confirm that the reference counts are correct.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ea9e58a89d92d3..a4bd6a39c6ba71 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -738,9 +738,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RTRMAPBT	31	/* rtgroup reverse mapping btree */
+#define XFS_SCRUB_TYPE_RTREFCBT	32	/* realtime reference count btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	32
+#define XFS_SCRUB_TYPE_NR	33
 
 /*
  * This special type code only applies to the vectored scrub implementation.

