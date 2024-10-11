Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC40D268
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610468; cv=none; b=T/WBIpldrV2G/WBWZMeXlBMJ2JSLbgbPtjlovcO81yi+Lfft9xzpHhA2BZQ3d9vZU6uhzCBHnaZuP3EMttChmURKpM68+XYNiQSgPYpzyTzJTKGvWU4YyDSjJ1I65W+tWUZqOQk4XSDXJZDAeRu4RS/Tx6tb1DzDm/Ye/D23ofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610468; c=relaxed/simple;
	bh=HEt0xaW9pYeyokZVEp3mDyGZAi4YXq71JHKB7hb7oIA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U2Tb8OCyxmr48F/yefTlYGzu2xRvlMhkGF9CBVWDnnoN8soSQ/PphScZ8oa/d2iC67vbzMJVDBw7Wz4vbuMgNtYB94cFX4fNXVe3X5/df+NJ7QwwWWyV6ceO5WEX2by2jrvRB0urpfdTsmEHruUih6zRnsOKkptVmpUXw5tls7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtsR7BzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtsR7BzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5090CC4CEC5;
	Fri, 11 Oct 2024 01:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610468;
	bh=HEt0xaW9pYeyokZVEp3mDyGZAi4YXq71JHKB7hb7oIA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MtsR7BzVERAK4Aj+ou34BHpvuxraFmE7fKAuWOx9/xaLeeMniXb2IPfiJx1gjfsFk
	 ew1/hIQBeepHpMeKrQBRWGIqF19AKiDXyEY9bzLMsaziKdAY/+lq0pFXkxuFDwN3Hm
	 5metoEhDad9/WrMzlIPq+2fiUIdEqdj/hkp9p8pl3XFZJDtq6GBplgEfVLX0fLxf0a
	 eYB7NnmjLmpsv8G4cwyMJID6Ox2V3E6lXAhaNDwbV7xUrCXCqgQt52pjO27tzJrBlS
	 XbT/bwI29e298PpB6Xeih+KrBTtJiW0VGoZBB3wDVxC+6T9WjhKXHY/z4o9CWeXj2B
	 bjGI/QcbL2Rhg==
Date: Thu, 10 Oct 2024 18:34:27 -0700
Subject: [PATCH 38/43] xfs_scrub: check rtgroup metadata directory connections
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655949.4184637.16694081606954535613.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Run the rtgroup metapath scrubber during phase 5 to ensure that any
rtgroup metadata files are still connected to the metadir tree after
we've pruned any bad links.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   24 ++++++++++++++++++++++--
 scrub/scrub.h  |    4 +++-
 2 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 4d0a76a529b55d..22a22915dbc68d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -750,6 +750,7 @@ static int
 queue_metapath_scan(
 	struct workqueue	*wq,
 	bool			*abortedp,
+	xfs_rgnumber_t		rgno,
 	uint64_t		type)
 {
 	struct fs_scan_item	*item;
@@ -762,7 +763,7 @@ queue_metapath_scan(
 		str_liberror(ctx, ret, _("setting up metapath scan"));
 		return ret;
 	}
-	scrub_item_init_metapath(&item->sri, type);
+	scrub_item_init_metapath(&item->sri, rgno, type);
 	scrub_item_schedule(&item->sri, XFS_SCRUB_TYPE_METAPATH);
 	item->abortedp = abortedp;
 
@@ -785,6 +786,7 @@ run_kernel_metadir_path_scrubbers(
 	const struct xfrog_scrub_descr	*sc;
 	uint64_t		type;
 	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	xfs_rgnumber_t		rgno;
 	bool			aborted = false;
 	int			ret, ret2;
 
@@ -804,7 +806,7 @@ run_kernel_metadir_path_scrubbers(
 		if (sc->group != XFROG_SCRUB_GROUP_FS)
 			continue;
 
-		ret = queue_metapath_scan(&wq, &aborted, type);
+		ret = queue_metapath_scan(&wq, &aborted, 0, type);
 		if (ret) {
 			str_liberror(ctx, ret,
  _("queueing metapath scrub work"));
@@ -812,6 +814,24 @@ run_kernel_metadir_path_scrubbers(
 		}
 	}
 
+	/* Scan all rtgroup metadata files */
+	for (rgno = 0;
+	     rgno < ctx->mnt.fsgeom.rgcount && !aborted;
+	     rgno++) {
+		for (type = 0; type < XFS_SCRUB_METAPATH_NR; type++) {
+			sc = &xfrog_metapaths[type];
+			if (sc->group != XFROG_SCRUB_GROUP_RTGROUP)
+				continue;
+
+			ret = queue_metapath_scan(&wq, &aborted, rgno, type);
+			if (ret) {
+				str_liberror(ctx, ret,
+  _("queueing metapath scrub work"));
+				goto wait;
+			}
+		}
+	}
+
 wait:
 	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index bb94a11dcfce71..24b5ad629c5158 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -118,9 +118,11 @@ scrub_item_init_file(struct scrub_item *sri, const struct xfs_bulkstat *bstat)
 }
 
 static inline void
-scrub_item_init_metapath(struct scrub_item *sri, uint64_t metapath)
+scrub_item_init_metapath(struct scrub_item *sri, xfs_rgnumber_t rgno,
+		uint64_t metapath)
 {
 	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = rgno;
 	sri->sri_ino = metapath;
 }
 

