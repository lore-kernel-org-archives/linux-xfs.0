Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519992;
	b=XYcJr27FQTrfxKkH6+9wgc1CLBzfMaxxLKF9FS0tgBXMZRK1nvNI5W9lvp7I1D6/CBpZ
	 S8lQss1KexbSv+0JPSA+tMU6MOwWduEEFYC3DEloua276x+so58lEm/o1nf5lY82UTw4h
	 S27Ag82LTrkAmpXqhmWQ/m6ZfxEd+Az90LYt/cRUiAY6kJs6BafmVWwMb6pbD9sy8+ExL
	 wlWwsVpuu46YAM8ONu2v7R6mUCUByvR7xLZCQfDwXUCy+QnMDjDAc1zgvBK5dRkmA3hrC
	 5XsluN2ZB+fJpkUbOZvUuCZH4MpAAJyzGOXOa/j5syUJgaqOPWYoT1hIvtUCRTUpT2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519992;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QR9m/svfIRjXnbqKqWOERF/bRhogZTRtjnHurWmfAk8=;
	b=BoWAzXNBtLgzn/ovko4NA04JN6YnMCyAu+3QI5K6GXLtrYevsdgksGnOn8uS0HvubmEI
	 NcP+719a5kZN4EsbToxCSp9Ua4QpRB8j3bmUiU6gshU5TXb5l/qdqOrpwBlGInysv1fN8
	 jicUmHtOFLwnYu96ztXD8hDJXEBufkTa+bUTqxb9K1HiDPR0l2Me5qgkpuGf64nfWUDp7
	 KTRIXYcv+vo7ZnActbu44tqLNqH6Wom7LRHvamvKCOy6OmRNdV30caBZ3QZZdZw9axCe1
	 tNF9mKEv/EpbiSzxV1J8mDnFuvIQMHn0ZBiR541eqTmq1PxzZVyQlGM9GMEAytDuIpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTn0Q9md;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B5E606A897;
	Thu, 12 Nov 2026 21:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTn0Q9md
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46D01F000CE;
	Thu, 12 Nov 2026 21:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519992;
	bh=QR9m/svfIRjXnbqKqWOERF/bRhogZTRtjnHurWmfAk8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=TTn0Q9mdPKNMmKmGtfwl+7/2rilMIByBC11VSwEvP/74zJvBWUOmENx98Kz3Vtb+Y
	 mo8xFCYdsBWVw8o5oNTVxGpTokIDzDZb69+eYmMgzdcrvZ2AupkTywfK+T09hPMOsa
	 8RvClI4O1qGyaz9wu+oSyZNGhIRefgS4qAcuNoxzWbBu8chy7WxtuNvhBFObkz67xA
	 le1j8ospKsCT49L04Gh72Vd0G3bm5oKvWHipfLC65ptDT7TVifyWGH7nnoCahTspsc
	 ctQ42rLSCafnz9X9W00wUutkfqTxRPvy6Ci0WJ90BXtq/8cHlM+mU+ZaP1NMm8ifMT
	 9M295EEdt5bKA==
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
Subject: [PATCH v9 14/14] xfs: test for realtime and reflink under the pNFS locks
Date: Thu, 12 Nov 2026 16:46:18 -0500
Message-ID: <20261112214604.67875-15-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
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

A pNFS client can write to blocks that its file shares with another
file, or that are no part of its file, if a LAYOUTGET races with a clone
or with FS_IOC_FSSETXATTR.

xfs_fs_map_blocks() hands out no layout for a reflinked or a realtime
inode, since the client writes in place and only knows the data device.
But it tests for both before it takes the IOLOCK, and both flags are set
under that lock:

    LAYOUTGET                           clone
    =========                           =====
                                        takes the IOLOCK
                                        breaks the layouts
    xfs_fs_map_blocks()
      sees no reflink flag
      waits for the IOLOCK
                                        sets the reflink flag
                                        shares the blocks
                                        drops the IOLOCK
      maps the shared blocks
    /* the client writes in place */

If FS_IOC_FSSETXATTR sets the realtime flag of an empty file instead,
the blocks come from the realtime device, and nfsd points the client at
the same address on the data device.

The fix used here is to test for both once the locks are held.

Fixes: e54b5bf9d7ae ("xfs: recognize the reflink feature bit")
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v8->v9:
    - New patch.

 fs/xfs/xfs_pnfs.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 065875c8b7da..945f7a3e11ca 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -147,21 +147,6 @@ xfs_fs_map_blocks(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	/*
-	 * We can't export inodes residing on the realtime device.  The realtime
-	 * device doesn't have a UUID to identify it, so the client has no way
-	 * to find it.
-	 */
-	if (XFS_IS_REALTIME_INODE(ip))
-		return -ENXIO;
-
-	/*
-	 * The pNFS block layout spec actually supports reflink like
-	 * functionality, but the Linux pNFS server doesn't implement it yet.
-	 */
-	if (xfs_is_reflink_inode(ip))
-		return -ENXIO;
-
 	/*
 	 * Lock out any other I/O before we flush and invalidate the pagecache,
 	 * and then hand out a layout to the remote system.  This is very
@@ -174,6 +159,23 @@ xfs_fs_map_blocks(
 	 */
 	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
+	/*
+	 * We can't export inodes residing on the realtime device.  The realtime
+	 * device doesn't have a UUID to identify it, so the client has no way
+	 * to find it.  The flag is set under the IOLOCK, so test only now.
+	 */
+	error = -ENXIO;
+	if (XFS_IS_REALTIME_INODE(ip))
+		goto out_unlock;
+
+	/*
+	 * The pNFS block layout spec actually supports reflink like
+	 * functionality, but the Linux pNFS server doesn't implement it yet.
+	 * This flag is set under the IOLOCK as well.
+	 */
+	if (xfs_is_reflink_inode(ip))
+		goto out_unlock;
+
 	error = -EINVAL;
 	limit = mp->m_super->s_maxbytes;
 	if (!write)
-- 
2.55.0

