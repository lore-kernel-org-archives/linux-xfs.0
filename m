Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D636864CFC
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389016; cv=none; b=pNGI8nWQrB0SETcyijy7FNYV3Zwn9Hgi9YTYQY9wjSCQvSpjNm/TQk2NBNERumlxryXPxrr0938WglVi1QTKgHObP2CpwhpNvGdCEyhRHCWgbGdj4angBq4ImOoIv+RI4TBVrUZr7dIw8QsnXREu/o7aIsX3iQ5gWJQdN8hOVAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389016; c=relaxed/simple;
	bh=7ASlINKB98bMWIgwaM2e/PoDBUwDO0HvAGW+4KTrmE8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZaicxA0MTwQjuccl9JvWFeqqom5Q1YEWNQrfA/5zu7uyOyqIdNUR0IoH5ekL8HPqoIOsiZ6RJy2GIb/Ka/3T/6Z6H/52BSUAezYlPabT1NSVqxwo/NXa+X4JJltGcVK4iP0ncAmcn0IUTU5kHHzFJa7PmSdL10cUlsGAmDm1MmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H01F+CXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H01F+CXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBE7C072AA;
	Wed, 17 Apr 2024 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389016;
	bh=7ASlINKB98bMWIgwaM2e/PoDBUwDO0HvAGW+4KTrmE8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H01F+CXJwQqRinJVskNq2uodftVna6AeOlYuxF9wXLuQtkBwkoj0PWeMyx8hvAm7v
	 LPEAVBVCkcPM+cgwRx+M5QeoV6jCFLLlODf9uTbPeIsUP9jE8SWm+K3DKvZTTO8vAc
	 5CIbqcsBkTs96acK6c97quQKv38felU12U8GMp6e+SQd0GL/KLUP0GdnP3JUc2IKnz
	 VHg4b9IkzJ6l0FreiPDmh/v1iXk/bYpBt1NHDnQ3g7QlJqxvpe6u6eHgrXPqzQAlNu
	 cbOdPxzinecj2iApy4wxBKCCud2kiyMwUgTmeOob0TW+HVzUiqxRuaDeejpUTASYcL
	 MNNeuyOq2e6ww==
Date: Wed, 17 Apr 2024 14:23:35 -0700
Subject: [PATCH 07/67] xfs: use xfs_defer_create_done for the relogging
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842445.1853449.3058006608542515702.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: bd3a88f6b71c7509566b44b7021581191cc11ae3

Now that we have a helper to handle creating a log intent done item and
updating all the necessary state flags, use it to reduce boilerplate in
the ->iop_relog implementations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 include/xfs_trans.h |    2 +-
 libxfs/xfs_defer.c  |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 8371bc7e8..ee250d521 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -158,7 +158,7 @@ libxfs_trans_read_buf(
 }
 
 #define xfs_log_item_in_current_chkpt(lip)	(false)
-#define xfs_trans_item_relog(lip, tp)		(NULL)
+#define xfs_trans_item_relog(lip, dontcare, tp)	(NULL)
 
 /* Contorted mess to make gcc shut up about unused vars. */
 #define xlog_grant_push_threshold(log, need)    \
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1be9554e1..43117099c 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -495,7 +495,11 @@ xfs_defer_relog(
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+
+		xfs_defer_create_done(*tpp, dfp);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
+				dfp->dfp_done, *tpp);
+		dfp->dfp_done = NULL;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)

