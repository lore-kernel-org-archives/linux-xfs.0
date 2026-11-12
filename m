Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445376;
	b=CxjA3cPRlvSXrHQS7n6wJcwiYEBeoC7Zmb2BSY/GmDtKvnqX+QvU3SZQr3g3ObRTyDNl
	 ZKpQc+n6ikL6X21TtRedTylQZdrAd3a5U6GAdZOHJN+qyH+2p1vdzemzjGfnZBPDbHTvD
	 TcELs7vg4zd0sxsMIjAIkmlE1+K0NCemO29eem17sDF91ITQmyXzvsCBoRSRGo5qxRELa
	 eo6HcEeppxhQduFRmRd3Ij3+gFt50G6wEz4pxL3Y8HMzqWnv5s08BZndOFjn1WvzCJ/yF
	 QNEP1R2oLxPn2rHNoQFAsbplF5ZZ2+F2kzET4gqReJjdbf8EVNkX3wIhm1CFhPo3u2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445376;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lWCsyd4c0w948snICQ4xRIhBa6lv8yuoDr/rmjnMPJc=;
	b=335gpIW7F7X81tVl1g1S6I4cSbL+p/mKmuuhXZ7L28oL/WIUW1VKg/ieI14XHu7OF+vO
	 DmxFHeb0p7IKQJnySJaHtTATDazz8hNJLpEWDtMilAxGSHLU6Rz79WgGdESKVHuBveG7H
	 uaUWFe9U736Zte+YLb3DVGd10p+pmHhyAXeNj26/ln7nF/kt+8vWkzgv9y62I74iLmt6L
	 ePnoXowcqMST+DZvgLXVhtLz68gAOZzvx14BVmd8uKUUhIVY2OIYc9gt1oXoKrSCgi1mw
	 6pHCnOvGr1H3+3vZHHW3/VD81Gwv0sc1NxuspJG9xM4Jb1s4oMtjqNOYs3vlGoyFkEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6OjzaXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D69606A89D;
	Thu, 12 Nov 2026 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6OjzaXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896321F00A0A;
	Thu, 12 Nov 2026 01:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445375;
	bh=lWCsyd4c0w948snICQ4xRIhBa6lv8yuoDr/rmjnMPJc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=U6OjzaXfLnUIxTUPhpnvlvLajUQOlrBeyuJXD9tpj+8F66zV/hV7tiw3wIHmRYmjW
	 bwGvINgQO7EtHGT2sbSuoYuFcpiiT3wkVtjknyHo+0mvQDt2M4TJasIMiBexacnW/W
	 cMfmBEhh09kra+A0y91TSrgR1+hHfYSRbztCShj1EaXj+XydyfstNRTZXAll7id0Uw
	 Iil97bOGIWwnIs3HOLRS9yXjqU1T52/kfVX+mOTb43d/6jZXnyL5N7EigdmcBRBPdv
	 PS32FFJXRNVW6bkiu1/MPqNDesNU7MRVkp2kPdMc0cYgz69diwk1SZ408qqMw9IC4J
	 E5RmaHM7zjTWQ==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v8 14/15] xfs: resample the COW extsize hint after cycling ILOCK
Date: Wed, 11 Nov 2026 20:02:43 -0500
Message-ID: <20261112010229.51029-15-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A write fault on a shared extent of a file with an extent size hint, or
of a DAX file, can overrun its block reservation and shut down the
filesystem, if it races with a change of the COW extent size hint.

xfs_reflink_fill_cow_hole() sizes the reservation from the hint and
drops the ILOCK for xfs_trans_alloc_inode(), and the allocator reads the
hint again once the lock is back. But a write fault only holds the
MMAPLOCK, and FS_IOC_FSSETXATTR changes the hint without it:

    write fault                         FS_IOC_FSSETXATTR
    ===========                         =================
    xfs_reflink_fill_cow_hole()
      hint is 1 block
      dblocks = 1 + bmbt blocks
      xfs_iunlock()
                                        xfs_ilock(ILOCK_EXCL)
                                        hint = 4096 blocks
                                        xfs_iunlock(ILOCK_EXCL)
      xfs_trans_alloc_inode()
      xfs_bmapi_write()
        allocates 4096 blocks
        xfs_trans_mod_sb()
          t_blk_res_used > t_blk_res

The fix used here is to compare the hint with the one that sized the
reservation once the ILOCK is held again, and to start over if it has
changed.

Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v7->v8:
    - New patch.

 fs/xfs/xfs_reflink.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ff89516154bd..665ee75cd349 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -445,14 +445,17 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
+	xfs_extlen_t		cowextsz;
 	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
 	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
 
+retry:
+	cowextsz = xfs_get_cowextsz_hint(ip);
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
-		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
+		imap->br_blockcount, cowextsz);
 	if (XFS_IS_REALTIME_INODE(ip)) {
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		rblocks = resaligned;
@@ -471,6 +474,15 @@ xfs_reflink_fill_cow_hole(
 
 	*lockmode = XFS_ILOCK_EXCL;
 
+	/*
+	 * A write fault doesn't hold the IOLOCK, so the hint that sized the
+	 * reservation may have changed while we dropped the ILOCK.
+	 */
+	if (cowextsz != xfs_get_cowextsz_hint(ip)) {
+		xfs_trans_cancel(tp);
+		goto retry;
+	}
+
 	/*
 	 * The data fork mapping may have changed while we dropped the ILOCK
 	 * (a racing O_DIRECT writer under IOLOCK_SHARED can complete a full
-- 
2.55.0

