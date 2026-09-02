Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBD38DC57;
	Wed,  2 Sep 2026 05:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328096; cv=none; b=S2VCbJTw5FoIv/1f/f9cF5putpFZH1kD+oBaMqanQs68sofpMA6azcl+gGcMzpZL66EwxkBvmzo648cMumBIVcNpYYUqxeLCsHVa1Sk6uagcN/aJrJRVeIMuHe97MRG7fqjmZdAsL/7Uwv+kwP3DZfAaNWW0pr5da7ZqdO3+sJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328096; c=relaxed/simple;
	bh=11dbRVepnn0JomBls4IEVa8QURbtqJYFqh+i5T18BsE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=snJrQRaxemvkhqcriedyx8jJf2NzZJeUu2KU+UsPfUTCUaAj5bo1tMjdy5hZy3lB2178JPNmciEIBiGL24PWkzDc2IbhUHpOOt4kQQTe76b1hrtolncFxlA7uiZvyQoeIe+hNdIqOi4BQfoNN/PrifQuDZkWWfMbR97zPWH727o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1REsqba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1REsqba"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 077FF1F000E9;
	Wed,  2 Sep 2026 05:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328095;
	bh=2ji8LhTC/nPHgiYLIGQ8jqNFXORNTS7kq5RUAQUhgaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=j1REsqbaNP+oQlo3VI6+vyVlTCLWhNji/41sTx10sj1cii9S/OJls3KKogmjuRZPj
	 jbuHkwfdXgWRKng/vy4ohU1uQnZi2tpomtk4/WouXJqAM4VF84W/0VnL5eApgPmFfb
	 ucVMvSLsNnP2ENUDvkeE10l0r5UeGJ03ijdHdCHfHJQbq9p6bbIBH97m5te3cDprbl
	 RcCIf2tTwKl+y67mawV8rtb/eMvS/3UHFf4B8X1ASiZQ4oXLZXTvs0g3YmZ6zKRDoh
	 QiTOjRoU0MwJL/lEPBjqdYW7PLK2cARPbqcmM1gnrjrNExyMItshd6Nw8TVmCYj5qY
	 PUMuDYLpbrEIQ==
Date: Tue, 01 Sep 2026 22:48:14 -0700
Subject: [PATCH 7/8] xfs: report nonexistent parents as a filesystem
 corruption
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750414.3507776.12174708475212946225.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that when the directory tree scrubber tries to walk up a
parent pointer but the parent inumber doesn't point to an allocated
inode, we allow the EINVAL/ENOENT error code to bubble up to userspace.
That's not right, we should be reporting that as a cross-referencing
error so that someone runs the parent pointer checker.

Also add a termination check to xchk_dirpath_step_up because it's a loop
body function.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/trace.h   |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.c |   30 ++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 362c6d39e9f580..0f5adc293962fa 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1706,6 +1706,39 @@ DEFINE_EVENT(xchk_dirtree_class, name, \
 DEFINE_XCHK_DIRTREE_EVENT(xchk_dirtree_create_path);
 DEFINE_XCHK_DIRTREE_EVENT(xchk_dirpath_walk_upwards);
 
+TRACE_EVENT(xchk_dirpath_badino,
+	TP_PROTO(struct xfs_scrub *sc, unsigned int path_nr,
+		unsigned int step_nr, const struct xfs_name *name,
+		const struct xfs_parent_rec *pptr),
+	TP_ARGS(sc, path_nr, step_nr, name, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, path_nr)
+		__field(unsigned int, step_nr)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->path_nr = path_nr;
+		__entry->step_nr = step_nr;
+		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
+		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d path %u step %u parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->path_nr,
+		  __entry->step_nr,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 DECLARE_EVENT_CLASS(xchk_dirpath_class,
 	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip,
 		 unsigned int path_nr, unsigned int step_nr,
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index b2cf6e5439d915..717cbac2956238 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -368,12 +368,38 @@ xchk_dirpath_step_up(
 	struct xfs_inode	*dp;
 	xfs_ino_t		parent_ino = be64_to_cpu(dl->pptr_rec.p_ino);
 	unsigned int		lock_mode;
-	int			error;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Grab and lock the parent directory. */
 	error = xchk_iget(sc, parent_ino, &dp);
-	if (error)
+	switch (error) {
+	case -EINVAL:
+	case -ENOENT:
+		mutex_lock(&dl->lock);
+
+		if (dl->stale) {
+			/* live update detected a change in this path */
+			error = -ESTALE;
+		} else {
+			/* inode doesn't exist, path invalid */
+			error = -EFSCORRUPTED;
+
+			trace_xchk_dirpath_badino(dl->sc, path->path_nr,
+					path->nr_steps, &dl->xname,
+					&dl->pptr_rec);
+		}
+
+		mutex_unlock(&dl->lock);
 		return error;
+	case 0:
+		/* keep going */
+		break;
+	default:
+		return error;
+	}
 
 	lock_mode = xfs_ilock_attr_map_shared(dp);
 	mutex_lock(&dl->lock);

