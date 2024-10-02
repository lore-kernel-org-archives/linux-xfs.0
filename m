Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4B6BA50
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831303; cv=none; b=TtA5xKPKJkGiPchHw8l++4K7GfVrBTbt5SLteDvJaWIFBVp8D2yq0O20BchhnB/CmhgpOv7F3lAlV4epXJvjiyeFXslBBe67u0uxgLAPJE/vDI/M7dILlMYMbak1wMCDK8R7j/9CCJRvIEjYNzf8d2dDo9C57K3iOqNAghIxrbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831303; c=relaxed/simple;
	bh=sfc7wdrF1sM8tEs+W5K5ygN8muuVo3o30E4O2kdmbzU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHY5Tk1egLn93X5zgCrWAND/z/RyJasOZQJRWW8tPFJzdnjGK3WvevXGdjSGr6jFGC6inGvkmCn6vmtwJArFn2ox2M20cdu5C0SUNmW6O/vkrf2pcUqObJy75TaO0EaKEQR/Q8Z28UwrMIp6ggLNcJSoY5tzhW/FW2zkSJSLCmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgjNbO/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgjNbO/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D69C4CECD;
	Wed,  2 Oct 2024 01:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831302;
	bh=sfc7wdrF1sM8tEs+W5K5ygN8muuVo3o30E4O2kdmbzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JgjNbO/Zr0gZ4GZJJV4Vm5XLQIDyJaJ2qi+4rUrOHJpKNSqs4hkkUwMslHqpcL2OU
	 QlPxcrsTYrGR9V+vJAi6gUOKdx5MGkOOWboTOn2tArKYrHMn2wdmnufhfs2KVnNlEO
	 u1hkgHRQmYb1PEt9YjivfbmP3N4OSF7kKdgymKEBzTWk0wkC33Ce9OiY/9iQtdl7Lw
	 pqWyiUjyJezofI3kfDxp7nWXCHxfLzFk7gA1K6VORGl8FbTnTJ9U3qlfLAjAg4gl1g
	 npJI89gNQ+ZMjmKAxPSus1OI+o1r/x5wHDR4jgBs6xo1Wc2SLSlDPuqXrcKWWGvdGC
	 sTwbOgkzvWZpw==
Date: Tue, 01 Oct 2024 18:08:22 -0700
Subject: [PATCH 02/64] xfs: don't walk off the end of a directory data block
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: lei lu <llfamsec@gmail.com>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101810.4036371.11774176230375082405.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: lei lu <llfamsec@gmail.com>

Source kernel commit: 0c7fcdb6d06cdf8b19b57c17605215b06afa864a

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. Before patching, the
loop simply checks that the start offset of the dup and dep is within the
range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
can change dup->length to dup->length-1 and leave 1 byte of space. In the
next traversal, this space will be considered as dup or dep. We may
encounter an out of bound read when accessing the fixed members.

In the patch, we make sure that the remaining bytes large enough to hold
an unused entry before accessing xfs_dir2_data_unused and
xfs_dir2_data_unused is XFS_DIR2_DATA_ALIGN byte aligned. We also make
sure that the remaining bytes large enough to hold a dirent with a
single-byte name before accessing xfs_dir2_data_entry.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_dir2_data.c |   31 ++++++++++++++++++++++++++-----
 libxfs/xfs_dir2_priv.h |    7 +++++++
 2 files changed, 33 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 0c77245ee..65e6ed879 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -175,6 +175,14 @@ __xfs_dir3_data_check(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int	reclen;
+
+		/*
+		 * Are the remaining bytes large enough to hold an
+		 * unused entry?
+		 */
+		if (offset > end - xfs_dir2_data_unusedsize(1))
+			return __this_address;
 
 		/*
 		 * If it's unused, look for the space in the bestfree table.
@@ -184,9 +192,13 @@ __xfs_dir3_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			xfs_failaddr_t	fa;
 
+			reclen = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
 			if (lastfree != 0)
 				return __this_address;
-			if (offset + be16_to_cpu(dup->length) > end)
+			if (be16_to_cpu(dup->length) != reclen)
+				return __this_address;
+			if (offset + reclen > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    offset)
@@ -204,10 +216,18 @@ __xfs_dir3_data_check(
 				    be16_to_cpu(bf[2].length))
 					return __this_address;
 			}
-			offset += be16_to_cpu(dup->length);
+			offset += reclen;
 			lastfree = 1;
 			continue;
 		}
+
+		/*
+		 * This is not an unused entry. Are the remaining bytes
+		 * large enough for a dirent with a single-byte name?
+		 */
+		if (offset > end - xfs_dir2_data_entsize(mp, 1))
+			return __this_address;
+
 		/*
 		 * It's a real entry.  Validate the fields.
 		 * If this is a block directory then make sure it's
@@ -216,10 +236,11 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
+		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (offset + reclen > end)
+			return __this_address;
 		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
-		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
-			return __this_address;
 		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
 			return __this_address;
 		if (xfs_dir2_data_get_ftype(mp, dep) >= XFS_DIR3_FT_MAX)
@@ -242,7 +263,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		offset += xfs_dir2_data_entsize(mp, dep->namelen);
+		offset += reclen;
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 3befb3250..100413502 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -189,6 +189,13 @@ void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
 		       struct dir_context *ctx, size_t bufsize);
 
+static inline unsigned int
+xfs_dir2_data_unusedsize(
+	unsigned int	len)
+{
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 static inline unsigned int
 xfs_dir2_data_entsize(
 	struct xfs_mount	*mp,

