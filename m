Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A88823959B
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596257; cv=none; b=TOwC/N+lNKqR7clkA36jpHoJE2AoPg0fCXSqdJ5V9+KwmM4Y26szyZswgKihrd9PmrxrrM+uC9mBrfy5Dju0QDaTrEowSP1CAm1Na2QSHajSYbk+DB1vGkNn1NId8+7iM+yRK+6UHz5b60RWONq+OGGMrRJ6ietyE7R2tQioyfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596257; c=relaxed/simple;
	bh=HAFmTjo/j8JOQyc0FosP4Z45uNtgsKB7q3D1QYYCM4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyMKllu/Kys2+edJ9nBuVW85wwuiJMKWkJdh+sVF8Na4NkaqcM9jIJ4rxNBy/RuHaJ7cyHxk0rIEZ+tOW4q9o2ztIhvY8OMjMkQn0W8wPOIGVcc7tR4a1VTXvV3mhWYaKrUDosIux7TUGvXbzi3dyqWp3daeYFu1sx94n8dqdZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aiTiFEDh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aiTiFEDh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NLPTx9x7w8LqFz3cfJLca+2hCzXjK/W6lxdq44i/usE=; b=aiTiFEDhxvGkgSnKHvUZmevqja
	DzOLtd4Gr8PJrNHEyYqiB68eGiiqcsbHbYQMSBPnnEwpVghI37QIpDQyoWkeMAw060sqo1FNc2rGj
	t3N4NmDxHOaoLNM7ez0UjnEy2I52UidSGO2vi104Zy8bv3p8HMasWhhZNGxT5+x0FivkZ/K+bZiAn
	mvg7EIZmLt2jMTE5LupC7E8I79BN4TOBS49XWECHY+1ly4vrv3LksQhHQl8epYRd+giDbBTtJCZSQ
	8RLXAWNdLavBk3IxVgLMNwghcRaP0IGthcRSoQfA15J4XgEfUmPg3h/IPmhZjus9FZOkPft4r2z6l
	mk9DEYuA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMbA-000000053xz-0SlE;
	Wed, 26 Feb 2025 18:57:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 39/44] xfs: add a max_open_zones mount option
Date: Wed, 26 Feb 2025 10:57:11 -0800
Message-ID: <20250226185723.518867-40-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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

