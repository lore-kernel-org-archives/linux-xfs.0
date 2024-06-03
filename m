Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F513C9BA
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442038; cv=none; b=p5Gx7q3NdEo15iFYdT+Mu+7JS/zT9ugf6RwmYdFr+vGNEi5XAuj2OWdWkrQQTvFpCUAjq/zbmaUcvYB0b07TyDCLH1P2ORkXDbGGXxoYa9xS2ztglxpzIn3fVlrBvIfJ5xxh3iQbM/I5U3socKJ0LWG/uEHQm4+WcybVC6QpYiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442038; c=relaxed/simple;
	bh=xmg16dIx5vf4mvvnjxzG4gGLLl6dXrnTbovbhZAeKiI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrKzVtMtvTaRK/n0S386F0OJyjyLBkXcuRMglE09ba3X8NpTvB06a2zqW1n7RiMhVI/fGwJ6tdDTJdxS9U2n0SioQSws9JNHWggwY9MOwFwKD8HsuW7GSGUsMEiz6WgI7d2mRom1eNjACLH9ql6YYU2xFkL98Qgu0n39c+1kVdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0iTV/2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0iTV/2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E158C2BD10;
	Mon,  3 Jun 2024 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442037;
	bh=xmg16dIx5vf4mvvnjxzG4gGLLl6dXrnTbovbhZAeKiI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N0iTV/2VmzTWxQ9hHV9H8WiC1l2Uo/qfRMOt8vNYigf/MbP8cPg8nDSsQam0vUDh/
	 rqsFox1nji3Q67z1N8kxfaHg1IHye3evyBkNQvdQOUVsqHOI8a6XUF6c9+LDIAXLua
	 8kkPRk6vFkP7B7jtTsKBKVX+xk8yVTwrhz9MugZWlfvqU4+qETs8uW2Uqi1ij7/HZd
	 kJ/VaaA6+stUd4P2hlScp/oqocQZ9WjwKrjjp0NVH1kxGZGgV8/BzJN8VvXhaxtNSP
	 h06KtAOB/6Y34m8P3o+5aBLLQ/MIuKcxh5uvAKwP3FVHu6wHceXIXqG8PqeUPMJxyQ
	 bhhHld1DTHoTA==
Date: Mon, 03 Jun 2024 12:13:56 -0700
Subject: [PATCH 084/111] xfs: factor out a __xfs_btree_check_lblock_hdr helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040632.1443973.1196978259106600749.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 79e72304dcba471e5c0dea2f3c67fe1a0558c140

This will allow sharing code with the in-memory block checking helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index e69b88b90..6b1839243 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -91,20 +91,14 @@ xfs_btree_check_agblock_siblings(
 	return NULL;
 }
 
-/*
- * Check a long btree block header.  Return the address of the failing check,
- * or NULL if everything is ok.
- */
 static xfs_failaddr_t
-__xfs_btree_check_fsblock(
+__xfs_btree_check_lblock_hdr(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -124,6 +118,28 @@ __xfs_btree_check_fsblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
+	return NULL;
+}
+
+/*
+ * Check a long btree block header.  Return the address of the failing check,
+ * or NULL if everything is ok.
+ */
+static xfs_failaddr_t
+__xfs_btree_check_fsblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb;
+
+	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	if (fa)
+		return fa;
+
 	/*
 	 * For inode-rooted btrees, the root block sits in the inode fork.  In
 	 * that case bp is NULL, and the block must not have any siblings.

