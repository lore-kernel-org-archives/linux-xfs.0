Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795657957;
	b=IGI7/vsQZ/7dNMVXypc2k2mFboxDN1d+1SxeJkcztBIzuN1uh8S825GjfI7mhAhRa3DE
	 VJ/Ra1c3X8h65r1X+DOkbe0F2wUdf8lj957RnNcDoJkvI9hvbOCFPwXQPZDkHmzfRGzcB
	 KiT03a6j/VLANS2swyxNtgasIidteH7l/kSmvqIZ/XL1Gg+qG1glfXjf1oBsl4Hqiz2tF
	 kN9X7rxJs9ikZKxJHqZJxM1xariRH6+1EfLFCCd71z8WqSUo8jX4eDQ+nuM2m/uIpWuC5
	 vqx9zrjJjqa22hDxl+pTcsWFEgmDPYc2Ybl6/xLKUWz93uki2Gh56SFwnUCUyiNqNMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657957;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dWCjJZ3Shq53Quzo8dulZttUT1lx1SSneksXpJWVxRE=;
	b=x8/4iiu7DW1OogxE2G8QE+RrMrLTabNWBj0LNBXibEzRVmviTP+7wUyZxjhQGR09v0G7
	 R726kL8FbAquJYOMRav0xgiIaT/QOSjtm0VHQ9OLT/Ip3Xmivkh5iv6OqbSd5AgcPY4RC
	 OTuZGQPyUOZWua0eOo9IMp2PAPLySzIozU+Zh0Do3kIrFbzq6MOp9zUNC4WyP3FIKQYsj
	 2xI0Baedk6cCabZarooc0N9QVCb+WPJft7F3SRnqHJqsTVFzYQ3p7X9fmn1TJH4TYugwU
	 YdgVizE51Abq1AztS5gPa7y55Ox0Ss15DQ6+l67Kaice7yYpQFZi//Iw9npcASzOoDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loPkFd9M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642E5606A338;
	Thu, 26 Nov 2026 01:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loPkFd9M
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795657956;
	b=vrpWpzP6TsHmPcqr92UOZrMwhO4sVvLbDnF7R9GEVpBPncsdVIHSSguGfEovf4D0Fydx
	 K6umM+/FHDbvREveh04+tjXZZkXusoZOXiPl02kMqQmSwXfs0QxWblN9Te/QVAQXPYMO0
	 NW3MMB2UozZh6GhDuEVv5hu3d1BlOb+TQ0MQO5AJCgb6mAABwkZzyPdHR4a38B29cRCok
	 AGZAHuAqzuQ92AIB6Ski5HmiDr1vUOyewwywiQcNOULxf8NYwphDa786rsdhw5UauEWl9
	 9Ss5mJeQs+vOZga3Y8Ncj3Q46qs3dUHTRRCM+udCGmPNnIt1DEwg1R5SuvwlGrTol8Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795657956;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dWCjJZ3Shq53Quzo8dulZttUT1lx1SSneksXpJWVxRE=;
	b=krmfTUTl/2w7FypeKDUFZ4Dw3vDzAVEEDagn+23Lme0sjm+0i4l/gAePVRC+lIoi59ne
	 EtpvC+PzDvH86aQJBrT2FLstUl6mCsXP7Uam3L/B7dS135/HqpENvx7D8Lvd3KD5ZLPRF
	 5dQYwUQjb0G65zQGhN1vEjyY4ox7Bl1T3oKc8a0oAXdtHFw5RYBKH28pOceIkQ002gin4
	 KaQNPhuLvTl5gpdb6rgMn3stBD+J6vobhbAaSMY1BjGlZP/EDeJOqEa5G0+JxEPjFFucP
	 NJz2+ySEvL8sVfiYDaTsI4LJEwQ6g88Ylr3dwgb/Wfucw7hqG7L+IunceLQ2eZx+f3A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AFDF21F000CF;
	Thu, 26 Nov 2026 01:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795657956;
	bh=dWCjJZ3Shq53Quzo8dulZttUT1lx1SSneksXpJWVxRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=loPkFd9MpoJQGhmWflpxjTCQ6qbNvI7Fd2Lq6jcLsDVc49lCljjPdE8tlOKncT/28
	 W7KbTFkqXcoLf5B5Q3SpcHgnQ8tIYElHLUd1t+lM/mHENTOS9VN+NDcY4//MUH4c3m
	 9Dn5LAiWoV413gyM1Hk3dp33JHXwlk1vyr77cn6ksNNM5JMVy7gV3OGSr1d/PZP6fI
	 P6jIVMyBAkE8+AgwkIVZRL2seSlrG24gxJ0sc82F2KVrCdeoP4C6+XJAYeGTNJrx2y
	 S4toDpFhTWtb4SaORaOqXXAr+Znz8ukyoNuOQUazp09jHxw7A6+yAGuus/DhEqyrQv
	 Ba9jWL8U3TpMw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 366CB4D171;
	Thu, 26 Nov 2026 01:52:25 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 26 Nov 2026 10:52:25 +0900
Subject: [PATCH v2 1/2] xfs: factor the mapping of one pNFS extent out of
 xfs_fs_map_blocks()
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261126-xfs-nfsd-map-blocks-v2-1-6d85b1388739@samsung.com>
References: <20261126-xfs-nfsd-map-blocks-v2-0-6d85b1388739@samsung.com>
In-Reply-To: <20261126-xfs-nfsd-map-blocks-v2-0-6d85b1388739@samsung.com>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795657944; l=6438;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=LbAnNAneOGzHgP5YEL5LZU8hkVcZI2YdvmZ1qH3H1no=;
 b=fBQ5f75Kco5k8yOS0YcINvvUfjxQyYlVTcUXHnd38mo0nX1bX2Vn8K7UQZ7Zm94MifUu4AkMp
 nl3ccCSYuNXCl3GtNNBd9y2d7AKR48nauQpBX43Hf793XcNmQaS2jBr
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Move the part of xfs_fs_map_blocks() that maps one extent of a pNFS
layout into a new helper, xfs_fs_map_extent(). The helper also
allocates the extent first if it is a hole in a write layout. The next
patch calls it once for each extent of a layout.

No change in behavior.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_pnfs.c | 137 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 80 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 4a6c1a399d7..39d1c5271a7 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -122,6 +122,74 @@ xfs_fs_map_update_inode(
 	return xfs_log_force_inode(ip, false, NULL);
 }
 
+/*
+ * Map the extent of a pNFS layout that starts at @offset_fsb, allocating it
+ * first if it is a hole in a write layout, and set *@update_inode if it
+ * allocated. The mapping may end before or after @end. Called with the iolock
+ * and the invalidate lock held.
+ */
+static int
+xfs_fs_map_extent(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	loff_t			end,
+	bool			write,
+	struct xfs_bmbt_irec	*imap,
+	u64			*seq,
+	bool			*update_inode)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)end);
+	int			nimaps = 1;
+	uint			lock_flags;
+	int			error;
+
+	lock_flags = xfs_ilock_data_map_shared(ip);
+	/*
+	 * Map to the end of the extent that covers the start of the range,
+	 * so that a client doing I/O in pieces gets a layout it can use for
+	 * the pieces that follow.  Never map anything before the start of
+	 * the range: nfsd calls in here once per extent of a LAYOUTGET, for
+	 * the range that is left after the previous extent, and the mapping
+	 * can change in between, so a mapping that reaches back can overlap
+	 * one already in the layout.  Don't extend the mapping past EOF
+	 * beyond the range either: xfs_free_eofblocks() can free blocks past
+	 * EOF without breaking the layout.
+	 */
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				imap, &nimaps, XFS_BMAPI_ENTIRE);
+	if (error) {
+		xfs_iunlock(ip, lock_flags);
+		return error;
+	}
+	if (nimaps)
+		xfs_trim_extent(imap, offset_fsb,
+				max_t(xfs_fileoff_t, end_fsb,
+				      XFS_B_TO_FSB(mp, XFS_ISIZE(ip))) -
+				offset_fsb);
+	*seq = xfs_iomap_inode_sequence(ip, 0);
+
+	ASSERT(!nimaps || imap->br_startblock != DELAYSTARTBLOCK);
+
+	if (!write || (nimaps && imap->br_startblock != HOLESTARTBLOCK)) {
+		xfs_iunlock(ip, lock_flags);
+		return 0;
+	}
+
+	if (end > XFS_ISIZE(ip))
+		end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
+	else if (nimaps)
+		end_fsb = min(end_fsb, imap->br_startoff + imap->br_blockcount);
+	xfs_iunlock(ip, lock_flags);
+
+	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb, 0,
+			imap, seq);
+	if (error)
+		return error;
+	*update_inode = true;
+	return 0;
+}
+
 /*
  * Get a layout for the pNFS client.
  */
@@ -137,10 +205,7 @@ xfs_fs_map_blocks(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	imap;
-	xfs_fileoff_t		offset_fsb, end_fsb;
 	loff_t			limit;
-	int			nimaps = 1;
-	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
 	bool			update_inode = false;
@@ -205,64 +270,22 @@ xfs_fs_map_blocks(
 				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
 				LLONG_MAX, NULL);
 
-	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
-	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	error = xfs_fs_map_extent(ip, XFS_B_TO_FSBT(mp, offset),
+			offset + length, write, &imap, &seq, &update_inode);
+	if (error)
+		goto out_unlock;
 
-	lock_flags = xfs_ilock_data_map_shared(ip);
 	/*
-	 * Map to the end of the extent that covers the start of the range,
-	 * so that a client doing I/O in pieces gets a layout it can use for
-	 * the pieces that follow.  Never map anything before the start of
-	 * the range: nfsd calls in here once per extent of a LAYOUTGET, for
-	 * the range that is left after the previous extent, and the mapping
-	 * can change in between, so a mapping that reaches back can overlap
-	 * one already in the layout.  Don't extend the mapping past EOF
-	 * beyond the range either: xfs_free_eofblocks() can free blocks past
-	 * EOF without breaking the layout.
+	 * Blocks past EOF that were allocated for buffered writes, such as
+	 * speculative preallocation, can be freed by xfs_free_eofblocks()
+	 * without breaking the layout unless the inode is marked as
+	 * preallocated. Mark it before handing them out for writing, as for
+	 * blocks allocated above.
 	 */
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, XFS_BMAPI_ENTIRE);
-	if (error) {
-		xfs_iunlock(ip, lock_flags);
-		goto out_unlock;
-	}
-	if (nimaps)
-		xfs_trim_extent(&imap, offset_fsb,
-				max_t(xfs_fileoff_t, end_fsb,
-				      XFS_B_TO_FSB(mp, XFS_ISIZE(ip))) -
-				offset_fsb);
-	seq = xfs_iomap_inode_sequence(ip, 0);
-
-	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
-
-	if (write && (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
-		if (offset + length > XFS_ISIZE(ip))
-			end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
-		else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
-			end_fsb = min(end_fsb, imap.br_startoff +
-					       imap.br_blockcount);
-		xfs_iunlock(ip, lock_flags);
-
-		error = xfs_iomap_write_direct(ip, offset_fsb,
-				end_fsb - offset_fsb, 0, &imap, &seq);
-		if (error)
-			goto out_unlock;
+	if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
+	    imap.br_startoff + imap.br_blockcount >
+	    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
 		update_inode = true;
-	} else {
-		xfs_iunlock(ip, lock_flags);
-
-		/*
-		 * Blocks past EOF that were allocated for buffered writes, such
-		 * as speculative preallocation, can be freed by
-		 * xfs_free_eofblocks() without breaking the layout unless the
-		 * inode is marked as preallocated. Mark it before handing them
-		 * out for writing, as for blocks allocated above.
-		 */
-		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
-		    imap.br_startoff + imap.br_blockcount >
-		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
-			update_inode = true;
-	}
 
 	if (update_inode) {
 		error = xfs_fs_map_update_inode(ip);

-- 
2.43.0


