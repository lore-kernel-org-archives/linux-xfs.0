Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A868D29BDBF
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762252985; cv=none; b=ROxppai1SBBHxR8hyRsZWRRezKIm+HLAbqcqyKHkCxIkVeaMT5oQuMM0smhScyXB/VhZjgtIOLa8XoYfj89SUmdA1Mz3MxMsz/OV13u1EccLYGrvd4kTWDWy6SG3oQNj69De1iBd/hsqFqXSssuoa8U6hOzPl5ylPAIeeYdm6WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762252985; c=relaxed/simple;
	bh=iDCqlJD1G9WWiRT3p2RYL/AnJSFwLT8UNID4HoAOD/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jzxm1NbK6mCVb/Fupe426luUNjFvGVjMTAXCIQtwPDcQ11LEdNfsZAF+zmeSRb/0lUI+r/8ePgEEI2hMd/wZCCOO1UGnr4kzu+N+CD92OsdjVP/Yu+MucsK9tLDoqfc/4YUpdB3VPcxJ0aLXAp8zK8xR7bqk4D9EnKLSMZOA1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xGC4neHg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xGC4neHg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vVcmKDJU4Rvlxt1tlLfSmot4YgMFNDqc1pID4y3O1d4=; b=xGC4neHgUyKXsrlmulRVU/SuE1
	X13Vri+b6/OvH/gjGPGX8LzDV7s0g27Od7VvOtIlGg8DZR044t1Tnt5GZIk+yyusi4etmCP/C4mec
	EudIMeoF3S7jbTHIDKPjkMOZRWbnnHuP59B4ov0RdyElVk5a0ay6/LqTpgqJqQ33J5t15Lew48Bwy
	3b5Z5ZRniIFPBuy04/YMTq/DEXE8Gq2Ts5J+oooG9dLnveLyvFRoYLTYYP0TCc5iXzjufQU4XTaz0
	+KSUABAF2Iizn9G9zSoyi6Gfc+5v0PN2kaeSOPby2d3efnt0SAVKhZKV+tB9FbbJeGXnkQu48Gbrd
	Ld42gzJA==;
Received: from [207.253.13.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGEVC-0000000BdGI-3NLc;
	Tue, 04 Nov 2025 10:43:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: free xfs_busy_extents structure when no RT extents are queued
Date: Tue,  4 Nov 2025 05:43:01 -0500
Message-ID: <20251104104301.2417171-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

kmemleak occasionally reports leaking xfs_busy_extents structure
from xfs_scrub calls after running xfs/528 (but attributed to following
tests), which seems to be caused by not freeing the xfs_busy_extents
structure when tr.queued is 0 and xfs_trim_rtgroup_extents breaks out
of the main loop.  Free the structure in this case.

Fixes: a3315d11305f ("xfs: use rtgroup busy extent list for FITRIM")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index ee49f20875af..6917de832191 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -726,8 +726,10 @@ xfs_trim_rtgroup_extents(
 			break;
 		}
 
-		if (!tr.queued)
+		if (!tr.queued) {
+			kfree(tr.extents);
 			break;
+		}
 
 		/*
 		 * We hand the extent list to the discard function here so the
-- 
2.47.3

