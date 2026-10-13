Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC95417BD2
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871372; cv=none; b=sa5GYwCn6kcn13gOh2ROTYwI9m7t6aIHsDwzkWFmtxyou3Ko6Sup1qmLH+phXsHNbjujJxrWC1y8gtLz3gsE0th3ZO0UZayAKio7qLtJ2l+AIvIby+PscSsNTspbqnQJDgeYwhW4WYNPgtmo/E6CdaW/8nxHW7qaWmb8uJWbvuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871372; c=relaxed/simple;
	bh=R20iPKjRsDGhqMdkY7P3BRr5yRuQZX5jrEOeFiTPrPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbhYt+o16+QiNBnZrdewGiBaio8Ivh6s+KIappmzFQ5+xQc5l1S9xvstqtXrYIDwHJnQDHAAnqlHaseTKhNwuK2lCAvapkoBOFZLXfpL+dygLQWQQmipIqJP30wGXR1SjC9Fl0fuqJohapIllqk/fjZj5ulqM0wwEEGvympvMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NR60TWrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NR60TWrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730F51F00893;
	Tue, 13 Oct 2026 06:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871371;
	bh=TdiRFNeG6QESc+ffr8DkzdDJ1VcUgxH5Jd2xAKrbWtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR60TWrN76lJ7EHf7MLKzem/UjREkkDiI2i5UzGZ8TTDuGC7KFlXonimfqE7Wgzld
	 dYUfoyR4DbFqxHobvcLDTW/IPS45jZhn2X5srbsepPIugnUFcqaW03rGfDXQsI14kO
	 HDHqWjNcXJEx7ZnbikgvMShQWxYgqSGAlXg9RnPDeitGYcGOPEuI93eKUtJU7+4Iaz
	 H555qPct+67P+zzLo4qn+CuLmg/TI9SflCSp6CClXFEKvkG/bGLfB0fb39DmOFdCOW
	 oMlzrWTa0eGUQ1P8jwjONZKYqshLnp9hmdqynzPoOBsADYc3fLR7pvljhvnq12jfFL
	 76cJGwUBVsI0Q==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 34/48] xfs: allow xfs_imap() to map without an inode btree lookup
Date: Tue, 13 Oct 2026 17:01:24 +1100
Message-ID: <20261013060204.3138690-35-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_imap() maps an inode number to its cluster buffer location. For the common
inode cluster geometries it does this by arithmetic, but for the general case it
falls back to an inode btree lookup that reads the AGI and walks the inode
btree.

Some callers cannot allow that lookup. Log recovery in particular wants to
cross-check a logged inode buffer location against the one derived from the
inode number, but it runs before the filesystem is fully available and must not
issue btree lookups.

Add an XFS_IMAP_NO_LOOKUP flag. When it is set, xfs_imap() maps the inode by
arithmetic alone and returns -EAGAIN instead of performing the btree lookup, so
the caller can tell that arithmetic mapping was not possible for this geometry.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 7 +++++++
 fs/xfs/xfs_icache.h        | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e705f681ed44..3664d5fff9bf 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2449,6 +2449,10 @@ xfs_imap_lookup(
 
 /*
  * Return the location of the inode in imap, for mapping it into a buffer.
+ *
+ * If the caller cannot allow a btree lookup to be performed, then it should set
+ * XFS_IMAP_NO_LOOKUP. If arithmetic mapping cannot be performed, we return
+ * -EAGAIN to inform the caller mapping failed due to a lookup being required.
  */
 int
 xfs_imap(
@@ -2536,6 +2540,9 @@ xfs_imap(
 		 */
 	}
 
+	if (flags & XFS_IMAP_NO_LOOKUP)
+		return -EAGAIN;
+
 	error = xfs_imap_lookup(pag, tp, agino, agbno, &chunk_agbno,
 			&offset_agbno, flags);
 	if (error)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 905944dafbe5..a1386b16edcd 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -41,6 +41,8 @@ struct xfs_icwalk {
 #define XFS_IGET_INCORE		(1U << 3)
 /* Return -EAGAIN immediately if the inode is unavailable. */
 #define XFS_IGET_NORETRY	(1U << 4)
+/* Map the inode by arithmetic only, never by an inode btree lookup. */
+#define XFS_IMAP_NO_LOOKUP	(1U << 5)
 
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
-- 
2.55.0

