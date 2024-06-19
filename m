Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B05D13D525;
	Wed, 19 Jun 2024 13:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802535; cv=none; b=rlsgDQJZ/JcKxF1au0KJiJGlddHQrK0MPHTzOm8hqKe6rOiObNgz8gErDGbrBXqcr74OcXTWX3/il41kMoF+JVltk+7rQ5PgGXEQP2xBLaJBpFkN39lp+Gj4b4ypwUxS1YAr4p8ZRNp/XWE1easBb9OzE2Gw9iqfW82pLvKyjK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802535; c=relaxed/simple;
	bh=BZltfSmsxvsB/ujTyLslwGrjH5yY3d7w1OkpYEAO2gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlicjewqn9fbPCwIzTbXEh3ZUPa22I/dhjMgZO2TBe+ZWjw2iJfrQ4YamI7rN9qGYhB5AFri0K23tIC5OZUjH31eCQzTV11llUIyz0xaFI/e/YfVdq6OetbYgTLDnsJG4alq7MmKbHNf4fm/CtfCRDmZGiBWvY0jnt29z6IGN7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htsfZrft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htsfZrft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C9AC2BBFC;
	Wed, 19 Jun 2024 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802535;
	bh=BZltfSmsxvsB/ujTyLslwGrjH5yY3d7w1OkpYEAO2gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htsfZrftIayfRapQ+OdIm7aKvOWebK3Ke1Aa7L6t6dbELZ+uS0tz2FStlOoi1Bqp2
	 kvCBBvFLu+hAoFlW0m5fO/ipzulWyiAJXVyxTJ+UiRJxSmhD36+zQTmi1KUka8x6Pp
	 FC2Yl3TBxWTTjH9VzFgMb3dbXVJKnYZtvIa33IsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 230/267] xfs: fix imprecise logic in xchk_btree_check_block_owner
Date: Wed, 19 Jun 2024 14:56:21 +0200
Message-ID: <20240619125615.153917840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0afba9a8363f17d4efed22a8764df33389aebe8 upstream.

A reviewer was confused by the init_sa logic in this function.  Upon
checking the logic, I discovered that the code is imprecise.  What we
want to do here is check that there is an ownership record in the rmap
btree for the AG that contains a btree block.

For an inode-rooted btree (e.g. the bmbt) the per-AG btree cursors have
not been initialized because inode btrees can span multiple AGs.
Therefore, we must initialize the per-AG btree cursors in sc->sa before
proceeding.  That is what init_sa controls, and hence the logic should
be gated on XFS_BTREE_ROOT_IN_INODE, not XFS_BTREE_LONG_PTRS.

In practice, ROOT_IN_INODE and LONG_PTRS are coincident so this hasn't
mattered.  However, we're about to refactor both of those flags into
separate btree_ops fields so we want this the logic to make sense
afterwards.

Fixes: 858333dcf021a ("xfs: check btree block ownership with bnobt/rmapbt when scrubbing btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -385,7 +385,12 @@ xchk_btree_check_block_owner(
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
-	init_sa = bs->cur->bc_flags & XFS_BTREE_LONG_PTRS;
+	/*
+	 * If the btree being examined is not itself a per-AG btree, initialize
+	 * sc->sa so that we can check for the presence of an ownership record
+	 * in the rmap btree for the AG containing the block.
+	 */
+	init_sa = bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE;
 	if (init_sa) {
 		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,


