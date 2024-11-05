Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3F71DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845295; cv=none; b=srIhXYj1DUXt0Pnh93cOuP0tYDuQJtZVx2whM5+eSSro06Xr47+oyVmjZNiJqvNdFmRW5g5MuyJFHgM7q3ztwUzH+yLUDrpUNbDBmXasRuj4C17/+SUQN0KGSrZo+cMfPnTZlBynjgc+g10PXnrQ4wTIR0ldJT3PXuaKJ98KQOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845295; c=relaxed/simple;
	bh=rfaEJDW7NCAX9gEtorsZS0hjtrv4YAqTIE+H9l92W+Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bl9bXs1pVfsWqeZgo1TCr1/yz0UMfOfjbaDG8WYMs4NoHXVziNmuObfjGPCzelfQTkggwQHL0N/i8R0TV2EocLziwVzC9xPilb8qa7eTvs/+dwJU+Y284ZNZmQfJwrrmZBxDA0Ai2PEGMWHM43fY16V+kl4JCEctZSct91FNpjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNhNJya2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNhNJya2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3692AC4CECF;
	Tue,  5 Nov 2024 22:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845295;
	bh=rfaEJDW7NCAX9gEtorsZS0hjtrv4YAqTIE+H9l92W+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SNhNJya2hsM0bavsjKUSkwK2JxJV9HWA36rgMRXzl57JMa06kIvgqW8Si0/7WlBI+
	 XxvxmWKPSIaPE+tAe4dTRiN4hFj/1OtSxRcx468jhdpj7FcXczjVrWag+6z+5UIZZE
	 CSJAEVkgGukh3htceZYWu1cgXqWIeq6aO2JWHVkXynKgBxWtwo4qpVhUo/ELQmFv0P
	 bKLyQmldGrNb++2ZBMH40K1KvZdK6QNUdi2XH2TyfBQ+rs+Y7RKZfHGNtDe5DbeixF
	 d5sz1mSt2Zy54FkHVX9Ozcq9vJ6cPdeuwC5gUXuj4LiawGastvMoQN+q+NQw6r3ZaU
	 VARFj4G9eetaA==
Date: Tue, 05 Nov 2024 14:21:34 -0800
Subject: [PATCH 19/28] xfs: do not count metadata directory files when doing
 online quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396346.1870066.8264990662471768720.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Previously, we stated that files in the metadata directory tree are not
counted in the dquot information.  Fix the online quotacheck code to
reflect this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index c77eb2de8df71f..dc4033b91e440b 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -398,10 +398,13 @@ xqcheck_collect_inode(
 	bool			isreg = S_ISREG(VFS_I(ip)->i_mode);
 	int			error = 0;
 
-	if (xfs_is_quota_inode(&tp->t_mountp->m_sb, ip->i_ino)) {
+	if (xfs_is_metadir_inode(ip) ||
+	    xfs_is_quota_inode(&tp->t_mountp->m_sb, ip->i_ino)) {
 		/*
 		 * Quota files are never counted towards quota, so we do not
-		 * need to take the lock.
+		 * need to take the lock.  Files do not switch between the
+		 * metadata and regular directory trees without a reallocation,
+		 * so we do not need to ILOCK them either.
 		 */
 		xchk_iscan_mark_visited(&xqc->iscan, ip);
 		return 0;

