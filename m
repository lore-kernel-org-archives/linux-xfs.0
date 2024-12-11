Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B40B1EC4EC
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907514; cv=none; b=SSv+ImThIg/+K2m/8ueFSWr1A0KW/oSXIWXBqufksOt7t4MUBupYOECcFDYZy3FJHXK2nLY7S9qlvoxtXJTid2Hj0v53SaPZLTy+g0v/1p7xpSdeCZCUAV++Yfsumy69u02BrCCuhO0mG7cvolBWG/SNJBUJTSVXogefMcY0GHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907514; c=relaxed/simple;
	bh=ipGVS9DDDSrgh6+U/mN/QO1/0rN/pO/EEcdSER+9ubY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs1C9ZjHWfZ/x9tm2P1pAU1J5ilvrTFvO2GoQn1Dbtl5uDzFD4PSGcsmp0h8MoK97Z6GXiicoAWnMR11m6tSSdoAcEk/fVYn9ab8ALV0Y9hdEHwK4O9/iwDVjXhgfSG6ijL9yZtHiaY7rw0H+c1uYZzSu5yfhP9R3OOaYDCCMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uTmCXE2o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uTmCXE2o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oA4aI3ZYqkjuboNAVBNG7TH0MxHbuDx8Nqv9r+l8tX0=; b=uTmCXE2oHrOEHKolcmcWGLjDXC
	59cU1MrbMq5AJHVDfHswplSvYT7Sgs5mtCboFVKETyeI0vrlxE9oWYuB5IIxLhJgYkK7VNB4tLctI
	QOjIq+WDfYlMOi4mf1zqPVboGV7CjLEjWPn4KmwJSFTJdSPJ16hFKDfpsala7NBHWOj48FQ3pMAR0
	59Ojh8G+unJoUGtV2VKiz4OMWCGXtiFT2TDWajaSNjG+2P9JEc6c2iAf9KOKWxQ/F7kCr/dN0OXMz
	yCVULyGD+Xb+B7NztXupZjvBDLDUgbsEgp57r/wRiogtjro9qR58N5BiEQo4cRPXBI0ZVY+KdR1au
	3uCr8nXQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIYC-0000000EJW8-2BRV;
	Wed, 11 Dec 2024 08:58:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 40/43] xfs: add a max_open_zones mount option
Date: Wed, 11 Dec 2024 09:55:05 +0100
Message-ID: <20241211085636.1380516-41-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Allow limiting the number of open zones used below that exported by the
device.  This is required to tune the number of write streams when zoned
RT devices are used on conventional devices, and can be useful on zoned
devices that support a very large number of open zones.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 690bb068a23a..e24f6a608b91 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -110,7 +110,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -155,6 +155,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_u32("max_open_zones",	Opt_max_open_zones),
 	{}
 };
 
@@ -234,6 +235,9 @@ xfs_fs_show_options(
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
 
+	if (mp->m_max_open_zones)
+		seq_printf(m, ",max_open_zones=%u", mp->m_max_open_zones);
+
 	return 0;
 }
 
@@ -1456,6 +1460,9 @@ xfs_fs_parse_param(
 		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
 		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
 		return 0;
+	case Opt_max_open_zones:
+		parsing_mp->m_max_open_zones = result.uint_32;
+		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
-- 
2.45.2

