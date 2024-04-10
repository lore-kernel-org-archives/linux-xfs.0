Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9673391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710661; cv=none; b=LCmun1dbkoTtZV6hUdQzly9fySW91VNLpKTz5uHaOnmrybP6qfPvp14XnbGrB5r8oQgQJmy2dfWZe3SBYBe2KJKTIa1JMEu6f8o6l3zQs/jPQeU8GsEi+qdCLDiXSdu0Kl6Qoj9vSbU0TXfVLJkG19kTHA88bj5qlzMthd2kbYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710661; c=relaxed/simple;
	bh=pvhy8RNP8qkvL0hwZFDEUElpq873FoEElycEoymQ9qw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLwXQTs1l1kxGhfy3CZMRy9BS7CUB5WH/l/8ULWjKV8IKXztIROY6gsECJluNtwIUcxDDSWcMUG8VhFsydwHMxS2m19YLALItjsQ2ii35aUHQuM/GMD1zc+jgVqaB74ABbzzztQ5DN0Yyjw9wIsvprbHaXFkM4Bafx9yz9JGZsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5L8y5kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5L8y5kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C54DC433C7;
	Wed, 10 Apr 2024 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710661;
	bh=pvhy8RNP8qkvL0hwZFDEUElpq873FoEElycEoymQ9qw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y5L8y5kVOHdDIajDzbT7rYa5U6KyKRyhzkd7lYowrLb+LvVlGQq6bvScBap8eGNPU
	 r4e5NWGyZXo6cm93kenvddEGZ1CATYvnr2Da5YWi1dxA4nK8O0K7Ugj27AsJqf2CvR
	 cG6WgiJzFpPOKRD75AZ1M6D5kQpTNpdU5NBrSrzKiujbYwMdBlL96PHFEXDS0Cc0lC
	 OqNXoQTIGieKwwpvpK4+ofzmXFlBEtLD+BDoIS0EmxDFOV+x3VWVaEmoazAM2aOtqT
	 lm+ADC60+0FMmjcjBymHHLjjxCgPpw1bj/6PD81eO8h7cgZPTfhAgpLVB8yM2NvB5b
	 2pt6fN7o+Rxqg==
Date: Tue, 09 Apr 2024 17:57:41 -0700
Subject: [PATCH 16/32] xfs: create a hashname function for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969823.3631889.1348496929393481589.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Although directory entry and parent pointer recordsets look very similar
(name -> ino), there's one major difference between them: a file can be
hardlinked from multiple parent directories with the same filename.
This is common in shared container environments where a base directory
tree might be hardlink-copied multiple times.  IOWs the same 'ls'
program might be hardlinked to multiple /srv/*/bin/ls paths.

We don't want parent pointer operations to bog down on hash collisions
between the same dirent name, so create a special hash function that
mixes in the parent directory inode number.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |    3 +++
 fs/xfs/libxfs/xfs_parent.c |   49 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    5 ++++
 fs/xfs/scrub/attr.c        |    4 ++++
 4 files changed, 61 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 41de6a135d907..99930472e59da 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -439,6 +439,9 @@ xfs_attr_hashval(
 {
 	ASSERT(xfs_attr_check_namespace(attr_flags));
 
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_hashattr(mp, name, namelen, value, valuelen);
+
 	return xfs_attr_hashname(name, namelen);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 5961fa8c85615..d24104821a090 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -90,3 +90,52 @@ xfs_parent_valuecheck(
 
 	return true;
 }
+
+/* Compute the attribute name hash for a parent pointer. */
+xfs_dahash_t
+xfs_parent_hashval(
+	struct xfs_mount		*mp,
+	const uint8_t			*name,
+	int				namelen,
+	xfs_ino_t			parent_ino)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= namelen,
+	};
+	xfs_dahash_t			ret;
+
+	/*
+	 * Use the same dirent name hash as would be used on the directory, but
+	 * mix in the parent inode number.
+	 */
+	ret = xfs_dir2_hashname(mp, &xname);
+	ret ^= upper_32_bits(parent_ino);
+	ret ^= lower_32_bits(parent_ino);
+	return ret;
+}
+
+/* Compute the attribute name hash from the xattr components. */
+xfs_dahash_t
+xfs_parent_hashattr(
+	struct xfs_mount		*mp,
+	const uint8_t			*name,
+	int				namelen,
+	const void			*value,
+	int				valuelen)
+{
+	const struct xfs_parent_rec	*rec = value;
+
+	/* Requires a local attr value in xfs_parent_rec format */
+	if (valuelen != sizeof(struct xfs_parent_rec)) {
+		ASSERT(valuelen == sizeof(struct xfs_parent_rec));
+		return 0;
+	}
+
+	if (!value) {
+		ASSERT(value != NULL);
+		return 0;
+	}
+
+	return xfs_parent_hashval(mp, name, namelen, be64_to_cpu(rec->p_ino));
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index ef8aff8607801..6a4028871b72a 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -12,4 +12,9 @@ bool xfs_parent_namecheck(unsigned int attr_flags, const void *name,
 bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
 		size_t valuelen);
 
+xfs_dahash_t xfs_parent_hashval(struct xfs_mount *mp, const uint8_t *name,
+		int namelen, xfs_ino_t parent_ino);
+xfs_dahash_t xfs_parent_hashattr(struct xfs_mount *mp, const uint8_t *name,
+		int namelen, const void *value, int valuelen);
+
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d5c2e73be8623..fe51a17661831 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -536,6 +536,10 @@ xchk_xattr_rec(
 			xchk_da_set_corrupt(ds, level);
 			goto out;
 		}
+		if (ent->flags & XFS_ATTR_PARENT) {
+			xchk_da_set_corrupt(ds, level);
+			goto out;
+		}
 		calc_hash = xfs_attr_hashval(mp, ent->flags, rentry->name,
 					     rentry->namelen, NULL,
 					     be32_to_cpu(rentry->valuelen));

