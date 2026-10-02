Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E736143B3C4
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 21:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975449; cv=none; b=owyl0o+ly+8SBH3S8+p/H7AGP8xfVSMHN0j3a7HA5/2mjAuTLk0CKx7rJliit3rXM5tTfkl1u9ztiXu01URXR3oJndvux6K0qIn0BpmdJraahCN0Xlmoe5g2TRUJ2unXbk8JNnZarnCPHVFo4NuJlygbAYpgi/X+LGaE7qHMVEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975449; c=relaxed/simple;
	bh=rN5pMzfYWa+UPrQzBjxnnTaegGgwC+x+wOlS390U7hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b++JbUtMP+VMvs1wRKlOtashv/D7l/EAZdKs0zUSc3lSZmJV1LhB7TyBVvIJz9FThVa3icBtxJD6JQMD8EtdRJGDgDEqELOfZcARO1+ht09QEFnq2vVxttMU4OidaIA/jePWGf0Fn7gWyb+rfYqae2P84fi88U8TeR+bX/Tm3ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=go1e63pH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sV8DIsFb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="go1e63pH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sV8DIsFb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790975445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fr4tRYyv/XJFxbaE4OAW37rKNlxgtlmoy3fM852xkcI=;
	b=go1e63pHwd0SgwyQeiXzzsYqdxS0K3PQj1vkd8kwffo0BZ18JfyKfTm3tbABMj37Nq6QZ7
	4nyYlGOpkpms0PfoCf4X2mYYAqhOZtibmYk9R6pl/uGlz11ILyebVUSRvybDovl1HJsorW
	kxfV7NIY/Oj2bU0k+fJCWCLPOPrh25c=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-ZAKh0Vm9NIWf_PChKtZs9w-1; Fri, 02 Oct 2026 17:10:44 -0400
X-MC-Unique: ZAKh0Vm9NIWf_PChKtZs9w-1
X-Mimecast-MFC-AGG-ID: ZAKh0Vm9NIWf_PChKtZs9w_1790975443
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-822121639b4so517978a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2026 14:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790975443; x=1791580243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fr4tRYyv/XJFxbaE4OAW37rKNlxgtlmoy3fM852xkcI=;
        b=sV8DIsFbXjQWqNFv0cXZKEfnqjlbrpYMdks662mDIKSTpFeKnLWlHwz3V9paLjlK5m
         bsOI9mdk0/gn4I7UktN426ShhX2i1EvpK8vCfRGtZRFWyI2p5Lhz9utuDK1zfEZlqaOK
         TVSPbUxREF1pclyPj/i34qx+cMUhIi2GF2aIgZ1pE4YiRS/zMszKu4bgMfSTpQwKO3a4
         pRXPWEgtPAPBM+5hpnQ60W9eyzwwugMacC57mDwOklcNX8BW4lauDouoj5ko/pZdsrTL
         FWgGCk0JPEFrJgal2OaBve+iq/KB9n686riqATbhjOVcmXVJ6i0vBudnk3WscMXj8RgD
         s49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790975443; x=1791580243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fr4tRYyv/XJFxbaE4OAW37rKNlxgtlmoy3fM852xkcI=;
        b=pdY0QowTjchWFlu9SWmPeQzTkBRYRzs27g4eBcM9hw/TGwpAedqI7+s42XIENYnr54
         NDUg1/1mA13kgik9nh7ty77esysjimus5Jay9jQPf1VfdwIfZmKF5isYbvETO63JBI2A
         WibqIGqkXIu/TB+soGUCFRSj1eSKW0E3x+yePYB42y27Wa8h3+okKgTCUer9ilZeM8ZA
         VBbaDNYm281o3vMEfJs34Jc1jw4VnUtgMrvFIK+xxuFyu70KFVIIDpRlRagSyB7hvawl
         /I0H1KlugzrWBEcf9vL1yVzl7I12c2vYn0kUBjiG1QWIODdXkO9mHQYDRQAVPSyWRH4b
         Oomw==
X-Gm-Message-State: AFuF++n6vHkSRnfs3LKhDm+POjBIyr3LDZEFbUSbJL/HYBOwRvoSqFLJ
	bS2AUOkyJvj1rqFs9C86pFJ7+H9DluWInP7+TWUVCKeDv2SdZ1GKWe0eC1clpOozF10XqNI4lsN
	HC5tb5b8IZW+LFbPkNg67+enGKrnq33W5szBIfq4aCLo30OEMl70MFsUNLNdEzm67vcUvOXjjFa
	hApYLeSasavvGIAaD6gfYkxQ0RUaytB1VzpusKcJZCmx9qxOY=
X-Gm-Gg: AYBFou2SnvmGOkVJ6y5tEF+AKuevCz27tdTLGXVQuxFKgOYIMlccXiXx9Di6O2qglif
	qHSAgDPOQZIEnFo5KETaf0vG9Udmez7df8Bl73b50GBkOaB6rA7wMaO9msybeCxf0eQMOr18xes
	tV/L4A5gHWNBY6TjGUgDqk81+Z9yMj3CjKBT7jwRFgaKFImMlcFCE1EFgQkRVte5zKVfndaYdBF
	D64xcY+twO47Yx3dT5x12YOJtCNuPJM14yGE3j/Sfn6INGbok8YcL3lqViKubFuY74JpxNbI+i+
	HUVrdb0NJWAfGWYPD9dlKr0PRRJOXe7fDgfxODJJfDY+BpZ3VtcvPexp0MQ8a3Yw/pIK1o1aa8a
	uWLCISxchvyhlktehllitaEpTumdpSIT8ZULu3Q==
X-Received: by 2002:a05:6830:6c0c:b0:81b:ac9a:5681 with SMTP id 46e09a7af769-82283677064mr3966665a34.29.1790975443404;
        Fri, 02 Oct 2026 14:10:43 -0700 (PDT)
X-Received: by 2002:a05:6830:6c0c:b0:81b:ac9a:5681 with SMTP id 46e09a7af769-82283677064mr3966645a34.29.1790975442885;
        Fri, 02 Oct 2026 14:10:42 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227aa72075sm4456044a34.27.2026.10.02.14.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 14:10:42 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] xfs: factor out xrep_reset_fork_to_extents helper for scrub/repair
Date: Fri,  2 Oct 2026 16:08:10 -0500
Message-ID: <20261002211038.2139655-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002211038.2139655-1-sandeen@redhat.com>
References: <20261002211038.2139655-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The open-coded 8-line series of steps to reset a fork to empty extents
format is repeated 3 times; factor this out into a helper to eliminate
cut and paste.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/attr_repair.c    | 12 +-----------
 fs/xfs/scrub/dir_repair.c     | 11 +----------
 fs/xfs/scrub/repair.c         | 16 ++++++++++++++++
 fs/xfs/scrub/repair.h         |  1 +
 fs/xfs/scrub/symlink_repair.c | 11 +----------
 5 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 28f92e9ba72b..08afb522cd5e 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1317,17 +1317,7 @@ xrep_xattr_swap_prep(
 	 * exchange.
 	 */
 	if (ip_local) {
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
+		xrep_reset_fork_to_extents(sc, XFS_ATTR_FORK);
 		xfs_trans_log_inode(sc->tp, sc->ip,
 				XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2cfcf1c35679..2d04c5ae63a7 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1511,16 +1511,7 @@ xrep_dir_swap_prep(
 	 * exchange.
 	 */
 	if (ip_local) {
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
+		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
 		xfs_trans_log_inode(sc->tp, sc->ip,
 				XFS_ILOG_CORE | XFS_ILOG_DDATA);
 	}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c2a437416227..20b82c7e72b8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -882,6 +882,22 @@ xrep_ino_ensure_extent_count(
 	return 0;
 }
 
+/* Discard the contents of this fork and initialize as empty extent-format. */
+void
+xrep_reset_fork_to_extents(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
+
+	xfs_idestroy_fork(ifp);
+	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+	ifp->if_nextents = 0;
+	ifp->if_bytes = 0;
+	ifp->if_data = NULL;
+	ifp->if_height = 0;
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
index 181961364233..5f5bc5211600 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -304,16 +304,7 @@ xrep_symlink_swap_prep(
 	 * exchange.
 	 */
 	if (ip_local) {
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
+		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
 		xfs_trans_log_inode(sc->tp, sc->ip,
 				XFS_ILOG_CORE | XFS_ILOG_DDATA);
 	}
-- 
2.55.0

