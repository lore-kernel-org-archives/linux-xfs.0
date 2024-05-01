Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93F61607A4;
	Wed,  1 May 2024 18:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588888; cv=none; b=ZlDY5p4LDNQLVY2vughsvj96iZ+gXYjGw2ZM45B9z80QNR6S4NUGsfvYUOUNM6TPajUuNpUaXchcP3fDPOjhNwpOMSQ5MlpSH2A49JKx3RrtHIr44RU54MBo5y15qOLvXL0mjY9RN3boErSVFr2K4Ylg3POgUnK3qlzYB91/iKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588888; c=relaxed/simple;
	bh=U5+mRHM7rde0nDEBuEhGAscCYAqpJHI6BeC5WF0rjKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXUqlJ+kCTl0eO7no/RM5GriCBdIHyZvfwJwrRRmqp5tHk+2rZxm+9d6T3GYZXlhoy0otLLyUIMQCmHfTpoFeMvjJhd/N3t94yXPwmL0d1rXWLMoRX+cTqr6ghs5F6VfRqQxRXI/ODv+LlJm6/PFIBYu914dUUcaF2uJ793QLJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpIRTUf2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpIRTUf2"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ecec796323so6786646b3a.3;
        Wed, 01 May 2024 11:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588884; x=1715193684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jx59y6Xy95X+e6QXVtHeWj3TFhamHw8tAuTcIYOGkNQ=;
        b=VpIRTUf2m+A/q/7oX7jMdhzFMsF8GyD5zB9JQ7ld1ShVPwa1N0BRwt+fyjl3e4Pgw7
         BzO6bDCjhClT0jHTNO3bWlJj+OhXP11AQx0iL2v8dPHKjxIgL/IRWiMPuFVU/p254RbN
         bi0K5+lNH2UmmDL4wixI7L53Qqi3FKAaKwfkrc+xKtJ7kdCQaU4DbsaKwRsbdlOOdv/Q
         veW898WyV+M+UFS+AtAuGOCqMZFN/Hc0WYtFOlUSvnmVLxmByzaQ50RSOGiCuAefKNVt
         eDJzTddEX0jwOw2y9yGMg3wlftCiyfeIaJGp956f2Mi0VJCQpt/md8aqN8NKvx9wDjR8
         g4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588884; x=1715193684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jx59y6Xy95X+e6QXVtHeWj3TFhamHw8tAuTcIYOGkNQ=;
        b=t2M16mB0kh5bK8V/yqDCyTA2kVkitUaiQ6KIi5RpWEfMoQ5Qh6iStSmOdzIWqmyBMm
         ve8q5h443Q/83oDz+mh4/YBri+YPXmqWenvYpWSSQAMdYQXTvluxWAT+ILWOzlWfjry3
         kL16bbdQWW5DAMDPTic7D8kdR43AaP+S0GJ4DXcuDcCULnnC2Wb2o6VeE+YIlLH2iuXR
         y25hmeGiS+UHtFPx4xUrp9ZML8mY98u/u05pZDHpthFjLXVJxIu0gCfrXjFTrCQaF7r7
         p4pqILRLCGMdsCb1bZFFYWfZJfHSJfV0WoY8m6Hv7x72FOoATn56o3g/8SMcU0wlnrJZ
         Dt1g==
X-Gm-Message-State: AOJu0Yw6s9bQT6c0jw3NR6mJwYHr9UqKEdOb1Q23IJdhIbRU7WzLVF6v
	Hybe0i3WCuTB6p53nfSrx5byn7Y68JwkATmF0VLFWD1liB/rHSUcrrFpDtJz
X-Google-Smtp-Source: AGHT+IHcD4XSdriSiKkhbzBKLUelYESAo0SNvdR9TzLnSLeYnls4kuesti9TtdyR2Ba5iFOd7rSp6w==
X-Received: by 2002:a05:6a20:1b13:b0:1a9:3cf2:508d with SMTP id ch19-20020a056a201b1300b001a93cf2508dmr3260882pzb.38.1714588883790;
        Wed, 01 May 2024 11:41:23 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:23 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 08/24] xfs: use iomap_valid method to detect stale cached iomaps
Date: Wed,  1 May 2024 11:40:56 -0700
Message-ID: <20240501184112.3799035-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 304a68b9c63bbfc1f6e159d68e8892fc54a06067 ]

Now that iomap supports a mechanism to validate cached iomaps for
buffered write operations, hook it up to the XFS buffered write ops
so that we can avoid data corruptions that result from stale cached
iomaps. See:

https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/

or the ->iomap_valid() introduction commit for exact details of the
corruption vector.

The validity cookie we store in the iomap is based on the type of
iomap we return. It is expected that the iomap->flags we set in
xfs_bmbt_to_iomap() is not perturbed by the iomap core and are
returned to us in the iomap passed via the .iomap_valid() callback.
This ensures that the validity cookie is always checking the correct
inode fork sequence numbers to detect potential changes that affect
the extent cached by the iomap.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |  6 ++-
 fs/xfs/xfs_aops.c        |  2 +-
 fs/xfs/xfs_iomap.c       | 95 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_iomap.h       |  5 ++-
 fs/xfs/xfs_pnfs.c        |  6 ++-
 5 files changed, 87 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 49d0d4ea63fc..56b9b7db38bb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4551,7 +4551,8 @@ xfs_bmapi_convert_delalloc(
 	 * the extent.  Just return the real extent at this offset.
 	 */
 	if (!isnullstartblock(bma.got.br_startblock)) {
-		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags);
+		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
+				xfs_iomap_inode_sequence(ip, flags));
 		*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
@@ -4599,7 +4600,8 @@ xfs_bmapi_convert_delalloc(
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
-	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags);
+	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
+				xfs_iomap_inode_sequence(ip, flags));
 	*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6aadc5815068..a22d90af40c8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -372,7 +372,7 @@ xfs_map_blocks(
 	    isnullstartblock(imap.br_startblock))
 		goto allocate_blocks;
 
-	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0);
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 09676ff6940e..26ca3cc1a048 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -48,13 +48,45 @@ xfs_alert_fsblock_zero(
 	return -EFSCORRUPTED;
 }
 
+u64
+xfs_iomap_inode_sequence(
+	struct xfs_inode	*ip,
+	u16			iomap_flags)
+{
+	u64			cookie = 0;
+
+	if (iomap_flags & IOMAP_F_XATTR)
+		return READ_ONCE(ip->i_af.if_seq);
+	if ((iomap_flags & IOMAP_F_SHARED) && ip->i_cowfp)
+		cookie = (u64)READ_ONCE(ip->i_cowfp->if_seq) << 32;
+	return cookie | READ_ONCE(ip->i_df.if_seq);
+}
+
+/*
+ * Check that the iomap passed to us is still valid for the given offset and
+ * length.
+ */
+static bool
+xfs_iomap_valid(
+	struct inode		*inode,
+	const struct iomap	*iomap)
+{
+	return iomap->validity_cookie ==
+			xfs_iomap_inode_sequence(XFS_I(inode), iomap->flags);
+}
+
+const struct iomap_page_ops xfs_iomap_page_ops = {
+	.iomap_valid		= xfs_iomap_valid,
+};
+
 int
 xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
 	struct iomap		*iomap,
 	struct xfs_bmbt_irec	*imap,
 	unsigned int		mapping_flags,
-	u16			iomap_flags)
+	u16			iomap_flags,
+	u64			sequence_cookie)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
@@ -91,6 +123,9 @@ xfs_bmbt_to_iomap(
 	if (xfs_ipincount(ip) &&
 	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
 		iomap->flags |= IOMAP_F_DIRTY;
+
+	iomap->validity_cookie = sequence_cookie;
+	iomap->page_ops = &xfs_iomap_page_ops;
 	return 0;
 }
 
@@ -195,7 +230,8 @@ xfs_iomap_write_direct(
 	xfs_fileoff_t		offset_fsb,
 	xfs_fileoff_t		count_fsb,
 	unsigned int		flags,
-	struct xfs_bmbt_irec	*imap)
+	struct xfs_bmbt_irec	*imap,
+	u64			*seq)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
@@ -285,6 +321,7 @@ xfs_iomap_write_direct(
 		error = xfs_alert_fsblock_zero(ip, imap);
 
 out_unlock:
+	*seq = xfs_iomap_inode_sequence(ip, 0);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
@@ -743,6 +780,7 @@ xfs_direct_write_iomap_begin(
 	bool			shared = false;
 	u16			iomap_flags = 0;
 	unsigned int		lockmode = XFS_ILOCK_SHARED;
+	u64			seq;
 
 	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
 
@@ -811,9 +849,10 @@ xfs_direct_write_iomap_begin(
 			goto out_unlock;
 	}
 
+	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
 	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
 
 allocate_blocks:
 	error = -EAGAIN;
@@ -839,24 +878,26 @@ xfs_direct_write_iomap_begin(
 	xfs_iunlock(ip, lockmode);
 
 	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
-			flags, &imap);
+			flags, &imap, &seq);
 	if (error)
 		return error;
 
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
-				 iomap_flags | IOMAP_F_NEW);
+				 iomap_flags | IOMAP_F_NEW, seq);
 
 out_found_cow:
-	xfs_iunlock(ip, lockmode);
 	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
 	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
 	if (imap.br_startblock != HOLESTARTBLOCK) {
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
+		seq = xfs_iomap_inode_sequence(ip, 0);
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED);
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
+	xfs_iunlock(ip, lockmode);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
 
 out_unlock:
 	if (lockmode)
@@ -915,6 +956,7 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 	unsigned int		lockmode = XFS_ILOCK_EXCL;
+	u64			seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1094,26 +1136,31 @@ xfs_buffered_write_iomap_begin(
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
 	 */
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_NEW);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW, seq);
 
 found_imap:
+	seq = xfs_iomap_inode_sequence(ip, 0);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
 found_cow:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	seq = xfs_iomap_inode_sequence(ip, 0);
 	if (imap.br_startoff <= offset_fsb) {
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
 		if (error)
-			return error;
+			goto out_unlock;
+		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
-					 IOMAP_F_SHARED);
+					 IOMAP_F_SHARED, seq);
 	}
 
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0, seq);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -1193,6 +1240,7 @@ xfs_read_iomap_begin(
 	int			nimaps = 1, error = 0;
 	bool			shared = false;
 	unsigned int		lockmode = XFS_ILOCK_SHARED;
+	u64			seq;
 
 	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
 
@@ -1206,13 +1254,14 @@ xfs_read_iomap_begin(
 			       &nimaps, 0);
 	if (!error && (flags & IOMAP_REPORT))
 		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
+	seq = xfs_iomap_inode_sequence(ip, shared ? IOMAP_F_SHARED : 0);
 	xfs_iunlock(ip, lockmode);
 
 	if (error)
 		return error;
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
-				 shared ? IOMAP_F_SHARED : 0);
+				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
 const struct iomap_ops xfs_read_iomap_ops = {
@@ -1237,6 +1286,7 @@ xfs_seek_iomap_begin(
 	struct xfs_bmbt_irec	imap, cmap;
 	int			error = 0;
 	unsigned		lockmode;
+	u64			seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1271,8 +1321,9 @@ xfs_seek_iomap_begin(
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
 		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
+		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
-					  IOMAP_F_SHARED);
+				IOMAP_F_SHARED, seq);
 		/*
 		 * This is a COW extent, so we must probe the page cache
 		 * because there could be dirty page cache being backed
@@ -1293,8 +1344,9 @@ xfs_seek_iomap_begin(
 	imap.br_startblock = HOLESTARTBLOCK;
 	imap.br_state = XFS_EXT_NORM;
 done:
+	seq = xfs_iomap_inode_sequence(ip, 0);
 	xfs_trim_extent(&imap, offset_fsb, end_fsb);
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 	return error;
@@ -1320,6 +1372,7 @@ xfs_xattr_iomap_begin(
 	struct xfs_bmbt_irec	imap;
 	int			nimaps = 1, error = 0;
 	unsigned		lockmode;
+	int			seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1336,12 +1389,14 @@ xfs_xattr_iomap_begin(
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, XFS_BMAPI_ATTRFORK);
 out_unlock:
+
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_XATTR);
 	xfs_iunlock(ip, lockmode);
 
 	if (error)
 		return error;
 	ASSERT(nimaps);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
 }
 
 const struct iomap_ops xfs_xattr_iomap_ops = {
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 0f62ab633040..4da13440bae9 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -13,14 +13,15 @@ struct xfs_bmbt_irec;
 
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
-		struct xfs_bmbt_irec *imap);
+		struct xfs_bmbt_irec *imap, u64 *sequence);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
+u64 xfs_iomap_inode_sequence(struct xfs_inode *ip, u16 iomap_flags);
 int xfs_bmbt_to_iomap(struct xfs_inode *ip, struct iomap *iomap,
 		struct xfs_bmbt_irec *imap, unsigned int mapping_flags,
-		u16 iomap_flags);
+		u16 iomap_flags, u64 sequence_cookie);
 
 int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
 		bool *did_zero);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 37a24f0f7cd4..38d23f0e703a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -125,6 +125,7 @@ xfs_fs_map_blocks(
 	int			nimaps = 1;
 	uint			lock_flags;
 	int			error = 0;
+	u64			seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -176,6 +177,7 @@ xfs_fs_map_blocks(
 	lock_flags = xfs_ilock_data_map_shared(ip);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				&imap, &nimaps, bmapi_flags);
+	seq = xfs_iomap_inode_sequence(ip, 0);
 
 	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
 
@@ -189,7 +191,7 @@ xfs_fs_map_blocks(
 		xfs_iunlock(ip, lock_flags);
 
 		error = xfs_iomap_write_direct(ip, offset_fsb,
-				end_fsb - offset_fsb, 0, &imap);
+				end_fsb - offset_fsb, 0, &imap, &seq);
 		if (error)
 			goto out_unlock;
 
@@ -209,7 +211,7 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

