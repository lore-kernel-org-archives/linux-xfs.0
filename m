Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCCA3B5302
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179598; cv=none; b=S9gIYKr9Wy8qJ5kV4g1DRBkzh0tOKZTEEWWeSL7LwrlhbHGcwP3/z/vAu6v7/dnzKb2+rA6fYQjPgWWJi7hcsh5saYxZrZJqkTTdGJAG7AVRdW9TZWJCk2awuQodPdz8qGayf0K4DAx2fBmzVesjoc6Ebe7q/4ZfeEOkohIJ5yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179598; c=relaxed/simple;
	bh=REFRWhDWC+vbZOjUczPTbh34b4IJz3f3P6yMmzn5aNA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMBI1CxRgHZLvM+rvZWzpyK5+0WC82G+JJf1UGuEbdG6EZgzUkRt8434FGec72rez9yYT/fwDJ6JT7xCdJP5mhG7sGTOx2GATiqdJvdqyGveNOxd0s+OxZ6e2KSzzQXbgJclY27NkGW7ifaAF2wqFWe3IiVgdpm6igUNIWemRA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feHd/mWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feHd/mWG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ADE091F000C4;
	Fri, 16 Oct 2026 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179596;
	bh=KPuDT5iQBvvfbMcHM2oumvfIl1mAPm698EvjufhlR2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=feHd/mWG/h6hrv6JgyBVa2w/OM0M0PALXfHmOCRBmfaxkW0lKOMwIwXAYH6Y8mC4h
	 sehbA0X8y269wpPe6gIOYMqwYLiZx992fSUjGyYoVGdEd35APCNppoVLtDkVtWb3yF
	 KAKcYcw6hRsIOYtbL4V/UtyZTe2Y+uvNjZXZC2k1bRhxxg5qbyJHUQlrEI/kYbGa82
	 QubDTtmyHt7Uh2HGECMGaBfqh4Jz9AQlJEakI1tFpoIB36Qd7P6VnN3P2AKJHZgC90
	 id6NvComFtBiuJHG3VGB5AzsaYoCcGPrpsB6M3eypeMg0SK4iy8LwMdlGpzxlhracQ
	 kNGycuYp6WVlQ==
Date: Fri, 16 Oct 2026 12:39:56 -0700
Subject: [PATCH 08/10] xfs_repair: allow sysadmins to add realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942886.717548.8292845087020905533.stgit@frogsfrogsfrogs>
In-Reply-To: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
References: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the realtime reference count btree, and therefore reflink on
realtime volumes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase2.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)


diff --git a/repair/phase2.c b/repair/phase2.c
index 08413c464a89d0..16bdb579e702a5 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -252,8 +252,8 @@ set_reflink(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(_("Reflink feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reference count btree requires realtime groups.\n"));
 		exit(0);
 	}
 
@@ -265,6 +265,7 @@ set_reflink(
 	printf(_("Adding reflink support to filesystem.\n"));
 	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
 	return true;
 }
 
@@ -509,6 +510,28 @@ compute_rtrmap_reservation(
 	return ret;
 }
 
+/*
+ * Compute the amount of extra space needed for further rtrefcount btree
+ * expansion.  If we're adding rtrefcount to a filesystem then there won't be
+ * an rtrefcount inode and we'll return the full reservation charge.  If
+ * there's already an rtrefcount inode, then subtract the ondisk space usage
+ * because that's not reserved.
+ */
+static xfs_rfsblock_t
+compute_rtrefcount_reservation(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rfsblock_t		ret = libxfs_rtrefcountbt_calc_reserves(mp);
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	if (rtg_refcount(rtg))
+		ret -= min(ret, rtg_refcount(rtg)->i_nblocks);
+	return ret;
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -592,6 +615,7 @@ check_fs_free_space(
 	/* Realtime metadata btree inodes */
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		new_resv += compute_rtrmap_reservation(rtg);
+		new_resv += compute_rtrefcount_reservation(rtg);
 	}
 
 	if (new_resv > mp->m_sb.sb_fdblocks) {

