Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E4148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529223; cv=none; b=gyCZ1uc9JEC3QOtbUUXNg8jMv0Fhex5j4VjCLNEL4hUEMarkxTvNBhxvShy7wYtba1QsM42c10inB+W3Lukq1I5RGT1hD79mKClisn7L4mmIBpwFrCXuXWHnyzESZEeFvGNB/TXmfBk4fHZaX7W8IsqIA/n4FDLWysHxTxHdBxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529223; c=relaxed/simple;
	bh=u8vQGOAFS3fRlIDY+DztncLSbhillKE26awze/1PlUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/wDa06nQLGgaCkwjJbSVVv/pgAHGaB6ELnO3eBv1Ecg5PV8Zp3e2mh3Yrwu0dNe7CfkqDt/7EwZ3ugEzDQlYBPfAYD63NzJmAe16X2uD6O3zRmm2mig+cm5VF9Fm017ZsHLxJ65NCKUNZtuYxB0G9HYGTNLYy+evErpa112oSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omzfcWqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omzfcWqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C580C4CED1;
	Fri,  6 Dec 2024 23:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529223;
	bh=u8vQGOAFS3fRlIDY+DztncLSbhillKE26awze/1PlUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=omzfcWqSPe/+BGzrLeU7ExcG7bOUf2RszTVoYdH7uO9Z2ghIkgWH/RPCCxarzHHCt
	 SuG+0dAFA6OuA24MHHiSjekqCZa7diPnrjujaxi7jyZySjv/ief2iPF+RbjZfVEXvF
	 KZ1nzCOrml7c5dMmmL3tDZn6tYRF2Dt4nRn4ZcbKn1KmIBwgYJuMoJIOCFq91RDQZs
	 KE4pr5gKqAq+nvFt54WtEA70grny/sqN2QsSDF1FJTQIcOimOo84GpTiYeHSPDWyfl
	 808PREK4aAenS0mMTg7cynHbc7VnQO+5J7p7Lc90yGbxIoG4snpZJO95BWrV3hj7Y3
	 tMlUkEMDPulLg==
Date: Fri, 06 Dec 2024 15:53:42 -0800
Subject: [PATCH 09/46] xfs: refactor xfs_rtsummary_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750132.124560.385687088862969658.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f8c5a8415f6e23fa5b6301635d8b451627efae1c

Make xfs_rtsummary_blockcount take all the required information from
the mount structure and return the number of summary levels from it
as well.  This cleans up many of the callers and prepares for making the
rtsummary files per-rtgroup where they need to look at different value.

This means we recalculate some values in some callers, but as all these
calculations are outside the fast path and cheap, which seems like a
price worth paying.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c         |    4 +---
 libxfs/xfs_rtbitmap.c |   13 +++++++++----
 libxfs/xfs_rtbitmap.h |    3 +--
 3 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 5ec01537faac6b..a037012b77e5f6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -323,9 +323,7 @@ rtmount_init(
 			progname);
 		return -1;
 	}
-	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
-	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
-			mp->m_sb.sb_rbmblocks);
+	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
 
 	/*
 	 * Allow debugger to be run without the realtime device present.
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index cebeef5134e666..edcfb09e29fa18 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
+#include "xfs_sb.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1164,16 +1165,20 @@ xfs_rtbitmap_blockcount(
 	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
 }
 
-/* Compute the number of rtsummary blocks needed to track the given rt space. */
+/*
+ * Compute the geometry of the rtsummary file needed to track the given rt
+ * space.
+ */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
 	struct xfs_mount	*mp,
-	unsigned int		rsumlevels,
-	xfs_extlen_t		rbmblocks)
+	unsigned int		*rsumlevels)
 {
 	unsigned long long	rsumwords;
 
-	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+	*rsumlevels = xfs_compute_rextslog(mp->m_sb.sb_rextents) + 1;
+
+	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 58672863053a94..776cca9e41bf05 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -311,7 +311,7 @@ xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
-		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+		unsigned int *rsumlevels);
 
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
@@ -342,7 +342,6 @@ xfs_rtbitmap_blockcount_len(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	/* shut up gcc */
 	return 0;
 }
-# define xfs_rtsummary_blockcount(mp, l, b)		(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */

