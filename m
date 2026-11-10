Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270123;
	b=dpmjfpNNymvuSwqi27SFaH5Lstr5VV/HvFZmI2cCog42K6u73Zt1HRfOZ1YVpNgNterY
	 F50tXl8FieZPSah9Hv9TbE4BQrKe7qpkABhLkvaTn3IyV6BnCzsLgWFaYCis0QQGwc4P7
	 yQqTGuWVA1alozRM0lsuz1wkcwEzUISEQvfOKNc5dBSjY070n1ihOjDujOBC8J/URlIfw
	 zTB+9OjyYUrCtgr1T/6MB2S3x944rXJzs5ujZ62AMPK9msbyIVXhQYv+j4fBq71flLBHs
	 Q16e0FmvkIrL7rleydBPSBUQ/3hFymEVsg2dONw7rNLYl8ysgDKz1hAzHncEZrk+g+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=2J64EBFRklmHgVPBtbnylPOybqEX3QonMWfpADLSB+E=;
	b=QHSsyz7g/f0lQfHq8VCcWllhj+BZmfGKVb9Tt3U10+jEI2MR3zu4gNGvJ5G5kHmtz2Yn
	 +G3kfxW13xp47vR0oqb9tqszeazqiLJgVypJsbN5As8sf/4gHZLMZ7t49s3CU8uJbBH5m
	 S4vmj/A9/vhC2zEroXqXtUfLrOeUkCcFGeTnSWb22StLBzFzhF8vBpY3L7nowchT04wzh
	 xHmtEj+jZh2r0bpvoFllAY1EtEesEfNWkknkhwnJ71QA+1Tb7hdTnv87FyD+bEAi/bvkM
	 xAYkcAadAtRAJoEM7WifIcfhlarW+jUx8/YnzFbZevhZ8/czuh1w9EXEbPd/wgsrWMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1wz4ksr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A54606A31C;
	Tue, 10 Nov 2026 00:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1wz4ksr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1033A1F0089F;
	Tue, 10 Nov 2026 00:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270122;
	bh=2J64EBFRklmHgVPBtbnylPOybqEX3QonMWfpADLSB+E=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=N1wz4ksrQwdD7Y1nF/kfiRDvSy2Ms0LLtH0KbxUlqYeidPgdBxaVD4MNmuwJh6zB4
	 cL4cMieQTYsxlbfg97e6XT2f0tBSnfLGtlrlzrgFvD24mFjdbs8z+s8taTMUSUMFrA
	 qOFbYXR9Z//h/SAH9HelbeHID6fgr8ZhTjgHHqnIa409pHuy+ttP694Sdzs8CqYku7
	 XKzGmC524AQ67Sel1tYbk0DZCZW0GOGXBWG+u7Ckqngr0Xk9SJoUElb5uj2ku7su9L
	 po0t8ma4KxIC5qXxojjuO6KEnOz0SNjhICHHNrW8hap9No4yOxCjv1r/SZgvU+8tP4
	 CdYcsYUBPd/Mg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: mark the inode preallocated for pNFS write layouts past EOF" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:22:00 -0500
Message-ID: <20261110002200.3505549-1-sashal@kernel.org>
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

    xfs: mark the inode preallocated for pNFS write layouts past EOF

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-mark-the-inode-preallocated-for-pnfs-write-layou.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 55e88c74391a9b0c0ca2e31c5e7a957289eaec3f
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:22:58 2026 +0900

    xfs: mark the inode preallocated for pNFS write layouts past EOF
    
    [ Upstream commit 8b8e265991556d99b6d721697f148975a7c68767 ]
    
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
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 1b0b739571612..ef08f0f619f70 100644
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
@@ -135,6 +143,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -203,20 +212,27 @@ xfs_fs_map_blocks(
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
 
