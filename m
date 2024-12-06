Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF91F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528864; cv=none; b=lYho+ApB0j5zoBpTR7OOAYODMdmPLnjuGXox6700jcZ/AXJnL0nQuX0J20klhYdwjsQHlMnruniCKP8NvgzwyMnkifcBdGt4C5iVpvEjUrBc6c6AxbamWIYyXu1JZIrZfaHHjNDewrsATYB9y9JvyhMS0kxeIROYsvlL5S4yl6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528864; c=relaxed/simple;
	bh=/NXBxWBDSNk6wWv/WLJYvhXfWdgQSqEdlnu/3zrSUQU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5hOM+gH1znfzfvVm7c0fAzO4QzL+uip7ArhJmMMxLbCTv8l7Im2czx/wSFYFYZwKs6triMISjhASo7934MzTHx8ZVNuX17tpJCnh1hQfQOK/VwWxr4fC8j5PoKKn8fwG/CwSe8JVtY2K2zCohWrJsFILVgl8xA/uF7v1TLV4WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Suq9aQPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Suq9aQPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A495C4CED1;
	Fri,  6 Dec 2024 23:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528864;
	bh=/NXBxWBDSNk6wWv/WLJYvhXfWdgQSqEdlnu/3zrSUQU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Suq9aQPH44SJHWJks//VKi0U0mOx/PAF8XpOFuIQ3RwWWRUdgbjTGBA9s9qlOySJM
	 4XH566Yu/hcL0nI6AsPrO6cOGhFuPdWF50OsIhXp0lQ1Tk+EhE+MerDflUuVEXziYp
	 orsmoHWjThl4Bh1ZJTS3fo7/S/8YFTqgcXBqNrShMit0wkPHRX8+j+02CVrBUdiwcZ
	 YYfD8j7D2ELdOUNdeNNIQRYR+YDWgqJLXEK8k5x9NR+DtcAQUYPNzD9hQem4OoHUlc
	 fji3VBFUgoUF3fwhARL+6I9PtYL1K7+G8i087HAvfgLfTWqaggGxDvILlqyGzuZSJG
	 gDmThfyc7K+NA==
Date: Fri, 06 Dec 2024 15:47:43 -0800
Subject: [PATCH 31/41] xfs_repair: update incore metadata state whenever we
 create new files
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748710.122992.8928188548717908519.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we update our incore metadata inode bookkeepping whenever
we create new metadata files.  There will be many more of these later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase6.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index f2358bde194e38..dd17e8a60d05a3 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -474,6 +474,24 @@ reset_sbroot_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/*
+ * Mark a newly allocated inode as metadata in the incore bitmap.  Callers
+ * must have already called mark_ino_inuse to ensure there is an incore record.
+ */
+static void
+mark_ino_metadata(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+	ino_offset = get_inode_offset(mp, ino, irec);
+	set_inode_is_meta(irec, ino_offset);
+}
+
 /* Load a realtime freespace metadata inode from disk and reset it. */
 static int
 ensure_rtino(
@@ -693,6 +711,7 @@ mk_metadir(
 
 	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
 	libxfs_metafile_set_iflag(tp, mp->m_metadirip, XFS_METAFILE_DIR);
+	mark_ino_metadata(mp, mp->m_metadirip->i_ino);
 
 	error = -libxfs_trans_commit(tp);
 	if (error)

