Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D9E1C0DE7;
	Mon,  1 Apr 2024 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990163; cv=none; b=Cghpoa+/WHnzo6u92yTHRb0dpyc6R6fxp8mEt18OsuR5jMI4eQCG5wFq7AI1eHVoyu0iqHiq0yqSW7AYEikH3qdcOTVMSbo4X12WzPR6YPZgkC6uC8gxZX0jf9KMGc6shuArCILBMATLvlkrS7uQpc5on7WHwda3531zQ4zuVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990163; c=relaxed/simple;
	bh=i2ZJjlbZDbH0CK9ki02+3jM56nI6WFpjudgHWzEEkQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCDQZcsTnTMF7j3U3YbjGPr4vpt6OkSNE33Xsv991B8zY9eisFkQS2e4xoLSA7wP9T3/d+zfC6unmemIFxEGGM9px7fqONM/xnJf38esdVx7UpIXougaapux03eSYL8TPIiQwQuF0ZizM/HKB8FOgAeO4tKjIGR9cp+qfx7fhMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDksCHb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDksCHb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F23C433C7;
	Mon,  1 Apr 2024 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990163;
	bh=i2ZJjlbZDbH0CK9ki02+3jM56nI6WFpjudgHWzEEkQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDksCHb5iHk0uX6a3REtzzGl6cl8km+b2IcXzKOEWXx42LcFxcnu5g1/bQI1ywmTZ
	 pl5bwp4eFRh0cpzNuaE/XFkwKl9bUtFuGGX8V0qymf027V/8/rDAKDDEy4xJ2Fqp8K
	 qafUHk1KaaB29iA/wZFbsXYL1cfP0eYqQlhxs4NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 265/396] xfs: recompute growfsrtfree transaction reservation while growing rt volume
Date: Mon,  1 Apr 2024 17:45:14 +0200
Message-ID: <20240401152555.806638455@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 578bd4ce7100ae34f98c6b0147fe75cfa0dadbac upstream.

While playing with growfs to create a 20TB realtime section on a
filesystem that didn't previously have an rt section, I noticed that
growfs would occasionally shut down the log due to a transaction
reservation overflow.

xfs_calc_growrtfree_reservation uses the current size of the realtime
summary file (m_rsumsize) to compute the transaction reservation for a
growrtfree transaction.  The reservations are computed at mount time,
which means that m_rsumsize is zero when growfs starts "freeing" the new
realtime extents into the rt volume.  As a result, the transaction is
undersized and fails.

Fix this by recomputing the transaction reservations every time we
change m_rsumsize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1070,6 +1070,9 @@ xfs_growfs_rt(
 			nsbp->sb_rbmblocks;
 		nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(nmp, &nmp->m_resv);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1153,6 +1156,8 @@ error_cancel:
 		 */
 		mp->m_rsumlevels = nrsumlevels;
 		mp->m_rsumsize = nrsumsize;
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(mp, &mp->m_resv);
 
 		error = xfs_trans_commit(tp);
 		if (error)


