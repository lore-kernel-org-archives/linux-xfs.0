Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1408617F0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230857; cv=none; b=giWFnoWNMBtf7OE5mSAMVkW8r7dtneOUM0q+v5dgLqNPd7Jtz4hTWz5Za0foDHtNo7l611vqNRWGc/uoGoI0aoW3chMvpmmMZZrePfI1LM94fvc1IJRgc7vvZWO3rXOWtMfNheoifNRX8KIeqETr8KHyqRz3mjrS+SVH97HxVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230857; c=relaxed/simple;
	bh=PCXxF8Ex1V5nSIBpyvyVEKYZz5j8FqVWRLg2CFBenIU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=johSKgJjGR5EdfD8xwqbi9kkplOk9V4Ky7mwM+S/fGlpc9cPF2OT2FeqO/l34x1B5bzeSa48cxNtCFHDYKPFnPPP+Rn9uFVu96i73jXuLjx1ZZV+rSCH4gyO0sZta6vUF2gpBAQUGW3/VcalKRicSWofPprzytmWSF2CK8jAbBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVNu0dG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVNu0dG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA9FC113CC;
	Tue, 16 Apr 2024 01:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230856;
	bh=PCXxF8Ex1V5nSIBpyvyVEKYZz5j8FqVWRLg2CFBenIU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVNu0dG5P7vpv7BLKYccWuKG3DeI67G4PpPhJbPHiwyoExGJlWNe5LS/x+M1z+HPQ
	 4YKBQsZaWmcKoIZJRkhcbHxvVJ/fE8N52jAkdMWSyqeGb79s1u5wYIHN0Ha52sVAEC
	 wX0zRpHqxJwn/yNiSZzUzThNblN4VzkTN1hxjByAbX8QhI53X0AfDnEjoLrkfdDh28
	 DkV2/F0EEXjv6a+pVXt0AeKR4lfO0nIt5bDWOtIW1ck5Z/4EJY6h1D/PqWIcI2Z6jH
	 1oT7hYCxHKZ9KJtMUlNKsEipFQVir0Zg0i4I5AhgxxGkZ1/SqpZGT0bNLkZo0j66L2
	 rN3ZzGwpm/h9w==
Date: Mon, 15 Apr 2024 18:27:36 -0700
Subject: [PATCH 06/31] xfs: define parent pointer ondisk extended attribute
 format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027884.251715.15032727408274787215.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={dirent name}
        value={parent inumber, parent inode generation}
        hash=xfs_dir2_hashname(dirent name) ^ (parent_inumber)

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the name-value lookup mode in the extended attribute code to
match parent pointers using both the xattr name and value, we can
identify the exact parent pointer EA we need to modify/remove in
rename/unlink operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h |   13 +++++++++++++
 fs/xfs/libxfs/xfs_ondisk.h    |    1 +
 2 files changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 0c80f7ab9475a..1395ad1937c53 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -890,4 +890,17 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name contains the dirent name.
+ * The xattr value encodes the parent inode number and generation to ease
+ * opening parents by handle.
+ * The xattr hashval is xfs_dir2_namehash() ^ p_ino
+ */
+struct xfs_parent_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+} __packed;
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 81885a6a028ed..25952ef584eee 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -119,6 +119,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

