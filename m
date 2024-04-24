Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9061339BA
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929186; cv=none; b=kM7COsZcZGc8LGar7crRGD8qDCL2HssWHLZPmzFJR/Op1aMTLREt3s3VqE3rkkSXmdN4yAUEEngQPklS3SubTV/J/5Cj2MGI4ZHqJpurE9UUuBUFsaDS29wUCUPAX93PyzYI4Nc8jI9MPuWHwhIiTfMIjS+XvZF6g3vrRYLQ1Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929186; c=relaxed/simple;
	bh=e/l+JJfFqJnu01decjF2mxf15HKzbCP78f/lkGpIqNE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/SlGeRcO8iXbJPnwX9+vXQwuGrMSl2CrV1HLMMYkFVcpETpFy+xc1FQbTcRpQsCMR/W1AoXGol0gPGpcp4IOtpUJi9Sz92urnF4pYBSBXJpXXhPMmrlvXVpu9yzlL3bNaw5smS4NL7+A8q1pCeZZ79tiFqzSzTYSC+S6mgt3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbcsL5SG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbcsL5SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E3BC116B1;
	Wed, 24 Apr 2024 03:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929185;
	bh=e/l+JJfFqJnu01decjF2mxf15HKzbCP78f/lkGpIqNE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QbcsL5SGBtM0I7WaRLmyNq8k5nDWlFcUUQAPDakOgZ9XQNAfLGRaoj2aiR6Jiaf+i
	 kHPzXGMCXRk6+DFhiNROwcHpLHMZTJn6MgmIrBKZuCLBrXh+v046ffVsjZjaUa1qB6
	 QnFiuTxNbkgWJdjc9PuJZm5ZZtX9Z7GXu08lx1dRG5oRXLPDI8Z1i+YxFvacrOXQDR
	 ldDn4XYLw40fseh7aj4yT4Hqm4CT6jRka+Lj/LqOJs0O8SreNq+RFjiccHX2rSTiqb
	 5ceh54nRRDWJtpTBsQwhk61a+d+Cv22MMpsaKzTp09DNeKjIJliqZlBQbv3SKS19c8
	 ZFGWcG6Un7XCQ==
Date: Tue, 23 Apr 2024 20:26:25 -0700
Subject: [PATCH 16/16] xfs: inode repair should ensure there's an attr fork to
 store parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784924.1906420.155030277853959722.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

The runtime parent pointer update code expects that any file being moved
around the directory tree already has an attr fork.  However, if we had
to rebuild an inode core record, there's a chance that we zeroed forkoff
as part of the inode to pass the iget verifiers.

Therefore, if we performed any repairs on an inode core, ensure that the
inode has a nonzero forkoff before unlocking the inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index e3b74ea50fde..daf9f1ee7c2c 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1736,6 +1736,44 @@ xrep_inode_extsize(
 	}
 }
 
+/* Ensure this file has an attr fork if it needs to hold a parent pointer. */
+STATIC int
+xrep_inode_pptr(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+	struct inode		*inode = VFS_I(ip);
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	/*
+	 * Unlinked inodes that cannot be added to the directory tree will not
+	 * have a parent pointer.
+	 */
+	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+		return 0;
+
+	/* The root directory doesn't have a parent pointer. */
+	if (ip == mp->m_rootip)
+		return 0;
+
+	/*
+	 * Metadata inodes are rooted in the superblock and do not have any
+	 * parents.
+	 */
+	if (xfs_is_metadata_inode(ip))
+		return 0;
+
+	/* Inode already has an attr fork; no further work possible here. */
+	if (xfs_inode_has_attr_fork(ip))
+		return 0;
+
+	return xfs_bmap_add_attrfork(sc->tp, ip,
+			sizeof(struct xfs_attr_sf_hdr), true);
+}
+
 /* Fix any irregularities in an inode that the verifiers don't catch. */
 STATIC int
 xrep_inode_problems(
@@ -1744,6 +1782,9 @@ xrep_inode_problems(
 	int			error;
 
 	error = xrep_inode_blockcounts(sc);
+	if (error)
+		return error;
+	error = xrep_inode_pptr(sc);
 	if (error)
 		return error;
 	xrep_inode_timestamps(sc->ip);

