Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3B120E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120968; cv=none; b=XFqfJqQTDOSyE/6W7qKxU1lJ3tB1+luXzLovV6l1OGDn8L2Esn8SNjSBuJ7510b+Zgcxw0Anxhw+Ma6MlIeNI/RC5Z6Di4OUEDi2uLKLgsrb19TRZ+fcITO/MunRb0Qz3WKUUdUjxHja+mefoIB5FDlD1nPCPaPFi7qKOqPB+KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120968; c=relaxed/simple;
	bh=xRwmoBrlTg/slmWpuDbPbxHOgFDrU5aR+P4B/7aRSCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1zRVDbw1v+NGZvpQtp7V+R5zkGcS1kbq6m5wrVFM7q/4NHAyGqO0Z+UYok2caroV63aNb1v5gMMBZ3SNHy8GbEKrYLpoCX34p+7TBGYVAgNsdH3+Gu874DV/z7Ak0r5WRYL8Ehl5aFJJc6YFleCTOzL4vQCmRc1Vajh+SxqMH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iv4RBopK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iv4RBopK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kn/Xqb36AvnmWyyN1R6nV4nu5NbV3uIfPpwFkKsFJws=; b=iv4RBopKsNlyuYpmT3rnpWe2BA
	AvaUPG4+Q9JaKktN983Vanab56TlERhQV55AeYuM4NLrA/L2KjC8WCDMnOdJBygSxAaGFfW9ldHsr
	lkDQTBRr/2WscDIpKB3RX0+XxGrUkPTtzxdztNGiYVwvEI//QIErE4VeuKuMsD6RTcwaqwE5Jah2M
	v/HUqTCvsd+uLohrFgRuFwSTAICvj32kE8rXvIDBFUzCb2Lw1DZgD/lZ2OZNXRD7kqd0zP4qf9Zl6
	ZFaP3sisAozmNwp1O23lV/I1MVzgAZEWjavML96/FQg/a/69vUKarbCHjPyQS9C4N6FG10QD9x7RI
	ZBCq7okA==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFtW-0000000DOJa-1iVD;
	Sun, 23 Jun 2024 05:36:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] xfs: check XFS_IDIRTY_RELEASE earlier in xfs_release_eofblocks
Date: Sun, 23 Jun 2024 07:34:53 +0200
Message-ID: <20240623053532.857496-9-hch@lst.de>
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

If the XFS_IDIRTY_RELEASE flag is set, we are not going to free
the eofblocks, so don't bother locking the inode or performing the
checks in xfs_can_free_eofblocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index de52aceabebc27..1903fa5568a37d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1245,9 +1245,9 @@ xfs_file_release(
 	 */
 	if (inode->i_nlink &&
 	    (file->f_mode & FMODE_WRITE) &&
+	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
+		if (xfs_can_free_eofblocks(ip)) {
 			xfs_free_eofblocks(ip);
 			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
 		}
-- 
2.43.0

