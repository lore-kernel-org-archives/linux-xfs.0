Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC34C58ABF
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534823; cv=none; b=hlP7N0erkMnqdOh3fOMByWAXm37zBICOxe3vdkZBfOhCBRS4uDO8iTx6/bVGoT4047FJHy7jVPNOlOBao/p4VK6I7j98JKpHI77Yk4hGXuJXLzdAjhAecgnoFpG20KrIioF78yYyOSHL7a6FvO04h1RoUkbz5zsWF6qOh/rgqaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534823; c=relaxed/simple;
	bh=zGEcu+2Ivl0BseYmA0etc4/tyxn0EJRyCKPWqU/PXeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Elw5RmnCGCXUHAlZyIY688XqC6j+feOf+fRk5oU5Ky0dThU2effI7ipskMEkYMDZuJeEOXKacZgabjyJi3n0TFacef2rm2wP042vcCJuO2wlWwWxIPmk4mDFVgv5Jdkc2MPnayzmNpZztAtaLaTSGoIDHRLlEqWTiVF7LUlmlUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ddfonv2J; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ddfonv2J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5V7XlQxY7gcnXWKqYjiJ/vZtW2JFilicOMNs6wdcGgs=; b=Ddfonv2JvdBUM6AIAxUCCuopxd
	Av9XKmH/O1IZfQnGVU/LtLwC8BZ0FpO9Zn9MDDgSIbKq9NiUGoylAZtxJ9aUZfa3p7Lb2P5CK+1Yr
	0Mpa1zio/5FV9K6iQYnhRY86Dmtof7UwvjUNH5WfsgcWBkvXlCO//Db3elIxo2Evror8/LYZaOu7y
	qcMq7zBcccCEC9vbOM69TOtTGKCdHqk6X5iwYbluEQo1WYHvnJY7zajOSOEAsL58RP4OsmdjeaxaL
	Idjve0R5M0BpyoU4ZxQezD/E4EewE5kyLqgz1qBr/CzOh+60epXgfQFRNx7ypCqKjb6l9Qqwoupvf
	MthA3Bbw==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8j-00000002lC1-3gdT;
	Tue, 13 Aug 2024 07:40:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: check XFS_EOFBLOCKS_RELEASED earlier in xfs_release_eofblocks
Date: Tue, 13 Aug 2024 09:39:40 +0200
Message-ID: <20240813073952.81360-8-hch@lst.de>
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

If the XFS_EOFBLOCKS_RELEASED flag is set, we are not going to free the
eofblocks, so don't bother locking the inode or performing the checks in
xfs_can_free_eofblocks.  Also switch to a test_and_set operation once
the iolock has been acquire so that only the caller that sets it actually
frees the post-EOF blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 30b553ac8f56bb..986448d1ff3c0c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1234,12 +1234,11 @@ xfs_file_release(
 	 */
 	if (inode->i_nlink &&
 	    (file->f_mode & FMODE_WRITE) &&
+	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
+		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
 			xfs_free_eofblocks(ip);
-			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
-		}
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 
-- 
2.43.0

