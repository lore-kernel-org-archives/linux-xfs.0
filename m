Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0F7BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928073; cv=none; b=eu79mJ+/YsUF43Ko5CnmY1wufos7RwZsmoFPF4XJWQYdSWpxrdqLB8g/aPy5Z1/Fb3at0IOYj2kxbpkSGSrxHT5eQlVEiK9IlRl+CIiDWXi1SRlkRX38cudJLqysZWgnfFo0k5Q+u/2KEn21CtHzxC4q/umOdeTVCtpOlYWP/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928073; c=relaxed/simple;
	bh=NVf3bMUUmzBmRDL387Yg34YN7iRMtqR/ABWhgd+xc54=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WRoWKk/HGtbHUnAu0RiLAfVtZu0jpVn0S3K7eH3ax/ctkz8/97hTyyVvvKlyQz/nhjRcfShzyfyr1Cc6om5ZPM8bQcLeP2hIO4I6D+kmCr02/qlDFoaR4F6z403Zi9RKhm0F93SooHkJKJh19ed6OPImt8IqNAX4PEPf9EJYSYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLSgQszq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLSgQszq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AB6C116B1;
	Wed, 24 Apr 2024 03:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928073;
	bh=NVf3bMUUmzBmRDL387Yg34YN7iRMtqR/ABWhgd+xc54=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cLSgQszq8hOVJhV1L8L+H3N5uTl0vaK3RGSBlfGKip9UvLTlNNCUV05vDGJEXY5cJ
	 ES3H12yiW0/m0n4oA6Y9+LCVfR9vu6MuZtXgDK5yDvtwVKpOpyEy/9mp8f+O2PiZ+p
	 e8HoVZKK4CdDPOSEFW2QdNg2rf7csgOlOaGvNglB4obuuuxdbyimea3U/z5loNwceO
	 PpDCjkn6VxbQLMRn1TibfLVRhmKL2bTtIrrCzRnnc2NXf0IamsYsVXvNZchBtbHrCI
	 dpw8rjcFZHtishR02A0s1NQIi/B6YAIcGdSVGCTIM63cMzVAMDLenmBiZTTX1qagsL
	 JUKJBjslXaS8Q==
Date: Tue, 23 Apr 2024 20:07:53 -0700
Subject: [PATCH 1/5] xfs: remove XFS_DA_OP_REMOVE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782127.1904378.1691673126590693268.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
References: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
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

Nobody checks this flag, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h     |    1 -
 fs/xfs/libxfs/xfs_da_btree.h |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e4f55008552b..670ab2a613fc 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -590,7 +590,6 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 static inline enum xfs_delattr_state
 xfs_attr_init_remove_state(struct xfs_da_args *args)
 {
-	args->op_flags |= XFS_DA_OP_REMOVE;
 	if (xfs_attr_is_shortform(args->dp))
 		return XFS_DAS_SF_REMOVE;
 	if (xfs_attr_is_leaf(args->dp))
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 7a004786ee0a..76e764080d99 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -91,9 +91,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
-#define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -102,7 +101,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 

