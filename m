Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9EB17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481380; cv=none; b=l+yAInUgwyRkvLL7FJjW5/B4OmQw7Orhe3gEFX/AWGeCLXNWBnbAgL99MRbr8kxa5nxTsTbQY7Rr4yUpKCFxyona/C7tOhwTyZNpOM6r1CSeeBBC41RcwG6LWLd7MMCLpfr6YJiquUcR7I2Q9if/7bObhpT3M/8/NZ6I9xpavIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481380; c=relaxed/simple;
	bh=ByQ2paw3lCvCs8m2RawGJZ1dbquqkvo3DwpcSPRpl1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nZWvx674XAk02bsexB8nhXrf5Mtdcl11kIkSOlv43HDE407+/OO6tMiFvqTNSZhy8QWge9OTriswLk7+uXB8jHvjsgTHtVYljuyuWeebm1WECFQdByrBlrtg6n3jX+qppxnsmgciz9Mo3Dezt9zpMmTlE86L+IpYFkR058LROq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bSYLkvHP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bSYLkvHP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lw1QlIlo8n8YbxYcxV2TWEHM4cqB42SUKvArEpT37GE=; b=bSYLkvHPO2OTYOOLljRv2qo6P1
	i3rODwS4zR6ymo+vNaUQRsBGp5VBckGjbcv0ZzqZfTnqWVSNypfLGhnj7qNrF+MycsdgPGl6XVFCy
	Bi2c1zL4iPsNnlK537YjN3/U0WW1hgwJZy74fQeYeWFdo7sVhK+NznJ8ycciE6SCP/bY8sKNqNU3w
	b/jvQJIRO4z6wsgZijjXkYH0oKyzW+fUImLervSDnq2HarLqCjBiW8UZrLXPeP0T8NTT2hBwVR5oh
	Jglbz2VK3905DLS+bVjIP7P2Pfd5U/w8KDVPTsUAZ1O2sxiSncWKowtzuwaFBWs7dHNWDsYj6faGU
	uBl5vxzw==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvS-00000006NhT-37O1;
	Tue, 30 Apr 2024 12:49:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/16] xfs: rationalize dir2_sf entry condition asserts
Date: Tue, 30 Apr 2024 14:49:13 +0200
Message-Id: <20240430124926.1775355-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Various routines dealing with shortform directories have a similar
pre-condition ASSERT boilerplate that does look a bit weird.

Remove the assert that the inode fork is non-NULL as it doesn't buy
anything over the NULL pointer dereference if it is.

Remove the duplicate i_disk_size ASSERT that uses the less precise
location of the parent inode number over the one using
xfs_dir2_sf_hdr_size().

Remove the if_nextents assert in xfs_dir2_sf_to_block as that is implied
by the local formt (and not checked by the other functions either).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ----
 fs/xfs/libxfs/xfs_dir2_sf.c    | 12 ++----------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0f93ed1a4a74f4..035a54dbdd7586 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1105,12 +1105,8 @@ xfs_dir2_sf_to_block(
 	trace_xfs_dir2_sf_to_block(args);
 
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
-
 	ASSERT(ifp->if_bytes == dp->i_disk_size);
-	ASSERT(oldsfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
-	ASSERT(dp->i_df.if_nextents == 0);
 
 	/*
 	 * Copy the directory into a temporary buffer.
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 17a20384c8b719..1cd5228e1ce6af 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -378,9 +378,7 @@ xfs_dir2_sf_addname(
 
 	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(sfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Compute entry (and change in) size.
@@ -855,9 +853,7 @@ xfs_dir2_sf_lookup(
 	xfs_dir2_sf_check(args);
 
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(sfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Special case for .
@@ -920,21 +916,19 @@ xfs_dir2_sf_removename(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
+	int			oldsize = dp->i_disk_size;
 	int			byteoff;	/* offset of removed entry */
 	int			entsize;	/* this entry's size */
 	int			i;		/* shortform entry index */
 	int			newsize;	/* new inode size */
-	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 
 	trace_xfs_dir2_sf_removename(args);
 
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-	oldsize = (int)dp->i_disk_size;
-	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == oldsize);
-	ASSERT(sfp != NULL);
 	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->i8count));
+
 	/*
 	 * Loop over the old directory entries.
 	 * Find the one we're deleting.
@@ -1028,9 +1022,7 @@ xfs_dir2_sf_replace(
 	trace_xfs_dir2_sf_replace(args);
 
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(sfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 
 	/*
-- 
2.39.2

