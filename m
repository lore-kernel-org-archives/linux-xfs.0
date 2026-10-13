Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B8549B5AB;
	Tue, 13 Oct 2026 06:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871734; cv=none; b=t+8B75qdeCA+7GaDpwLGH/D3ZBxAyoB+Tr7Fy7tOkiWx3vFGuOU5smRsg/0IOGQJn72XfND22il17X7pbn1bEypeGEQPcNz5sKgiunH1+laS4mbXaGdwpP0l2DEQbJXAKQWLtfdrUpBl9gmtG7Pjfl1yXtxBlm43efgjFZYja0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871734; c=relaxed/simple;
	bh=gnyx3t17l82dkBWySPGmaxramW5+1WAfqm0sta5m59k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYdBJqInRGGAr4qmBii9iJ143aOTMzJgyG6j0BCAVTVDvrQtxD56OPtVHuk1iURhYe2TdHcIA1iqLHItGxRCm1G+Dxq+dfpbTDKOP8Kh0vP7onsFOpSSzshu2pts+xO51aT0uF9rdLyjlHe6SkUhSyDUH02Hax+WLYvoFWkxP9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpYxiwoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpYxiwoi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 109071F000FF;
	Tue, 13 Oct 2026 06:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871732;
	bh=a5cY3IjqN5rLvTa1uBzF3NKznqylu/jybFdUSBmjbVk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gpYxiwoixGsdhWxaM3E9Z6lLn83mMBgBW8b1f79jk94GTBzvMYZ1dFDbSd+QwTWbf
	 sp5WN/cxk1ZGoqRk0k4LnyekWI3tJRX9RJWE3ZGTWrbQUX0Rf9n6Fe3KCZ7A38Ye+v
	 Z+WH9G19lfGi2k1wx+nIjjekHM5V/BFDU/xSS9UQe6Q4ZCjp9vBtn2bWVCRR2d/vdn
	 YicNy+cKUBqgnxj9DXfNPKFOH8/JEVKxlBuwDkdMdFXQZoOPSmlFvkSkaCW/vyaT76
	 3CFwaLL8gFaicmynp6NASoOEOy1C67a6QhSBNgZ2lzPM5Lugs7T2dHAyMejxUZ3lFp
	 upuzOObHFjh5A==
Date: Mon, 12 Oct 2026 23:08:51 -0700
Subject: [PATCH 02/12] xfs: don't rescan ifree and icount when frozen
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107884.1898896.544633277275486083.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that it's pointless to rescan the AGs if we've already
frozen the filesystem because there won't be any more perturbations.
Fix this to mark the scan incomplete and exit.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/fscounters.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index eb1a095a0fa9b9..5984fe13a973b8 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -379,6 +379,11 @@ xchk_fscount_aggregate_agcounts(
 	 * to maintain ifree <= icount before giving up.
 	 */
 	if (fsc->ifree > fsc->icount) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
 		if (tries--)
 			goto retry;
 		return -EDEADLOCK;

