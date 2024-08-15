Received: from dwarf.ash.relay.mailchannels.net (dwarf.ash.relay.mailchannels.net [23.83.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C9214F9D6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 21:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723757082; cv=pass; b=V/VQUJuhlwPaKuM4FZ0X1gWyEr+WQjjtz/XW+J5+01grlh8xRE30bfDEQlGsjh0zzA8lAiiG4fuMi0VtAuPbvPCcm8YziVMPeKBU1y3l/XzscSmNrKZOtLRamtl30XlNr4mWCcHo3kY7xQPyt1gd+pb5AfprAXdVRqB64T58ElA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723757082; c=relaxed/simple;
	bh=oN/PUDnAjVWq+DgxdfEgfhbKENytoMooS7/fbncWYqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeGWFLHKw6BuTvsFKURnjPZiFZPumd5MClezKDs0xcSrEeb9zBSuLlMC5b6X9WHv2DPh1mWXeIfhsERquIQaEyNgTWXo4NxZI8D9GkBaMmM6oI/C7ZWPxnedKscQIUhVMDHGWkKVe1MFGOmf12Q3W6JEEogin/a2QxmFCLNAgh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=MwOsakGs; arc=pass smtp.client-ip=23.83.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="MwOsakGs"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 000CD7A7ABB
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 21:17:30 +0000 (UTC)
Received: from pdx1-sub0-mail-a258.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id A75CE7A7BED
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 21:17:29 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723756649; a=rsa-sha256;
	cv=none;
	b=cy/UWW2N3T6Ow04rBV6pmKQ/arXHTyXvRLOXVdPXNZqh7NQeQd9Jd3YFtCK972Abk6XDYT
	FGSDC6twwXIBlEfVEA9WwtKBgAET3ekAhZaoKLgg95AVoQt3P2SN5kUMdybAPjgIw2+34U
	hI4tRHdH9sPYIfWLJahqRt7pDs2UWC23MX32PecEDLw3nbb53jrA+fTjamHu4FWjohSEGG
	jGHZLnejVHkScD0JXczBWL87WFdLhdYR4TGxkHVMP4e0mmAMGQt2kpcVw/406VpMRUVbMq
	/3wYKkCKU392ROrNExTBSMdYb7OGUdbasZetWupW+e7gEN6ZR9NtBS1toYa0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723756649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ONJXDFMJbMD3oLnJMrIEFCbjfNXrSfx2YBc+dEYC7bM=;
	b=JIzEK7DqCq83awuhQwTVlrBhz1oHBePyXQn41M4/j51p6S/Wd4bPHB+CDS+bNYDdWHggxm
	VqpANlmMkilv/fmbDLZldlDL4Zdxx1v1mtRiEQT6Z5VtzGkJMLpxUZwwCIUdbFArWmZoZR
	ylXkXvsBCXd5vQL6ITt76blkJoNkXSnK/bcoTyv6ar2LY6HmV3GWtnSiXikr/9+727kfQe
	pBerbABxKVYWEeVTmSeY9RKSlJj2nZN8zq6jKo+7v86MQ19B96gHRw5MHqng5pE22mC8m6
	MUGtuaf1aL9VMtK4nHpg1C0s7Eq8Yl4n5dZoOia4O8jXyVmXNveVpEjkoG/e9A==
ARC-Authentication-Results: i=1;
	rspamd-587694846-t85ng;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=johansen@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Thread-Snatch: 3d5a9e1f13012ce2_1723756649898_3258734874
X-MC-Loop-Signature: 1723756649898:3609826451
X-MC-Ingress-Time: 1723756649898
Received: from pdx1-sub0-mail-a258.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.101.250.139 (trex/7.0.2);
	Thu, 15 Aug 2024 21:17:29 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a258.dreamhost.com (Postfix) with ESMTPSA id 4WlHyK35VwzYv
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 14:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723756649;
	bh=ONJXDFMJbMD3oLnJMrIEFCbjfNXrSfx2YBc+dEYC7bM=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=MwOsakGsMmWhxb6mJdJE1vGK1VyAxnyMpD6CFAGwrdT4T/4jVMfb9UJEZSl/kLQH0
	 dBp9KHY+47QFyRp0k7aS4UwPox26GFxbcPKqlkDxp2YVmNwe2sOnfsOnyNMrGYy9Ac
	 Fy4z9wbjm2V2Ym9L2csFGG2Vu9Wc85uTaO2joa3twUami9zwPtqomkiCDGMeSuRXaT
	 N7AQ4Y3dcyT6KG8rlRGU7hhABeyg3MeWDtkuImTJQlsnb6iYUNRXZ/C3mGaicKhEJL
	 FKAPup8V+JE+sDgwGKWJHNuLmWV8iRZQQzkUHIYvdD8cdp2TGDias8cXGQTqqEfcfm
	 2TQDYesJCEurA==
Received: from johansen (uid 1000)
	(envelope-from johansen@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 14:17:28 -0700
Resent-From: Krister Johansen <johansen@templeofstupid.com>
Resent-Date: Thu, 15 Aug 2024 14:17:28 -0700
Resent-Message-ID: <20240815211728.GA1957@templeofstupid.com>
Resent-To: linux-xfs@vger.kernel.org
Date: Thu, 15 Aug 2024 12:32:45 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 2/5] xfs: move calculation in xfs_alloc_min_freelist to its
 own function
Message-ID: <7e4310e32168cc4aa9f3a0782a6f6fabcaf476d5.1723688622.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
 <cover.1723688622.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723688622.git.kjlx@templeofstupid.com>

This splits xfs_alloc_min_freelist into two pieces.  The piece that
remains in the function determines the appropriate level to pass to the
calculation function.  The calcution is extracted into its own inline
function so that it can be used in multiple locations in xfs_alloc.

No functional change.  A subsequent patch will leverage this split.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 75 +++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 59326f84f6a5..17e029bb1b6d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -79,6 +79,46 @@ xfs_prealloc_blocks(
 	return XFS_IBT_BLOCK(mp) + 1;
 }
 
+static inline unsigned int
+xfs_alloc_min_freelist_calc(
+	const unsigned int bno_level,
+	const unsigned int cnt_level,
+	const unsigned int rmap_level)
+{
+	unsigned int		min_free;
+
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (full height split reservation) + (AGFL refill split height)
+	 * = (current height + 1) + (current height - 1)
+	 * = (new height) + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (current height - 1)
+	 * = 2 * (new height - 1)
+	 * = 2 * new height - 2
+	 */
+
+	/* space needed by-bno freespace btree */
+	min_free = bno_level * 2 - 2;
+	/* space needed by-size freespace btree */
+	min_free += cnt_level * 2 - 2;
+	/* space needed reverse mapping used space btree */
+	if (rmap_level)
+		min_free += rmap_level * 2 - 2;
+
+	return min_free;
+}
+
 /*
  * The number of blocks per AG that we withhold from xfs_dec_fdblocks to
  * guarantee that we can refill the AGFL prior to allocating space in a nearly
@@ -152,7 +192,6 @@ xfs_alloc_ag_max_usable(
 	return mp->m_sb.sb_agblocks - blocks;
 }
 
-
 static int
 xfs_alloc_lookup(
 	struct xfs_btree_cur	*cur,
@@ -2449,39 +2488,13 @@ xfs_alloc_min_freelist(
 	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
 	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
 	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
-	unsigned int		min_free;
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
-	/*
-	 * For a btree shorter than the maximum height, the worst case is that
-	 * every level gets split and a new level is added, then while inserting
-	 * another entry to refill the AGFL, every level under the old root gets
-	 * split again. This is:
-	 *
-	 *   (full height split reservation) + (AGFL refill split height)
-	 * = (current height + 1) + (current height - 1)
-	 * = (new height) + (new height - 2)
-	 * = 2 * new height - 2
-	 *
-	 * For a btree of maximum height, the worst case is that every level
-	 * under the root gets split, then while inserting another entry to
-	 * refill the AGFL, every level under the root gets split again. This is
-	 * also:
-	 *
-	 *   2 * (current height - 1)
-	 * = 2 * (new height - 1)
-	 * = 2 * new height - 2
-	 */
-
-	/* space needed by-bno freespace btree */
-	min_free = min(bno_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
-	/* space needed by-size freespace btree */
-	min_free += min(cnt_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
-	/* space needed reverse mapping used space btree */
-	if (xfs_has_rmapbt(mp))
-		min_free += min(rmap_level + 1, mp->m_rmap_maxlevels) * 2 - 2;
-	return min_free;
+	return xfs_alloc_min_freelist_calc(
+	    min(bno_level + 1, mp->m_alloc_maxlevels),
+	    min(cnt_level + 1, mp->m_alloc_maxlevels),
+	    xfs_has_rmapbt(mp) ? min(rmap_level + 1, mp->m_rmap_maxlevels) : 0);
 }
 
 /*
-- 
2.25.1

