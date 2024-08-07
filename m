Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5FE13CFA3
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058097; cv=none; b=pnaR16P+WBnbM1ps3xB/WmAYq3qhGTv8mw4Vp1FyRSTgUm8qpCnmWxbvnI0DgNr7oFCHnFv7FQm4sJ7plbXdgrs2ofWPTFW9BbHeFE9I3AZMUPOzjcyiNcCN0sxS2SBIZjgJ2q5YR4DmjZje6uX54i/wEXmzECxWzWjJu4rGjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058097; c=relaxed/simple;
	bh=kgkb46v7suy+I5vqP3isDpQz1hwwm+X+K3j8fc3dy5Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJbV0CZ/mDo5grG2BL3JoKL7C46nC4e++F1FydZ3SJngbcJ3sB0hm1lsVC0E8EQZDXVyBNNyMRSJrTL55fAmEDrUvV9mVWeaA/4vT33dnlBWggD6u5VHbCxxeZAwYQTQ9PW3pu/cajvtVhDWMYimRpyMsmR49sUSu4c3tQMFzCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSoPdEQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSoPdEQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3549C32781;
	Wed,  7 Aug 2024 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723058097;
	bh=kgkb46v7suy+I5vqP3isDpQz1hwwm+X+K3j8fc3dy5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GSoPdEQJK9kSqkHj0Vk/Hi1maJ0w28GJDUHxEV1Psex8iLnpLKSdsFMqXKcvK9fPN
	 17b9B8ZDGiclEALrZ3IzaLNs2kaeQZh/AJxcNl5zAEIbDG63U7R6hbL5c/Lzv3wGUA
	 pMtLPflZOF49R9RpY6WnMgiZA3Rge5AhBOAKhNwLscx4tuFWm85gBdfPZSMIyPYSpM
	 ZNEkp5WEowjv7kBrRA9LhosgOUWLp5N3DaT1ywimKUOSwjweJi8Z3IdKBS1ZA7QTy2
	 qmUYwn+ZBO2B8mptMTrbYbTWNKpUUY8MxmLsSxwv2IRF4ixQJgoMofnSeBG9W/EyJ4
	 Wvo1qX0jMDUqw==
Date: Wed, 07 Aug 2024 12:14:56 -0700
Subject: [PATCH 4/5] design: document the metadump v2 format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172305794147.969463.227865134024435978.stgit@frogsfrogsfrogs>
In-Reply-To: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
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

Document the ondisk format of v2 metadumps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 design/XFS_Filesystem_Structure/metadump.asciidoc |  112 ++++++++++++++++++++-
 1 file changed, 109 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index 2bddb77f..a32d6423 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -6,6 +6,9 @@ snapshot of a live file system and to restore that snapshot onto a block
 device for debugging purposes.  Only the metadata are captured in the
 snapshot, and the metadata blocks may be obscured for privacy reasons.
 
+[[Metadump_v1]]
+== Metadump v1
+
 A metadump file starts with a +xfs_metablock+ that records the addresses of
 the blocks that follow.  Following that are the metadata blocks captured
 from the filesystem.  The first block following the first superblock
@@ -21,7 +24,7 @@ struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
 	uint8_t		mb_blocklog;
-	uint8_t		mb_reserved;
+	uint8_t		mb_info;
 	__be64		mb_daddr[];
 };
 ----
@@ -37,14 +40,117 @@ Number of blocks indexed by this record.  This value must not exceed +(1
 The log size of a metadump block.  This size of a metadump block 512
 bytes, so this value should be 9.
 
-*mb_reserved*::
-Reserved.  Should be zero.
+*mb_info*::
+A combination of the following flags:
+
+.Metadump information flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_METADUMP_INFO_FLAGS+	|
+This field is nonzero.
+
+| +XFS_METADUMP_OBFUSCATED+	|
+User-supplied directory entry and extended attribute names have been obscured,
+and extended attribute values are zeroed to protect privacy.
+
+| +XFS_METADUMP_FULLBLOCKS+	|
+Entire metadata blocks have been dumped, including unused areas.
+If not set, the unused areas are zeroed.
+
+| +XFS_METADUMP_DIRTYLOG+	|
+The log was dirty when the dump was captured.
+
+|=====
 
 *mb_daddr*::
 An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
 << mb_blocklog+) following the +xfs_metablock+ should be written back to
 the address pointed to by the corresponding +mb_daddr+ entry.
 
+[[Metadump_v2]]
+== Metadump v2
+
+A v2 metadump file starts with a +xfs_metadump_header+ structure that records
+information about the dump itself.  Immediately after this header is a sequence
+of a +xfs_meta_extent+ structure describing an extent of data and the data
+itself.  Data areas must be a multiple of 512 bytes in length.
+
+.Metadata v2 Dump Format
+
+[source, c]
+----
+struct xfs_metadump_header {
+	__be32		xmh_magic;
+	__be32		xmh_version;
+	__be32		xmh_compat_flags;
+	__be32		xmh_incompat_flags;
+	__be64		xmh_reserved;
+} __packed;
+----
+
+*xmh_magic*::
+The magic number, ``XMD2'' (0x584D4432).
+
+*xmh_version*::
+The value 2.
+
+*xmh_compat_flags*::
+A combination of the following flags:
+
+.Metadump v2 compat flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_MD2_COMPAT_OBFUSCATED+	|
+User-supplied directory entry and extended attribute names have been obscured,
+and extended attribute values are zeroed to protect privacy.
+
+| +XFS_MD2_COMPAT_FULLBLOCKS+	|
+Entire metadata blocks have been dumped, including unused areas.
+If not set, the unused areas are zeroed.
+
+| +XFS_MD2_COMPAT_DIRTYLOG+	|
+The log was dirty when the dump was captured.
+
+| +XFS_MD2_COMPAT_EXTERNALLOG+	|
+Dump contains external log contents.
+
+|=====
+
+*xmh_incompat_flags*::
+Must be zero.
+
+*xmh_reserved*::
+Must be zero.
+
+.Metadata v2 Extent Format
+
+[source, c]
+----
+struct xfs_meta_extent {
+	__be64		xme_addr;
+	__be32		xme_len;
+} __packed;
+----
+
+*xme_addr*::
+Bits 55-56 determine the device from which the metadata dump data was extracted.
+
+.Metadump v2 extent flags
+[options="header"]
+|=====
+| Value		| Description
+| 0		| Data device
+| 1		| External log
+|=====
+
+The lower 54 bits determine the device address from which the dump data was
+extracted, in units of 512 bytes.
+
+*xme_length*::
+Length of the metadata dump data region, in units of 512 bytes.
+
 == Dump Obfuscation
 
 Unless explicitly disabled, the +xfs_metadump+ tool obfuscates empty block

