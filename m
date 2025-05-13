Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA79F27442
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 05:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747114267; cv=none; b=hAqxBJs3FPX7bUt2AAPFaurkC63CbgU14LS0MfbRbzVuDwQZuzo6IpSS8iExKem/LM/g3gh6AwxNj8Ic9/Bt/u/47AINa+Vd7KQGTwp2KGBfaD7pJcS7hv267J0EtVHhEuh7gM+pbt8LA1/2XIej/PUP5Z0xsYxLyKojUr543eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747114267; c=relaxed/simple;
	bh=WtgVHMPeqvEO7V2cNhxzM8aB3uZLEoWkmyvUl8ncLBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fUYqpbk6uBLw/AqU/ZuVr5hEdf+nhMazFPI1UZAsuX8LjlNQbbd3kRJ5DjM/m+Awy68riP5jbzLBDZI6EPY20hfly6u/sqs7ndwLLsG5vTXRhsflbUUvGqVXsx+gnlMt1AN0aFdssFLEc5sedDQfmkJs8adEbNQLjQgpUPkK/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O6VZCDm7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O6VZCDm7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hL4h1WhlnRWgawyeTRtyV5ruqzXQU0z3vzwzkzyOf6g=; b=O6VZCDm7nRZcIVDn/+IFK9lyU1
	4Spmhvid5d20TzD2+FUdy4733uvxRS9N0j4SGJFRfHMKCuSDzXVcsv3IdVF34FGvY3wEOlfmKKGUR
	aYQe9nZimJiiP9ijw8x0+EnwHThEiU6hvaZKH9ra/DFAY1nHxx2yV+tVHUe2PS0xRk9pj5V0/Ga6l
	/VNdSvXMjzUzXeG2VEiwGUzlCU5UQhfSoVCxVvk0S9sUu1SHhAaTKRj84vf4/32cHc8NCPzgHvjHP
	zCGwHgvZgtqy0Pya5EkwpOfXYE0sgp7VT5fQem/r7MnDHn0S/xTXsRr5VffRpdUuSTEUQEEQyfpRy
	6hQ3NI0Q==;
Received: from 2a02-8389-2341-5b80-3c00-8f88-6e38-56f1.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3c00:8f88:6e38:56f1] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEiEK-0000000BOZg-33LA;
	Tue, 13 May 2025 05:31:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove the EXPERIMENTAL warning for pNFS
Date: Tue, 13 May 2025 07:30:33 +0200
Message-ID: <20250513053102.757788-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The pNFS layout support has been around for 10 years without major
issues, drop the EXPERIMENTAL warning.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

This is ontop of "xfs: remove some EXPERIMENTAL warnings" from Darrick.

 fs/xfs/xfs_message.c | 4 ----
 fs/xfs/xfs_message.h | 1 -
 fs/xfs/xfs_pnfs.c    | 2 --
 3 files changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 54fc5ada519c..19aba2c3d525 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -141,10 +141,6 @@ xfs_warn_experimental(
 		const char		*name;
 		long			opstate;
 	} features[] = {
-		[XFS_EXPERIMENTAL_PNFS] = {
-			.opstate	= XFS_OPSTATE_WARNED_PNFS,
-			.name		= "pNFS",
-		},
 		[XFS_EXPERIMENTAL_SHRINK] = {
 			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
 			.name		= "online shrink",
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bce9942f394a..d68e72379f9d 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -91,7 +91,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 			       const char *fmt, ...);
 
 enum xfs_experimental_feat {
-	XFS_EXPERIMENTAL_PNFS,
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
 	XFS_EXPERIMENTAL_LBS,
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 6f4479deac6d..afe7497012d4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -58,8 +58,6 @@ xfs_fs_get_uuid(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PNFS);
-
 	if (*len < sizeof(uuid_t))
 		return -EINVAL;
 
-- 
2.47.2

