Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A5F23C9
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831786; cv=none; b=A2TANPc2A6y6ZfKKF/sw/MfX8uN5ZowjwnQw9AnpwnmAa9XuX2okEYpNSKEoOeOltiX5ufF/0pvvVBRPnVIByI4T6BQKaoQPP0T9AA4SW8MP5R1UxHRyl+z3+aF28ZYh7gGyqY3SWZzMv7GRIlloIW3Bid+iHgRHMP6ln6VzYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831786; c=relaxed/simple;
	bh=PR1ZMQTcbD8xVqUTpq6MNIl4FKc4uzmqT0kG5UXtLXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDXwdQAWZvJqxnau0snRkMlWFTpfRLNIo2UMHvV1NMA+zYjpIKjUO9zW1LzFyN5MA6456DUPbqAxiMKKd/KF/KqqboukZwQUfdM8fsOPPYEVnvXI+hjatcgd4rabCixY596GenqyCJTQ3JJgLozf55s29IicwYQpplEqnb+5v58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2RlKwkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2RlKwkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A999C4CEC6;
	Wed,  2 Oct 2024 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831786;
	bh=PR1ZMQTcbD8xVqUTpq6MNIl4FKc4uzmqT0kG5UXtLXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M2RlKwkpX7s9qwvx7nf4IoZ/vmsmq2uAbeSzVsO8dcTeJyNMoHFjUN/NYGO6XsoMf
	 bjdO2dzmLv3KYG216nXRLENp4VtU8YhHS30qzLQddkXz9pdrZtytdWpur/N5vQ1hSX
	 gp/NUdrwkiOGs6Zy5UT3MzZQqsHuILnp6CSyk/L1lLDgGVe6csTkSiVTHcZ73IwbVJ
	 pxcztXo9joT3TBXtDlnFN/Rkv53b9qb+93cLXY/yzFU1NZWeQPSGA74zNZAPxQ0prx
	 nWMld4TsfoC6GdSYG0jf8VwCVeN42zVS7bhg1gNbUKL0i4vWaITqJ1Xpa57l3fiw/n
	 Hhyoyhy52QOgw==
Date: Tue, 01 Oct 2024 18:16:25 -0700
Subject: [PATCH 33/64] xfs: clean up extent free log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102279.4036371.10205207231938482835.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4e0e2c0fe35b44cd4db6a138ed4316178ed60b5c

Pass the incore EFI structure to the tracepoints instead of open-coding
the argument passing.  This cleans up the call sites a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h |    5 ++---
 libxfs/xfs_alloc.c  |    7 +++----
 2 files changed, 5 insertions(+), 7 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 812fbb38e..f6d6a6ea1 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -14,7 +14,7 @@
 #define trace_xfbtree_trans_commit_buf(...)	((void) 0)
 
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
-#define trace_xfs_agfl_free_defer(a,b,c,d,e)	((void) 0)
+#define trace_xfs_agfl_free_defer(...)		((void) 0)
 #define trace_xfs_alloc_cur_check(...)		((void) 0)
 #define trace_xfs_alloc_cur(a)			((void) 0)
 #define trace_xfs_alloc_cur_left(a)		((void) 0)
@@ -243,8 +243,7 @@
 #define trace_xfs_defer_item_pause(...)		((void) 0)
 #define trace_xfs_defer_item_unpause(...)	((void) 0)
 
-#define trace_xfs_bmap_free_defer(...)		((void) 0)
-#define trace_xfs_bmap_free_deferred(...)	((void) 0)
+#define trace_xfs_extent_free_defer(...)	((void) 0)
 
 #define trace_xfs_rmap_map(...)			((void) 0)
 #define trace_xfs_rmap_map_error(...)		((void) 0)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index ab547d80c..48fdffd46 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2540,7 +2540,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_owner = oinfo->oi_owner;
 	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
 
-	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
+	trace_xfs_agfl_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
@@ -2602,9 +2602,8 @@ xfs_defer_extent_free(
 	} else {
 		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
-	trace_xfs_bmap_free_defer(mp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
+
+	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, &xfs_extent_free_defer_type);

