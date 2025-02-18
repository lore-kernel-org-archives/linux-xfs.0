Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0536C22FAE1
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866442; cv=none; b=cPHgo3xTPw9CKt1VnYnbg3v75b2svuclU4Q2EOIgWHZwMp2f/ZERz0xOUMWXWwi6P6pASU6mA8/MFcpumAZwyRym4D2wsa8tgDk1A0pLqYHINechJt2UflEw8wqLEJ7pVrroFWQiq/pB74OuuXCID/070cAsZ0ie3XMDvJUPbGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866442; c=relaxed/simple;
	bh=HAFmTjo/j8JOQyc0FosP4Z45uNtgsKB7q3D1QYYCM4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScqmSsAC7hiwPMvGI79sstLittHpG8z4RXnOG1obYKxoCkTIRHYYO0eQDRWRi5MVohP7z/Sp7IqtZzGmwmiuYA1wQjNyZy7YCBICcTiGKxU2VfPyDWxERQNS/98fr52FGI0AdDL5miPTJJ62DVuE1cFNpK1u8cluFMy4mG6UBgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=33TyWJN7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="33TyWJN7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NLPTx9x7w8LqFz3cfJLca+2hCzXjK/W6lxdq44i/usE=; b=33TyWJN7V086q9hGess9KtaENg
	moItilRuQHnM0jhWHyzdlARWOP730BtwaYOST5R7DRKGvosdCC+yaph9oIo212BBp8QeGNI85HPHJ
	hUhmC0xn7OdXFcg7gxsa0vusRN9p6diAxP0lzSjU2Y99coMs+Nc3/nwYYsgHAvDMd65azP+JvjvhW
	MBSJSb1pTehzlrPh6CSc3sSMIHWXnetWuz53MHULdrnwWV+uJ/MDc1JnFXPl7GFAcsY0224rw8TkB
	4xl0VDoAh/iiOWedXlonNtfgmMvPkEGxgbZzsbcRsnzNCOp/qofPKe4+55sV/HwxPnXs6Cqm++SBX
	6MqXFlaQ==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjw-00000007Cu2-0JQE;
	Tue, 18 Feb 2025 08:14:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 40/45] xfs: add a max_open_zones mount option
Date: Tue, 18 Feb 2025 09:10:43 +0100
Message-ID: <20250218081153.3889537-41-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4ea7150692dd..aac50bdd629c 100644
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
 
@@ -1081,6 +1085,14 @@ xfs_finish_flags(
 		return -EINVAL;
 	}
 
+	if (!xfs_has_zoned(mp)) {
+		if (mp->m_max_open_zones) {
+			xfs_warn(mp,
+"max_open_zones mount option only supported on zoned file systems.");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -1463,6 +1475,9 @@ xfs_fs_parse_param(
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

