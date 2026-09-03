Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285CB1E1DF0;
	Thu,  3 Sep 2026 05:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414745; cv=none; b=BoTKrIauv/VCiNqB9chrE71jbwTD/xkyu5Z8PsYA3MQ3VBwZAE5v9UnswBjseNXXOUe1DMskGv8k2GHTdSd8f5DXC/mtv60Q7GZaDwfv0G1ZIeqlXFd/7jdDIbNYSVt0zjwJVIMUGVUIfiI05yKYCgeYRBxfGiYYks7Nwj91fXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414745; c=relaxed/simple;
	bh=9dYU+QCxVoODY/nwZ9fWljM3/8ec/rsMK/88gX/GwCk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byttcdjd7NAmi1m5LHfUErqu8+wogu6Y6i3jRQ0lJ9oceRP0jJC2ZL5BJiVb074BZ8cLhFLve0rnpBx0I0+whHtZ9GG+MCct5ze15u1TwJ3uVGDJRL8Rd7uHYnw4Zn6xMCAyKdDWusPPBN9z99D2jB5LEZOIGsEA06zNIBoLOf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFUkA8V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFUkA8V+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A239E1F00A3A;
	Thu,  3 Sep 2026 05:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414743;
	bh=mW4uAXGLZ+EdNpMv/OAYKzLQduloORu5penGTLHv2B4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=PFUkA8V+mMlWmlF6EYAPU6BpqzMGkajxJyk8wGpn4TjX1fCjv/GhNn7pZMLWfWguR
	 dzX/lGk7u46FiaNG1cgxbLZ1Gn78HyLt2XmTa08gh3QSq+eIrDnDMg5hjmHtASnAd+
	 KA59hCtt9Yk4DWoLdJjz7rzDE23hX49/ri8wjGq112XezktUuYWV+qhZWCoOdWLyhr
	 TB8UvxIZ39DRlHcXm2sZnjp6bkmBEM5n0wvdPZ6Yt2DISyzSb/Iin7eAUJqIIpS5yo
	 ubsx4Jd33ZK3npULvN2xDdOf8vQldxgdnc4gjHXkHjqMCHHBuDOjeymHVOFnsMTbMb
	 dnYusVH8jCalg==
Date: Wed, 02 Sep 2026 22:52:23 -0700
Subject: [PATCH 6/6] xfs: count escaped corruption errors in scrub stats
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969957.484660.10087312504640007572.stgit@frogsfrogsfrogs>
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The main scrub code will quietly turn bubbled-up EFSCORRUPTED and
EFSBADCRC errors into corruption errors.  These aren't recorded in the
scrub stats code (says LOLLM) so do that now.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/stats.h |    4 ++--
 fs/xfs/scrub/scrub.c |    3 +--
 fs/xfs/scrub/stats.c |   28 +++++++++++++++++++---------
 3 files changed, 22 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/stats.h b/fs/xfs/scrub/stats.h
index b358ad8d8b90ac..221052b95dd077 100644
--- a/fs/xfs/scrub/stats.h
+++ b/fs/xfs/scrub/stats.h
@@ -27,7 +27,7 @@ void xchk_stats_register(struct xchk_stats *cs, struct dentry *parent);
 void xchk_stats_unregister(struct xchk_stats *cs);
 
 void xchk_stats_merge(struct xfs_mount *mp, const struct xfs_scrub_metadata *sm,
-		const struct xchk_stats_run *run);
+		int error, const struct xchk_stats_run *run);
 
 static inline u64 xchk_stats_now(void) { return ktime_get_ns(); }
 static inline u64 xchk_stats_elapsed_ns(u64 since)
@@ -53,7 +53,7 @@ static inline u64 xchk_stats_elapsed_ns(u64 since)
 # define xchk_stats_unregister(cs)		((void)0)
 # define xchk_stats_now()			(0)
 # define xchk_stats_elapsed_ns(x)		(0 * (x))
-# define xchk_stats_merge(mp, sm, run)		((void)0)
+# define xchk_stats_merge(mp, sm, error, run)	((void)0)
 #endif /* CONFIG_XFS_ONLINE_SCRUB_STATS */
 
 #endif /* __XFS_SCRUB_STATS_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8742445c86f45e..12c228b7f4770d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -765,8 +765,7 @@ xfs_scrub_metadata(
 out_teardown:
 	error = xchk_teardown(sc, error);
 out_sc:
-	if (error != -ENOENT)
-		xchk_stats_merge(mp, sm, &run);
+	xchk_stats_merge(mp, sm, error, &run);
 	kfree(sc);
 out:
 	trace_xchk_done(XFS_I(file_inode(file)), sm, error);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index ef3f6abdb7061a..76f2515188d1b1 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -188,31 +188,37 @@ STATIC void
 xchk_stats_merge_one(
 	struct xchk_stats		*cs,
 	const struct xfs_scrub_metadata	*sm,
+	int				error,
 	const struct xchk_stats_run	*run)
 {
 	struct xchk_scrub_stats		*css;
+	unsigned int			sm_flags = sm->sm_flags;
 
 	if (sm->sm_type >= XFS_SCRUB_TYPE_NR) {
 		ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
 		return;
 	}
 
+	/* caller applies this same transformation after we return */
+	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
+		sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+
 	css = &cs->cs_stats[sm->sm_type];
 	spin_lock(&css->css_lock);
 	css->invocations++;
-	if (!(sm->sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
+	if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
 		css->clean++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+	if (sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		css->corrupt++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
+	if (sm_flags & XFS_SCRUB_OFLAG_PREEN)
 		css->preen++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+	if (sm_flags & XFS_SCRUB_OFLAG_XFAIL)
 		css->xfail++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+	if (sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
 		css->xcorrupt++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+	if (sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		css->incomplete++;
-	if (sm->sm_flags & XFS_SCRUB_OFLAG_WARNING)
+	if (sm_flags & XFS_SCRUB_OFLAG_WARNING)
 		css->warning++;
 	css->retries += run->retries;
 	css->checktime_us += howmany_64(run->scrub_ns, NSEC_PER_USEC);
@@ -230,10 +236,14 @@ void
 xchk_stats_merge(
 	struct xfs_mount		*mp,
 	const struct xfs_scrub_metadata	*sm,
+	int				error,
 	const struct xchk_stats_run	*run)
 {
-	xchk_stats_merge_one(&global_stats, sm, run);
-	xchk_stats_merge_one(mp->m_scrub_stats, sm, run);
+	if (error == -ENOENT)
+		return;
+
+	xchk_stats_merge_one(&global_stats, sm, error, run);
+	xchk_stats_merge_one(mp->m_scrub_stats, sm, error, run);
 }
 
 /* debugfs boilerplate */

