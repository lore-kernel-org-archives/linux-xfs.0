Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D0B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294830; cv=none; b=IbieJ8ioXobiNL0gR+oUnYWP/91CET+cx/MEREsoioAgHngCmgcikOZV3W1vq41Lc1yvVKzBhcF5obKuBnjhiTpfIS7upYJQXbyhTZYro7EUGImtVELbNaQ5trEHQhQTNGmIxrhYxWqX2ZSGcNcDmKWTPmBid73QqFuYg7jhgk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294830; c=relaxed/simple;
	bh=2VRqz4dA1BAhSOCzVF+h0tuDZV4Px4GWX13HoOXc+58=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CLMElPheDXuraBF9jmSzqfv4RiLMmlIcUP98paKsIkiA5fNNeumQ+mrdnTiobzJjk8tN+Kx6w8nDlSXPi01U+LzKu1zBLZnhMVhMAii0sNmT9nrLOAMrsaE+1K+1wJWrg7Wztb5Fc14MrwxOi3wLk6pgPS0hFp+LmksRdHA0eMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AA0bTh5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA0bTh5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE46EC433F1;
	Wed, 13 Mar 2024 01:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294830;
	bh=2VRqz4dA1BAhSOCzVF+h0tuDZV4Px4GWX13HoOXc+58=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AA0bTh5HOFiTGrFJ6TPiAEeiSB00+1bzvluMt8BVMO8GqzbxfBqGhehaVmSlnIq5+
	 IP25IsKC6Kcu3cEUWXhKEoVcmYlUXjoVc0Esl0Xx6V83O0b47UoU70O6fiRszY/YL6
	 98pYAJYwImVrrvpVxkVeAjZ1S7/Bv1E3Ou1QjRfzmMv0DNkwUFJ9B1vK5I9qYCrGe1
	 /+Vc99rXf6GXM+s00yVQLsr2M0qsDROlezi3fvIEzhzyvL3aLQKAuW/rUCQEhs1fvF
	 ZgFeapXNW/DjyPwRtw7NhO1+LsUspOsO532uGSXVepDqE7YoNbIYejbUcebpeSn8WQ
	 UZ9+N/jjQW5EQ==
Date: Tue, 12 Mar 2024 18:53:49 -0700
Subject: [PATCH 03/67] xfs: use xfs_defer_finish_one to finish recovered work
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431236.2061787.17936183721529625244.stgit@frogsfrogsfrogs>
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

Source kernel commit: e5f1a5146ec35f3ed5d7f5ac7807a10c0062b6b8

Get rid of the open-coded calls to xfs_defer_finish_one.  This also
means that the recovery transaction takes care of cleaning up the dfp,
and we have solved (I hope) all the ownership issues in recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |    2 +-
 libxfs/xfs_defer.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4900a7d62e5e..4ef9867cca0e 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -479,7 +479,7 @@ xfs_defer_relog(
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
  */
-static int
+int
 xfs_defer_finish_one(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index bef5823f61fb..c1a648e99174 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -41,6 +41,7 @@ void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
+int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 

