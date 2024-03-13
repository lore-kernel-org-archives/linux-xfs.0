Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F3CBA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295706; cv=none; b=AI8bVzZNvdC7jAswEj9jPM3c58hSsLH/yaOAz+XGh0Y90rPrERGHx8PYJ18doFAUXwq+6c8MotGRD6IXIhaUvNgLQEsHKXcmEGHctYA5tm2pednp9W5XzZshSF69RWrfHH1IQZzOpg4ksxEyFnOUA/jufGqkezdufvtmQCA4xTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295706; c=relaxed/simple;
	bh=luixzqVMW8xrR2J9k8AKFXLQ0fTYfIKvWXkOUDFsiYo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CECTctIkSGbesr3WWR9WnC3/VHwbkum+jFNR+yOq8dXYS2eUIxJvPXMabzMP/3/CQHVONxmxixBBEqprIIQSBI2ulhnFBnU074JI3S+xYco5RuxMuJ7ktCPVHEGiqdnfOhepXLrT1wd038jXHFoWdKAnCHlT3pi3/LEHDM4DfV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nW8lNIc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nW8lNIc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8357DC433F1;
	Wed, 13 Mar 2024 02:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295705;
	bh=luixzqVMW8xrR2J9k8AKFXLQ0fTYfIKvWXkOUDFsiYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nW8lNIc3pmzgPT5lAVCDwmodtGtY3BJWGf8EbCwQwpHF8lMy2Z1YN8t/4ZT6DmuHB
	 MB6keEmzBJ86VPJ1v4CV+Jbz0ZqDfsGer8EtulUKzcePrm2Yt+yweHcEdN8B4mMYMf
	 Gzybnwm9rlO26HkVIqhhK7ZU8/LhGnt9l1wEaZhTK603YpT1RXmYhMS7QO9ygldaLk
	 zrpk5JgNSgrNSsD9v2JOh3sranw4v7ref3M/WTyJBLb3jPFrE+mljpcl4iD9rc7/0J
	 BAA22bAQRTv40Y5zg3q+QgeFBSkN7QOHUKrXP4FjZdY7Pi4mNZNg4DQpl5GkOk+qyj
	 HgKX42cuatY1g==
Date: Tue, 12 Mar 2024 19:08:25 -0700
Subject: [PATCH 59/67] xfs: use xfs_attr_sf_findname in
 xfs_attr_shortform_getvalue
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432045.2061787.2868680894600493998.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1fb4b0def7b5a5bf91ad62a112d8d3f6dc76585f

xfs_attr_shortform_getvalue duplicates the logic in xfs_attr_sf_findname.
Use the helper instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr_leaf.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8f1678d296a7..9b6dcff349c9 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -845,23 +845,17 @@ int
 xfs_attr_shortform_getvalue(
 	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
 
 	trace_xfs_attr_sf_lookup(args);
 
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count;
-				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			return xfs_attr_copy_value(args,
-				&sfe->nameval[args->namelen], sfe->valuelen);
-	}
-	return -ENOATTR;
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe)
+		return -ENOATTR;
+	return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+			sfe->valuelen);
 }
 
 /* Convert from using the shortform to the leaf format. */

