Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02990B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294893; cv=none; b=mnjroGLwb/JF+FNiRpbXi5D1Zqh2KSRW87hMF0NJeBiFiZvQy4DuRFT8E1CQOA6SJm51A0wrlheVBDLCnZIdSCy7XeVzZ2R9Rm00Zh4pfp3NaTUzSBCFJ6lfDtaVCI6aGE0xrYh3hdI6WRaX8J//Ph4+qOntveWBITsSZ2td1O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294893; c=relaxed/simple;
	bh=4k0bZTVm60PnU4Yy9ReZC2WAQsmGqwMtu+CN0ZA5za4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qj6Ys70uYQC15lW0blTgyz5OS556I9zxNhP4ryjydmz6EyLy9GUfRj9mIRvrCrhofTE8K00V1B/8dUW6L4LvNeT9Oy3XTc0GYCJtOo58S1RSkwOeY8Fhf9+FkKjHFo84p9DL24pG9vf+1i8YQAUTVXsmckzUAmz8ZalwNYDHsx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0yUPhEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0yUPhEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E3C433C7;
	Wed, 13 Mar 2024 01:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294892;
	bh=4k0bZTVm60PnU4Yy9ReZC2WAQsmGqwMtu+CN0ZA5za4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X0yUPhEd9ThRJ98owucXKMz+zAJ/wTd4PzvIyiicCd88AWVX8MyOYU5Our5eA6Lq0
	 7Dd/uBsJ/sw0IkwzKjajOK4mdOH9jm5nWLtGEP48r1Ydicy30ztTWl4Mi6h7D8Aksq
	 Xh+bXc8l0YaGCjxnCW9sOU+6pr1RhwHQce3/51nzKrWsvEjjtxuNOZzI2T6eH4EMJX
	 QaZxtrWfLsd3ZU141RFbt/Q2SOm68gQcee4XA3G23AvI5rXhvLkW1jU7bVSSHAWqPu
	 hGNwg0iWhrAYwltD+9Ox2nq1I4fhdhiATvFDi7Dxy0uKXh17x0KEIXZnVEQ/Q24fH2
	 Rj5pooKquarqA==
Date: Tue, 12 Mar 2024 18:54:52 -0700
Subject: [PATCH 07/67] xfs: use xfs_defer_create_done for the relogging
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431294.2061787.11191434487692281302.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 include/xfs_trans.h |    2 +-
 libxfs/xfs_defer.c  |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 8371bc7e8a43..ee250d521118 100644
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
index 1be9554e1b86..43117099cc4c 100644
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

