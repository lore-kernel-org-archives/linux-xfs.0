Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2573655EE
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589680; cv=none; b=RqRU2GHUF+5YS9rG2yCE5EFEeHuluLX7XqMhJdLKur720+LVnWqcj88WUj3cDzJtNKwtpcBgzXHr2RIIwEL3ruJ69NCoSJ6qkTzmyKAut2/fctEup0Sbde3X3kebOu5VUzBVnF2xC98ezQFW1Ddc9EG7Kp83yPQ3btZ6CYqWoXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589680; c=relaxed/simple;
	bh=SxZrlo+iel71GFD+nwnlJoQ3yxmWvpN2dRxR62EBuH0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P5W2zPLRbzoOZzsys+jarn3FgzupkAZbtL2f3KFeOT8nCeq9BQjOZ89K2vHmrEmVO+DAEsdHn0Y2T071JFAvwDVQSs1u/8wcCnR8DcFlaEK9uH6XbIZKBkYnUX5rM+GgF/FHvaJSPVYtP5JJvRhtibKkZz91tvoxx6RgB2gKsDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rk6RN/nC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rk6RN/nC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 09B141F000FF;
	Fri,  9 Oct 2026 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589679;
	bh=v1RwOBSkLBC08fCoB116LMvLj+Z/8efdhDrJ7vzqU5E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Rk6RN/nCeV3Q13iDUgVYAEdn2b4dj12OF7auVkKFvK3InsCnaqwxV3PWRuqGedVl8
	 GdlansRxmJJAJWuPh8UnhAL4CWhAwV7tLWezz7C4EQYDZblVXKtPe3M3ARi+l8nIMa
	 nxSHimdnMMHLwqFszA1KkCVLWzleSyJMBvwY3pvas1ZJ1FlulyMGsEMXrIIkprNYyt
	 F0Yur0IGZyyIlFMM7TcJ5SxcuNtI/XKz7petWREOcPXndSzH8ylo0ojReXQ8D+mMKG
	 jzDB1d5FNsuzZ91yTSucdJ6+eriLLB2J87TMsfMNNa5T4JQVOS8UDQhlFMjv3dT9Bs
	 Sep0glrF6XeAg==
Date: Fri, 09 Oct 2026 16:47:58 -0700
Subject: [PATCH 09/26] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de,
 syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
 yun.zhou@windriver.com, linux-xfs@vger.kernel.org
Message-ID: <179158947530.3719791.2785151427381835148.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Yun Zhou <yun.zhou@windriver.com>

Source kernel commit: 41a28c865d1d5843f8cb9e0af17a8f4d9e2961ff

xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
xfs_trans_commit(), which flushes the CIL push workqueue internally.
If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
lock these buffers to fail them, causing a deadlock:

setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)

Remove the xfs_trans_bhold() calls so that commit releases the buffer
locks normally.  After the sync commit, re-acquire the buffers via
mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/stubs/xfs_mount.h |    3 +++
 libxfs/xfs_rtgroup.h     |    6 +++++-
 libxfs/xfs_sb.c          |   37 +++++++++++++++++--------------------
 3 files changed, 25 insertions(+), 21 deletions(-)


diff --git a/libxfs/stubs/xfs_mount.h b/libxfs/stubs/xfs_mount.h
index 0dea578ee3a550..26f7b8c7f30127 100644
--- a/libxfs/stubs/xfs_mount.h
+++ b/libxfs/stubs/xfs_mount.h
@@ -181,6 +181,9 @@ typedef struct xfs_mount {
 	uint64_t		m_metafile_resv_target;
 	uint64_t		m_metafile_resv_used;
 	uint64_t		m_metafile_resv_avail;
+
+	/* Always NULL, do not call xfs_sync_sb_buf! */
+	struct xfs_buf		*m_sb_bp, *m_rtsb_bp;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index c0b9f9f2c4131b..fca2eb74908caf 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 # define xfs_update_rtsb(bp, sb_bp)	((void)0)
-# define xfs_log_rtsb(tp, sb_bp)	(NULL)
+static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
+		const struct xfs_buf *sb_bp)
+{
+	return NULL;
+}
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ea99f8b5eee55a..ff4498662e693f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1468,36 +1468,33 @@ xfs_sync_sb_buf(
 	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
-	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
-	if (update_rtsb) {
-		rtsb_bp = xfs_log_rtsb(tp, bp);
-		if (rtsb_bp)
-			xfs_trans_bhold(tp, rtsb_bp);
-	}
+	if (update_rtsb)
+		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto out;
-	/*
-	 * write out the sb buffer to get the changes to disk
-	 */
-	error = xfs_bwrite(bp);
-	if (!error && rtsb_bp)
-		error = xfs_bwrite(rtsb_bp);
-out:
-	if (rtsb_bp)
-		xfs_buf_relse(rtsb_bp);
-	xfs_buf_relse(bp);
+		return error;
+
+	/* Re-acquire and write the sb and rtsb to disk. */
+	xfs_buf_lock(mp->m_sb_bp);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+	if (error)
+		return error;
+
+	if (update_rtsb && mp->m_rtsb_bp) {
+		xfs_buf_lock(mp->m_rtsb_bp);
+		error = xfs_bwrite(mp->m_rtsb_bp);
+		xfs_buf_unlock(mp->m_rtsb_bp);
+	}
+
 	return error;
 }
 

