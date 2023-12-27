Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9552819C
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1NfvR/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E97C433C7;
	Mon,  1 Jan 2024 00:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067534;
	bh=dBTuLcBHxxG3bO3FFE1moXvOrSAT7gmCwM/axURrUdM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j1NfvR/Tm6pGtw4Yq1ixTqFhRAO3TdhzD4RKyuHWhu6+rBdQTvn6hL6IOBTopIBBd
	 mQCz+KO+pbCEXp+TFb3DU0xZidTbIVoc6bsqWXyANwJQ9PUOPEqLxFyESlbpVhX9DP
	 xMHFSeMzUCTTsDmlZ7ndSIuar4dGPJ4kLqdSxGzqBNgvy1/yGSsYQaxKpUAe4BY+ej
	 GIGWCyG0hgLTUM6P0krU+tPyUCZmwVCEW+lSfB9tuC572vKkDb0MrzF9WiqRmzk1OQ
	 MKr5s3oqkhJngvE6o77Z07opOt1rdQFmKxr4nwY7wqWZj0+2eSoWsWyX1bMrPbzsnf
	 QRdUsBsUgY04A==
Date: Sun, 31 Dec 2023 16:05:33 +9900
Subject: [PATCH 1/8] xfs: clean up extent free log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014055.1814860.7878254184257730202.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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

Pass the incore EFI structure to the tracepoints instead of open-coding
the argument passing.  This cleans up the call sites a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h |    5 ++---
 libxfs/xfs_alloc.c  |    7 +++----
 2 files changed, 5 insertions(+), 7 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 5010b35b1f6..a6ae0ca13b6 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -13,8 +13,8 @@
 #define trace_xfbtree_trans_cancel_buf(...)	((void) 0)
 #define trace_xfbtree_trans_commit_buf(...)	((void) 0)
 
+#define trace_xfs_agfl_free_defer(...)		((void) 0)
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
-#define trace_xfs_agfl_free_defer(a,b,c,d,e)	((void) 0)
 #define trace_xfs_alloc_cur_check(a,b,c,d,e,f)	((void) 0)
 #define trace_xfs_alloc_cur(a)			((void) 0)
 #define trace_xfs_alloc_cur_left(a)		((void) 0)
@@ -242,8 +242,7 @@
 #define trace_xfs_defer_item_pause(...)		((void) 0)
 #define trace_xfs_defer_item_unpause(...)	((void) 0)
 
-#define trace_xfs_bmap_free_defer(...)		((void) 0)
-#define trace_xfs_bmap_free_deferred(...)	((void) 0)
+#define trace_xfs_extent_free_defer(...)	((void) 0)
 
 #define trace_xfs_rmap_map(...)			((void) 0)
 #define trace_xfs_rmap_map_error(...)		((void) 0)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3d7686eadab..08cdfe7e3d3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2569,7 +2569,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_owner = oinfo->oi_owner;
 	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
 
-	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
+	trace_xfs_agfl_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
@@ -2631,9 +2631,8 @@ xfs_defer_extent_free(
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

