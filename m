Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6971C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422311; cv=none; b=irMi7loeuGfqIgynShqRix8FANfweDEJ03V0wS40HvMs+t+WZL7CGKfTP7thIUDK9a5Funnzd7JSG/lWDjdtumjhs8jV4leKPzSz2+FIvwU1DpEVnezdjnGm0w063N5FqHDQQ7L5Dbu2wz7k2fM/ZMauGzMMSr2IA6XCnyju5XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422311; c=relaxed/simple;
	bh=WabQGzoL3MOAQdFRUIk3R+1vJpW+YTssrJcCrAIDh1U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=clsZjpvg59jamif9fLxESgvk1RaXd+ZuuR8DPwp3uvVW381TjJyng1DQz7gEjPj6hpiXLXi2dret7W6O1vVFkaUktqNNBNPPaPu3nMZ7ipYrttTpOb7ffNlMImjHPjbDgaQGS1tIEA2Cdhpd9MeksQ5oKVhOfj4Gqaf30E6euPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWY1GQbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWY1GQbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE18C433C7;
	Tue, 26 Mar 2024 03:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422310;
	bh=WabQGzoL3MOAQdFRUIk3R+1vJpW+YTssrJcCrAIDh1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KWY1GQbAwCklSpI4kBEzxwJ9e5vZr5f9qVucgc4HGXYJ7ajwsgaqzTHqYUx8roXqt
	 61Kt+Z/gRzVbbgWjtt+uS/En47WbTVjRkRKirznuGazbzITd+BKjCpOi0BaJs8WwW7
	 pjkwHeOPsms2GeFizziWLbf67GG/y5ChJugd2mHp8N7d1iJcwRkC2Pt9dQQsiAczk2
	 jKwDTXYLQ5yBDkLsT4pAqdrro3HLCesjCspBVnm/Xl0w+/Jb4OoZ/eofT/Dy/KHB6Q
	 DcqbqHUt/HnRn0+rJrHYVt5lW7iBJRzmQ/T0hoZkhmDqS8sBlKkKiPv2Rd5OzA8Yy8
	 3NmR+Hi9xk+qg==
Date: Mon, 25 Mar 2024 20:05:10 -0700
Subject: [PATCH 09/67] xfs: hoist xfs_trans_add_item calls to defer ops
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127093.2212320.2060615082633349516.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
index 42e1c9c0c9a4..27f9938a08d7 100644
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

