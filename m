Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F4A1C548E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528316; cv=none; b=epLbVgfYvRCzSFOPYHrWURhh6RBjHolHTTXwFrV0iEMmQm9bQjCA15foWv5plQVimKoL68393DSLz9wOUGzIZxIajRadl5dm/L8b9G8o82IfX+NdU0R32BVVuVvsusxKcZp2PFj5ms0QkIS83SXoOAazRgWaXf2F0qItYA6ZFdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528316; c=relaxed/simple;
	bh=dIwngUAllLCIFo9fuvFGhs/Z4uqBhX4bjwnojaYl6aQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLu6BM0+gU1jigCmcYIOVJJRmgaGBuw94LMh4PL0tvgCIPipcrABrNz9U93O3XSQ0S4VgiJ5atiJGEQF4z2l8BjZui3svUZX5mTKbM6TQYO9Qh0xE0Ode/iK3v4L07+PnCzyC8HAQay/0ZD63B1WQizW0ARcR/iy4tlZisw98V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzACcqBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzACcqBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB8FC4CED1;
	Fri,  6 Dec 2024 23:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528316;
	bh=dIwngUAllLCIFo9fuvFGhs/Z4uqBhX4bjwnojaYl6aQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nzACcqBCwLet8VXSDFMUVYChSh3ALTQFLNdDrlYeZbsmaI5264iNOIzov8vwEw8Sz
	 g9y4fzRY/oVTquLFg2nbqN9YdF4WPhM8/6aoPH6qR4yDBh+XgIfqSJ2FWtjoosaFYW
	 Iy73RAU9zVBhe/HIl4k6EsyNtwv7WUS2/Xzw1K2VZj2mAmJmTlDK1ujF5hrRb1PbRg
	 d3DZhCW0BaM/dL4tVc4483OJKLqYkNqPMB2UaXu0ND+cmNy+6mbrUcse8AcS6hftBD
	 wTFy1DPOY/su1tQ9bzG6O9VPq3/QOFmqj3xERLZuErjTSwhJMWg89GqOwJKgApdqs5
	 GsqNzatiG+oXA==
Date: Fri, 06 Dec 2024 15:38:36 -0800
Subject: [PATCH 32/36] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747365.121772.15504972794584218787.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 688828d8f8cdf8b1b917de938a1ce86a93fdbba9

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    1 +
 libxfs/xfs_sb.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 860284064c5aa9..a42c1a33691c0f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -242,6 +242,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index de12edd8192e1c..4ca57d592be8fa 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1306,6 +1306,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_has_exchange_range(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

