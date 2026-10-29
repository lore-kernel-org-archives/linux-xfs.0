Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275802;
	b=d9hVamsa5ZYVLurz70N1oAbV2e+1iKhKX5Fs4eAZNbcLkvOLQJ9eSgzJTCALUgolKe1Z
	 qpUWhl5hqBjhroYp+f1JWsrQnyM09dpR4AXJkZOPRI+drtqFyIpqWae3Wyqq2RUhnFZnc
	 076tExzr3C1bWyGksGE4gVfexYnuyau/vrf+fl5TU0y+Z6afHfrdBdV3r/s3nYkgdbEcJ
	 WvjvEzNndCmduRtZWFMC9EOH9vgPc/X9frHQc6xz32gBL+q2yJCzLYwffRNBSgCdsFXvb
	 AxBUy9XSfjvXNw6YEGJwcbDCMqh7BrTTqtCcUAyZ+TsMc+K3fYfzVFsTRhwmaNBRfpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WxALu7wRQN6zYCNxaUR/NOHgzJaMGHKB7nBjoQUFEAE=;
	b=AQ9pjchl2T7jMGj1XCYEcAvRNrnaVFOPVum1XVsw1O4v/wVr0XwFDZ/tWO7WqEIVNM03
	 5WGyDiNsjmaVC7wMO664/DmTGOQA7+kjG06O/AoRQoL2eKxP9KeH7UOYFChhJwk+qlZHE
	 A+0tWXeqJXtUB5qIW2KZOF+LsjD+MYinFWCgeipBYC3vjuktG5CpPhmhsmdlqONrgrD76
	 NmRFJbZHNqKD8webysNvl7vW3lZBt9O0JFuQqWfnTYvc+gxxdTsSclnwwvaoHblF/6Poh
	 hpXhDYKreKeJ9MonPDV6mhB6c8nktZ3IAHGszF3syV/q1SQ00bovIn7nPzdKKW6UP5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="J7tE/x63";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69666606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J7tE/x63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357041F01828;
	Thu, 29 Oct 2026 12:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275802;
	bh=WxALu7wRQN6zYCNxaUR/NOHgzJaMGHKB7nBjoQUFEAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7tE/x63REhZyCdrF44QcQdlaCkvSd2xJD4jzV6fzj1MAES9jXIh7IAFFqXj3soZD
	 4ecdiGKaE7on2tPHED1jExZUx1JFVdfZRPN+nzV4pFcTPVajomyibYSA+wTwAjy1f1
	 yIgk2QR6ed4idrF/iIqGVx1D3F3MtO28P3fKTaf3X6m85OhOW1nk6FTNZml0V2Tbkd
	 BScsANmatACx71jHYbAHgpDgp8O7l3rtq5lSU6WHWN5hx2ly6JEEYCkNHZlPre+B/e
	 OVG53uTJPa1CM/QKihipw4NGhmWSnxTyAxfyrpKOF2ms55/LoVirxZqND2bPUTiFa4
	 vBsKUBIHqAysg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 09/28] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Thu, 29 Oct 2026 13:06:06 +0100
Message-ID: <20261029120631.803074-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 libxfs/stubs/xfs_mount.h |  4 ++++
 libxfs/xfs_rtgroup.h     |  6 +++++-
 libxfs/xfs_sb.c          | 37 +++++++++++++++++--------------------
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/libxfs/stubs/xfs_mount.h b/libxfs/stubs/xfs_mount.h
index 0dea578ee3a5..5ccf2cf9544e 100644
--- a/libxfs/stubs/xfs_mount.h
+++ b/libxfs/stubs/xfs_mount.h
@@ -181,6 +181,10 @@ typedef struct xfs_mount {
 	uint64_t		m_metafile_resv_target;
 	uint64_t		m_metafile_resv_used;
 	uint64_t		m_metafile_resv_avail;
+
+	/* Always NULL in userspace, do not call xfs_sync_sb_buf! */
+	struct xfs_buf		*m_sb_bp;
+	struct xfs_buf		*m_rtsb_bp;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index c0b9f9f2c413..fca2eb74908c 100644
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
index aae63ccdb6b5..9f5924660a77 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1469,36 +1469,33 @@ xfs_sync_sb_buf(
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
 
-- 
2.54.0

