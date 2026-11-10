Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271114;
	b=Cm4zZvkeOF8ZDH91o2NU1osGjgGBpOmiBH2mW25FI3aQaig05GrCd6r6fDpq0IuDbB3g
	 jmvldan+xS5axs2KzFpZG0BB+2p8HfcQZOsjZDA0q/FN3FRhXQgz7nLwx9nR+WU6KRM1p
	 dsXIUJe5OyLlI7Ls1Bg5nZZasm5IhflP0e3YxNQqxbBPYv2XjnxwJ15hfPP9rTDWEUuZ3
	 i4NeqFcFkw4vtJarrRFioqpdM73WOE5lvoKqri7e2cdl1Or6M/5EXNJsojiRf17v7F0I0
	 mqYDpkNKcorHq1U8joqR+DH13uhXV8yaDVpdhWhh6A79o0+nN5wUzpe8SCNyuX7uV2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=iBdX3nzPsZYnpNylYigcCXCt+BrTA4qldD4VEN8H74M=;
	b=4A4Lv6iZASE4cU5ud/mdZ3iqzRq55HteBtFeoEPL7e7qkh+kFuXuOaByiOOgtRIscopk
	 qw0UyD/SdVpX/igPZkIex1pfLEoy0+aHpvwukmgBswoL9iGmUzWAYVCsPCgftF63jsPfn
	 J805gI4LPp22W4oya9J3UJrrAV9M+RuMAvEPuSxtSnkXnKfQVeQ9oecOFt3Q3hRpp/Ezj
	 8KdhbtAJbPtPuD1bw0JHPqlyHopuUdCtdObzX7HPjk1tx/zAurRA3rgd5ePGkmVzDDDGG
	 VrX1FfVfgk/KjP70VbpJbX/LbB6FZVHJlIJoE3WkHxG5EH/7Ju7BZvCZBNL2us4vY8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uo8pMJYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C16606A31C;
	Tue, 10 Nov 2026 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uo8pMJYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9A61F0089F;
	Tue, 10 Nov 2026 00:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271113;
	bh=iBdX3nzPsZYnpNylYigcCXCt+BrTA4qldD4VEN8H74M=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Uo8pMJYrz4mKk+4eA8dUrM9ksWxoissakSd/hOe676fiuAh8aS7wSR8cyLM9hGvoi
	 1kiBp0shAKvuvGQkatCE+nGFtNKErCMEhve+jMP1oNjVVhol5PQdnkSSuuTfBL+0ie
	 8cw3mU6uHuWjiNXFhXbAekTdT6p169Yh89ZsXUUdDtyP6lUh+yOcOmdmVEUN5m/jXn
	 lEIHJ4QJ/ZWKx8nBfuUCxJH164ejyTrPOCaVtYup3OrfR33+HnYp/VeiJe3UhUrYrg
	 BOyJ6MhhPohM07YhzKN3abIU4PFhve8WahtkT0sMxHr7uPJ9PYcgoV7kYzRBt98hDj
	 wjK7u3biSupZQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: mark the inode preallocated for pNFS write layouts past EOF" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:31 -0500
Message-ID: <20261110003831.3527779-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-mark-the-inode-preallocated-for-pnfs-write-layou.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit b759035eccf3f31db12829cc6ccbd0c77dfd0cbe
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
index 23d16186e1a34..ca3d085a3e781 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -101,7 +101,15 @@ xfs_fs_map_update_inode(
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
@@ -126,6 +134,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -194,20 +203,27 @@ xfs_fs_map_blocks(
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
 
