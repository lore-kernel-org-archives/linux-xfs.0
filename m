Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D5118C935
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838230; cv=none; b=ZGMYMIKWWrTymv7DOJugh8bFV0BAcW2ZibIqhn7aSd3LFnn2PYVK6AW+BC0KptW4nPujZruvl7uIHzZJEgh994MbgT93RfKaRF4+xKjSaCR2Qqmx090IvXwosAWhSb7CP5zkP/eZqDjbD7CnR1rpN0p0eXHItghk6jrpN7cAE8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838230; c=relaxed/simple;
	bh=/rPgtyWDqZuKbDXvkpgoOAHAfCL7gvGUGLEZgWay05I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIy9XmcU/0QEZexH+S6EccNNo0PbPoCxfW8VErGpuLWMT/aqf7DrCdkVToxC+AziV4mnL6BiJFEUQcwUixpS5gcq6hWcJuuB/EjJqEvC3DxDi9TO5xYRoWS225SxBBTSriRwwfTBeGyJDVvqa8CeRO+UN/xE2HAGfUeRn9hSC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tAIS8X/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tAIS8X/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B99C4CEC3;
	Fri, 25 Oct 2024 06:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838230;
	bh=/rPgtyWDqZuKbDXvkpgoOAHAfCL7gvGUGLEZgWay05I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tAIS8X/KlzeplMAmw9LRtbGlkHTCFC/kcFQ+8UHFx4OhjRp674DbkNNBADHmgT+DC
	 48lXB5PVfHFffmRxs8HNCV3fbq2DE/QtkEFNSl2GWz4vz+ajRInl6iDK9qQGftmeQC
	 dYtKejXa925+lqZ5JevVaGskuxoreLZZFTHLBdktBHf+54lBpSnjRNhzrUNrQSHhw3
	 y6cWf4zv4C7aFSU8zqNqVzyte7Ao+ilB20sZ/c2sdXe0uKIKaK3oTqvBo6GVPftzw2
	 FpnatTEptKj6NqJ+NObZFRiY2X5JJx5nFkOEeiXW5s7kpgntbzwEq+Vf7Li7TlRKhx
	 xMtVB/ygfrvMg==
Date: Thu, 24 Oct 2024 23:37:09 -0700
Subject: [PATCH 2/6] xfs_repair: use xfs_validate_rt_geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774469.3041643.11171513742936148834.stgit@frogsfrogsfrogs>
In-Reply-To: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
References: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
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
index a4173e5f7a595c..7c08d766623c0c 100644
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

