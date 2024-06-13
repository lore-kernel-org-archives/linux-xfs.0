Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEB9135A7D
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718311049; cv=pass; b=fYn9v3DKD6283+DI24d345SNlcMV5ahdUPTPJxezkQF7Y5dqozqEDqhfjkUOYJjeiREPikTjkiD6A6KMxpEmdcPuRKDr9+3BEaYHgmtMAHTX5hJavZrKHYPEX5LAMbfN/QxsbrkwcPe458WiAiE0Uqr8/09a2v6wsrPN+2fPy7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718311049; c=relaxed/simple;
	bh=Tetj88LPtvkglnISn3PzT13trw4CozURsUBO076yNRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP4pZ4zO5vslD8ay3cKc6M8DuCd+U0ku20kmtoQB0067cpPH8LYbKXGvXVWkWmD0xDW8zzZpQsRPBXNY02wju3KuPVQ9JrQEmJeqwIjTrtbaorrI60groMhESEEVamsBXOcYBWqS2hseDnQfo0oLf7acV26NxvJGrsAwOsAsbfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=GUS2jvIj; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="GUS2jvIj"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 9672D8425F4
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:28:08 +0000 (UTC)
Received: from pdx1-sub0-mail-a231.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 48A63842701
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:28:08 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718310488; a=rsa-sha256;
	cv=none;
	b=QdGpoCrZbSgpFNprdxdcTqAxKE4Lc5W/f2ehlk+taf5v6+Cpq7G7KT06A+DrI/29MS/vhf
	P8ofscmLdo6f14RTn1negIizvuxaMQvUwrup3Q1FF2zDJ/niXBiZUslOh+ujwt0Ep7M4T8
	TwbeFQvyQiGHXhyGujdya7srn9/rCGuSQxJznpcu+pYeZ71FnsXz6DwUdYNUcJHpGLc87y
	RqR5jiiomK7zRDXSeUNSGxsbzTeu3VjiOFsxqH/54zWiIrzG7WXQD05Yk2mMAdImvbRlqH
	eRFzdHtosYF8wzvU3Kgmj3B+jPOinyYIgJ50uAwNh40J2Z581qMVyclX1d1OPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718310488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOQ9i9IdUgbMinaQRggIQuygSNpYAsxs4kqFU4lVXwc=;
	b=sv9f8WLsu6BAYVJuccv4uH3+yo2knD+gnB0NXoi/+sT3RzK/S65HpG3HIlL3UGMAUEmXqs
	lWFQAaKDncOquxNJpuvtrSCKvfvhM1RmQiUsxYwBlLG99Zuo4wzCNR0d3hLE4s4Uzewm/o
	m6HTU3BMFOU0aLyVwmlkkOSsJsSjvp4UwgoWXDI0W7fx6yZfgLEUWSVqD/kqM/Mi09gedd
	vNXB8rjzNaFpEHnFftgHPJeCdapz6COklSEZldCa35MdoFJzGNNYU7RAGFkTGpRjLkilKY
	6fgleVoRBLyisz094jObFUIVWRO8JJqsDQYJDUWVaJIaXVVEbbAqPOO/cbh/cA==
ARC-Authentication-Results: i=1;
	rspamd-79677bdb95-l6xf4;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Harbor-Cellar: 796ea2eb0f6ef146_1718310488505_1620179655
X-MC-Loop-Signature: 1718310488505:2549102912
X-MC-Ingress-Time: 1718310488504
Received: from pdx1-sub0-mail-a231.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.82.153 (trex/6.9.2);
	Thu, 13 Jun 2024 20:28:08 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a231.dreamhost.com (Postfix) with ESMTPSA id 4W0YrR5LDPzHZ
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 13:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718310487;
	bh=EOQ9i9IdUgbMinaQRggIQuygSNpYAsxs4kqFU4lVXwc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=GUS2jvIjZBFQ0zzp16/d57fFVlRz4YnvjjnjFyi1PkX3HWLUJ+ekl2LYDzOw+M6EV
	 t7YaNFW9qBqK0xInzBXoqk2qpmVjqpevJBmOjmpmkqviV9UvAOTGxxf66bkgNAxY2v
	 A/qcfIcKDU9NH5UiehFrE/J/x6U5S0OOLmKbLYfZ6DXpvm69M8DITjHVkPsXynUWYD
	 7L2+Vd/HfO4Ikp6BoJEyUoQK6Ejl6MJ+uh4Mzxeq3gJUL/GorTvW2rnKb22P2Mzgtg
	 NgTl5TTw3hDMXX5FL7cwp/Kw/LvTbB/JcYqx6uKUpHrvpXSeHidDEF+2Fgz+kIpLTz
	 3qt2415i+ebcQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e006b
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 13 Jun 2024 13:27:58 -0700
Date: Thu, 13 Jun 2024 13:27:58 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 4/4] xfs: refuse allocations without agfl refill space
Message-ID: <100c327fc8c5dcd74d659aff97033783380c28e6.1718232004.git.kjlx@templeofstupid.com>
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

Ensure that an allocation that may be part of a multiple-allocation
transaction has enough space in the AGFL reserve to refill the AGFL in a
subsequent transaction.  The AGFL reserve was established to make sure
that there is enough space reserved for multiple allocation transactions
to use this space to refill the AGFL close to ENOSPC.

Check an allocation against this reserve and refuse to let it proceed if
the AGFL reserve cannot meet the needs of a subsequent allocation.
Without this, the second transaction may ENOSPC if the first uses all of
the AGFL blocks and the AG is close enough to the limits that it cannot
refill.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3fc8448e02d9..7b0302f7e960 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2389,11 +2389,13 @@ xfs_alloc_space_available(
 	int			flags)
 {
 	struct xfs_perag	*pag = args->pag;
+	struct xfs_ag_resv	*resv;
 	enum xfs_ag_resv_type	resv_type = args->resv;
 	xfs_extlen_t		alloc_len, longest;
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
 	xfs_extlen_t		agflcount;
+	unsigned int		agfl_refill;
 
 	if (flags & XFS_ALLOC_FLAG_FREEING)
 		return true;
@@ -2429,6 +2431,21 @@ xfs_alloc_space_available(
 	if (available < (int)max(args->total, alloc_len))
 		return false;
 
+	/*
+	 * If this is the first allocation in a transaction that may perform
+	 * multiple allocations, check the AGFL reserve to see if it contains
+	 * enough blocks to refill the AGFL if freespace b-trees split as part
+	 * of the first allocation.  This is done to ensure that subsequent
+	 * allocations can utilize the reserve space instead of running out and
+	 * triggering a shutdown.
+	 */
+	if (args->tp->t_highest_agno == NULLAGNUMBER && args->minleft > 0) {
+		agfl_refill = xfs_alloc_min_freelist(args->mp, pag, 1);
+		resv = xfs_perag_resv(pag, XFS_AG_RESV_AGFL);
+		if (resv->ar_asked > 0 && agfl_refill > resv->ar_reserved)
+			return false;
+	}
+
 	/*
 	 * Clamp maxlen to the amount of free space available for the actual
 	 * extent allocation.
-- 
2.25.1

