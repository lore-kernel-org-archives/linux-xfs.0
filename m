Received: from bumble.birch.relay.mailchannels.net (bumble.birch.relay.mailchannels.net [23.83.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD24770E8
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751374; cv=pass; b=fr5lj1DkW/WC923N3MPtFQHP083dgEcbssRvidL+KjwMgBn88RXxDOtnjE+v3sVAv/EDjvMMPnxCWOy8dl8+8D547uewZM0fBR9wITaAvhjgxgTo+aLjsV17pGwRuipH2BgtR0HjifqSR1eebvaMA2at5IshA6+kO+vg+lixs50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751374; c=relaxed/simple;
	bh=5LmSysuK5yLZB0f0RQUaLLKvwe376pvZ2JeRv9QcNfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lULsCZw2JiYM8CneQdkHdPwkfLwC3qJpslGIP1FEZ8A4EmYhbBI9BGuiSjie8Xec4oc7RVd0hrrIybbv+hhw1gQ+w6APBw9cUImsxP/89IWt4cL8kvwgSZ4Ci4ENWvw4m1D9JgsVgJ1IrI1zJzCMQYnPCKagT26BxeyeIrz1/PM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=QrL4QAMG; arc=pass smtp.client-ip=23.83.209.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="QrL4QAMG"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 30F72503BE5
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:31:52 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id DA8145053CD
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:31:51 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750311; a=rsa-sha256;
	cv=none;
	b=N+5NsY9ifKvSEVxmtb9w/98f4fglw+z2kMpbNWSWxXmHruk6sqdBHF5P7M4TvRm5O828De
	jkJLpIgFSxHk9So5xB1VPixrlkqUuDF5wJ9MUKkLgPFUgCHKdGN4ockr70Nsv4rg5t6dMf
	+uDULxcN5aeeDOagcuDXrN5p7NFJNu4IGAx551NHjSfKIC51hZSozz/DDP2QK7L9s83H3I
	RQokHXJjAqy/AGbxQ3BeHlGjEF+aeuvQNgDG3P2EmIsw1z22V5yb6RdrvH8TNdXCZIh0SD
	EIODuhlGTiz9ogGXo4S9GUuGdhL31F5cRZ/3N7JaEEo+EFMLTSWsjX10bePJrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiHOZpQ51dTUKfpN0a1BAL0ZPQ6v3YA3kaeuXRxm4ho=;
	b=LIlGppoe/skQsLWWqgrwILp/bXjUjLyHDITbEL1idQDlNWZTt0bt9WGoygNMqZcvUqwEPJ
	g+s9/wqymdoECb6o1jk/A/ymFiZHfLqdShCmt4lY5OVsEbKR+8SnIWlAOzFSeHuPsJPOem
	dgd7YDvkoLX7mt8FkHRPtXCHmNmzKAh4FBxdHK5hiLRXDxolYAL6Uzqmw1MmIqRIpuBXXj
	FZCTh0Vegv4sNBjkUTbMkNKAcd3PyduLObMypVxZIFGnmH3JFT0sTD/JWjY5hiGT8/uZ3I
	Y4bJ2HSi3geBVjmAdlbHcWPRSxfdA71re36C4UyoZ22QtkbFu+ymF5phaX766w==
ARC-Authentication-Results: i=1;
	rspamd-c4b59d8dc-pk989;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Society-Fumbling: 436463574e79823e_1723750312108_2462130268
X-MC-Loop-Signature: 1723750312107:1032874456
X-MC-Ingress-Time: 1723750312107
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.172.23 (trex/7.0.2);
	Thu, 15 Aug 2024 19:31:52 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFcR4vh8z1g
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750311;
	bh=MiHOZpQ51dTUKfpN0a1BAL0ZPQ6v3YA3kaeuXRxm4ho=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=QrL4QAMGr0HrnNFv6n/xesOqiMoHND6CxwTt2g94T2So/Y7S2kKtyhOdd0YZM9RtL
	 xqUyB2y50Ud3Vl0qejVhDgR4VYyr6maQWlG4vU2AQ9Wt/4aJ4XBpi72tqOUbS9R4/F
	 khG/+7Fnf/rza9Gil7pNWo+t/H3e+HaGjQkoCKPRS+BzW/S1/12VY/y6R/p9KjESPZ
	 dEPXq7IadypwvHYT4qyVV1pXvxgWjkwvbgDTxsGSKJK3i/jXGsmJ5zsbc5OA7YftHg
	 AIR3GV8Z6jw082maJQz7a0ak1g/GrUx8vN/cTUB2JqQQ+KsoTBf/q2fi89+y3VFu40
	 +/eHGBfqxMdTg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:31:50 -0700
Date: Thu, 15 Aug 2024 12:31:50 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/5] xfs: count the number of blocks in a per-ag reservation
Message-ID: <aa97ca3662b008c5319f636f1520dfe680c20041.1723688622.git.kjlx@templeofstupid.com>
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

In order to get the AGFL reservation, alloc_set_aside, and ag_max_usable
calculations correct in the face of per-AG reservations, we need to
understand the number of blocks that a per-AG reservation can leave free
in a worst-case scenario.

Compute the number of blocks used for a per-ag reservation by using AG
0's reservation.  Other code already assumes AG 0's reservation is as
large or larger than the other AG's.  Subsequent patches will used the
block count to construct a more accurate set of parameters.

The reservation is counted after log_mount_finish because reservations
are temporarily enabled for this operation.  An updated alloc_set_aside
and ag_max_usable need to be computed before enabling reservations at
the end of a RW mount.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/xfs_fsops.c | 21 +++++++++++++++++++++
 fs/xfs/xfs_fsops.h |  1 +
 fs/xfs/xfs_mount.c |  7 +++++++
 fs/xfs/xfs_mount.h |  7 +++++++
 4 files changed, 36 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c211ea2b63c4..fefc20df8a2e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -551,6 +551,27 @@ xfs_fs_reserve_ag_blocks(
 	return error;
 }
 
+/*
+ * Count the number of reserved blocks that an AG has requested.
+ */
+uint
+xfs_fs_count_reserved_ag_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+
+	struct xfs_perag	*pag;
+	uint			blocks = 0;
+
+	pag = xfs_perag_grab(mp, agno);
+	if (!pag)
+		return blocks;
+
+	blocks = pag->pag_meta_resv.ar_asked + pag->pag_rmapbt_resv.ar_asked;
+	xfs_perag_rele(pag);
+	return blocks;
+}
+
 /*
  * Free space reserved for per-AG metadata.
  */
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 3e2f73bcf831..75f5fa1a38f4 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -12,6 +12,7 @@ int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
 int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
 
 int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
+uint xfs_fs_count_reserved_ag_blocks(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 09eef1721ef4..d6ba67a29e3a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -952,6 +952,13 @@ xfs_mountfs(
 		xfs_warn(mp,
 	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
 	error = xfs_log_mount_finish(mp);
+	/*
+	 * Before disabling the temporary per-ag reservation, count up the
+	 * reserved blocks in AG 0.  This will be used to determine how to
+	 * re-size the AGFL reserve and alloc_set_aside prior to enabling
+	 * reservations if the mount is RW.
+	 */
+	mp->m_ag_resblk_count = xfs_fs_count_reserved_ag_blocks(mp, 0);
 	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d0567dfbc036..800788043ca6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -213,6 +213,13 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
+
+	/*
+	 * Number of per-ag resv blocks for a single AG. Derived from AG 0
+	 * under the assumption no per-AG reservations will be larger than that
+	 * one.
+	 */
+	uint			m_ag_resblk_count;
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct dentry		*m_debugfs;	/* debugfs parent */
 	struct xfs_kobj		m_kobj;
-- 
2.25.1

