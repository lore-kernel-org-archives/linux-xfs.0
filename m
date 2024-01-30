Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F98333981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591151; cv=none; b=KEIR5gr0OUSK3hEaHzWwLzH6HL/bVjkQJCxK9BZMsMf8mQYd0FBHu5mbHtRQmnh4iN3JT+Dm+ilD9f6CkB7lEnQl10tadK/zWgrxjYBbopGKDBzSCrhQRoP92ZkcVY9VA8ZBE1aq4SkFwcaq/KyEcGm0TYyhX2qAMuskRLV2DHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591151; c=relaxed/simple;
	bh=WxBEdAOGc88owLjShlcNPqU1GKD5clvABdaCFLv8B6U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFjhtSeRAyAY8Y3wwGWqzG/Kl3bvh+2AxVIliItNWiBFLI4nWzDrvyXdiI3trbr6kDYo2dfr/ksbEjBQ7atO0E/cUsbevJazkA97C0bdSCQUvak1GTgj42CmrHMGZrvfvrCrlVBJn0SQ7FNx9vAyr30g5WgS1B4GEmDGP/RjU8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uUjTAxaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uUjTAxaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41B1C433C7;
	Tue, 30 Jan 2024 05:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591150;
	bh=WxBEdAOGc88owLjShlcNPqU1GKD5clvABdaCFLv8B6U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uUjTAxaYYIYe3j4hb0YzB2iMBBb6kEKk2fW0+1N1XcoLQyKT0ExWVBUXslKT9q50Q
	 aSXtOQGBGhw1dMZMNxafdjOcGeIrZpkgTTVQh5oYyRUt79S4MyLuEv8ZpQeNm/NjpY
	 HBIfgwcJiTIrr0coJY5r3/PZEXjAVw9q+H/Icz/9LkFFA6nEYlqJnlbZFBPup6x8pm
	 v9r1VpIcrqu6G44Bx85WCry8oUVlS3Ci56pDu62G5CMjhWu6hNoOcJLG06o3aHc9jA
	 gkCGEIH2KM4TUhpOVNQb9ks9GhTXvpq6eQr1txyM41vxnJr4di/kGXRl1mQl8I2DWl
	 nlBqouJ2o5Ngg==
Date: Mon, 29 Jan 2024 21:05:50 -0800
Subject: [PATCH 3/4] xfs: create a macro for decoding ftypes in tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062349.3353217.11576095008682851869.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
References: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
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

Create the XFS_DIR3_FTYPE_STR macro so that we can report ftype as
strings instead of numbers in tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 24f9d1461f9a6..060e5c96b70f6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */

