Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEDA2147E5
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529504; cv=none; b=Fe4tzFwZGsdwhx8g4iZpeubPOV2fVIe9mhoTVFW1s+TQIU2nNkfOQRnp4ov04RnCguDolUva+nPa5MZJWXvNPrF4Ystb3MKS3/zcyxk+CPNjXvPD6LANDyAgdha2AyJHrkRLMJDw3D8ZGnNox8E23J9Jlo7ILFtt+LFjt1ICl9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529504; c=relaxed/simple;
	bh=PWEH0pQ/KQV9w3eVvRjt9ZxHUhqfHEuyQeJB0406w9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=An0sf6dogb/xR9CuKcm/yJunU3O0uTPB1SWxjmrdlbSRyGll4NBsNtliWe1P26yDEeYYsWs4jV8NmdFajIbaRGMOVd4qoWyIvhfg/2fZsmCG2cCsSPsDLFVs/7Xi3XhXZ6gH0OWFdDZaEl0b8hwE6uul6o7sT23RrRNDRnxhYoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GM28rp+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GM28rp+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C57C4CED1;
	Fri,  6 Dec 2024 23:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529504;
	bh=PWEH0pQ/KQV9w3eVvRjt9ZxHUhqfHEuyQeJB0406w9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GM28rp+STkqkngrPDmiA6z+9bjYdPQmKIjDq71X60yERTM/hmJ4o6JWuY2XOwqMNf
	 WyCx1Ad/kkv3cr3vv2nwwlL5p5bf3QK10x91SaIvvfZpB8PcOeGsq73ud7eW4J89jQ
	 qusEP5K+k5ksvLxu1EYPlfYS4hrNosP9e429cQMkzx4pF1S/YGWu1XcJMVg7ky65qr
	 MRfqMAteAhciopaiefvGLrriv++VuLTpPrl9MMzBHIEjH7Kyn8cxLVZNWj/vMH9BLO
	 o4/5lcOIC8JfnuQ+HF/00OU761KuuH4hNwEeE/m/HBSD0nBHJyYj9Bcuc+guUQgBk0
	 fagiLdDDupTQQ==
Date: Fri, 06 Dec 2024 15:58:23 -0800
Subject: [PATCH 27/46] xfs: don't merge ioends across RTGs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750408.124560.2784689223312407504.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b91afef724710e3dc7d65a28105ffd7a4e861d69

Unlike AGs, RTGs don't always have metadata in their first blocks, and
thus we don't get automatic protection from merging I/O completions
across RTG boundaries.  Add code to set the IOMAP_F_BOUNDARY flag for
ioends that start at the first block of a RTG so that they never get
merged into the previous ioend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtgroup.h |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 026f34f984b32f..2ddfac9a0182f9 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -188,6 +188,15 @@ xfs_rtb_to_rgbno(
 	return __xfs_rtb_to_rgbno(mp, rtbno);
 }
 
+/* Is rtbno the start of a RT group? */
+static inline bool
+xfs_rtbno_is_group_start(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return (rtbno & mp->m_rgblkmask) == 0;
+}
+
 static inline xfs_daddr_t
 xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,

