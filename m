Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9F5225A31
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824425; cv=none; b=h6sjDM0tUokHoBFaxN3yD7XSW4BCiTpXlXJVAwDk7aBJT7+uSKWaHeUrhFChgzoS+pjzWInX/Him5G5Boq5RWbkmp09UqQQfSshMkFvp7luJHkSEytdICE2WcQtlz0CP6hYm0ykKq/MTUDaBdbbZBsOz0sAbP4JX+jfrXNFMvtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824425; c=relaxed/simple;
	bh=tmTWlXafKv6by9/6WXe0c+jn5N1d1otykfHVuLB8EXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRiz0ndwaGCV9mKqUaNT6NtMMG8eXeusKOoiurzjOhpU8gCzZR+hJUgFTIv3ZN7fsCr+qYvVFTyNeuQrINtozN+aOlaGkXTQgAseERYy5NPcLS8iJdfsXBU0OKN2pldh3HiaFGIv/d2FbB4S1pS6Kw+w1lK37WJ4crgaw/Q5AYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SK0Q1TOq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SK0Q1TOq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7Uqxs5u/G5rSYD7BCqd6Ym6BZitveqCMFF4GcFDbQLc=; b=SK0Q1TOqNFTvtr1J3tRraNrIyN
	kF3K9XvOj7iio87HPDfHCZANNYWzZSKPr5haVgYtAjZxpEQm3xN3A5nGkF/1aQk1pqybGdHvgwugy
	An0m8UkF2UDLcUcOqn4paf83kD1Ksjca++iMFoLZ5Bk7Zxzo1+pJbOnI4qQkjTgWnPfHeNkYpThyM
	RxpnKBVDQJiL1HjxD953Ex8o9H0cw5OGaFvvOhh+hDMucLTblbsMPfaHf3/xKVkbENhSRTUEENxiZ
	eQ7JMNSJCOoPl3XVJrjYSWJBDRSt0YDG3PCF3brqi1ZIrDLTYs9leLtcCmDTn0ueMD+IKMe9ywe5w
	DIEOwrYw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvfD-00000005Qqk-1fxv;
	Thu, 06 Feb 2025 06:47:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 38/43] xfs: add a max_open_zones mount option
Date: Thu,  6 Feb 2025 07:44:54 +0100
Message-ID: <20250206064511.2323878-39-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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
 fs/xfs/xfs_super.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ceb1a855453e..b59d7349dbd2 100644
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
 
@@ -1462,6 +1474,9 @@ xfs_fs_parse_param(
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

