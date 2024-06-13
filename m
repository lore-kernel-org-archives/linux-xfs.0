Received: from crocodile.elm.relay.mailchannels.net (crocodile.elm.relay.mailchannels.net [23.83.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92550824A4
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718310482; cv=pass; b=UkEhZs3K89o0GX9cCKPL+eNaov8VUzp+rNhtRpXBbdk2CRH7IgMJcWT19/2N9E7UOQ/Cjdyok08Qutl1quA1G4P0Vli0AGffrxm652FCiz+7r5Qiwqxl1TRIaTr2igkrosk7ByRVO9SawVqNj+9FfiVluKyHildC6x3jMXIPOD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718310482; c=relaxed/simple;
	bh=OIC76fgDHrWTJW3Oypu1DWfs0cQNJKRJE7Jw15MTfq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5uz0/hsb94LWPrbusdotljsNDKLTAqChEJJYEuZEv4umzDRD/5hyULEDplXpNxJzORKsn/Ah034DvYH08IZQdr83aordMICdMjKhMdA/3Gkmh056RXQ1lMbduoQoeZlM6f2Wgr19XY99AvHayWhwC4vmi40wOXiMn1c0L/rEkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=YACJKUNm; arc=pass smtp.client-ip=23.83.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="YACJKUNm"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E4DAF424BF
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:57 +0000 (UTC)
Received: from pdx1-sub0-mail-a231.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 835A34043D
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:57 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718310477; a=rsa-sha256;
	cv=none;
	b=3cVVfylclox1y8N04h6J97YiV4QJoOKv8KGeIFg8gV4AVS0EbhOrD7vJDCgYtV0YVnM6aA
	j3/JlA/yTW7NdBDPsxYbdRfyfySub4s5NEDMTedIY1o0XscrwWdozF4QEH+TYswiwMiIzw
	ZcoE+pHX9oZBQ6vP6D3gVIStjeK+YT6NjWP3WsqRF1b0ATnjtMVPAtBzDbHW798bT9fZtO
	86XCBkEi6bcKhhY+nAmFCAATHDBn3xza/Hgr0oDyBRcFryAL7zIXJHTH8SJ8Bt18FVpZem
	6YE9Uy7kNPZAeyFP5YVI8azUwgDQMnZe6Y9ZL1+FZCQ4mXhK4TeKB3loQygXCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718310477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEtRnV6fCVboF1vhEUchMRUKfle7ghdO8uBvJiwAi4A=;
	b=9E5Xa/PEs6vuGa6inryi785OyeHJmdMRCinfL2f6KNY33F6SYKQhSvhi4aUaxIOP8CNaFQ
	O9cgrQ6LwtM3PXc/p0bwh7Alb71uiFF+IhoaAUyvsqeNLty+S1jFyzf9OcRXWdd5codgA9
	+PVaVCO3AI3nHTT8MAwOm63tzuZr3j2JMxvazy3M+n10XaeGkXqwwhfQNraB9QYtQkWup8
	AeHNcrsHXvBKdfmQc2G5c4bUsqE3lgKI59qP7qgul99ikHVvpq1MeSdAxDbSKARD+TO1vG
	iUO9fxqnyvq4J9vJyhoLCh1KafPgF5g+m21toPktXhRXalVe7yFrlZxginTF8A==
ARC-Authentication-Results: i=1;
	rspamd-79677bdb95-mkdnm;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Cooing-Abaft: 20cb34f91f8faf37_1718310477795_1107781588
X-MC-Loop-Signature: 1718310477795:3745807984
X-MC-Ingress-Time: 1718310477795
Received: from pdx1-sub0-mail-a231.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.173.217 (trex/6.9.2);
	Thu, 13 Jun 2024 20:27:57 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a231.dreamhost.com (Postfix) with ESMTPSA id 4W0YrF25DtzHF
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 13:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718310477;
	bh=oEtRnV6fCVboF1vhEUchMRUKfle7ghdO8uBvJiwAi4A=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=YACJKUNm5+edaVdjs5/hI7RQVlmW6mKoXeah9Hx7yELFfuwtWyRe3HLN1rTcNJw5k
	 j08KGKVtBOZjr3Va2eDiI92knLQj3A/YBZoyVxuCGvKRH1NA+4QMu66o2ukVwD5FkL
	 p0fxdP7XZ+tTGfmaOYt/I+INT65v82+XyxwRjVHSmX+FOCxZIYgZx1m5fZkWAqX72E
	 o5smOFoaD94nVBv6zgP0nhL/920lIMOgdDSLZXtLm80aep4WGhho7lqcBFOOg/Z25B
	 r4/hspce+VBd4GTeTje0iSM6BUFUY+29F7Vbl7OJK9vClo2pHgGTKSkBYe1SHe3Mzi
	 4loTM4Ug8dOfA==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e006b
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 13 Jun 2024 13:27:47 -0700
Date: Thu, 13 Jun 2024 13:27:47 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 3/4] xfs: let allocations tap the AGFL reserve
Message-ID: <ea3afc58fdf51c5edd86455bfea8d6a6fc448d1f.1718232004.git.kjlx@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718232004.git.kjlx@templeofstupid.com>

In the case where a transaction is making an allocation after its
initial allocation, allow that transaction to tap the AGFL reserve.
This is done in case a prior allocation depleted the freelists below
their minimum fill and reserve space is needed to finish the
transaction.  This is predicated on the earlier phases of the allocation
enforcing that the AGFL reserve has sufficient space for the transaction
to refill the AGFL.  That enforcement is in a separate commit.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0b15414468cf..3fc8448e02d9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2389,6 +2389,7 @@ xfs_alloc_space_available(
 	int			flags)
 {
 	struct xfs_perag	*pag = args->pag;
+	enum xfs_ag_resv_type	resv_type = args->resv;
 	xfs_extlen_t		alloc_len, longest;
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
@@ -2397,7 +2398,19 @@ xfs_alloc_space_available(
 	if (flags & XFS_ALLOC_FLAG_FREEING)
 		return true;
 
-	reservation = xfs_ag_resv_needed(pag, args->resv);
+	/*
+	 * If this allocation is a subsequent allocation in a transaction with
+	 * multiple allocations, allow it to tap the AGFL reserve in order to
+	 * ensure that it can refill its freelist if a prior transaction has
+	 * depleted it.  This is done to ensure that the available space checks
+	 * below don't stop an allocation that's up against the reservation
+	 * space limits when there is AGFL space still reserved and available.
+	 */
+	if (args->tp->t_highest_agno != NULLAGNUMBER &&
+	    args->resv == XFS_AG_RESV_NONE) {
+		resv_type = XFS_AG_RESV_AGFL;
+	}
+	reservation = xfs_ag_resv_needed(pag, resv_type);
 
 	/* do we have enough contiguous free space for the allocation? */
 	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
-- 
2.25.1

