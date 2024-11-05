Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1F01DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845248; cv=none; b=UBYrPxES14dNJ92b7VJ/w7r5qd5dcRWLOsgxkaidRsE17XRf/KxQ9OZggDBVlyaPe1K86jVyfe+w7mk/papwcmRd2q5rSShfbLDZ+KPIvln5uvoiL55+ai/r79wD6NpQqn+osSVVudbycyvqaoDAhAHLlXb82GenqHiwMly5KhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845248; c=relaxed/simple;
	bh=7QiAUR5fanCqJUwhR92ZY9GSx4XPnomlIwlg76OPJ9M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkER0kBsFS5CKuwyaS1VcFc0BLkbe0EPDuUlCBniaI4w1p9lQfIqjex3A2acpQxQlvpD36CLi4OseapYeDcYKbnlWArJbJ3fCg6RElECGxKHTmmJdmXqBw1pSp9eKdkV/ueTKVFzGuPU7Q6a1ExZlFadJnRo+iWRfXlviE89c4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUjWXiyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUjWXiyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672E0C4CECF;
	Tue,  5 Nov 2024 22:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845248;
	bh=7QiAUR5fanCqJUwhR92ZY9GSx4XPnomlIwlg76OPJ9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XUjWXiyGU3zKICka9aU/EpFv92IIecEae7oGz9VaJHbZ7ARgyHlXnouUqtSWQ8bjN
	 X74d6z5NN/Qd2dGGREH7wGXkSvyDJiGQo+ZFHjFbe9YqJUYGflbyCSDc1r0oktlYpD
	 K5Lag7s3BiopMluD3/ngrnM/fkoBuOc5+Dj0SQnbjhW+xm7fCtJBgPc6kgP7eYe6hR
	 3UDrDE/CjynoEKEErcmKvieB0OINOJUn14rGKpADhgTP4GEokKLEpVqA5+Vejt0oov
	 iHmY8owTVNZ6VPL3pOhktGyEjAiUYJAQAS+xSpimdPWX62E12hrl4szQuaBJUWJ3Lk
	 AQGfJd4FBjgpg==
Date: Tue, 05 Nov 2024 14:20:47 -0800
Subject: [PATCH 16/28] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396294.1870066.16913348261899248162.stgit@frogsfrogsfrogs>
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

Online repair might use the xfs_bmap_add_attrfork to repair a file in
the metadata directory tree if (say) the metadata file lacks the correct
parent pointers.  In that case, it is not correct to check that the file
is dqattached -- metadata files must be not have /any/ dquot attached at
all.  Adjust the assertions appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |    5 ++++-
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c63da14eee0432..17875ad865f5d6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1004,7 +1004,10 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5eda036cf9bfa5..7805a36e98c491 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1042,7 +1042,10 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

