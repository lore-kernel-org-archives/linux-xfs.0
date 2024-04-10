Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F6EEC2
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710364; cv=none; b=afRIHnM4W7bWmGLXLUha1epvtATZ17HkLQwN+12Q/z1OAhaw/aqU7Zla47lUwYUud7fqywm2oW96fthc5e22aGH1Vvc6rJVb00flDnBcOYUfPC9ouXdVoLcQKVhaw/QHDVwzEHUCxM3c9Y/PpoVwUwIKqDGKx8Uyo+/cIWTDdic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710364; c=relaxed/simple;
	bh=OcjrjP9hiR4ne59SrdjR1Nk2Vr4Zmb47RWKZfcYbu/E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aV2gzfWkfZxZxKPZUsr0lzcAb1gkn1puhEWJ9/FNl7hmm4wbwhNE2F8F8jT+HVyrJgGMtGgIrBYD4pVqEKXdNUt6svLoBp9uVki3cNQ9KDsey4yN6K9CIE8/WFO7Y0qpXCut2By7jOYgLAlaIRxvuvfTJeEVrir1bH0Yelw4sKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kd2/BQI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kd2/BQI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43977C433F1;
	Wed, 10 Apr 2024 00:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710364;
	bh=OcjrjP9hiR4ne59SrdjR1Nk2Vr4Zmb47RWKZfcYbu/E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kd2/BQI+JdLeBe4JrzqCecEF5jk8Lpw4WOvPUfHsi+Wb82lIxrAgNYVoCtsort66Z
	 qUzq9vbgDAbSuBiN6eWU08TtBBvP32+n4X1DfUM7eRCr8wTRuHhc5lNwhZhw+9RwEv
	 PCpU6J2sDzqGhJQzgapFZKs9JGwLhURdpzrihxn7+5lRslRnoOcNKuKPRohGOcYfv1
	 hxWFrdm2KDc/rNWvIdIGFzdeXLRVfVk+lhII/MD5KuuQG6ZXmoMkGCkG23nWcQ5Ric
	 Qt4MECmcLDchMJsp9Jyl9Z9tEgEIKl1bxXeIdOMTHUNIlsOF88Mmv97pCYe63PNK2p
	 kBDGI8i8a2fHQ==
Date: Tue, 09 Apr 2024 17:52:43 -0700
Subject: [PATCH 09/12] xfs: always set args->value in xfs_attri_item_recover
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968999.3631545.8805460036255507720.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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

Always set args->value to the recovered value buffer.  This reduces the
amount of code in the switch statement, and hence the amount of thinking
that I have to do.  We validated the recovered buffers, supposedly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ebd6e98d9c661..8a13e2840692c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -572,6 +572,8 @@ xfs_attri_recover_work(
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = nv->value.i_addr;
+	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -580,8 +582,6 @@ xfs_attri_recover_work(
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		args->value = nv->value.i_addr;
-		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);

