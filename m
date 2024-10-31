Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9881F1E7C09
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417044; cv=none; b=fAF89SlC7e6FVXDBZZkp+Nhp3CC4hcZZj/4UPz2LjfdPXD40eAY26INCLai1GYx5mtupbZlSKlPchRKPbcnPUYLhqzO02I9DA/k6QsLPhuTc+uxOzLDyymsdiilEzkZfvlFqALWuxxFwG+WATLvm40FOb5eIxK/oB1b0moMYEkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417044; c=relaxed/simple;
	bh=0AHzcXLas3a4rW2ud5bbDx/k7BW2dyPEEK3v9dcfxdo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdNIUM9jYEAXFt51p3f/O1oJOCAce6St+SwvNi0gzU242FG3oQYs2vRXcOkiBdbyhNYEm+By11W2UDn7tSqlM95XrL4COvBwyzMTMDC8VyKwH8k5sRdIanZKpSI8EbEpDdPBrsWXHgjlwWNPOe6OnECoHn0hJ3DHRn6rFsAzjRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ye97DvyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ye97DvyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629BFC4CED7;
	Thu, 31 Oct 2024 23:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417044;
	bh=0AHzcXLas3a4rW2ud5bbDx/k7BW2dyPEEK3v9dcfxdo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ye97DvyQLW8qEX+fjQkSzRHjZ0hOfikgOL4DKf+lrBudfjyaTenGfPpDlWCB/65EN
	 vGJPN//5lgl6Z1L5GHfuyjqU+fuNTeN5eFGGE1kv1OWCXT804mi8JcWE9LhmtQSc73
	 N2IpUgkzVB2nmmB2MogP1JjUJCxJKPSHTjl8SBKXXF/Vw8a/x4UTj0FGjwAAsm5Ae/
	 LZ7gxvMcWjJD8OD0U5Ypomr2QJY2rB5DDJ6/1cHCao05vDcEGcViktxnGVmpYcdZ2d
	 bO1gJZ2eB8/dK0eDbxvW/XRYC3iM4VQs5b6itZWA4H8PeHVvzoM3zhgTRKBwtddTE8
	 3f2kofRRqZpyw==
Date: Thu, 31 Oct 2024 16:24:03 -0700
Subject: [PATCH 2/6] xfs_repair: use xfs_validate_rt_geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041568133.964620.17517771729333469028.stgit@frogsfrogsfrogs>
In-Reply-To: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
References: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Use shared libxfs code with the kernel instead of reimplementing it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/sb.c              |   40 ++--------------------------------------
 2 files changed, 3 insertions(+), 38 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b9986a00681c1e..a4e8fd08a90541 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -309,6 +309,7 @@
 
 #define xfs_update_secondary_sbs	libxfs_update_secondary_sbs
 
+#define xfs_validate_rt_geometry	libxfs_validate_rt_geometry
 #define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_agbext		libxfs_verify_agbext
diff --git a/repair/sb.c b/repair/sb.c
index 4b49c1b33c6c83..1320929caee590 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -447,44 +447,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 			return(XR_BAD_SECT_SIZE_DATA);
 	}
 
-	/*
-	 * real-time extent size is always set
-	 */
-	if (sb->sb_rextsize * sb->sb_blocksize > XFS_MAX_RTEXTSIZE)
-		return(XR_BAD_RT_GEO_DATA);
-
-	if (sb->sb_rextsize * sb->sb_blocksize < XFS_MIN_RTEXTSIZE)
-			return(XR_BAD_RT_GEO_DATA);
-
-	if (sb->sb_rblocks == 0)  {
-		if (sb->sb_rextents != 0)
-			return(XR_BAD_RT_GEO_DATA);
-
-		if (sb->sb_rbmblocks != 0)
-			return(XR_BAD_RT_GEO_DATA);
-
-		if (sb->sb_rextslog != 0)
-			return(XR_BAD_RT_GEO_DATA);
-
-		if (sb->sb_frextents != 0)
-			return(XR_BAD_RT_GEO_DATA);
-	} else  {
-		/*
-		 * if we have a real-time partition, sanity-check geometry
-		 */
-		if (sb->sb_rblocks / sb->sb_rextsize != sb->sb_rextents)
-			return(XR_BAD_RT_GEO_DATA);
-
-		if (sb->sb_rextents == 0)
-			return XR_BAD_RT_GEO_DATA;
-
-		if (sb->sb_rextslog != libxfs_compute_rextslog(sb->sb_rextents))
-			return(XR_BAD_RT_GEO_DATA);
-
-		if (sb->sb_rbmblocks != (xfs_extlen_t) howmany(sb->sb_rextents,
-						NBBY * sb->sb_blocksize))
-			return(XR_BAD_RT_GEO_DATA);
-	}
+	if (!libxfs_validate_rt_geometry(sb))
+		return XR_BAD_RT_GEO_DATA;
 
 	/*
 	 * verify correctness of inode alignment if it's there

