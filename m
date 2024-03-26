Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E257314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423094; cv=none; b=m4nCAQdWA5rwLv8HBWGkMdSLEx8U1qwF1GFiu7m/L2aDA2U9N76Z/G4HcOlV2PJwsWCoA348QTJlHGHoJf3hthSmnRgZYaNFSIMOR7hLjMAHLHmRiFZAmssT2lG4fJHg+xLsW3NUXevkHuLvNVsE/dAtJwQMwi23+RF3eOVtbl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423094; c=relaxed/simple;
	bh=nQ/OcrMPZpEA9rbFbg3Cp24nLIie47NJ1bF+nTg2PnY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CAO1NUZVzpman8HydwWI02bMpStlwIgS80nAhX0VJrt99R6XJ/GMSLVRG7UGletfZfZMrGM5SX1TxZGGwUtk9fV3If9u4zIRcJEb7zjj074FDM58NwOkpDT0x3D3Ocq18AYGceFLoO+WXu8S7HNkVKWZ40nMy0gK6WzLmdfn5Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P39ZskGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P39ZskGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A42C433C7;
	Tue, 26 Mar 2024 03:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423094;
	bh=nQ/OcrMPZpEA9rbFbg3Cp24nLIie47NJ1bF+nTg2PnY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P39ZskGRN04F9fPulPscvwOCoRY8ff0lyZQHoHjC7GnLYs0cTNM0wboWANPHg3io5
	 AnqrVyzL/7N0jagQU4SS8JTsaM9xAQdo175Kt7nkvxhizeI0FBXFrG270kv4SWXOC7
	 qoVvNkOteZik4W7PMLhSj2RCfD56j9IhVlyyh/HTsmFQ3bWOnCHs4QtAXr1TNf/uQd
	 Q8cceEQ8yH5VKJKn3QY9n6/iRBFDuZep122Hj10MBVKLYHLQoNhil8AdQavnkwfLjR
	 AGMAzryCxq7GZeo1YNTiCwtre5tec+gtluQN7IcfBOX0BPGKn5MEU/80JDc1jPxHcH
	 /Uex2QAz2yO/g==
Date: Mon, 25 Mar 2024 20:18:13 -0700
Subject: [PATCH 59/67] xfs: use xfs_attr_sf_findname in
 xfs_attr_shortform_getvalue
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127807.2212320.2709582451352365418.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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

