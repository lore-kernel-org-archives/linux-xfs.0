Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269368;
	b=HjEsTHaoTd51AwD4j/trtEWScv0WRr563WFua2F3quKZuQNdMmj09CSQ8fIJ5jGC7sT4
	 PSgpLARYqS5yPrNJjQMFkI3FYmtvgCj9S50I9FalrEd2W2aKljqf2fnU2eLsK87qw5p/O
	 5Azn3c5Hp6UY7ZC7NKyvgaUrk7EM7W2mubylhrINZxe75FLAuwLjp/cu4v1Y7f0YhkL3n
	 aJbuH8bTONgRumZBd9ZV5RJ3FwgOgGSmaA7kXaf9d5xySF5wu/39Tz0rC4y2vuophVUTS
	 vF7lWurX/9NvQf09YJaOGjMhY1lT7rptA7cfprlHYiSdIHaPg7eA+1qdilJiTjOdO6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=HSdZgf/qmN9IIZB/7PzhDcT4WA6NtrXeAtOLya0vzAo=;
	b=DzEJ18QmrseqwPHbOeMzqk9qDFygagfLm+7UxRuC+xeQuvRTyhGwKPdEUf6ZlZputI2f
	 QLOlEEt4dvI1FREOG03uHu+EwBc4KHdx5x4g1ns45Y6WfMRbKB2tKMpqfeb24NxAwW78n
	 wwBVfENF6kSriV7ZHlfwdCu/hGeETBu24YyC0VL2c30q3w3tBuKc8GsjIzGyzsCGrhGFR
	 I5X38IEZnyAl3MJL1dYI2XlcxhhgQ0E02vAMITG4maUFaKrEqHpa3q3SwwviU/ntdUjlL
	 iSFibdxxqR2+LNvLHW7H9kXmgLNZbAj1pRUEAJJaPH10yosgZKEj79pcsKG+4x5sYFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CU+/7mmf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087B606A321;
	Tue, 10 Nov 2026 00:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CU+/7mmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D321F008A2;
	Tue, 10 Nov 2026 00:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269368;
	bh=HSdZgf/qmN9IIZB/7PzhDcT4WA6NtrXeAtOLya0vzAo=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=CU+/7mmfMCCRKZzFBoa4Kn9uuES9tDvaDC0w5CctHckeKLjzJF86c4AvtTdWkr4Eg
	 38VwgfOShJOeApZWn/Db08b4T5s3k2KMuGxgYZYhgqZJcNfRgcHsizLCcr6exSnQvh
	 TzOg4N/l22AHtmwKkJHPFkdHfOvTifYhDyyGeUIbrQTJISL/JcF0jPr80kzyjn/FEl
	 845T3f9eiyVJ6Oty5STkl+ACsKquCI9dtsDDnIB2F/nK9v8Hn/BhQSKfIsVObm1pbL
	 B7yXQegObXRNwtwFy90B7XINVpwhgctH5nc3p0IJmlwsuGY/swhAioQ8x2qm/p1kHV
	 KoMBUI3MoBCFg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: mark the inode preallocated for pNFS write layouts past EOF" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:26 -0500
Message-ID: <20261110000926.3488149-1-sashal@kernel.org>
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

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-mark-the-inode-preallocated-for-pnfs-write-layou.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2195115f1551bbe4d4b69a6f57f9664b7208fb24
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
index ab385617003a2..a9f0b472f3076 100644
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
 
