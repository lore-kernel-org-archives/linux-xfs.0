Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD98331D730
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 19:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227501; cv=none; b=MKMUBqawdy2aMxTb+38AhPCft+Rdx8jsYk5sAk7O1j+mqW7p8q0Vl6BVbt7dJNjTKqyGisLrTBAh1u8Z5tYsj9st/6oYhVbH3zzsgS9N5te7D+/F4ocdAV0IcJARhe3e55uQKcaSfdKQAYbOILgKPLxL9ON8HaMVe/PWbDJeMSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227501; c=relaxed/simple;
	bh=O70LDoVM3ThRy2luaiFaXXtNoXUrGsEQup8CEJeKVMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZP9gTAmwFLgkUg3WvOnGPrB/FcWOWMQVfoIBXtoS7xOjJky0O0QZwQLC5oO2I4A5utL33UnPMEbSX3kHae2j7BmIJ/QyXw68D7CXapi0kzrwFsbIbVXZOdB2xJc2ZerFvGoVKe2hNIDZF44oQeMzpvJsJcAhe4thQhS7vTtC0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=V27KV7LA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=am7QdFF3; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="V27KV7LA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="am7QdFF3"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id E5F051D00046
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 15:11:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 05 Oct 2026 15:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791227498;
	 x=1791313898; bh=sHWzN3nkLjT/Oahg3RX06lFbyd4siTnyjlmGvVKzrPk=; b=
	V27KV7LA2AP6TYZdXNjjLlQTgqGkFgEszf5FToN9/o8QquHTx34nCXll19GOHxwL
	SdULMtselUKHaIVf+S6kWHYS2fydNhNQXF0WNL9+Gg7xummuzxG/smHSz5R+oZmb
	WFS9zD7GwwvxPEEqZJ0L7E2I2iGPh9mYcp4JDPWMqj0bbqJfw8B6AJQrvl82Wfbi
	+uk5niPvze9w9DxJ4OETupx9iYO1UBIPoWlCfV6xiGl79iuv8k0mQAjV4H8bsRgu
	zCB+hC3xIWORAAxLMg9FCxhFJeAgSYS1GadkQCxeAaa6qesi+XpVdl0201Y6ZgME
	+j2tTD6MHUSAfEbOJ+Musw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791227498; x=
	1791313898; bh=sHWzN3nkLjT/Oahg3RX06lFbyd4siTnyjlmGvVKzrPk=; b=a
	m7QdFF3Ep7s2PuUpIP1GQBbQawA4Tu2amulwLS0PX5jJS3gfVdOrI6BluEy3wRvS
	oLv0L/+wtDjMF7/Kfyu8SiXv17/RdMyjZS7G5pY8FJyYqmeo8NOLaRFfy8Jt5xgf
	A51ff8/kvUtbk+ZXTwa1ddlUoblz51CzXpLo4Kn+k5pa5SuhJhRBm2RxETNs5dPN
	LeJgtiUxVPJYD4VmxoMFUsTMv9dNgd+1T668YVtj7o/qaESTtndoLsdXgMEZhd0O
	UCYFBBMOMGDJJfRuTcLBn9LF95JfhsxFjL1IpxFYTvTjFLTbeh29jUtfJ7X1ilCk
	+FFI7Vb8Br6fPW2CSu9rQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791227498; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:JvOi0BEf1XZLjI4CEiq/FGIydttSmaWLWhXbFoTPOiXnuzN
	wVyFK0ss23AMvXbVSuqpt4/zk4uIpDSOgnWIB/9B+6dUjyP3GmHmgXKEnmMqxzQr
	SHKm/x6hn70fKe6+toLmSsobx+K/yeSF+EPY5clYid3qt9j2YXXwpHm7q3f0TEW5
	DgCEGMRgi5r7Z6YwguQCzknN9iIitVlDzZT+PtckJpFfjeQomBIY0rs23huu2cVJ
	8ZvOgFDdksZcCTE0ofO95T+QsSIoWJmt8IXPei24oxPzpovyrGhhgvEfD0sI6+0s
	YIZ/BJ1VL3XKYopeX6yyKTzkBEv2+QluhGnGobA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:kkTeYTsrQvLl30LFoh83ltNHPOr47aN0L61kJN57N5Y=:O70LDoVM3ThRy2luaiFaXXtNoXUrGsEQup8CEJeKVMA=;
X-ME-Sender: <xms:avbDavOdHptZwSQ3WewuwXHb0iM3s9zJPdycNd1n_qv8wN4q6qcrgg>
    <xme:avbDag9TJEeLftddNNfWHQxfhBCjHVu0nYXKjsvqbNjyS0IQjMKnFlv1OLQdJlDuh
    35_4Mqvqb2HORAcTkkqN1dulODCL94QB6gvHSCUQLL9ZwOlwbEwRHki>
X-ME-Received: <xmr:avbDajTl1O7u1SeYjrVZargF-kXkDn7T3d5l_CEnRUeyiq2TnueWV6r3641FlFG7PE56aMGKuK5PIA08ENoPnTcd2S5H4g>
X-ME-Proxy-Cause: dmFkZTGxQPquClLCSsivTVRpGQvCes9B98S52qW11NCVD5sRTThGnyahCXp/kl2Le0SETm
    1zGI1I+mYWuEtbpCoY7xVJULjRH5/IlFZeeZSMG1a22aWHIPp6qxreQwC/sE9rZEdDGOoc
    7dohTuoJvyTNohTPFGVVA2PwAtQnc4TGZfywRGC05MV7GA4HvN5yyMYfb+CYKP9oVDznJe
    lwyzM84fQad6CjYEwGgDmuSwmMktixHQVNvGSyjCz1cWyWWyWggfXaxP1WUrhGzp3NcuWf
    NMDuQNWRveHhUXIKGTQ+H8PiT0Pwy/j5HASBuprZLckdBscm+ONcL12AkcBj4/WCPFUorT
    Y5hETA2eUg5Ov42WqUP6iV81HwMzD9F4MSO9hJS89TyR8/SxqdYuVsi86jgAcXtWBfaMGq
    IjY4TXRLPCSkYhYR/SAZWhfJomy7B2+gdqOtp+hyrtODZeKMF73Jf4vdgFP2Qv0N4gsY2G
    xt1e4nQNzujGc2Sj7UfjoSa3VqU8BmTrkxH0Bc8isW6H1cyGP+Fgemk2E+Y7YnZnG8qfpO
    j/L1phXFvIxKzr9Ffm1uG5nPraHaoumQytDYx+jzd5RP9gheHXlULjB00P8+JiRCTZMwN1
    lDLi/6L6bHYXwzUTi2/+HVJwwtmRONHphRq57kiDUqS5Lq7VAjT326Dp/ewg
X-ME-Proxy: <xmx:avbDaildojPRuu79tIR9D8S3bgRrqLWus9ji1HNDfiKZms3NOfCzgA>
    <xmx:avbDajS24fhtSgRFEvrDYbatr6A9FBwf2sXaOR1QBmQeYT5wq-lmOA>
    <xmx:avbDagOaUyA_ZaCTXsSiC775cZpjwduFO6Thp-i7nNxuivYXv71jTw>
    <xmx:avbDasVYpvwPakWb5yiImZUXCsfHAOw4BDLbSHx6gV4yRdL8cmiD9w>
    <xmx:avbDaviW_dyAyvZG9rl3PM6YCyz8CmwHOySJBdtRlgNahVC-fPuJuDm5>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Oct 2026 15:11:38 -0400 (EDT)
Message-ID: <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
Date: Mon, 5 Oct 2026 14:11:37 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V2 2/3] xfs: factor out xrep_reset_fork_to_extents helper for
 scrub/repair
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261002211038.2139655-3-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The open-coded ~10 line series of steps to reset a fork to empty extents
format is repeated 3 times; factor this out into a helper to eliminate
cut and paste.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Better? (nb: compile tested only)

 fs/xfs/scrub/attr_repair.c    | 17 ++---------------
 fs/xfs/scrub/dir_repair.c     | 16 ++--------------
 fs/xfs/scrub/repair.c         | 26 ++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h         |  1 +
 fs/xfs/scrub/symlink_repair.c | 16 ++--------------
 5 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 28f92e9ba72b..25bf4e49d56c 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1316,21 +1316,8 @@ xrep_xattr_swap_prep(
 	 * that to an empty extent list in preparation for the atomic mapping
 	 * exchange.
 	 */
-	if (ip_local) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
-
-		xfs_idestroy_fork(ifp);
-		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
-		ifp->if_nextents = 0;
-		ifp->if_bytes = 0;
-		ifp->if_data = NULL;
-		ifp->if_height = 0;
-
-		xfs_trans_log_inode(sc->tp, sc->ip,
-				XFS_ILOG_CORE | XFS_ILOG_ADATA);
-	}
+	if (ip_local)
+		xrep_reset_fork_to_extents(sc, XFS_ATTR_FORK);
 
 	return 0;
 }
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2cfcf1c35679..5db1ec324409 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1510,20 +1510,8 @@ xrep_dir_swap_prep(
 	 * to an empty extent list in preparation for the atomic mapping
 	 * exchange.
 	 */
-	if (ip_local) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
-		xfs_idestroy_fork(ifp);
-		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
-		ifp->if_nextents = 0;
-		ifp->if_bytes = 0;
-		ifp->if_data = NULL;
-		ifp->if_height = 0;
-
-		xfs_trans_log_inode(sc->tp, sc->ip,
-				XFS_ILOG_CORE | XFS_ILOG_DDATA);
-	}
+	if (ip_local)
+		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
 
 	return 0;
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c2a437416227..8385308c852f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -882,6 +882,32 @@ xrep_ino_ensure_extent_count(
 	return 0;
 }
 
+/* Discard the contents of this fork and initialize as empty extent-format. */
+void
+xrep_reset_fork_to_extents(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
+	uint			ilog_flags = XFS_ILOG_CORE;
+
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	if (whichfork == XFS_DATA_FORK)
+		ilog_flags |= XFS_ILOG_DDATA;
+	else
+		ilog_flags |= XFS_ILOG_ADATA;
+
+	xfs_idestroy_fork(ifp);
+	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+	ifp->if_nextents = 0;
+	ifp->if_bytes = 0;
+	ifp->if_data = NULL;
+	ifp->if_height = 0;
+
+	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
+}
+
 /*
  * Initialize all the btree cursors for an AG repair except for the btree that
  * we're rebuilding.
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 2bb125c4f9bf..c1ba462e4426 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -81,6 +81,7 @@ int xrep_setup_xfbtree(struct xfs_scrub *sc, const char *descr);
 int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
+void xrep_reset_fork_to_extents(struct xfs_scrub *sc, int whichfork);
 int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 181961364233..9f6901905bfd 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -303,20 +303,8 @@ xrep_symlink_swap_prep(
 	 * to an empty extent list in preparation for the atomic mapping
 	 * exchange.
 	 */
-	if (ip_local) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
-		xfs_idestroy_fork(ifp);
-		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
-		ifp->if_nextents = 0;
-		ifp->if_bytes = 0;
-		ifp->if_data = NULL;
-		ifp->if_height = 0;
-
-		xfs_trans_log_inode(sc->tp, sc->ip,
-				XFS_ILOG_CORE | XFS_ILOG_DDATA);
-	}
+	if (ip_local)
+		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
 
 	return 0;
 }
-- 
2.55.0

