Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714896;
	b=i6VQ2Gyx5Fakujs3gLNzpQCokbWUeue5x1TyMJO+gcU1u7y9th0JYRUj09eUQbXMmKrD
	 RvFzrQqzobtusCDSt/3gwJJYGtzLrlPdJfYKUKP5OR8PC8LIx/ET0yQzkrtKqPvPcpjrq
	 CDQcy6mN2hRUIlyw8/OgYeDnBJLMpIARmB0um8OJohVEmIJO5kBVZDdVvjG42OCHCDGdj
	 mDN10VZr3JcpwzrNzTjEfGQsG9354tC7v6KPKfMXZORDQ7e4zirin0Yalpq5PzuHVC0IV
	 LXqpwtBHpF4GTMBYCIJLIKu9zf9gu6iF8Y08OpYwfaf65IpKZMUxkkeivcXnpRxkJOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714896;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-SRS-Rewrite;
	bh=7cfCkUzPD9T3QchB6R7FTN2TL6jI1u9mcAOxdVYVoXw=;
	b=tPaGoA/ABFLh04VvU2tgXBWy94mdUHIXMPlfZLW7jdy+nQLOi3z/nV/c1HVVXBbsvILe
	 r4rzOavG2G6B9GcrcMuT62SA6KQBybpBouExU70VYg9jlA+wOg/I4KHCUGBppaZ6a+ymH
	 VD37nAuh8nxStmZ5DwNpHZEEc4Yx7UiUmRJWH7n9fVLMaXIr/p6ETJL23q8XiNPNY+OJu
	 EIjMLRkWuKfWvBoN/Qetk1eXxuNZcA377U6LSv9O6Qp31wuGQqc6YtcmidM/lHP7xCVi8
	 av2mc2uYYMNhUlWNz36aRawfdmcSVoeDYnme4tjFde6bNl901ED1eo27Sjpq4vB655g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=loIWOiOf;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9204606A337
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 14:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9204606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=loIWOiOf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7cfCkUzPD9T3QchB6R7FTN2TL6jI1u9mcAOxdVYVoXw=; b=loIWOiOfCWnDeERPvb5/Yzd99v
	vyFQIa2GhsWzKXXebqHTnmVi46XHrVhjrJgUGWLqHcUjJIqcC890Zay0siEWByjaz47cHlDQIpZqJ
	jFOeYWT7RQXalMRRC+pXu63jEELyVCQvx9YDiW68rvwvrydDyYNCV+oFFS3bHmyX0yuKh+kGo6rMq
	V6RqDrvpbb+UlL/PWu30wX04BxueeJH5VGzH5XBeALAmhJxEJQmcvpMjF8taOtPWhYu49EghCyucv
	1QSgR00JS9qs4A1tQSGv4pfjobHYTd7qVPzUm2MNUgXmrw3Y2G27V1dFmvPBjfuCKplcZT/w1hRVS
	y1St/pEw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFBO-00000002gCW-00HL;
	Tue, 03 Nov 2026 14:08:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.opensource@gmail.com>
Subject: [PATCH] xfs: always call xfs_update_stable_writes in xfs_ioctl_setattr_xflags
Date: Tue,  3 Nov 2026 15:08:09 +0100
Message-ID: <20261103140809.3794376-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently xfs_update_stable_writes() is never called when the RT flag is
flipped because xfs_ioctl_setattr_xflags() updates ip->i_diflags before
comparing the rtflag variable to XFS_IS_REALTIME_INODE(ip), and thus
the stable flag can be set incorretly when flipping the realtime bit
on an existing file.

Fix this by unconditionally calling xfs_update_stable_writes for regular
files.

Fixes: d528a6c1d4b6 ("xfs: data checksums require stable writes")
Reported-by: Wilfred Mallawa <wilfred.opensource@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..36ba609a2593 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -595,7 +595,7 @@ xfs_ioctl_setattr_xflags(
 	 * Make the stable writes flag match that of the device the inode
 	 * resides on when flipping the RT flag.
 	 */
-	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+	if (S_ISREG(VFS_I(ip)->i_mode))
 		xfs_update_stable_writes(ip);
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-- 
2.53.0

