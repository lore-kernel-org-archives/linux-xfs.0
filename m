Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EEB59166
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798167; cv=none; b=Ex8V/m3FzPboXGuDZ4HoBUbGasgORTG7RZw2NHDzGP6wFh/Oezex0mIeGNBRa4FH1ViqdFYy4m4VG4US8p0xAF3AslSWEGXjU3aUEhTGs3eB1cFfmpne/yFCWcb3JHYdvenz0wRRtQd3DLrJcTZ1sOdIt0EcpIZpAgOSL2hDHIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798167; c=relaxed/simple;
	bh=wA440xyVa4N51fKAXQyPi5tJpvTLF9eR2wHxf2BMsXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHiMHZz5X7KOVou/Zz2PzhExJiO7IXeABPZrV/ESJJV6lZj7J9idkkM8J45Cux+J+dncBwi3JVV9Zzfm49na8YXw94kRu2PnS+4yIMstgYmWklXaYeIpoN1vQcPlyAxVXV4d6PtJWEDkL2Fj+3M+EwJbidlqpx3uJyU5xyaRosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEXfxkIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEXfxkIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B38C433F1;
	Mon, 18 Mar 2024 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798167;
	bh=wA440xyVa4N51fKAXQyPi5tJpvTLF9eR2wHxf2BMsXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AEXfxkILu2FbmgoB5sLTuylnMdFCEY4Cr2zanFhBvRCbnyhRpomYL1eDf23OgJlmF
	 zpsGyYHitb9ilTuSW1BGPB4HU9ab0/HwoIrTDB1HBuKTaHCDB2u+5VCiUwQywG+Uoq
	 WVtvUoC6vR++Dbsfb/kSXeM7ROHPVc5Uu+vO/kIyoRko5VcLvdodft+Pas5PanOCQw
	 MYvcDwnKQp3SzSH+Fln0UsdzAhbtEC5VGN8KTvjRNUdoS7P3uyX2q1fTey7PRkJhUg
	 KW/urxYR3gNoVqh5PYjHCgZdwYc4apLNLP9pzG78Qg99NbIQOIY1OnYTp2hOsae7bx
	 v05fHClJteNdw==
Date: Mon, 18 Mar 2024 14:42:46 -0700
Subject: [PATCH 03/23] xfs: define parent pointer ondisk extended attribute
 format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079801921.3806377.16226630714090690246.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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

        name={parent inode #, parent inode generation, dirent namehash}
        value={dirent name}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.
Storing the dirent name hash in the key reduces hash collisions if a
file is hardlinked multiple times in the same directory.

By using the NVLOOKUP mode in the extended attribute code to match
parent pointers using both the xattr name and value, we can identify the
exact parent pointer EA we need to modify/remove in rename/unlink
operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: replace diroffset with the namehash in the pptr key]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index a1d80fc685237..d9d35575216f9 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -883,4 +883,24 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name encodes the parent inode number, generation and the crc32c
+ * hash of the dirent name.
+ *
+ * The xattr value contains the dirent name.
+ */
+struct xfs_parent_name_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+	__be32	p_namehash;
+};
+
+/*
+ * Maximum size of the dirent name that can be stored in a parent pointer.
+ * This matches the maximum dirent name length.
+ */
+#define XFS_PARENT_DIRENT_NAME_MAX_SIZE		(MAXNAMELEN - 1)
+
 #endif /* __XFS_DA_FORMAT_H__ */

