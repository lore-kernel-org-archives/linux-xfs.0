Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B34E76025
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534816; cv=none; b=DKb+qapa4Qr4QNND1/jFP0AJt4rnFOQHFvE++JEpy31cTnnUPBc8d6/LeMSqIhLWBv1FA6t9O+kGYEwmpzkuLGtq+aKDkf35HqwwgE6C1/syajrQvXmNhCB5+zlhkXH/2jXWathav+ZWKZLLxPvRcGfJ+GIh3saTdD91yYklr7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534816; c=relaxed/simple;
	bh=J6Leu8/NjO23GT58hVUMPeJM2l3c+SYzc021Q0VWY/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTKoLzgPwJBkfEvduFyRc65BtbWnUOim9pQ6ZhJxUjdPaEtbLUiKzQwBtcEtGBXYPi++T2y+4iYp4DlX9v4EsNWWO5zJvjU6FZYTIa7WLtddcK8xJUjlTRhTiT4a2hz/4G5PStT7121dP+EIbTBDrDwwEfxyeYvp4gh/OfGx+dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K1Dfyl6X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K1Dfyl6X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QobfccF+bzo+Z4/oCpc3aso3/9FbArdyguCNPPZZfCk=; b=K1Dfyl6XgdAYb0UFw7y4ThxnQF
	LUcLTMfarHyAK/FEnvqkhXnx7xCbaBnUSqmnCM6tUsXYNdgEDWebwqENR8J8w8wN+2erc9IvdhczV
	CMWLbYxqd/5W1NlhIHY4lxPlKvFryoykj4qS6oWBRmiHgsouT/92jDjI13MOS0oIurSE4Xq0IhrlF
	UeSoE/5Ji81S9wSA35LW3GQnL4eRTariNCnYQZiRnVuiTyr27laRLZ5zYtKdELcHe509jn4WrdcHd
	4ulwDbhILD8AyASw2ZhB1aiRlvFRgP25iD2oacUCYKUl5vZMqhovMfR6KR/R/QcFxPUMzurpLI9D5
	dzCh8sXg==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8b-00000002l9p-4B1D;
	Tue, 13 Aug 2024 07:40:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: don't free post-EOF blocks on read close
Date: Tue, 13 Aug 2024 09:39:38 +0200
Message-ID: <20240813073952.81360-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073952.81360-1-hch@lst.de>
References: <20240813073952.81360-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

When we have a workload that does open/read/close in parallel with other
allocation, the file becomes rapidly fragmented. This is due to close()
calling xfs_file_release() and removing the speculative preallocation
beyond EOF.

Add a check for a writable context to xfs_file_release to skip the
post-EOF block freeing (an the similarly pointless flushing on truncate
down).

Before:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 919
/mnt/scratch/file.1: 916
/mnt/scratch/file.2: 919
/mnt/scratch/file.3: 920
/mnt/scratch/file.4: 920
/mnt/scratch/file.5: 921
/mnt/scratch/file.6: 916
/mnt/scratch/file.7: 918

After:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 24
/mnt/scratch/file.1: 24
/mnt/scratch/file.2: 11
/mnt/scratch/file.3: 24
/mnt/scratch/file.4: 3
/mnt/scratch/file.5: 24
/mnt/scratch/file.6: 24
/mnt/scratch/file.7: 23

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: wordsmithing, fix commit message]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: ported to the new ->release code structure]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dae8dd1223550d..60424e64230743 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1217,12 +1217,18 @@ xfs_file_release(
 	 * There is no point in freeing blocks here for open but unlinked files
 	 * as they will be taken care of by the inactivation path soon.
 	 *
+	 * When releasing a read-only context, don't flush data or trim post-EOF
+	 * blocks.  This avoids open/read/close workloads from removing EOF
+	 * blocks that other writers depend upon to reduce fragmentation.
+	 *
 	 * If we can't get the iolock just skip truncating the blocks past EOF
 	 * because we could deadlock with the mmap_lock otherwise. We'll get
 	 * another chance to drop them once the last reference to the inode is
 	 * dropped, so we'll never leak blocks permanently.
 	 */
-	if (inode->i_nlink && xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+	if (inode->i_nlink &&
+	    (file->f_mode & FMODE_WRITE) &&
+	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip) &&
 		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
 			/*
-- 
2.43.0

