Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B62226196
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881604; cv=none; b=K9rU5eVbGEk7b5dxdKoT3gz5xTILKmTyQARrh3kx7fYPpNcKMpjZxq6+cQBIQvhpqYqhK6Ay4CDfqqq1X9mENlCM0oiZAOdxXb+54nbmFQdIynre8C3IitiLeLYhzDFwmt330sArn3ACu79zHvkFCuyWAnqpzQ1+ZZLqDsASMOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881604; c=relaxed/simple;
	bh=ncOzjixC6T7tlTlb/vr6pTa0iIqfn1Fs22Xy7PXZGs4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7fkcaKLgYTSrpX97eLBwjZJ2Rs6Uv8shlZH/VjJGl5Ty5U09d19B9kS4p1nY/b0LJp0vNL3xvql25PRS0VGZ9audVz3w7RFZJHl6fgdX7JlEy9kM36UF2Do2iVuba0Os3qtHlw0oxxBHHpKqZZNxdAfKyAg1v5lNUig8rKBmmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvHR5x1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvHR5x1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DBCC4CEDD;
	Thu,  6 Feb 2025 22:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881604;
	bh=ncOzjixC6T7tlTlb/vr6pTa0iIqfn1Fs22Xy7PXZGs4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fvHR5x1xVzuPxJZ/EL2YVaNKXUAQ+3A2naD53ND6BXnm99y2O9xmu6n/ced1hOU/2
	 Tr+hXy0hGVhoaqcIk4b7Xwk2aNr/ZxmXdDKdl0aV65qe3/AM0ZppprCGUQIRXJqrDP
	 XgWm+kQcbghUHJiKcwR6/X/1OrJbrCXScRQMl19v17NxB+vClDifiuvYBqB1cWRwbf
	 x6aKao5eq7SHefx9r8btjpwmJoa82jHyxchjp06kv6tKBS1Dl3AI+4ob0LLKeRT2zR
	 prDjZK7g4lrr+WAjBq4LaPNo5ern7hazWXUROE7IGXNMrr+V/aSLf4EYApO6/ZXrNK
	 Y2Yn63WLa4qBw==
Date: Thu, 06 Feb 2025 14:40:03 -0800
Subject: [PATCH 19/56] xfs: support file data forks containing metadata btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087082.2739176.8945352228485275485.stgit@frogsfrogsfrogs>
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

Source kernel commit: 702c90f451622384d6c65897b619f647704b06a9

Create a new fork format type for metadata btrees.  This fork type
requires that the inode is in the metadata directory tree, and only
applies to the data fork.  The actual type of the metadata btree itself
is determined by the di_metatype field.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h     |    6 ++++--
 libxfs/xfs_inode_buf.c  |   23 ++++++++++++++++++++---
 libxfs/xfs_inode_fork.c |   19 +++++++++++++++++++
 3 files changed, 43 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 469fc7afa591b4..41ea4283c43cb4 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -997,7 +997,8 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_META_BTREE,	/* metadata btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
@@ -1005,7 +1006,8 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_LOCAL,		"local" }, \
 	{ XFS_DINODE_FMT_EXTENTS,	"extent" }, \
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
-	{ XFS_DINODE_FMT_UUID,		"uuid" }
+	{ XFS_DINODE_FMT_UUID,		"uuid" }, \
+	{ XFS_DINODE_FMT_META_BTREE,	"meta_btree" }
 
 /*
  * Max values for extnum and aextnum.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 98482cb4948284..10ce2e34969d99 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -438,6 +438,16 @@ xfs_dinode_verify_fork(
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (!xfs_has_metadir(mp))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+			return __this_address;
+		switch (be16_to_cpu(dip->di_metatype)) {
+		default:
+			return __this_address;
+		}
+		break;
 	default:
 		return __this_address;
 	}
@@ -457,6 +467,10 @@ xfs_dinode_verify_forkoff(
 		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
 			return __this_address;
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (!xfs_has_metadir(mp) || !xfs_has_parent(mp))
+			return __this_address;
+		fallthrough;
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
@@ -634,9 +648,6 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
-	if (nextents + naextents == 0 && nblocks != 0)
-		return __this_address;
-
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
@@ -740,6 +751,12 @@ xfs_dinode_verify(
 			return fa;
 	}
 
+	/* metadata inodes containing btrees always have zero extent count */
+	if (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK) != XFS_DINODE_FMT_META_BTREE) {
+		if (nextents + naextents == 0 && nblocks != 0)
+			return __this_address;
+	}
+
 	return NULL;
 }
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6bbff85ffba8e..b66dc4ad0f52ef 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -265,6 +265,12 @@ xfs_iformat_data_fork(
 			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
 		case XFS_DINODE_FMT_BTREE:
 			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
+		case XFS_DINODE_FMT_META_BTREE:
+			switch (ip->i_metatype) {
+			default:
+				break;
+			}
+			fallthrough;
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -599,6 +605,19 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_META_BTREE:
+		ASSERT(whichfork == XFS_DATA_FORK);
+
+		if (!(iip->ili_fields & brootflag[whichfork]))
+			break;
+
+		switch (ip->i_metatype) {
+		default:
+			ASSERT(0);
+			break;
+		}
+		break;
+
 	default:
 		ASSERT(0);
 		break;

