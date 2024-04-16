Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F004C98
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230747; cv=none; b=EL4p8dir7uddXbz0H3xlrJy7kKW8zt8xTyttsewa85VoWEV52zT1yEkYEaohdaHfZD+Yd8NGYpUWWQ+WSukhaeCtNR38bdAE8IiTlVuealXzKtnxxenSaRUX+XyGJOBSP67pge/9nU965lx5n30Z/ZPMWBXum9bIogXaO/q/aqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230747; c=relaxed/simple;
	bh=BCFm0tUb9yYVgJ3ZkFTFQlShqlz0ej3jMgY7038vNrM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mCgF1scWH5TA+/t9OAmk1acsEIV5Ic13B8Mw+u/wtFA1L7jC2zBJvcJoaMVoHrFX7jf+yETfXHsP8SVcWXWCZ8YCo2iXbYj7utahmzltyiesl6ab8odCosglYF4ZoeMmCbk7inxQ9jds6raf5V4QX+89ZPKNxfb4YUKrG6wLkYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9kxl/eL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9kxl/eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551BDC113CC;
	Tue, 16 Apr 2024 01:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230747;
	bh=BCFm0tUb9yYVgJ3ZkFTFQlShqlz0ej3jMgY7038vNrM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L9kxl/eLwigG7uNR9vGT3UjesW4XwHzbMfBh/KweRFCWmK/rPjKzdSP1fh65VEydx
	 JLC4nw/WCvepRIG71ulgd5bJqbGkrpvBpnUf7puvlWnGJuIcrNYteL37elQuDvW49e
	 AKsxeEOCRSgRdRtDVOBWUGsZRAMjs7hSA5fN/nzVss4vEndJbNe5RMRcbYec0c7iI4
	 ShPf18LhdRwTUPaeogXDnfKlENCB7gQCZxE/HSE8MHjqgOY5Ky6uLNxYTZSGGCzcBS
	 dkvDCIpK7s/xFC9pix6p2rSIK20O8PuTVLHyAiVXsZn7vmn6+NZ6itJWe4JghvVt/h
	 MyGqWjLAqv0og==
Date: Mon, 15 Apr 2024 18:25:46 -0700
Subject: [PATCH 13/14] xfs: refactor name/value iovec validation in
 xlog_recover_attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323027281.251201.1051479206383291887.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist the code that checks the attr name and value iovecs into separate
helpers so that we can add more callsites for the new parent pointer
attr intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   64 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c8f92166b9ad6..39536303a7b64 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -734,6 +734,46 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.relog_intent	= xfs_attr_relog_intent,
 };
 
+static inline void *
+xfs_attri_validate_name_iovec(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format     *attri_formatp,
+	const struct xfs_log_iovec	*iovec,
+	unsigned int			name_len)
+{
+	if (iovec->i_len != xlog_calc_iovec_len(name_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		return NULL;
+	}
+
+	if (!xfs_attr_namecheck(iovec->i_addr, name_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				iovec->i_addr, iovec->i_len);
+		return NULL;
+	}
+
+	return iovec->i_addr;
+}
+
+static inline void *
+xfs_attri_validate_value_iovec(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format     *attri_formatp,
+	const struct xfs_log_iovec	*iovec,
+	unsigned int			value_len)
+{
+	if (iovec->i_len != xlog_calc_iovec_len(value_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		return NULL;
+	}
+
+	return iovec->i_addr;
+}
+
 STATIC int
 xlog_recover_attri_commit_pass2(
 	struct xlog                     *log,
@@ -798,30 +838,18 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[i].i_len != xlog_calc_iovec_len(name_len)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				attri_formatp, len);
+	attr_name = xfs_attri_validate_name_iovec(mp, attri_formatp,
+			&item->ri_buf[i], name_len);
+	if (!attr_name)
 		return -EFSCORRUPTED;
-	}
-
-	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, name_len)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				attri_formatp, len);
-		return -EFSCORRUPTED;
-	}
 	i++;
 
 	/* Validate the attr value, if present */
 	if (value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+		attr_value = xfs_attri_validate_value_iovec(mp, attri_formatp,
+				&item->ri_buf[i], value_len);
+		if (!attr_value)
 			return -EFSCORRUPTED;
-		}
-
-		attr_value = item->ri_buf[i].i_addr;
 		i++;
 	}
 

