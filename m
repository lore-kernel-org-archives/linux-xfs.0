Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B163216459
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845670; cv=none; b=HaaZvnm9zXiN52ZDmd5/qbI+Gddpb8UpPQ3kVnwiAXmidrXIUkKNf6Yu+bopNeprU4AgtrIaJIEDPXMIt5bMD3XZLLGIfRiNDID2GF95LTO1nVen6aIaXadSiWiqTKAMsnrd7By8KDlOmMx5ucwhqT56h5WjDbQpZEkZubN8WII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845670; c=relaxed/simple;
	bh=LVueN7h/Dwzf9QoEup99ULLONTT5Qs7lGMX+1lYnkz4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5CYT8e3Hz2bLfsXzOKSIvQAEZGKviRoktHGTXFj3gS2gCRC+wDysdQPLG/sNS0B0yBLflSZcOJXFGkYUHf4b/GkTMg/6cFCQcwKhkpGEj7+Mk3r1WFAW8rNU+lti5Zg2+dOvzng6sFcRq0l1HSREBcvCQijf2+/edL1h2Z8Z64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6VKw8rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6VKw8rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E264BC4CED1;
	Tue,  5 Nov 2024 22:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845670;
	bh=LVueN7h/Dwzf9QoEup99ULLONTT5Qs7lGMX+1lYnkz4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g6VKw8rpBFaaPzswE2vDOR85iw2wN68HW2WyZt7x/P+IOAWf/9nXjpz3S4xdT3C06
	 YNHER+Kb0SllOj0UelUO/IsDMJj1XxtFY0Vo8DBnBPaHBnZjvDxG1leYDmjudxVMMN
	 drTUxgwUnFzBs7PRNRWN5Fk2VYqp5kUGPZRqCHFjXYqSEY9jNF/h5zn+hBl7ORRRzZ
	 ievv3kEEVugJFfuUkbfH34I8gWAJWKLqFPb7odoN251PxAgivLDZSoS/a08FqJZWcv
	 LKwdJqAVASZjiFdMSdDLdCobUBwAE9Tlvp3xmLDuLbvLSGSbkthKAVpiHSSQi//qGO
	 ZAGRwMzcgBfag==
Date: Tue, 05 Nov 2024 14:27:49 -0800
Subject: [PATCH 15/21] xfs: calculate RT bitmap and summary blocks based on
 sb_rextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397196.1871025.1743152082903751803.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Use the on-disk rextents to calculate the bitmap and summary blocks
instead of the calculated one so that we can refactor the helpers for
calculating them.

As the RT bitmap and summary scrubbers already check that sb_rextents
match the block count this does not change coverage of the scrubber.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtbitmap.c  |    3 ++-
 fs/xfs/scrub/rtsummary.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c68de973e5f26c..5b42e01a07ac8b 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -67,7 +67,8 @@ xchk_setup_rtbitmap(
 	if (mp->m_sb.sb_rblocks) {
 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
 		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
-		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
+		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp,
+				mp->m_sb.sb_rextents);
 	}
 
 	return 0;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index cda5e836862178..7c2b6add44e8c9 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -105,9 +105,10 @@ xchk_setup_rtsummary(
 		int		rextslog;
 
 		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
-		rextslog = xfs_compute_rextslog(rts->rextents);
+		rextslog = xfs_compute_rextslog(mp->m_sb.sb_rextents);
 		rts->rsumlevels = rextslog + 1;
-		rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
+		rts->rbmblocks = xfs_rtbitmap_blockcount(mp,
+				mp->m_sb.sb_rextents);
 		rts->rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
 				rts->rbmblocks);
 	}

