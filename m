Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7609119ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528004; cv=none; b=XDghvouf2s4HyJY0fdw0LRhiYD9X7+Xt5H/jieNGnFzhWMxaZ7IOIf8qPHfhP4eG9Xbo3HffTDOUBu8rFLu7WwPtjKQU/n9fxeA25uS/qssiM7i0OFBLPlT+JME9e0vSxlN1S2vUD0Haf7fndEdCnY/W+WM8P0Z+vfG727+Rrr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528004; c=relaxed/simple;
	bh=0fY6gMu+rHt8126cgZ0KY+hYhAZW3qU5Dl2vTVDU6sM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkwMowJp/dwWNx+9BQkoEsNldOIU0LsnBFAvdoPcTVuCFpy/KHSQG1HRMExKkSbAfxT8HXgwixg/6nXX4vQ8w7nhw2C1lwLC0lIbYGRd2JA+4434Z3tFJ7AZq9MPkpPZg5kVKYtWJQ1QmnMQ4b4lglHWzRgkYt2EZOQb5s+u8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmQwRt6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmQwRt6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C34C4CED2;
	Fri,  6 Dec 2024 23:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528004;
	bh=0fY6gMu+rHt8126cgZ0KY+hYhAZW3qU5Dl2vTVDU6sM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZmQwRt6IIZR8AgiIvTn3u+o0cyEwlRGNHWe3daHCOsbDSxlEEtG30w7v8qPnEYuSv
	 kw9U+/uAjNIGZ4CXQRaAtQfKtkEfAJJr4PH575/HWy1gKLlc599/kfnqrLmjet4BIY
	 1DSKPOF7jls1bg+trv8plV66zXzeiOP1VP9cF/qCgI2aUXhIO+prcpLVFl9Sb68jkL
	 xFf9ZIo8RyxrkeiLWK0r6J2+wGP9Eu0l86U4uSOd0hmm36Zi31usqmySlcNCLo5Q/I
	 9Vq3seEN8oMLodCGmwTQpr+UNdLw4xOVfudGpY+DMWL7+m6RJmBbFeyYYilsETSh4T
	 +8sQcMTkO+j4Q==
Date: Fri, 06 Dec 2024 15:33:23 -0800
Subject: [PATCH 12/36] xfs: convert remaining trace points to pass pag
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747065.121772.10878241875389916748.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: c4ae021bcb6bf8bbb329ce8ef947a43009bc2fe4

Convert all tracepoints that take [mp,agno] tuples to take a pag argument
instead so that decoding only happens when tracepoints are enabled and to
clean up the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h     |    8 ++++----
 libxfs/xfs_alloc.c      |    4 ++--
 libxfs/xfs_ialloc.c     |    4 ++--
 libxfs/xfs_inode_util.c |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 0986e1621437d4..012e0018cb8367 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -81,10 +81,10 @@
 
 #define trace_xfs_free_extent(...)		((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
-#define trace_xfs_read_agf(a,b)			((void) 0)
-#define trace_xfs_alloc_read_agf(a,b)		((void) 0)
-#define trace_xfs_read_agi(a,b)			((void) 0)
-#define trace_xfs_ialloc_read_agi(a,b)		((void) 0)
+#define trace_xfs_read_agf(...)			((void) 0)
+#define trace_xfs_alloc_read_agf(...)		((void) 0)
+#define trace_xfs_read_agi(...)			((void) 0)
+#define trace_xfs_ialloc_read_agi(...)		((void) 0)
 #define trace_xfs_irec_merge_pre(...)		((void) 0)
 #define trace_xfs_irec_merge_post(...)		((void) 0)
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index ed04e40856740b..bd39bcde0ea224 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3354,7 +3354,7 @@ xfs_read_agf(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	trace_xfs_read_agf(pag->pag_mount, pag->pag_agno);
+	trace_xfs_read_agf(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
@@ -3385,7 +3385,7 @@ xfs_alloc_read_agf(
 	int			error;
 	int			allocbt_blks;
 
-	trace_xfs_alloc_read_agf(pag->pag_mount, pag->pag_agno);
+	trace_xfs_alloc_read_agf(pag);
 
 	/* We don't support trylock when freeing. */
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b3d6f7f4212588..4f087e6b074081 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2724,7 +2724,7 @@ xfs_read_agi(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	trace_xfs_read_agi(pag->pag_mount, pag->pag_agno);
+	trace_xfs_read_agi(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
@@ -2755,7 +2755,7 @@ xfs_ialloc_read_agi(
 	struct xfs_agi		*agi;
 	int			error;
 
-	trace_xfs_ialloc_read_agi(pag->pag_mount, pag->pag_agno);
+	trace_xfs_ialloc_read_agi(pag);
 
 	error = xfs_read_agi(pag, tp,
 			(flags & XFS_IALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 92bfdf0715f02e..f9f16c7e2d0788 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -439,8 +439,8 @@ xfs_iunlink_update_bucket(
 	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
 
 	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
-			old_value, new_agino);
+	trace_xfs_iunlink_update_bucket(pag, bucket_index, old_value,
+			new_agino);
 
 	/*
 	 * We should never find the head of the list already set to the value

