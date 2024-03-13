Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B99AD5D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295111; cv=none; b=YtK0K3Z49WjYMm6R+v4ZFOB7wOY0Twdsqa90uDaV8lB0nVd5FfgfgmCiRpjk8mflWKYkoDuOAmlmj5I3ntlsdyUaX8vihQKratlDkT9XDvPbo7lJxZcuG+6maLWpBRdpRC+iLuKnLxLFifHxtzsrdgHmb7JRN+zS5mDvithMsu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295111; c=relaxed/simple;
	bh=qRsfs5LTKwOmVcoUgXZAdKpAFyPmrtTMpgjAMG3MQIc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qo320YnWVxImPsWPLw3hAjKEqqebTVEt6/tr/sT53ESftHWSWlbdfil77b67Zy98CyOGje7DTZH+/h1CpIP78SbyDTdSQjhoz2Is6WsCqZjXv1hVgzJpMqb/p7RLwzqXC8WM6yT0nETZRUZXUdFRMaFZqQJ4MMMAqwpNRNPq4WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qneId1Qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qneId1Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DC8C433F1;
	Wed, 13 Mar 2024 01:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295111;
	bh=qRsfs5LTKwOmVcoUgXZAdKpAFyPmrtTMpgjAMG3MQIc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qneId1Qa/xIMcHg2jLJU5I/YdX5HXYidTzfHuehn4ZS+zEkmzRk+8fFZFB+G9OcW1
	 YaVZCU1M2rKK5xtjQfnYYZmo8YTK3yS3kAxRhvHEC4NrpFBV01zoSHq7+bmNHFT4UJ
	 AgaESeLVqLqQO2K5okPAUCebjQWyTEQWQElEVXOwOGHX+4i249EmhgYDajOX+NCQLc
	 51wCaff3sv+l5UOFPtrGLzuTLk3FqVVnltIJRy7EeboKGSt09/I0kpOzEDvTB6vw1h
	 DcOzTUz6OtPbNR9gRP1NgRoTHMClmbXG4kqY0SmmN386b3ybYm88tAD+8l2TDXRJoj
	 ps4LTMAHnaL8Q==
Date: Tue, 12 Mar 2024 18:58:30 -0700
Subject: [PATCH 21/67] xfs: ensure logflagsp is initialized in
 xfs_bmap_del_extent_real
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
 Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431497.2061787.7890780145330619670.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

Source kernel commit: e6af9c98cbf0164a619d95572136bfb54d482dd6

In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
Otherwise the caller __xfs_bunmapi will set uninitialized illegal
tmp_logflags value into xfs log, which might cause unpredictable error
in the log recovery procedure.

Also, remove the flags variable and set the *logflagsp directly, so that
the code should be more robust in the long run.

Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   73 +++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 42 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8c553d22c535..20ec22dfcaf4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5004,7 +5004,6 @@ xfs_bmap_del_extent_real(
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
-	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5017,6 +5016,8 @@ xfs_bmap_del_extent_real(
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
+	*logflagsp = 0;
+
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -5029,7 +5030,6 @@ xfs_bmap_del_extent_real(
 	ASSERT(got_endoff >= del_endoff);
 	ASSERT(!isnullstartblock(got.br_startblock));
 	qfield = 0;
-	error = 0;
 
 	/*
 	 * If it's the case where the directory code is running with no block
@@ -5045,13 +5045,13 @@ xfs_bmap_del_extent_real(
 	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
 		return -ENOSPC;
 
-	flags = XFS_ILOG_CORE;
+	*logflagsp = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
-				goto done;
+				return error;
 		}
 
 		do_fx = 0;
@@ -5066,11 +5066,9 @@ xfs_bmap_del_extent_real(
 	if (cur) {
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 	if (got.br_startoff == del->br_startoff)
@@ -5087,17 +5085,15 @@ xfs_bmap_del_extent_real(
 		xfs_iext_prev(ifp, icur);
 		ifp->if_nextents--;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5108,12 +5104,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
@@ -5122,12 +5118,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case 0:
 		/*
@@ -5144,18 +5140,18 @@ xfs_bmap_del_extent_real(
 		new.br_state = got.br_state;
 		new.br_startblock = del_endblock;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, &got);
 			if (error)
-				goto done;
+				return error;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
-				goto done;
+				return error;
 			cur->bc_rec.b = new;
 			error = xfs_btree_insert(cur, &i);
 			if (error && error != -ENOSPC)
-				goto done;
+				return error;
 			/*
 			 * If get no-space back from btree insert, it tried a
 			 * split, and we have a zero block reservation.  Fix up
@@ -5168,33 +5164,28 @@ xfs_bmap_del_extent_real(
 				 */
 				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
-					goto done;
-				if (XFS_IS_CORRUPT(mp, i != 1)) {
-					error = -EFSCORRUPTED;
-					goto done;
-				}
+					return error;
+				if (XFS_IS_CORRUPT(mp, i != 1))
+					return -EFSCORRUPTED;
 				/*
 				 * Update the btree record back
 				 * to the original value.
 				 */
 				error = xfs_bmbt_update(cur, &old);
 				if (error)
-					goto done;
+					return error;
 				/*
 				 * Reset the extent record back
 				 * to the original value.
 				 */
 				xfs_iext_update_extent(ip, state, icur, &old);
-				flags = 0;
-				error = -ENOSPC;
-				goto done;
-			}
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				error = -EFSCORRUPTED;
-				goto done;
+				*logflagsp = 0;
+				return -ENOSPC;
 			}
+			if (XFS_IS_CORRUPT(mp, i != 1))
+				return -EFSCORRUPTED;
 		} else
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 
 		ifp->if_nextents++;
 		xfs_iext_next(ifp, icur);
@@ -5218,7 +5209,7 @@ xfs_bmap_del_extent_real(
 					((bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN));
 			if (error)
-				goto done;
+				return error;
 		}
 	}
 
@@ -5233,9 +5224,7 @@ xfs_bmap_del_extent_real(
 	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
-done:
-	*logflagsp = flags;
-	return error;
+	return 0;
 }
 
 /*

