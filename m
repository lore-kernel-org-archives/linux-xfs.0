Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408092AD16
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287546; cv=none; b=DY1CPJOH1aP9Diq3O6U5VxJ5/TefB78I1VzwebfHuotCsVbi3mO5OcFEJR/y3GoDlgIotUPUUJAq8r9oiJEY1Eh6WaDbdiDlzaWOzjUqPId5XNcJp3cKcFz0WsZAhVfMMIkzSs8OvE1cwk3IJeaBIV6o6iV/BFGKzqEcX4FBcbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287546; c=relaxed/simple;
	bh=e2jFyOSaJ02UgToH27qJ9P4XpMl820XYBBGYA0EWlv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcDgfS+MMXMccTE4+76EYUIvFytlfHDsjS3sthiYCDK5Nn9T5ExP+JX8ltmGTcZ3LqDE3LU2eZ8uzJvPd7VSmbi6NC9VDIWjW39/bkN0TumLaOIh/z2j/gQRtSeqj89EG8W3UTiNKhJbEMFh/NxgFWmjSgO3fdvWj925jH5wns8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lzFeSJdz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lzFeSJdz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K4mgcDS2q9WdRaXv2zsdGjB/tHT8QQ2jQoVNOEv/s50=; b=lzFeSJdzzf3MFOgWjPzgcu/hOU
	yhjZuyKclcIV/WEfcbDbmniA+GE0+VL19blpHy2gX0o7oHBPRikYZhj8aWrsTrvrXcPyhB2APyspN
	v+XOvgywz0EQ0F2dAJxpjmX6Nva9MAdFaIaX1r1jO65bYuNWzEy2RTzGz2cDvqt8tP4qOfYErJ/6Q
	vKx8OAh+6lKlB0mwGv2U/EsbDeTaYNWjdO93t08/+aMP+vdIB7ZsTV20DGJrrrJaCFfeX19czca4q
	m83C9CDdE2DgkwQZ1FTYy8VxXUuZASApqdfgZgu2jHXmJBJxqCwRz3LJbOWuuqelg4X+M8hWxP6dq
	AaitUGqw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzauV-00000002x1B-3wpX;
	Fri, 19 Sep 2025 13:12:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/2] xfs: use bt_nr_sectors in xfs_dax_translate_range
Date: Fri, 19 Sep 2025 06:12:09 -0700
Message-ID: <20250919131222.802840-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250919131222.802840-1-hch@lst.de>
References: <20250919131222.802840-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Only ranges inside the file system can be translated, and the file system
can be smaller than the containing device.

Fixes: f4ed93037966 ("xfs: don't shut down the filesystem for media failures beyond end of log")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fbeddcac4792..b17672889942 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -165,7 +165,7 @@ xfs_dax_translate_range(
 	uint64_t		*bblen)
 {
 	u64			dev_start = btp->bt_dax_part_off;
-	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_len = BBTOB(btp->bt_nr_sectors);
 	u64			dev_end = dev_start + dev_len - 1;
 
 	/* Notify failure on the whole device. */
-- 
2.47.2

