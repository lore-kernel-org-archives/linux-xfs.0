Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240581;
	b=AXSjV8N5DUc2yvRnfhzwoLnjUnoFpJHK2Ncsi/mpbGsr56sQcaf7JPCjG+q1J3eNdUZC
	 MkVGK3neVWf9gEkfvuQ/1U4WRgKGNizy3dA+Zq0ib//0xbSNXw2FFXNH+Cm5hwUhIzxmw
	 A2LigjDKo3+cOnhiXhnyIYFlUlSBut4bYDsHCnnkqvPzjMwU3IxX9KfYRVjnu0ov+aUjh
	 KtW6boQj9yA0bjKWaGTOcpxlfXKDNwGbt3Bv/ULKyp7vIptY685fspvB/L7xnY7OhI/zm
	 taPDMMmYNhy1BM6kvFYX5u7DPFhHFQupLa9f/Aabn47kiqwXgW+P/xTK1RNLfjFN1EA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240581;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Yq9ZMI63qLBxY6PCPz2QYnd+8kkyUXHavGZL0xGjjCY=;
	b=tMaHg+ryD+dh7myLjJR8zAbJZcNCR3c+ZOC/HmLn+JruQGrHSNSDjVLGxwxPCJhZ2Z+Q
	 jtxNRKWfH/3BkzxuVRPX/670g323KV8uBbpp4rY7DAGj2AovzHRg5RG3p1IW8t0kY8UFM
	 QRQtHk/flyQU5bUlTM0csFreg7sQMGyTOujhTBDvwDcWZD6PHTGTaQunHQ4BVbEZd6enj
	 tSSogxcim1mlGVIawYZC0GE0OJLJ+K2VxPKWvdRAfKXfRgNFMKfCU9qGYCkjCx/EoJr2e
	 bGM2CcVdXv7XmXUtkyQ4t0/Hqmg8L8Ape5kBUXZuZ4ZPNE16lraemgXodjTV01QBA3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ghjxgpvj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD89606A31C;
	Thu, 29 Oct 2026 02:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ghjxgpvj
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240580;
	b=ff1oPXC+++hV4Vp0KisZoUp6OLevd59UBQUUrXM6039kKXzDPHcMTlOdPzdZKlp5vgpQ
	 5aCkkXHj2qTHGJddpkAvOWUhwJxc5WL8bwnUxCaSGl9E/LJhtoaS4xlcoTKUx8r72WmmL
	 BA+MEXfH4PS9rmfQ8XqnfbTQdCgSSziKd+drOPDF4zS3bhn7oZFwNE5f/oxpkAGeyETRM
	 rjmfEif+YnIwfSIfHxI92uyZtMqJYJ+/AXccWo9Xg2MMhdb+idU3uzgPiFbbMLy6MqxEh
	 t/Xh2j+94wcAgHuEk4HaVX/bs7fPoyKyX9IbM+8GOckArreB5aKVM2+dVX1gbBPNgyg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240580;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Yq9ZMI63qLBxY6PCPz2QYnd+8kkyUXHavGZL0xGjjCY=;
	b=JSihpMqkL57oiuWDMrbuNs1gZWIM5pU45Db00ifvFTgJEOrEdhX60sp7ip+Yp7fy+3zZ
	 ckeFSme6jUnAL/4RiHSQpmAk+A2jMa1IPizzfb4lrKOQbPWkawGn1v6bonf5Y3aPFj42B
	 Zycd440zf8o1TU7GHTJdQIKcnQzTLkn8bPD1Tjn5QvYIr+07bjqZmrvz7vMr1dSEXQ2AF
	 L6zeDLF3X9eoK78JmhdClIGfhSeyOPjxJM5NPEhlq5yVJF3tdarAbonsn6VO6M69hO4Vl
	 UUCqhpnOOd6+2sHGJSzHrjbVNLLjsKX9BWb0QtBelOYKdbn9VjVtoXBxSqPtsy5GVMw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 56A6F1F01828;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240580;
	bh=Yq9ZMI63qLBxY6PCPz2QYnd+8kkyUXHavGZL0xGjjCY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GhjxgpvjolSMkddJHnkVjlMC+Qbi/qNG5KMg07h7MAIT3nn0VpGU0V4RXUEc+OpqC
	 p3OdldMh7GgrndWcD4C3yS4L+WJscL6gu96wfDfBlSBo8TTWUR8Xg6vOYLIJkQarFY
	 ECQjih/Oryw2PSwUlcEPahO7mxh54W5obMNGQMdY2fjwsfKbRzRGUaBomqqsATkXsl
	 7I1xd1LO42tL1hZN+drvB4jmgPpOWbMzP4YqqMwi/MhYh9ogA0+rBpcTU6/DT1CN/I
	 dgekANGmpGcOxm70JS9G2yn48zS/K1ssXbym6NR0vxsIsmNTZKNAl4rJu9uvq3iTar
	 zbnPfc5XxELpQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BA08C4565D;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:22:58 +0900
Subject: [PATCH v5 1/9] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
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
Message-Id: <20261029-xfs-pnfs-batch-v5-1-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=2926;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=kvFEFezOANEyZWN5ZCau+9zPRqpo+E4KT/cLw0ydxqg=;
 b=TNS9tSsfIvPlGozoNoKjdfiaX+bseqNCBxknIWQoDmw8RhUBFz+53foAC0u20iHlPXF/BsN/j
 fUjhyVj5gLTDIzjG+dgeSXc9aAbMKo5tSDhwqYUA85zzUneM7VVJxs7
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC only when it
allocates blocks for a write layout. A write layout past EOF can also
hand out allocated blocks, such as speculative preallocation. blockgc
then frees them under the layout, and another file may get them.

Mark the inode whenever a write mapping ends past EOF.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Reported-by: Chuck Lever <cel@kernel.org>
Link: https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
---
Tested with pynfs: blockgc freed 960 KiB under an RW layout, and the
client's write then replaced 978944 bytes of files written meanwhile.
With this, the blocks stay and the LAYOUTCOMMIT succeeds.
---
 fs/xfs/xfs_pnfs.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ab38561700..a9f0b472f3 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -110,7 +110,15 @@ xfs_fs_map_update_inode(
 	ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/*
+	 * Force the log so that the blocks handed out to the client are
+	 * guaranteed to be present even after a server crash.
+	 */
+	return xfs_log_force_inode(ip);
 }
 
 /*
@@ -134,6 +142,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -221,20 +230,27 @@ xfs_fs_map_blocks(
 				end_fsb - offset_fsb, 0, &imap, &seq);
 		if (error)
 			goto out_unlock;
+		update_inode = true;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 
 		/*
-		 * Ensure the next transaction is committed synchronously so
-		 * that the blocks allocated and handed out to the client are
-		 * guaranteed to be present even after a server crash.
+		 * Blocks past EOF that were allocated for buffered writes, such
+		 * as speculative preallocation, can be freed by
+		 * xfs_free_eofblocks() without breaking the layout unless the
+		 * inode is marked as preallocated. Mark it before handing them
+		 * out for writing, as for blocks allocated above.
 		 */
+		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
+		    imap.br_startoff + imap.br_blockcount >
+		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			update_inode = true;
+	}
+
+	if (update_inode) {
 		error = xfs_fs_map_update_inode(ip);
-		if (!error)
-			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
-
-	} else {
-		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 

-- 
2.43.0


