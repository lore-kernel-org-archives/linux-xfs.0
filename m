Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553F3FFFAD
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946683; cv=none; b=EDq9UlBkDnnGHehQCMya+U3KUPQwUMK2XaBv8sDMi6P7k6ihn1MrdH2ZWsoIZg1RzgWQ5A2DtyVXLCFYXNs6MLJbBZMpQdcV/U9F3c24nn1nh5gDMtq9weXFxRkEaTnFP9Uwt07qolYkfZsbblM0Cr0qrEtOIEzGJw1zfXa7qGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946683; c=relaxed/simple;
	bh=oL6Xh36bcHS8hRS0MNt1DF4Yb+GbSCjSsFe418vMIC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwSi6Pw1QwYJCro8WQoQgA6t0hKZVUvgfsc7gy4FGRpZsNFGN25vNVBvpPFS5lqku0Y9hFobsOfK5slg/2gjvWwvJAU6QaDtzaxwpP4GILhGMb4DQb47dN4ygEDpnjEmi/XoSiPcFt7aa5pRjMpU2mj/xhK36BeA6upj2xPWtq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hP9eoLQ2; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hP9eoLQ2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783946682; x=1815482682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oL6Xh36bcHS8hRS0MNt1DF4Yb+GbSCjSsFe418vMIC0=;
  b=hP9eoLQ2IWD48DQhf/AXpypVJuQZUKTr2yV3Ps1Op1H/4yEnErrNRLfM
   CryJq5CUwPcARbHwi1bLQ/29QHBFY3075tPFqTuGvdvI4XQL9BiQw0hp7
   pUKkreRA3cKBOxARFlO0KYfEmdO1QmAqgTJMTk7Ge9EJGNre+uiuW14Ie
   svpPuFh9gFEvFmh4sitL4nfpWNs5S/cgaX/v4nk9DE3C4dq5zxMA759Cz
   GRYq8KBWbKp7BYEqvdirKeWoMd7uknCa44MGiyUV1ieoFk5117wj+23XG
   j+avOC9S6Avq7SSsfxlI5QdukTc60PY25idZu2RayyZknRa6YxANRvlJl
   g==;
X-CSE-ConnectionGUID: 4gvKQuF9RCqXZkW0ISuzng==
X-CSE-MsgGUID: m9PbzZP5Q++5zh8eHTILxQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149971528"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2026 20:43:30 +0800
X-CSE-ConnectionGUID: jATVsE8fRNSoCyg0ImeGFQ==
X-CSE-MsgGUID: LS6knHNrQRK8KvQhc01qmA==
IronPort-SDR: 6a54dd5f_3x5IrKIw0SAwoly25Dp4N7GFy5/3bRgz69HDyM80XqpdfHZ
 BNHI2dqEtAkhhY8I0NHzPX+AhdHOMDUnFgStEGg==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 05:43:11 -0700
X-CSE-ConnectionGUID: eSeAZitXQoysDbk6gxLN1w==
X-CSE-MsgGUID: 6iEeDGemTBykNhtlKYtPqQ==
WDCIronportException: Internal
Received: from wdap-mdygpqeptg.ad.shared (HELO C02G55F6ML85.wdc.com) ([10.224.19.14])
  by uls-op-esai2-o.wdc.com with ESMTP; 13 Jul 2026 05:43:11 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 4/4] xfs: mark internal metadir file creation helpers static
Date: Mon, 13 Jul 2026 14:42:50 +0200
Message-ID: <20260713124250.3978-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there is xfs_metadir_create_file() mark
xfs_metadir_start_create(), xfs_metadir_create() and xfs_metadir_cancel()
as static and remove them from xfs_metadir.h.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/xfs/libxfs/xfs_metadir.c | 6 +++---
 fs/xfs/libxfs/xfs_metadir.h | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 0d6a153bc9e9..7c6b086b73db 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -182,7 +182,7 @@ xfs_metadir_teardown(
  * Begin the process of creating a metadata file by allocating transactions
  * and taking whatever resources we're going to need.
  */
-int
+static int
 xfs_metadir_start_create(
 	struct xfs_metadir_update	*upd)
 {
@@ -236,7 +236,7 @@ xfs_metadir_start_create(
  * a negative error code.  If an inode is passed back, the caller must finish
  * setting up the inode before releasing it.
  */
-int
+static int
 xfs_metadir_create(
 	struct xfs_metadir_update	*upd,
 	umode_t				mode)
@@ -425,7 +425,7 @@ xfs_metadir_commit(
 }
 
 /* Cancel a metadir update and unlock/drop all resources. */
-void
+static void
 xfs_metadir_cancel(
 	struct xfs_metadir_update	*upd,
 	int				error)
diff --git a/fs/xfs/libxfs/xfs_metadir.h b/fs/xfs/libxfs/xfs_metadir.h
index a795a2d0e3fe..e434b9d1c932 100644
--- a/fs/xfs/libxfs/xfs_metadir.h
+++ b/fs/xfs/libxfs/xfs_metadir.h
@@ -32,9 +32,6 @@ int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
 		const char *path, enum xfs_metafile_type metafile_type,
 		struct xfs_inode **ipp);
 
-int xfs_metadir_start_create(struct xfs_metadir_update *upd);
-int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
-
 typedef int (*xfs_metadir_createfn)(struct xfs_metadir_update *upd, void *priv);
 
 int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
@@ -45,7 +42,6 @@ int xfs_metadir_start_link(struct xfs_metadir_update *upd);
 int xfs_metadir_link(struct xfs_metadir_update *upd);
 
 int xfs_metadir_commit(struct xfs_metadir_update *upd);
-void xfs_metadir_cancel(struct xfs_metadir_update *upd, int error);
 
 int xfs_metadir_mkdir(struct xfs_inode *dp, const char *path,
 		struct xfs_inode **ipp);
-- 
2.54.0

