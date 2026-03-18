Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F93783A4
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 08:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821677; cv=none; b=YvLeC2aURk29hzamzOWpwLUSV7Rj9McExenQBBPpBs8qeqDrB5WHfmjyd9bgzZyOQjfUk6VqtCWO23E/susgfT/ef3EhwyV4KZCKj6Lqg59DmmpVscE/uYG/A+wmBP7Hn3fWyX2hT3kVdI+ucXpnFX30ehjlivIV1hHcAejDMSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821677; c=relaxed/simple;
	bh=opox58GZDaRxh0LR+UQdzY4pn08kVDt3tq9LKsOCJ60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMQPhtgbe8DYbem6MtbFh6Jhsz9kJrro96XBA6EZXXTdEGSzqMVEqo84OJOkNfa+z8lVssjzloOZhbg6p0zrEN2kDxqm3Qg0c/7RrRpkk3OFpzB/dRbwPzUMOm8gnbqygheAZ1Z+RfV0bcH1V/xVmVOiGvwp6SEhDCo8Hw0U+PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E054968BFE; Wed, 18 Mar 2026 09:14:31 +0100 (CET)
Date: Wed, 18 Mar 2026 09:14:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dlemoal@kernel.org
Subject: Re: [PATCH v2 4/4] xfs: opencode xfs_zone_record_blocks
Message-ID: <20260318081431.GA26117@lst.de>
References: <20260310173709.457047-1-cem@kernel.org> <20260310173709.457047-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310173709.457047-5-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 06:36:49PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> We only have a single caller, no need to keep it in its own function.

This accidentally dropped the record_blocks trace event.  The patch
below adds it back.  Feel free to fold it in if that works for you.

---
From 6e413887a36cd91af3684d8af357b50538106bea Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 18 Mar 2026 08:58:38 +0100
Subject: xfs: add back the xfs_zone_record_blocks trace event

Commit 54514abb9891 ("xfs: opencode xfs_zone_record_blocks")
accidentally removed it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d712d5a5ce0..9d02160c5334 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -291,6 +291,9 @@ xfs_zoned_map_extent(
 		}
 	}
 
+	trace_xfs_zone_record_blocks(oz,
+		xfs_rtb_to_rgbno(tp->t_mountp, new->br_startblock),
+		new->br_blockcount);
 	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
 	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
 	rmapip->i_used_blocks += new->br_blockcount;
-- 
2.47.3

