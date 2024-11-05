Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C839C1CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846419; cv=none; b=gPhQonFMD9yaGuB5xfRCkLTo9TYG1SeTqQgdKoMsgALDV49aJsJPrAek0zrDhETF1MKjTh9TYdZx4LFxhy+yWkdU1ET7ikGVUkSmw/CS/oZMN/bJhiYrlFWvwxo9n609myyMpPq15gnWGq6+2ICbZ9L+Rbw4mcD90UZzV+4ctuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846419; c=relaxed/simple;
	bh=DA3SVveFGsoBPM1hbpnX29b0Xvm7WuHEsOER3KEx6ZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gC0IbYGpKolKUJsNnPQIhHVfpWpCt383rY8RCNSdQv6aYCx/Y6QkouHkaZRom1frtrpk1QN36NjeacUFfQaQJxamTeWLiaHWUBCG5Ph1awQhZz3V2cfyGgm+htVKZugW3cxpUoVHZicp45y2cq3//DquL0fvHgxB3S4R4tvIGso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqvJRRiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqvJRRiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411EAC4CECF;
	Tue,  5 Nov 2024 22:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846419;
	bh=DA3SVveFGsoBPM1hbpnX29b0Xvm7WuHEsOER3KEx6ZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HqvJRRiUSw9wQ4NCVVXArYLl4zrBzOIK2pfy8j1v4T9QKxALacYr2H5auk7pPW0Hr
	 XC7ibH/P8lKcK7ZxjbxoygaX1Mu3GPrOLS0WL4bNdEwt4kl7tPsUstcsWfehfoSRB0
	 4DsbGYuqYOu+NIQMxtt2k0s8Vq3OSvLAqpzrlcouhQeJVaWykD2T/Nqb8yhrgfK8Mh
	 Pxn04/mFf9123chFxoTgYtWjLVXkTHd5UoX5hKDG3FRP5ploNdJrtgFr32Q3pdqDWz
	 Z2hHex1vGoZYG+aw73ICNxcodhAMdzV6aTz67SY5s1M0CS1HMEnFNMayozZRrwHfAv
	 vL7jMaUSHgUIA==
Date: Tue, 05 Nov 2024 14:40:18 -0800
Subject: [PATCH 2/6] xfs: advertise realtime quota support in the xqm stat
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399596.1873230.8956988370471543351.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
References: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a fifth column to this (really old) stat file to advertise that the
kernel supports quota for realtime volumes.  This will be used by
fstests to detect kernel support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_stats.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index ed97d72caa6652..ffb52725c2a8e8 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -115,10 +115,11 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 
 static int xqm_proc_show(struct seq_file *m, void *v)
 {
-	/* maximum; incore; ratio free to inuse; freelist */
-	seq_printf(m, "%d\t%d\t%d\t%u\n",
+	/* maximum; incore; ratio free to inuse; freelist; rtquota */
+	seq_printf(m, "%d\t%d\t%d\t%u\t%s\n",
 		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
-		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1));
+		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1),
+		   IS_ENABLED(CONFIG_XFS_RT) ? "rtquota" : "quota");
 	return 0;
 }
 

