Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D111C83
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610171; cv=none; b=DUYo8MUwGK9E8ASC1e0iIJI07opoxsLNZD+sczOF7PCK4SSGyNjLX08Yn0KAdGtIprLREZA6Cpr3Fonwc1CAu2YwrtrIWRDOAGhe5jg5ij24CtZ80sfxJhd4EV4Wm0Pb/YK/xfsKOvhU5SyQsM0mvI18OrR00afa/JouZyN98m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610171; c=relaxed/simple;
	bh=YWGJq25PKXnIVrhfiORJI4sxuvh8kHRDC7A+MetPzLY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlW/h66hFdYvtIvTEjQ9uLWchILzOHifwZh6h3O3UGPGDTqD7MuzG5z1vJMnOh+lCY7I2nF+DuSLKBc0RMyzBTF9yshQnjRta0VEZvEu6Bi4nuHG3J7X1P7Dxs2K5uBfJoLsv+IRledhYv5fX4eWgVPZ5cxqLDwySXtKifw472Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZwybVQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZwybVQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7ADC4CECD;
	Fri, 11 Oct 2024 01:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610171;
	bh=YWGJq25PKXnIVrhfiORJI4sxuvh8kHRDC7A+MetPzLY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HZwybVQYUkWMhIvU7k3nsHWhPjJAgi0iHt4rKJ60YOi0YbQLpNxHUbcv8Gh3YRNkn
	 i/cu/L1A1BKNkAcWY181CjLL5V4yk//MxYYYEYVmWYa9VlmqL9UskCKAiIUHPAQO+B
	 3lbUqXoonGF8euOulMzbjKgoW6xovH7T7OJzMuFpjmQ89N9l/ctsOZQ0wy9TH2tlcE
	 r8QxPwkc+LKxoao5aAsoRkWTay1ldyVR9i/8Ztc8PzflJ1Xq4VKYFoySavTfigZvX/
	 fyLRtAUAvzjJ42TPJR8MFoHPi+HB8opKOesDzBc7af8hRT+EtKxM7TBHUuX5Yq9jYh
	 XKX5PcaKRTj6g==
Date: Thu, 10 Oct 2024 18:29:31 -0700
Subject: [PATCH 19/43] xfs_repair: stop tracking duplicate RT extents with
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655658.4184637.9443532168158411906.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Nothing ever looks them up, so don't bother with tracking them by
overloading the AG numbers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/incore_ext.c |    5 ++---
 repair/phase4.c     |    8 ++++++--
 2 files changed, 8 insertions(+), 5 deletions(-)


diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index a31ef066ef356c..892f9d25588c11 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -725,7 +725,7 @@ static avl64ops_t avl64_extent_tree_ops = {
 void
 incore_ext_init(xfs_mount_t *mp)
 {
-	xfs_agnumber_t agcount = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
+	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
 	int i;
 
 	pthread_mutex_init(&rt_ext_tree_lock, NULL);
@@ -778,10 +778,9 @@ incore_ext_init(xfs_mount_t *mp)
 void
 incore_ext_teardown(xfs_mount_t *mp)
 {
-	xfs_agnumber_t agcount = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
 	xfs_agnumber_t i;
 
-	for (i = 0; i < agcount; i++)  {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
 		btree_destroy(dup_extent_trees[i]);
 		free(extent_bno_ptrs[i]);
 		free(extent_bcnt_ptrs[i]);
diff --git a/repair/phase4.c b/repair/phase4.c
index 3a627d8aeea85a..f43f8ecd84e25b 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -322,8 +322,12 @@ _("free space (%u,%u-%u) only seen by one free space btree\n"),
 		case XR_E_FS_MAP:
 			break;
 		case XR_E_MULT:
-			add_dup_extent(agno + isrt ? mp->m_sb.sb_agcount : 0,
-					agbno, blen);
+			/*
+			 * Nothing is searching for duplicate RT extents, so
+			 * don't bother tracking them.
+			 */
+			if (!isrt)
+				add_dup_extent(agno, agbno, blen);
 			break;
 		case XR_E_BAD_STATE:
 		default:

