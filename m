Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E6259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441428; cv=none; b=ceoNisDT+mOXN33M23KGJVLIzE+I/dHBS1gEEQRkg1n96dxD3EHMZO+UPk0wQ8WsTcIuBSHjcok8gwhbs3vAN2MoEVGccvALSvkI6nXRBdW0fmE5lD2FbFBVAHs1ep428RmiQx38KcHYeBL7pB+PUC0qf0tO6wMKt00sLPq9b3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441428; c=relaxed/simple;
	bh=nCZc025rod3zV8hhTmm3sBDUxRoAsSJnpKVhbTj97hc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6SA4j5V/PwH9QR4IC50EMmQVJYmyas5m9InXFBCUyKeo0dlSko9VsvkJv9PJ/8h8ZacIKZEKw/sHIi4GZH83eIINi8Iy+zwtFaRC3eaY/iib64rhO6YAQqReUC33XywH0sMLyNyawEvvJt35Iker6TA2FBbpCkIekPGeth3JDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HBw6cZte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBw6cZte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BA7C2BD10;
	Mon,  3 Jun 2024 19:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441427;
	bh=nCZc025rod3zV8hhTmm3sBDUxRoAsSJnpKVhbTj97hc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HBw6cZtec8Ie4+KunY/knc53bVxSVl/9pCIMJxqpWfo0yJGfYqdvDTHtEftX7Wh8W
	 fSRcm+N37nVWK71wnP5GNn+JFNSjbg0zInYvcafPqo4dtnoJr2QhftkWliAzDZAtEv
	 VcIWeRO/0ZxetUe/NFVmKiqYaZTmml2El4AkxKmhcCmB7ty0oLJtPniTkZmGMir+3N
	 paimAJnp9jhWl4jnCocGh2QI15FLA6YVY+boRy+GFNgtAa2dofPCeqN8AYV4u/M2L2
	 fgpFUF/izfaeLIMBzZePrMzTMC0q+05SirIS+fm41vyAVdogJwp0ysgZWFEZgD4nRA
	 VeqlccBsGSmvw==
Date: Mon, 03 Jun 2024 12:03:47 -0700
Subject: [PATCH 045/111] xfs: factor out a btree block owner check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040049.1443973.11808273760696345845.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 186f20c003199824eb3eb3b78e4eb7c2535a8ffc

Hoist the btree block owner check into a separate helper so that we
don't have an ugly multiline if statement.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index dab571222..5f132e336 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1774,6 +1774,33 @@ xfs_btree_decrement(
 	return error;
 }
 
+/*
+ * Check the btree block owner now that we have the context to know who the
+ * real owner is.
+ */
+static inline xfs_failaddr_t
+xfs_btree_check_block_owner(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block)
+{
+	__u64			owner;
+
+	if (!xfs_has_crc(cur->bc_mp) ||
+	    (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER))
+		return NULL;
+
+	owner = xfs_btree_owner(cur);
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+		if (be64_to_cpu(block->bb_u.l.bb_owner) != owner)
+			return __this_address;
+	} else {
+		if (be32_to_cpu(block->bb_u.s.bb_owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
@@ -1812,11 +1839,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER) &&
-	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
-	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_ino.ip->i_ino)
+	if (xfs_btree_check_block_owner(cur, *blkp) != NULL)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */

