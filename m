Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4F1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990890; cv=none; b=cvWrwYWPMA6H1sLhg6SjBjzX5YMB+jjz+KCfBEYZ2F1dmaneODF7EefuLoYsrxoGLzpRfWYECR7S3pfMO7bwXG7v00z/5XJWf005NnKpIm1IegB8NoI4c9nO8G6bmSiHvuA/8B2uHOni0QqkeDIeTvocmX6Pvii38wWkp3aR3qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990890; c=relaxed/simple;
	bh=MS5yVfNU50cycZuzgO4Kh26q4X/ajMaqnZtRKIS9T6Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kEVVrpl+57yeNJ8d9OZF2jrG/1peCbHrq58OF55K8NPrinlM4UEvk8jUfzQqg8onJ4g/OLaq7i/OUOaiV3AUt0FTyJnG5aSDasdpkHDo/sGKUaiyJi6rV0XQ40CWU9XzSWIJdS4A6LEpFwqLbyrcyKuJTx2c0qk2LDP0kJX78yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPfweeY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPfweeY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E984C4CED3;
	Mon, 23 Dec 2024 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990890;
	bh=MS5yVfNU50cycZuzgO4Kh26q4X/ajMaqnZtRKIS9T6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SPfweeY3zuzuBUerpct1qpUVWX7iC3VISoNfcv3nBoza1mbNcTnvtd8k7lVF6kMoD
	 h8LqyYbpJnTs0tdmltRXZDvnYo5E1qctUj3VtOabF7Fc2YdB0W37icTAaBAwsP9MOt
	 Ozf8u6KX+7qV6MCjYzrLw54ZtKTmpvagl6Q4HsjPJdapxFFoIQ3pNpsr6ZC5L5y8CA
	 EKeTLqmZu87zqDtyioLlrtW0THlBQabsMJGi+CMNHnOxKq+5Sti+qxvka6pzorkYsL
	 SvgLy4omqMDbpEfVYwV6sndSatxci7Qos4x1j52WhNCmoE+Dk2R6sAaVbY94PK1PGx
	 Ma8GU3Di4QFKg==
Date: Mon, 23 Dec 2024 13:54:49 -0800
Subject: [PATCH 32/41] xfs_repair: update incore metadata state whenever we
 create new files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941458.2294268.17770338571940137824.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 688eee20bb3e8e..8fa2c3c8bf0419 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -474,6 +474,22 @@ reset_sbroot_ino(
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
+	struct ino_tree_node	*irec =
+		find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+				   XFS_INO_TO_AGINO(mp, ino));
+
+	set_inode_is_meta(irec, get_inode_offset(mp, ino, irec));
+}
+
 /* Load a realtime freespace metadata inode from disk and reset it. */
 static int
 ensure_rtino(
@@ -693,6 +709,7 @@ mk_metadir(
 
 	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
 	libxfs_metafile_set_iflag(tp, mp->m_metadirip, XFS_METAFILE_DIR);
+	mark_ino_metadata(mp, mp->m_metadirip->i_ino);
 
 	error = -libxfs_trans_commit(tp);
 	if (error)

