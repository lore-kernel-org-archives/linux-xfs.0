Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AB03A640C;
	Tue, 25 Aug 2026 05:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636221; cv=none; b=UTF0ehbx/n+O+7Zidh07WcY5iuQHaKxeI6oGT6UXA0BNq2q5UK/CBBIvhABlAUTt9h1rvRNLZuy3J9Zofk5/dpVWXWP/2kFBjM3Vq4RbiuYIK5Zx1y/RrXWICaPEkuU7Jp+pNGjJ4dhddjEORguATMISnaoKuMJ/+UUMbXW1uXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636221; c=relaxed/simple;
	bh=xyaxKvXcFfngQPj5LG02OgBIzMS32XIP573ISO35pKo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oE3D0Dx/5hMNX5Mzz3T4FMlyeu0U9XaBeFQ8Y+g/b1L+av1NdJNG9Qq3VQ8oabPKdWaSd4KBHxJ7SNkkXLSZs9PbD85hBy8RDgFfydysR1dKIU9jMubh39uLiP27wD2xD+ZTYIo4ro+GxdGoUZblb+/LBaTc3LgrxQCuvGy6Z6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ex8z1Bb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ex8z1Bb9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D34E1F000E9;
	Tue, 25 Aug 2026 05:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636219;
	bh=waXtV7QDNCgN2Hkmg1W9WrecojDZOpytzFEKNE24rbo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Ex8z1Bb97TWBVrrkweWkmP6Fx3SyGbxEoF64I6MOG2iAd5L/sjoNqmgPAnRYZ3JNM
	 pTf+wHc4eHmUpzxTNT3alG8gPlKAglI6GjhInuC3+qfiRC5hh77ct+4fwtsavr7KlW
	 pzOqHif8Vpe7wK2eDFhlNIPHUw47Cl2KeP+0+3r3RQz3riXDNIZK51inuOxgDFzsbE
	 rZUIkfyvmi52e+Kc/cX2yMYolTIOtxCx1CEMX3/e9gYUSnhgLcbjt0T//8Jj/k/loK
	 7jMFafamwbumP7PW15CSQSoVmUDMj5DQTRPyu848QeMO8bSIZ2MHaoJXDfxxAD9Bzj
	 RBE2FCKEdkLbQ==
Date: Mon, 24 Aug 2026 22:36:59 -0700
Subject: [PATCH 4/5] xfs: report nonexistent parents as a filesystem
 corruption
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760941165.944364.4932010221437452578.stgit@frogsfrogsfrogs>
In-Reply-To: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
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

