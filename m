Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DA473440
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534812; cv=none; b=PEu+8Jg6L9HX1zGqXMMiVD7fspmdi4T8uuMlTix4W6c99fcLf/6Hg2AHbERNvtojR0cm2iviL0J4jYr5R+ED5kqrEIg6MttIn1DiR6RAQdJXX+XcfL6uLh5eRC8ANJzeTOWR2YiRFNdXREcgbvPheAlSTumvptn1VgROhcmCv+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534812; c=relaxed/simple;
	bh=0Drdnd72/Ix05pIHUK0jr7RafWKeesBrsYreeJwOkh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmK4fWYXamFxaYh+GXF76S1ejVfevktozI9aStv1FpxCYtiedTYF7y4yEszQh9x86CApYvKnI7qDQhyHeXcwoz+jWuNjS7LP+7vD4M+shqQpct8VcI6RoJSrRLuHx1UbRlRkwhHFG5QInLXYWy9EdHnStLxcmqYYdKzNqRA17zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fteo9h1G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fteo9h1G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KTOgUjOmthP3IRDH+hOUuMpX3veZJQr7Ng4yG6l8TAg=; b=Fteo9h1GCI0ljqTj3PbUhJzGDh
	cXqOwT/4gHfEQb+uNaUuOc1sIzk8eZgrNDYcJsyF1gVdBeU/td1+L/BzyxC6bjsce3u8reRwCz0xm
	lKbTGiqPGUrxnB9hZE6Sj0jJvxu4JQ56hY8TgLkOMxZtWzwDpmc/IFRc1HgTG3dBatkz8aArLttuo
	NHn8pyaWbrr4ozdKH8TPlYgibvDtNmVRHjvGq6rr8SpI8EygY/LmjwRsxSU7RzgheQd7JiOBeqGI4
	mMAo9/FdMHcrotAhRXmiJpAKuWHhVflwzV6p2X9LQiAUnGIvOatxSZoyieUK1tl6FTCwfzzWr8zpr
	VoWzVxfQ==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8X-00000002l9S-45oQ;
	Tue, 13 Aug 2024 07:40:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: skip all of xfs_file_release when shut down
Date: Tue, 13 Aug 2024 09:39:37 +0200
Message-ID: <20240813073952.81360-5-hch@lst.de>
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

There is no point in trying to free post-EOF blocks when the file system
is shutdown, as it will just error out ASAP.  Instead return instantly
when xfs_file_release is called on a shut down file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 17dfbaca1c581c..dae8dd1223550d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1187,8 +1187,11 @@ xfs_file_release(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 
-	/* If this is a read-only mount, don't generate I/O */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount or the file system has been shut down,
+	 * don't generate I/O.
+	 */
+	if (xfs_is_readonly(mp) || xfs_is_shutdown(mp))
 		return 0;
 
 	/*
@@ -1200,8 +1203,7 @@ xfs_file_release(
 	 * is significantly reducing the time window where we'd otherwise be
 	 * exposed to that problem.
 	 */
-	if (!xfs_is_shutdown(mp) &&
-	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
+	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
 		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
 		if (ip->i_delayed_blks > 0)
 			filemap_flush(inode->i_mapping);
-- 
2.43.0

