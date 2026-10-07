Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD3437DE9D
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386730; cv=none; b=dlBFE7FA/gRfveI0s3DYZm7F9Jt8g6MYHGMOLVrULAe14DGDYpCnAXPcpHYkJjAon/GD+/u8r8Dhm4mGGwO93XaZZjYTfaMsTfPm9i5QA4zjTs/Fbs73nvGToBs5n398UV2P+24+QhhWuq2ecjuZKgZx3zUNyQPffIEjEnwwiQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386730; c=relaxed/simple;
	bh=eM/Vxb9NYR+VzpftIQBXTVcb5Gb3/9Qwt9iwlxKUFgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSXZ+FcOgYd/v2ciA5qFbwVpwvx64bGEA+AaXMUKOtl67F73mERWF2T7qFfbdTdUEiVJLfMSWysMA5eT01lgm1OwO14LTekSqfZStTHRkJNvZhhVtL4newKpvUpfv6/mj3vdn5fbWWXgXGr2T9IjwHFoJlWpc2gDKC/ig3XxUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=s6SY6FVY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wVMeAh6T; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="s6SY6FVY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wVMeAh6T"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 2C7401D000FB
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 11:25:23 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 07 Oct 2026 11:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791386722;
	 x=1791473122; bh=DgG4Yoa6q7udcHuM6nvCE3b3mG9k5KacLG4fJjCCqJU=; b=
	s6SY6FVYei/TClwWZ9/HyY25s0te3pSV88oIeGsxeRjZ6WpFYEJvEs4GYG7EpL2t
	3vl/bPCQ7N06jRucm0tIl+v9x6MFkqRuCymEEYeaO7B4EGHgOGZhZLzKb2pyQEB5
	GXTWvscEgvqTCfwMP+Z7cxHNi8YKqZNnPl1G8aJm87qbLGd87i6gqejOxYUmSHHS
	bmBCecoPNKwOQae6MWQ3rSIALVcNYFGStEmmQz8jTV05zUevvWLt2zlo0fdP30TT
	/jzoOXRQ+W0xrV7/2S4zVE40KXaemE7vmMpXWrKlyt5bIJYCY423w7PpmUnPYjpG
	jyAkCOPhLD/qpxloJ90J2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791386722; x=
	1791473122; bh=DgG4Yoa6q7udcHuM6nvCE3b3mG9k5KacLG4fJjCCqJU=; b=w
	VMeAh6TSBt7KfuWqJE7Fny6tbi+jT4G4NqtBAcgZRHDhcvWCtuYHEOl7yBYqhWUq
	J5tS4GAHg1lQmTOkbxrPQPY6qtNNuJmeqVyyimmieyOR1MSuqJKQO58cS1p2ayIF
	KMs4XwgVJUWszXgsq/95Zooo3QuKuUbJJVvVIEa+Mtso+GnYP6drNY9SR44n9bpW
	KjWWhTVoZiBBUUUoo3/nz8r90DrbTKt2qaomipuwUGjHdNJYJxyTEEB/Jz/yFjvi
	kpU9KokEbjbhu+BzuIl7jsXIQc5AL1iQV3g2Oh47JTbmspid9pv76I1NinS3Q+ru
	Z1CitF1xx5IHffq8xV5wQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791386722; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:Os5n+pFCTAqyOwyKdoUO9ASsJD9rNZk0TgO5dfZGmb/SLXr
	n4MynZo6YUWDWA2fDii4QBEHt8/0H02BcteXxWhEb3DsDIMCbcA+XE3MxlRkLl0E
	emMHmrRlsr2LPoW/ppE74NrKGkj92w7AX/p5BfM4UfrT/iw+H/HcPvD9nOcP9/2C
	x7/waHGIwigkxKvj5hIIGfbHju8TzgtvPu6plu2RkNWmoIpyc7c0KZvUKjspISa6
	rOtNuq3G83oNAlaLpiQ5thA+nPLHmZLexmkGONqXlQOlKks6mOLg8TunLobPz8oF
	0uWrv8gkuawKAUJdvAL1dqfu4ZEhz7CEzVw5R3Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:Xg8Dx5unh+I8QDAaID5bZ6ST0BKv1nSUNPxuFn/pGb0=:eM/Vxb9NYR+VzpftIQBXTVcb5Gb3/9Qwt9iwlxKUFgA=;
X-ME-Sender: <xms:YmTGahZ8NcKTKWpIO1BkGdGB3bm6vjZuI7OAHJWKM9nPlngAPcj2jQ>
    <xme:YmTGavR_tlGeYFlLxahygEwtydxhpOHB5httdSVPCdsmt3iF1CgdGtyQROK3VXjBc
    -cOkshus5L8wo308z5KXKmRmNM70l5MVMqqDBZOUxiNtud-WC6L6Pr5>
X-ME-Received: <xmr:YmTGasRFrPGKZVNPjdSGdQDQKqs0d-0FN_Sfs_a6EdMwjORzLedGwM3EolEtdkY3AoTGEwNzQQBy-wK1HsAUGsjPedCYCg>
X-ME-Proxy-Cause: dmFkZTEJE7XN6fSVuFLtUhzzGIQyRaKFeDK7hhtV3k5v8Of8JKG/hiEGHO4x2uvr6PQm0y
    TjJTwOeBhqs4Pb/jxK7SL7YJV69aOJqlw6flwjNCOO+rdi+zWWdKzE4DiC5RjNQ3IiT6qh
    tlO8B1UpEMw/YwF7wmR5u/gv9+Z4CxbrhNw412BR/vupxHB9aBuTCeQ0V1p3SEZkxdNCAe
    7Y2pFUQ2SuW7COwzB14O/LznrWpEzGmPbZi/NkqHZQM9aYxh5ViW3X/7NMlbgh1aEUQlRB
    MJUoanFRSFtKjeJM1tEbvs78EEfj3zeyHVatgLyiUvx5EBasMQFOEX57+F0L6EZxn5AaaD
    dCGLjuqCN54rEB6pnRq30/WUegUKJB/UEmhrnIsnkYKuj/sxOftIQsOvM3ZtMyyXjhh0pf
    g6GLHswDMYU254XDDDju6oT2QI1FpW48ijkmJbPtSWnXeOJdHzeDKqcYs+KLXPAslXZgZU
    HZ0QdmaaF+5uSRQWVE3B5HQe5O7DL/J27CFzEU4avEf9o6T6hnGGV5bhd81S/0/gaAFaPI
    JBef14cieiraK1df/xP7YjxzEgpj0GBBcoICuZ8kYKYLOJUr9DF1U1nUcLl6h0BBv9qelh
    ZExgTsK57DWGsMuMMVzKT+SmVYC0rqpQgQ6vjlF/+9efH911Lk+nXFwfxMIA
X-ME-Proxy: <xmx:YmTGarT2WHsVdUPmkcY4IAFVzhtkYq8sIvKcon5XW6vO_VJp6u5JfA>
    <xmx:YmTGap5_jC3gae_d_TLwGkFM8YHAPSAv_40SvGKAcm5t56TWXXLcvw>
    <xmx:YmTGav2jHk00bUCzqnMRwmzTUNlpad6kznvZuSQhPFaRaOwL6-ToGw>
    <xmx:YmTGasBo1kYRUHgUe7J_GVBkIrCOm61B52jB_uivSXpZUZcxjhaoFg>
    <xmx:YmTGanWNa-tB8pl9IYtKhsL2y2Zjl1E0XACj5aviHEzDDA6dQhFAbN4f>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Oct 2026 11:25:21 -0400 (EDT)
Message-ID: <9c5ce463-c28e-4b71-ae32-7d42abcb87f8@sandeen.net>
Date: Wed, 7 Oct 2026 10:25:21 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V3 2/3] xfs: factor out xrep_reset_fork_to_extents helper for
 scrub/repair
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org, Christoph Hellwig <hch@infradead.org>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The open-coded 8-line series of steps to reset a fork to empty extents
format is repeated 3 times; factor this out into a helper to eliminate
cut and paste.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

V3: Ok, ok, fine - it's a switch now. Merge whatever you feel is best. :)
    This V3 change is compile-tested only.

 fs/xfs/scrub/attr_repair.c    | 17 ++---------------
 fs/xfs/scrub/dir_repair.c     | 16 ++--------------
 fs/xfs/scrub/repair.c         | 31 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h         |  1 +
 fs/xfs/scrub/symlink_repair.c | 16 ++--------------
 5 files changed, 38 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 387ad909e20b..46e6b2fe109a 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1319,21 +1319,8 @@ xrep_xattr_swap_prep(
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
index 956aa75218aa..dd00d4ed8c17 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -882,6 +882,37 @@ xrep_ino_ensure_extent_count(
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
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		ilog_flags |= XFS_ILOG_DDATA;
+		break;
+	case XFS_ATTR_FORK:
+		ilog_flags |= XFS_ILOG_ADATA;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
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

