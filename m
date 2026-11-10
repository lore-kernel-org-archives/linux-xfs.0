Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269373;
	b=GYIM/ySkg3gnGP+WQOKTfqlpA4eV1qogJPg3QxqFTe9ALOyIiIdfjabarW17Iv/VU2y1
	 ztD2RRf4WgliK+2nWHbkdPNxUsREw7AXRG4MEgbEcfArrzyV3oPYccxtjLarW+kQrrJ/9
	 xyZiwsD2YPorp2sdy1lUL86HBFcn6e4WK7yMBzvVITldq63PoAD4uBmU5jPEtEZeOiF6g
	 GN7YElsVjiFIH7DTpEG4ITUgM7Zvwqp6kvasrER2zliRC+y8EPqNxpMgzK81VFc0uxJz4
	 /8VHpJqaB6jZtTjM9CDbZ4s5TN4tiUPV5J9moN0cPFKlx8yiv5wTW5CZ9/lgRwi3Zqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=qMpsMUsW3szS7AeVMxGmM6BMHQUSHjeCPFgccu4DhTE=;
	b=EZWnedwJdz0I+Qc8YWVa8t33CTubojogQNM9+DgtEMwyVCGGmCJVyilHZf4i1xtx+paG
	 kBBfrD+GbNJ8bCA9uGv4dNHyVkueil9Et5qtGNAkRBJ6Y3RoTKh83zizJQadRFBMi7rb2
	 LJBHvQZNBCM4z7JbDt4jhmoCOFB2iDArOkuRzRDm5P3JNtR+3AiH9KaYYP17XcFsQ1wXy
	 d5pelb1MSirAbSK5RQTrIkhVyfY4Wb+O+GnjsfUl58xQ3Q6FLS94NsrkN5btbXJW0PCDV
	 3XYSEhp1Dy4zHd3OERNjAjzZ6PCF/EW20V0gIMnVvEB6wmMBdKSxxzwmBFI4cgcYtTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DQ0/Gjpx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAE3606A31C;
	Tue, 10 Nov 2026 00:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQ0/Gjpx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260111F0089F;
	Tue, 10 Nov 2026 00:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269372;
	bh=qMpsMUsW3szS7AeVMxGmM6BMHQUSHjeCPFgccu4DhTE=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=DQ0/GjpxauzG/5lAARH5KCdFg5g3GZOPar7UbB7slOcAJa2tRVLd+kociAXMxOuuh
	 5EszaMGmoORMBDaGFzZkQr81csqYFPOFhUd+XRFOb0wgL/20qF1FgQchqSOH/GjZT8
	 QlFs0IqVA8bObjAipRh5UoXSJdJAf2Ofu1dee7Zt9Z/uZm5w6MSZzRl+UBXzBD1GNO
	 ZKy1BcqoZVc46SprT22nkNkWd2g6gUCIJbEpdYRwlycdsvW/BzI5uTv7j/0Di9KuyS
	 m32jZixATVooOlwK386Rw1+Vi05wkozAG71qieXy+faOdnlb64GWc2BupcK4hdUETd
	 x98DLT5eLtHag==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:30 -0500
Message-ID: <20261110000931.3488276-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-refuse-a-pnfs-layoutcommit-of-a-range-without-bl.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 0e73260ccd0e6722aa0688107e15995c067c0b1e
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:00 2026 +0900

    xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
    
    [ Upstream commit bcf0b7f18ad11e1d410e82ffef678705eff0a317 ]
    
    A client can commit a hole in a LAYOUTCOMMIT, because nfsd does not
    check the extents against its layouts. xfs_iomap_write_unwritten() then
    allocates written blocks there. A large hole overruns the block
    reservation and shuts XFS down. A small one exposes stale data.
    
    Refuse such a range with -EIO, using XFS_BMAPI_CONVERT_ONLY.
    
    Link: https://lore.kernel.org/r/20261014130834.GB15773@lst.de
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca9..59bd9a24b3eff 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -668,7 +668,7 @@ xfs_dio_write_end_io(
 	 * they are converted.
 	 */
 	if (flags & IOMAP_DIO_UNWRITTEN) {
-		error = xfs_iomap_write_unwritten(ip, offset, size, true);
+		error = xfs_iomap_write_unwritten(ip, offset, size, true, 0);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 40695d18dac08..aced9a023db1d 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -102,7 +102,7 @@ xfs_end_ioend_write(
 	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
-		error = xfs_iomap_write_unwritten(ip, offset, size, false);
+		error = xfs_iomap_write_unwritten(ip, offset, size, false, 0);
 
 	if (!error &&
 	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c6238fed61e4..93826ca74b6be 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -614,7 +614,8 @@ xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	xfs_off_t	count,
-	bool		update_isize)
+	bool		update_isize,
+	uint32_t	bmapi_flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -676,8 +677,21 @@ xfs_iomap_write_unwritten(
 		 */
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-					XFS_BMAPI_CONVERT, resblks, &imap,
-					&nimaps);
+					XFS_BMAPI_CONVERT | bmapi_flags,
+					resblks, &imap, &nimaps);
+		if (error == -ENOSR && (bmapi_flags & XFS_BMAPI_CONVERT_ONLY)) {
+			/*
+			 * Nothing was mapped: the rest of the range starts
+			 * with a hole or a delalloc extent. Nothing was
+			 * changed either, but xfs_iext_count_extend() may
+			 * have logged the inode, and cancelling a dirty
+			 * transaction shuts the filesystem down. Commit it,
+			 * as xfs_alloc_file_space() does on -ENOSR.
+			 */
+			error = xfs_trans_commit(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error ? error : -EIO;
+		}
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f2520a9b3a13e..8fc0c6fc8bea5 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -15,7 +15,8 @@ struct xfs_zone_alloc_ctx;
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
-int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
+int xfs_iomap_write_unwritten(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t count, bool update_isize, uint32_t bmapi_flags);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a9f0b472f3076..7ff83274a5135 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -344,7 +344,14 @@ xfs_fs_commit_blocks(
 					(end - 1) >> PAGE_SHIFT);
 		WARN_ON_ONCE(error);
 
-		error = xfs_iomap_write_unwritten(ip, start, length, false);
+		/*
+		 * A client may only write to blocks that a layout handed out,
+		 * and xfs_fs_map_blocks() allocates blocks for any hole in a
+		 * write layout, so refuse to allocate blocks for a hole or a
+		 * delalloc extent in the committed range.
+		 */
+		error = xfs_iomap_write_unwritten(ip, start, length, false,
+				XFS_BMAPI_CONVERT_ONLY);
 		if (error)
 			goto out_drop_iolock;
 	}
