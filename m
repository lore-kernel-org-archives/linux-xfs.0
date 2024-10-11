Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583F74A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608376; cv=none; b=avd4RlI2z343x3GCxNWOT2jwC0TMYMZ2kSCfvXRdCzT0yCfuVGigKr4aK5rxFlQbaihoS580MVll1ObRN41FswqMpWVt97hMhDtzRYBBtGtz/VM5qRe4bfkKaQpPA3+HZb0ClsPO5zkWkIsBTXyJ0W0wQPxHy7UVFLuHq3l5FnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608376; c=relaxed/simple;
	bh=LVueN7h/Dwzf9QoEup99ULLONTT5Qs7lGMX+1lYnkz4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fRDBDhWw9EtKxNrFjyFoKymyi4lRNIQUnLSAZQed8BbkjADNCozjHIqmJhr3zOU48donOgLtocTQRfJ2UFhlqS+oA5tTLQigSJu6AGPI/XMlFCzLjJVmQcsGemXvozifrNM0NYnPNrahDDZ6DLTSbK7SjpvO+5vGyLjnq19EMKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGnHwZhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGnHwZhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC50C4CEC5;
	Fri, 11 Oct 2024 00:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608375;
	bh=LVueN7h/Dwzf9QoEup99ULLONTT5Qs7lGMX+1lYnkz4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hGnHwZhhCeUDBWYn53mZ86G1ZpoaKlpuooatTrvZhR18pZQ/LdMEvRWcTPP8310gc
	 p7iaaeQ/i/45+YyImuxkVIJAVCMCVKvRrNB1vQ31eS3mP3AGyAhq6I8GPS7goYaenP
	 Kio1BKPPpjtUZgexal7LnAyLlJBX2MqBHki0ysIZSAdrDBIDZemxoNilq02fOnIMpd
	 9x6xANRUA2UbZh8TGdFwsN2jVxQ+R6iF2F00hUtUuqIRxdLEKCFxUWABXY+SXbYBd8
	 S9yuUEAEbVkQzuBaNRFZs/7H75FOlnJ/bGfCV/vXDW3NA9OIP5duTMf/qolPrYOyQ0
	 Pd2rSo0obMJ6Q==
Date: Thu, 10 Oct 2024 17:59:35 -0700
Subject: [PATCH 15/21] xfs: calculate RT bitmap and summary blocks based on
 sb_rextents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643207.4177836.13628401666277178987.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

