Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A312633D1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051622; cv=none; b=EFI31A652+eccmGUrQjFZMoNKNlmE1NxdDbMeUA9YTRaKFdAP66EyCXA8pQjo2ViBFGikomNbU5GpieK6w1ILA2SUZ3dSiiOaNcIa9RYnA598p0dAWjA37XTx7gWiPXNOsfWrI8cgbwfwM9V5T4YbPULFPvA20IUf8C+/V2oo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051622; c=relaxed/simple;
	bh=KxzKVBAqmkCo107hCEzHl1aAQsVGoze3jh6ydvl4Nec=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yr5H3u3CCNxrMfSFwAB0Ti4lPHoYXZ6fOgsfijSQao3Ez/4wTZgp8li4gwEdsrsV1C7mNdR810ZdFvs1/WHggecZsiWmwAo5mXQPc8PohEEmt5aM5Xg3FZrcXvLtHxjqyzudo6xBZMEZQbop1IEHiND+STpsRyZsR86qyYgqdHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anDh/JFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anDh/JFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3C8C4CECE;
	Fri, 13 Dec 2024 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051620;
	bh=KxzKVBAqmkCo107hCEzHl1aAQsVGoze3jh6ydvl4Nec=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=anDh/JFgTU38tDV0ByGfUZKry844c3cgihS0e0AA2Re+KqfeZohmD8AZ+oL7jnaLr
	 P0qKuR49+ObpU3BWfmnTDPMh0m4JSEqOLgCqFOhg9CEfHkvItVFxfLJLEnQ8mkQ+EG
	 6uTAXpPSPVNMzthl+psKEd+6HIKW4+Fc7y3VRlRAqlnmNWhsxywpfLCdYPrqLC0/UI
	 iEQPNbQuto2b5dqMkjUzYPt+ri9Er1ihkP+oRw1juIX1lg0Lu3S8t1B3Uj5wj7HZ43
	 A5GfaRfLtm4eq6Pm81/ArPNR/Hrav2yeBTTaN3bDQEorDc7d5Nh1J6zHF1jh3MIi57
	 lP73mCEtccNoQ==
Date: Thu, 12 Dec 2024 17:00:19 -0800
Subject: [PATCH 1/2] xfs: prepare to reuse the dquot pointer space in struct
 xfs_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122719.1181241.4694610206738243416.stgit@frogsfrogsfrogs>
In-Reply-To: <173405122694.1181241.15502767706128799927.stgit@frogsfrogsfrogs>
References: <173405122694.1181241.15502767706128799927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Files participating in the metadata directory tree are not accounted to
the quota subsystem.  Therefore, the i_[ugp]dquot pointers in struct
xfs_inode are never used and should always be NULL.

In the next patch we want to add a u64 count of fs blocks reserved for
metadata btree expansion, but we don't want every inode in the fs to pay
the memory price for this feature.  The intent is to union those three
pointers with the u64 counter, but for that to work we must guard
against all access to the dquot pointers for metadata files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    4 +---
 fs/xfs/libxfs/xfs_bmap.c |    4 +---
 fs/xfs/scrub/tempfile.c  |    1 +
 fs/xfs/xfs_dquot.h       |    3 +++
 fs/xfs/xfs_exchrange.c   |    3 +++
 fs/xfs/xfs_inode.h       |   10 +++++++---
 fs/xfs/xfs_qm.c          |    2 ++
 fs/xfs/xfs_quota.h       |    5 -----
 fs/xfs/xfs_trans.c       |    4 ++++
 fs/xfs/xfs_trans_dquot.c |    8 ++++----
 10 files changed, 26 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 17875ad865f5d6..8c04acd30d489c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1004,9 +1004,7 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	if (xfs_is_metadir_inode(ip))
-		ASSERT(XFS_IS_DQDETACHED(ip));
-	else
+	if (!xfs_is_metadir_inode(ip))
 		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0842577755f7bb..02323936cc9b20 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1042,9 +1042,7 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	if (xfs_is_metadir_inode(ip))
-		ASSERT(XFS_IS_DQDETACHED(ip));
-	else
+	if (!xfs_is_metadir_inode(ip))
 		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 2d7ca7e1bbca0f..4ebb5f8459e8f3 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -749,6 +749,7 @@ xrep_tempexch_reserve_quota(
 	 * or the two inodes have the same dquots.
 	 */
 	if (!XFS_IS_QUOTA_ON(tp->t_mountp) || req->ip1 == req->ip2 ||
+	    xfs_is_metadir_inode(req->ip1) ||
 	    (req->ip1->i_udquot == req->ip2->i_udquot &&
 	     req->ip1->i_gdquot == req->ip2->i_gdquot &&
 	     req->ip1->i_pdquot == req->ip2->i_pdquot))
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c617bac75361b2..61217adf5ba551 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -160,6 +160,9 @@ static inline struct xfs_dquot *xfs_inode_dquot(
 	struct xfs_inode	*ip,
 	xfs_dqtype_t		type)
 {
+	if (xfs_is_metadir_inode(ip))
+		return NULL;
+
 	switch (type) {
 	case XFS_DQTYPE_USER:
 		return ip->i_udquot;
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index dd24de420714ab..d1c1d5819fbfe0 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -119,6 +119,9 @@ xfs_exchrange_reserve_quota(
 	int				ip1_error = 0;
 	int				error;
 
+	ASSERT(!xfs_is_metadir_inode(req->ip1));
+	ASSERT(!xfs_is_metadir_inode(req->ip2));
+
 	/*
 	 * Don't bother with a quota reservation if we're not enforcing them
 	 * or the two inodes have the same dquots.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1648dc5a806882..1141c2e8e123ae 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -25,9 +25,13 @@ struct xfs_dquot;
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct xfs_dquot	*i_udquot;	/* user dquot */
-	struct xfs_dquot	*i_gdquot;	/* group dquot */
-	struct xfs_dquot	*i_pdquot;	/* project dquot */
+	union {
+		struct {
+			struct xfs_dquot *i_udquot;	/* user dquot */
+			struct xfs_dquot *i_gdquot;	/* group dquot */
+			struct xfs_dquot *i_pdquot;	/* project dquot */
+		};
+	};
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index dc8b1010d4d332..3abab5fb593e37 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -428,6 +428,8 @@ void
 xfs_qm_dqdetach(
 	xfs_inode_t	*ip)
 {
+	if (xfs_is_metadir_inode(ip))
+		return;
 	if (!(ip->i_udquot || ip->i_gdquot || ip->i_pdquot))
 		return;
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index d7565462af3dc4..105e6eb5762011 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -29,11 +29,6 @@ struct xfs_buf;
 	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
 	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))
 
-#define XFS_IS_DQDETACHED(ip) \
-	((ip)->i_udquot == NULL && \
-	 (ip)->i_gdquot == NULL && \
-	 (ip)->i_pdquot == NULL)
-
 #define XFS_QM_NEED_QUOTACHECK(mp) \
 	((XFS_IS_UQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4cd25717c9d130..f53f82456288e5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1266,6 +1266,9 @@ xfs_trans_alloc_ichange(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+	if (xfs_is_metadir_inode(ip))
+		goto out;
+
 	error = xfs_qm_dqattach_locked(ip, false);
 	if (error) {
 		/* Caller should have allocated the dquots! */
@@ -1334,6 +1337,7 @@ xfs_trans_alloc_ichange(
 			goto out_cancel;
 	}
 
+out:
 	*tpp = tp;
 	return 0;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 713b6d243e5631..765456bf342851 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -156,7 +156,8 @@ xfs_trans_mod_ino_dquot(
 	unsigned int			field,
 	int64_t				delta)
 {
-	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(ip));
+	if (xfs_is_metadir_inode(ip))
+		return;
 
 	xfs_trans_mod_dquot(tp, dqp, field, delta);
 
@@ -246,11 +247,10 @@ xfs_trans_mod_dquot_byino(
 	xfs_mount_t	*mp = tp->t_mountp;
 
 	if (!XFS_IS_QUOTA_ON(mp) ||
-	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino) ||
+	    xfs_is_metadir_inode(ip))
 		return;
 
-	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(ip));
-
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		xfs_trans_mod_ino_dquot(tp, ip, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)

