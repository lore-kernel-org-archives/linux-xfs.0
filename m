Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225C8651B1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389048; cv=none; b=tCY0Ely0uAgZAPgHDFCl9UEigXq9b13X2hwri/0ll73eLgObsekmaux+Fh9S2o8ZIcjD0DkR+ZujttCr3O0BfgAOUwwT3vB5sSyDmOfp4s5t8D2llfmzYOOxjlpuTmk/8C/Ln7qeesoOXhrKyx3vrNtJSA6EE9TcXp2h73jXY8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389048; c=relaxed/simple;
	bh=6iKvRFFf77Lxs8D7nST2yd1HcUwWLVY8tqvQi4rYKpo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bn0jGFIHbSmplAx6abd2/5+xIYBaGt7FF02alU0Tu7QukeNvr9iWFMmODRLxiDvPfYazZGN5tSpOs4eiAuas5gcH9dkuhxRTyeggYyg6OZBafvXXsmwulkzdOrpxdKr2+NaBM3CR/CF7TitmKTuIt4rx/+9EGSBM4izyD6VRp4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaE12jYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaE12jYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA060C072AA;
	Wed, 17 Apr 2024 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389047;
	bh=6iKvRFFf77Lxs8D7nST2yd1HcUwWLVY8tqvQi4rYKpo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oaE12jYkw8VX6nqatZdgr/WZwnoGirLFa8622hTx5Q/GwqxmOOsNwDtmgGvJzLWcy
	 kRA3FHdQS60f23c6WDW/Kxfa6nai5Y/hdF5qCu3BGoGDeZOQUXLkHQxvD3RS0qucHH
	 ENgvzmHsJzdzx+fK1TaVRwSnJpSBLzp+wat7Tqs7Z7RmEgcIWgnYO0TMFXSjUoUdyk
	 G1n4IAHtq1OSQrX84OCHuZudaM4yBVHz+87KV+Zf0Y/RxsQWWgfEVqSSZH64VQmf33
	 Nba5fblYj5HFbBFR1eFY27FSXjPrhLt+aS8vX4CNFC12jJXoMzXNY++2GRkJyWx3tC
	 9bGP5DlVV5hlA==
Date: Wed, 17 Apr 2024 14:24:07 -0700
Subject: [PATCH 09/67] xfs: hoist xfs_trans_add_item calls to defer ops
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842475.1853449.8912215927627769686.stgit@frogsfrogsfrogs>
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

Source kernel commit: b28852a5bd08654634e4e32eb072fba14c5fae26

Remove even more repeated boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 42e1c9c0c..27f9938a0 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -208,6 +208,7 @@ xfs_defer_create_done(
 		return;
 
 	tp->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_done = lip;
 }
@@ -236,6 +237,7 @@ xfs_defer_create_intent(
 		return PTR_ERR(lip);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
@@ -501,8 +503,10 @@ xfs_defer_relog(
 		xfs_defer_create_done(*tpp, dfp);
 		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
 				*tpp);
-		if (lip)
+		if (lip) {
+			xfs_trans_add_item(*tpp, lip);
 			set_bit(XFS_LI_DIRTY, &lip->li_flags);
+		}
 		dfp->dfp_done = NULL;
 		dfp->dfp_intent = lip;
 	}

