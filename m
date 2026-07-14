Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A431FFC59;
	Tue, 14 Jul 2026 06:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009096; cv=none; b=XpjwVliwjytPg0/vtV/twNlCfqpTUMhY7CffqYsewav/GfhDfCzWeAbnTaHTajdX+QNsMsjni1+bkO1qNyUPbOk9X0O54Z2L4+qxh+DeVcloujq7vPIWpqwj8wCRh/Y+hox8Or4f2JcWFdsxe9+c834F5nNdlcZADgd4lZfX75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009096; c=relaxed/simple;
	bh=jC4Pq8beK1OE8Pjt35/Dh+v2/botcoOJUhz/CHgFvN8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWE+2bkvHpfC5Vxa8VZDBLTaBS8q7Co9yN0MWqKsbuhYVbgXRGTVrExZ22NE6XzgHe5Ua/OHVYVjHaTSzG0TjStw+O+1px5gctt/gbsuh4IDxSJ6PJcchrI4LksPLU4IwZiZI3ddLpJ4p9IekWcUUI2qIStskFjiPG6zocbS9Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIu72t3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIu72t3Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 80A671F000E9;
	Tue, 14 Jul 2026 06:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009095;
	bh=viL4lMwmA+kS6yt7DsEr4i1uMANgTfNR2BFp/itXgrY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DIu72t3YFP7Anrh+OQEdr7mql2KaV2bzK5r2pTNwUqUnQrL6+rhvpzLaoMPqqUxYG
	 I9duP9geGTi+sKw8Zwu6ufg3yKRzdylHiDrY4UsmA6SZf9HTixdVZVEEh9KC+1rR/R
	 5ggSl/L32AASAd1kvtgCuCLEl5ESxrpzpfQ6dDuUnybWzmazERt0Fdv2mDYveTsgBw
	 VQ1y0aXF4itU20XEyZ0xqCfI3cUPNGAtF1uXhjs+K/KlV0nY9PRwsRNCU2pZJSeIqo
	 h+8cmKd86tyKkxC1ppjCNZoBpTWQPqp1yLZWnsbdDeU0m6x/B9mrJVoS6PQ8BzKKgW
	 oIID/QukiTOFQ==
Date: Mon, 13 Jul 2026 23:04:55 -0700
Subject: [PATCH 4/8] xfs: don't wrap around quota ids in dqiterate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716455.267810.17980451597796112244.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that q_id is an unsigned 32-bit variable.  If it happens
to be set to XFS_DQ_ID_MAX due to a filesystem that actually has a dquot
for ID_MAX, then this addition will truncate to zero and the iteration
starts over.  Fix this by casting to u64.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dqiterate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 10950e4bd4c3c0..079dc4e691a01a 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -205,7 +205,7 @@ xchk_dquot_iter(
 	if (error)
 		return error;
 
-	cursor->id = dq->q_id + 1;
+	cursor->id = (uint64_t)dq->q_id + 1;
 	*dqpp = dq;
 	return 1;
 }

