Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8D7370D71
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022501; cv=none; b=nX3BP5Aonz4B73+Ab2MpNO5rQFKegDQa5jLHiP10SJfUz8gVTguclpJbkXjABjhtp/NU7y/5sdrbY1rgYMdnOgpv+82gtB9gSttLcY3HgP/WeRQdXCmCKojGT/k3IK9bDfOPTiQIGWxxmN9BC+MqFozp9LXPPIqnLrAJaL5e3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022501; c=relaxed/simple;
	bh=vauOBReKKhGJ7bxAl3Yd+qQRK3tQLA+hew9elQXV0Do=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntt2lWhGkpMmjU1auCxANtrhnx36pF67+p0m6b3eQWINrKGNRXxGWf8JXvwyEL+bvovEnY2lX5Q3jUdV3mefHbrYRU77Nb/X67aLsCxUtJdVL0BwCBLmqyQN+TYKtE6uPMq+MWjsl/PXcPDpwOHPwcT0qwdaOLqxTXzfEi76kMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+/ywdzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+/ywdzD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BE9C1F000E9;
	Thu,  2 Jul 2026 20:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022499;
	bh=rAW2HV8BQfLuR7rDgR/1SwTH1jhXvdepdgbaaalbTjk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=J+/ywdzDUVvPOJOtlzlV/qrskJqv/OTIuVbqYvVIVDB5h4Aum/F/K7x15Qk/hTjXP
	 JPElcMH86mhMCtriSiFwJ7hOFv3cAH43K6DQZ8EG9p48WLhv0jhHpgCGKnml72knQz
	 u3rm2MONjpcC+5vcvO0S0FX0rPN4qRmfRqn6TsPiywLvq+2mpkBkmK7Cv9iS5mfYuK
	 +gy2uAJVM4SC1hvlDgvVdnSVkTiLnbdzQ+2YGmME/MayS8re84PqhfW8KRjjEWuUQX
	 hdstUdV2U4dmv+jIHKAi7ma7V6sXnSmV6LgdOXtbFTFGRfNI31WiD2Ktk0+p+AsAOz
	 9LQcqtnmYwh4w==
Date: Thu, 02 Jul 2026 13:01:39 -0700
Subject: [PATCH 05/18] xfs: add a XFS_INODE_TO_AGINO helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226396.845537.12861569963800218416.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f46edc9f1310d27710e2b39bf561ecef51f879d2

Add a shortcut for the common XFS_INO_TO_AGINO(mp, ip->i_ino) pattern.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h     |    2 ++
 db/iunlink.c            |    2 +-
 libxfs/iunlink.c        |    2 +-
 libxfs/xfs_inode_util.c |    5 ++---
 repair/pptr.c           |    2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 36a00c174f1ea1..f812c6782492cb 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1280,6 +1280,8 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGINO(mp,i)		\
 	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INODE_TO_AGINO(ip)		\
+	XFS_INO_TO_AGINO((ip)->i_mount, (ip)->i_ino)
 #define	XFS_INO_TO_AGBNO(mp,i)		\
 	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
 		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
diff --git a/db/iunlink.c b/db/iunlink.c
index 20946c967f548a..7eeef5f0886e11 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -23,7 +23,7 @@ count_rtblocks(
 		dbprintf(
 _("could not read AG %u agino %u extents, err=%d\n"),
 				XFS_INODE_TO_AGNO(ip),
-				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+				XFS_INODE_TO_AGINO(ip),
 				error);
 		return 0;
 	}
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 2d4dd0aee0b87b..7a00915290db86 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -66,7 +66,7 @@ xfs_iunlink_log_dinode(
 	}
 
 	trace_xfs_iunlink_update_dinode(mp, pag_agno(iup->pag),
-					XFS_INO_TO_AGINO(mp, ip->i_ino),
+					XFS_INODE_TO_AGINO(ip),
 					be32_to_cpu(dip->di_next_unlinked),
 					iup->next_agino);
 
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 8e439dc2f4faff..63b95238d8ce86 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -461,10 +461,9 @@ xfs_iunlink_insert_inode(
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		next_agino;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
@@ -550,7 +549,7 @@ xfs_iunlink_remove_inode(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
diff --git a/repair/pptr.c b/repair/pptr.c
index dc1ea2288eacc0..39e7bb5030d02f 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -1051,7 +1051,7 @@ crosscheck_file_parent_ptrs(
 	struct file_pptr	*file_pptr;
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	int			error;
 
 	ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);

