Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A01E0DBC
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191746; cv=none; b=rAyL5AXV+fNRE4t87ZPQ8kzoQE/8kSw8rYfTXZaLW8wud3gswXKeLe+luL1B0LVaitp0pqwwRBUXKDxlyH29Uwngzni8PISeYRtm4TgF3iL+LPkdSP+sMVK1u7fOVDupeRQQC0il34VxIoa8KEU2wSXK5NfG8E6GbDHCOzeRJKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191746; c=relaxed/simple;
	bh=LVueN7h/Dwzf9QoEup99ULLONTT5Qs7lGMX+1lYnkz4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkJsIagZWFJ1ax8DAY+khA/IKuvLzECRAyErwEVgftcG3jz3ej931BYJI6OhN+kPcxX+fNeZIQNHxrSDJZFbp98YHLavYWlUUUyZ5fbSSA05psPcbG0YQA8aDOJxhDxa7VSUtG7Nxy09uv/OANxOGZLY6siP9SCftFxnTD/c8xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pTqEecq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pTqEecq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19464C4CEC3;
	Thu, 17 Oct 2024 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191746;
	bh=LVueN7h/Dwzf9QoEup99ULLONTT5Qs7lGMX+1lYnkz4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pTqEecq82pJooX9cLaQatP/DGGSAKrFbOvcoEAaedd1+dD+9/JeqGZl4i/aANGjlC
	 CbVvKleFM6fAPRC9UQUvN6EZIlh5/KcUWYj/NlbXedOeeh69z6hNJDp6aJorVTipD6
	 3Wmwe8d+Kheuj3vih3HSknJBx/yJW5FYQaOKcwZC9jsVpKiwr0Ql9q6isW0iJeI1zi
	 r+xttYwsw1Lie0lti/kx74EJMoZGiU8KNqipI9Wxo91sFsF2mGwXv8DvrLP7Kp7UXW
	 KcrIzdjsl4ragpMIwZxxEg95A4OFc1xMkJ3iznZfZHiHK24+JN+Ncdbl8eyLIqzaPQ
	 Ti9pRzDKK5AZA==
Date: Thu, 17 Oct 2024 12:02:24 -0700
Subject: [PATCH 15/21] xfs: calculate RT bitmap and summary blocks based on
 sb_rextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070657.3452315.15851264890462207333.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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

