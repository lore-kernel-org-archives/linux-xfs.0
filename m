Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052CAD26D;
	Tue, 26 Nov 2024 01:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584534; cv=none; b=APq2tmWN2I8vwJDDpU2RwrVLGLtKIkR1owB52CQsmsfoyUaPFdO7L5w+Wcczw+g1Yo98HE56eYJyfSEwC9MCmJlFlp4+4fI32rra67znj3YbtI2+S8xuPnHF2Dk7rIUiXNLaPcrgAT+hxMUVKCgklDKT/JPzKfwSUw3xqvTepow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584534; c=relaxed/simple;
	bh=L/sfa2zdR7gn6tJWvXD9UNI+3OCZX2bx0Yt5/ZsmraM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HB6GqMRvSgkdj72xKnSVzZUqROgrt4tG/HelRCccQ3n50tKNRAS14pgFa2DBA0l8SQOLZs0GZEovZ/3tL2tQkTDYbzRtGAVXgJUDjD7JBzWYCj8GLkTU0rFpytQQdQ5B62m03SpAQ09anXSPlHCXlE7Z4xqcN0WQ+ipEJId4uz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUbRbL2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUbRbL2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77248C4CECE;
	Tue, 26 Nov 2024 01:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584533;
	bh=L/sfa2zdR7gn6tJWvXD9UNI+3OCZX2bx0Yt5/ZsmraM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rUbRbL2GccPRgbTG0MTyDOiGF+RzvdBoQkK8GyqYI+9Ryh/KGBkarCGnGf2TB2yuX
	 j/kXnvse5n4Eh8qbWM8sGgQNBC0l6T+DEQqIe1OSoGOUBbI1Mz0VhfwQqIwYlsAFGr
	 LBbLRObKPAT8Gow/gzRF06B02Vwi33If31VbwiOS7oADY+OYKzziLXLhCHqdLvUUUh
	 SQG27RzPW8VtHx7ybmt67oPDfItYkUUwWFHma98s4VKLvTm0yhfVrgNv1AtUx/aH2S
	 69BHEGzDQRm+r1/yw2chJHsHLpSa2/u0Cx55u6ynH83jTQGn9RWE2ibChUX7gd9Pxe
	 wwY8eMkBQ0OOw==
Date: Mon, 25 Nov 2024 17:28:53 -0800
Subject: [PATCH 16/21] xfs: don't lose solo superblock counter update
 transactions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258398074.4032920.16314140758572044747.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Superblock counter updates are tracked via per-transaction counters in
the xfs_trans object.  These changes are then turned into dirty log
items in xfs_trans_apply_sb_deltas just prior to commiting the log items
to the CIL.

However, updating the per-transaction counter deltas do not cause
XFS_TRANS_DIRTY to be set on the transaction.  In other words, a pure sb
counter update will be silently discarded if there are no other dirty
log items attached to the transaction.

This is currently not the case anywhere in the filesystem because sb
counter updates always dirty at least one other metadata item, but let's
not leave a logic bomb.

Cc: <stable@vger.kernel.org> # v2.6.35
Fixes: 0924378a689ccb ("xfs: split out iclog writing from xfs_trans_commit()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 26bb2343082af4..427a8ba0ab99e2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -860,6 +860,13 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
+	/*
+	 * Commit per-transaction changes that are not already tracked through
+	 * log items.  This can add dirty log items to the transaction.
+	 */
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
+		xfs_trans_apply_sb_deltas(tp);
+
 	error = xfs_trans_run_precommits(tp);
 	if (error)
 		goto out_unreserve;
@@ -890,8 +897,6 @@ __xfs_trans_commit(
 	/*
 	 * If we need to update the superblock, then do it now.
 	 */
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
-		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
 	xlog_cil_commit(log, tp, &commit_seq, regrant);

