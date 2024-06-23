Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F37720E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120960; cv=none; b=DkSX39qbiMsbgt6AKZWY9429a8kZnc2MnQr6llyHebMJC284hWCQOBiTv4B/vngODoxMVwvkjAbgU6tSMoKqqNPf9IbiT8nVF8eKMTrULKCdMXKnigqJo5oKjOzAWSUVE/YcXE8xLHDM6Ku5pWLQIFOwq2GwyMcOApoQc1+PDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120960; c=relaxed/simple;
	bh=FjthGtxobfOfKC1lXtoGcz2HsyNzP4KVwehkR3dVjuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCtjY2yydUiKZNyawZsDpQKCxyIUcQdIScfhqX92+CJQmgbNCW5rixYY8aUp+bJW/A8LpdlCpllWhMEdsk7IKn5KRYEb8Vhwc38SgQBkzcDL+Nw2q9OnW9qMoUUtQ+Fx1xJXUcLixWb6H91IMrF3B5LBZlpMkOmPPfVceTx0Uz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PL1HP8AU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PL1HP8AU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kE7LVIEANSoFbS2XZcfOuC0Wpv4C7XA/HLyg/AVpzxU=; b=PL1HP8AUbk8ViQN1FsKOqPDO2W
	fp2LkKDwLkq++aXCQPrtiluzNAYgl9myZ4Y/eTjdKWIbKq6vLigHSoZVSh6+FW+Ffx2/0atoWl2Bs
	4p8QMeilVpzeWxSQGEUrFcLlI2H8pws2FAiUgFWZIO2AVPLCkIr1y6bEVXxGu7oWy52xQeBRwYq+P
	ilPShF1kSByv+tYQgSercyUS6bHCQhtKpR+MOGTtTidXc95gASBWXZ8M/NOd7hejqsnKvJW+G1Z39
	UBIu2/x3nLE1iuXBm2cUK77Vl9teKaXzDT06b8iUMBzdE/+ZzWWNJpoR/BAVFgeU+/XqNaZIoMegp
	K34cZK/Q==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFtN-0000000DOHI-3yaV;
	Sun, 23 Jun 2024 05:35:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: don't free post-EOF blocks on read close
Date: Sun, 23 Jun 2024 07:34:51 +0200
Message-ID: <20240623053532.857496-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
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
---
 fs/xfs/xfs_file.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0380e0b1d9c6c7..8d70171678fe24 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1228,12 +1228,18 @@ xfs_file_release(
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

