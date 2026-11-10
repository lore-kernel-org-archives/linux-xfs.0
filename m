Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.154.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306972;
	b=c3HsOHXc1+8g19oVRtmA9CXXBOy+ptEcC+n2zhT0wwku670RVNRWjv1JS33mWnC2Rop7
	 /eHVy53rZy67mH4UV5902T2Kx/SSNwn2yaeRG1Z3dt2oYkvimUcYZH10qzLlf9xT/dsHF
	 Ym8Mn601R5FvjKf8ntBAisXYkaEcdqMbfhFJwGbjsd6O+vbhBDKfa/PmTCkqc2uznIlqH
	 GJ620sJiPRCQaJETvvExcMDZGv6mVWr+uELXTjoQEOyHgGrnyri2PpNkIAZyKrbfpnyzM
	 LDioeT7bkvNvtSxjfyPJHetQb7eEMqmEixRPIi1xLv93R1hkvSANobxg+oYpF2oF4wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306972;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XYwABPfbmroIa4YRcnOkhIiosnqF4rCxl1hDk4FSaGQ=;
	b=o8eLPeTh8KKz3AkWv8v7Ih52pdPXSmer+5UP09cyRkOAbxuavS9I0hJURD4SHmOqQ5C6
	 65G94tz/pXbesknYKquQ8kxTZcOP2wmiIG92nCAe88nN/DFX2Gck4yWJCc18uvQ9/3P/V
	 lUg8BeGE5Y7tOVPQIX0i3Mld84QQ/Di4h8wdH3i/EssYsziwNC88WRWd7No/BhkPrc7Yn
	 mMiT4RRpebFU8+7LaMWOuG3MsyNwmbBx1BV6yqEuG+OPy/lPpI1h1ogi0xDy+6zdRICXd
	 f/QRHN2YnlYiL08swmkT97TNRuW/Zh2DT7DmII0Uf8K4DvgQwuUIIPnBXxGxmHJ2gTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QadSDwrZ;
	arc=none smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864AE606A337;
	Tue, 10 Nov 2026 10:36:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 864AE606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=QadSDwrZ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794306971; x=1825842971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iz2f8xQz4gPqHPdAtljMrs8ExPm5zLmDKifU62Y59PY=;
  b=QadSDwrZF8kNiIaX/sVVeBFgyS+IFOvTdNEoMKNL0ZBRzomhLt15qAHc
   ZYh0p3Qn9wkSKbI+QfpZiSeSDq/Y7mSSKqe4aZX8lzLAOBOFw6ixsCP0f
   Y4AdxcWZebTc2VOAB4r184trirzK850Ln9BqnsutH9Hg6Ku6R28+apnn/
   u/uxV44mTK2vMrLa4F1XbuELnLRAXqN9deATN2q+EsF6W1dPG/Zlk/XBr
   NfxPMujJ3OEptnX5w7ORe6sJNjBuKjHngEltgSeHH7tTeP82vQlMLrVWK
   trz9hjA/0mEhJN5TJUvAKlItRZdWlUOS4FcL3v4GAfKRsRhX8d+cVIBxO
   Q==;
X-CSE-ConnectionGUID: AlCjkcWXTSWxsEnVPtQjAQ==
X-CSE-MsgGUID: y8hmQ9psS72oraoyZw6JBQ==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="158891413"
Received: from h199-255-45-14.hgst.com (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2026 18:36:10 +0800
X-CSE-ConnectionGUID: np1NyKr4RzqSthCPAkYJUQ==
X-CSE-MsgGUID: uMLqGR+YT/uVoeC3HAHdgg==
IronPort-SDR: 6af2f39b_h1QnecO4bxLB5HncjifrjaeuxkiAxnEamNtja4ghApxZE/j
 KzSt1Kd1LHKfj0DtjX4pUik51rqpq2OrAN8hBCQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 02:36:11 -0800
X-CSE-ConnectionGUID: hIPmb7BIRBqx8siv3GacCg==
X-CSE-MsgGUID: MVrKvjkYRIy4PnAJny6Rsg==
WDCIronportException: Internal
Received: from unknown (HELO gcv.wireless.wdc) ([10.224.5.251])
  by uls-op-esai1-o.wdc.com with ESMTP; 10 Nov 2026 02:36:08 -0800
From: Hans Holmberg <hans.holmberg@wdc.com>
To: brauner@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	dgc@kernel.org,
	cem@kernel.org,
	jack@suse.cz,
	axboe@kernel.dk,
	kbusch@kernel.org
Cc: dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [RFC 4/4] xfs: add a nostreamalloc mount option
Date: Tue, 10 Nov 2026 11:35:40 +0100
Message-ID: <20261110103540.46876-5-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110103540.46876-1-hans.holmberg@wdc.com>
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
 <20261110103540.46876-1-hans.holmberg@wdc.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a mount option to disable write stream based data placement in the
zone allocator, so that the effect of write streams can be compared
easily in benchmarks.  Write streams can still be queried, allocated
and assigned to files, but the allocator ignores them.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 Documentation/admin-guide/xfs.rst | 10 ++++++++++
 fs/xfs/xfs_mount.h                |  2 ++
 fs/xfs/xfs_super.c                | 15 +++++++++++++++
 fs/xfs/xfs_zone_alloc.c           |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index acdd4b65964c..10dfaa75af5d 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -110,6 +110,16 @@ When mounting an XFS filesystem, the following options are accepted.
 
 	These options are only available for zoned rt file systems.
 
+  streamalloc (default) or nostreamalloc
+	Enable data placement based on write streams assigned by the
+	user.  Data written to a write stream is placed in open zones
+	dedicated to that stream.  With nostreamalloc, write streams
+	can still be queried, allocated and assigned to files, but
+	the allocator ignores them.  This is intended for debugging
+	and benchmarking.
+
+	These options are only available for zoned rt file systems.
+
   logbsize=value
 	Set the size of each in-memory log buffer.  The size may be
 	specified in bytes, or in kilobytes with a "k" suffix.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 216a38a354e7..0bc3d15927fa 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -398,6 +398,7 @@ typedef struct xfs_mount {
 
 /* Mount features */
 #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
+#define XFS_FEAT_NOSTREAMALLOC	(1ULL << 48)	/* disable stream placement */
 #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
 #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
 #define XFS_FEAT_LARGE_IOSIZE	(1ULL << 51)	/* report large preferred
@@ -452,6 +453,7 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
 __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
+__XFS_HAS_FEAT(nostreamalloc, NOSTREAMALLOC)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5c92f8ebd8a7..ae47488251ff 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -116,6 +116,7 @@ enum {
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
 	Opt_lifetime, Opt_nolifetime, Opt_max_atomic_write, Opt_errortag,
+	Opt_streamalloc, Opt_nostreamalloc,
 };
 
 #define fsparam_dead(NAME) \
@@ -173,6 +174,8 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_u32("max_open_zones",	Opt_max_open_zones),
 	fsparam_flag("lifetime",	Opt_lifetime),
 	fsparam_flag("nolifetime",	Opt_nolifetime),
+	fsparam_flag("streamalloc",	Opt_streamalloc),
+	fsparam_flag("nostreamalloc",	Opt_nostreamalloc),
 	fsparam_string("max_atomic_write",	Opt_max_atomic_write),
 	fsparam_string("errortag",	Opt_errortag),
 	{}
@@ -202,6 +205,7 @@ xfs_fs_show_options(
 		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
 		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
 		{ XFS_FEAT_NOLIFETIME,		",nolifetime" },
+		{ XFS_FEAT_NOSTREAMALLOC,	",nostreamalloc" },
 		{ 0, NULL }
 	};
 	struct xfs_mount	*mp = XFS_M(root->d_sb);
@@ -1164,6 +1168,11 @@ xfs_finish_flags(
 "nolifetime mount option only supported on zoned file systems.");
 			return -EINVAL;
 		}
+		if (mp->m_features & XFS_FEAT_NOSTREAMALLOC) {
+			xfs_warn(mp,
+"nostreamalloc mount option only supported on zoned file systems.");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -1611,6 +1620,12 @@ xfs_fs_parse_param(
 	case Opt_nolifetime:
 		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
 		return 0;
+	case Opt_streamalloc:
+		parsing_mp->m_features &= ~XFS_FEAT_NOSTREAMALLOC;
+		return 0;
+	case Opt_nostreamalloc:
+		parsing_mp->m_features |= XFS_FEAT_NOSTREAMALLOC;
+		return 0;
 	case Opt_max_atomic_write:
 		if (suffix_kstrtoull(param->string, 10,
 				     &parsing_mp->m_awu_max_bytes)) {
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 8b2838239325..6161dd7ea61c 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -695,6 +695,8 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
 
 static inline u16 xfs_inode_write_stream(struct xfs_inode *ip)
 {
+	if (xfs_has_nostreamalloc(ip->i_mount))
+		return WRITE_STREAM_NOT_SET;
 	return READ_ONCE(VFS_I(ip)->i_write_stream);
 }
 
-- 
2.43.0

