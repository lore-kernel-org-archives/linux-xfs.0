Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F219048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990328; cv=none; b=WkzyP7RCbFP5hrdfwd+O5VrrWh3/w+9jQVk/+ZGowLHWmtI4A6FLFNvMocJb/TAh58pRT2W/hSB6ShFws3YqQ7m7N5IiW/WOl4W37rfE6bhVMd7cXX7pVGkZT9eEDdHlWpxisFoEUTxmTNdWp17bwIMT8bTnIyM1sFeSY5tmYoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990328; c=relaxed/simple;
	bh=dIwngUAllLCIFo9fuvFGhs/Z4uqBhX4bjwnojaYl6aQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfSoohmVq/kNubhOHW9uNTtHCYkuk6Pywg3auDcqHagG4atcgcaPa1HtUN90heZgar6KsXrVm7FVJMYnX3M4bFpc7OOE6BxYdfAN/3degpFouPCCse7rA4F/MZRwaP6gIulu83HLjYAdxPyJk3cdTK80md/Qw/9czRb4UB+UNtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJ9KUgHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJ9KUgHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3F2C4CED3;
	Mon, 23 Dec 2024 21:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990328;
	bh=dIwngUAllLCIFo9fuvFGhs/Z4uqBhX4bjwnojaYl6aQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LJ9KUgHS+z3rlHy/LzRTErPzdQCTPSpfM91GPUQYzfMd9DkXD5zlFJATCM+FWcQ2i
	 JSyuM2HWzpfeKjIQm08amaGiM7HfhkOSwSrkjqHPwcLJgA22qNnJuYUA7/oNZw5fop
	 HwESijbzHhGJO0rAvWpQ71b/HfFDhVscpQuz9Zl3pejPuIjedbLin2EqzzeguiNXEh
	 /Ey5ld/eUzVhllIhA2nBrQnknAr1+vGRbp6kiBraGGIB70v5AZfJswo+3quzsQY7Er
	 E6bHQicWGOy8FIA1dVznYJ2uKIxJhHmZl9fPJIVK+oIoVi6tRdw7/S9OriOHZXfmV5
	 tvxtsCovrG44g==
Date: Mon, 23 Dec 2024 13:45:27 -0800
Subject: [PATCH 32/36] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940432.2293042.4388607088123847451.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
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
 

