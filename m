Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342EB13A418
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 23:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718752874; cv=none; b=aWz8QjnA+UlHPfvgc5/HgNCLMlHYcr6hzHCuO1Fz31+GtoEwomO4eIIiLB0RTkED2BosC7oSjCBdkSaYczwdYdreAvthDzaJNq5D80gE5irlsZodcStt3cmryTYMOBzQ/APZH3bgve9NF0uaArpFdRhV0X3cxFQcZBZuvpiLWrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718752874; c=relaxed/simple;
	bh=xDw+R0EMXpbPmi7qDUjoEudX3tjCFks1BeDrV0GOOdM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SivKkPvRc6Vyc8StTzuLYkfmb5IsTg3v6BVoQxHBz4W36aTtSqJhCT2qBzwX4CSQPKl7F7cmE2jnXTJB3JG43/TFQuG6gsl8DBLJ+sv9bbFRutPj0a+EEp1GG1e1Rr+M8KWMTPAZIvghQS0Oh4jL3s1lQcGBoB8hOWhENlM9N+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLU2Usq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLU2Usq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F543C3277B;
	Tue, 18 Jun 2024 23:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718752873;
	bh=xDw+R0EMXpbPmi7qDUjoEudX3tjCFks1BeDrV0GOOdM=;
	h=Date:From:To:Cc:Subject:From;
	b=RLU2Usq5JxI+lL4NUV4eOcIZWD4vQ2izy5i9F6wSXfyq/9b2zu54ane0A68os1BNf
	 PJ5O4GigDV/tF90xGHGgOlMKkSeen8F/FL5USH56i1OUzddfJvb5AMHVlvI/CGQRMU
	 LJQHB4yT8GKQ+jle9M56e3aQ2SthqX0qEmsEKHjyL1q529YlgZem6InpPLypC0hWY9
	 D1spJbeW4Uh+7WjRmjEMHwcJjWPIvNkE5Au9LL2FzXyDFNUPfI4Quk+OnClO3PJDZV
	 5KzePOEa8yNTvYkP8bXDakGjl3TazcIes79pLSsbpXqQRlE/UPiT3rJu3MiYpR0/Ra
	 h+RUGTTucgozQ==
Date: Tue, 18 Jun 2024 16:21:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr &&
 attr2 fs
Message-ID: <20240618232112.GF103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs_init_new_inode ignores the init_xattrs parameter for filesystems
that have ATTR2 enabled but not ATTR.  As a result, the first file to be
created by the kernel will not have an attr fork created to store acls.
Storing that first acl will add ATTR to the superblock flags, so chances
are nobody has noticed this previously.

However, this is disastrous on a filesystem with parent pointers because
it requires that a new linkable file /must/ have a pre-existing attr
fork.  The preproduction version of mkfs.xfs have always set this, but
as xfs_sb.c doesn't validate that pptrs filesystems have ATTR set, we
must catch this case.

Note that the sb verifier /does/ require ATTR2 for V5 filesystems, so we
can fix both problems by amending xfs_init_new_inode to set up the attr
fork for either ATTR or ATTR2.

Fixes: 2442ee15bb1e ("xfs: eager inode attr fork init needs attr feature awareness")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b699fa6ee3b64..b2aab91a86d30 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -870,7 +870,7 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_has_attr(mp)) {
+	if (init_xattrs && (xfs_has_attr(mp) || xfs_has_attr2(mp))) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	}
