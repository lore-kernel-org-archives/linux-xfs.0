Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2669A192B66
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714555; cv=none; b=TKGqyPEFHTtACw7vC7cKxksZnceQGyLt7CLmp8bpuPXBYJQLi6PgKXvJavv+pWVNhF8tKSE357/H1tR/OwL7U/XlGSf3Dp0bo6awJOvKqM6/FcXTAPhIr2q88K9SBNg3wgij6UsQkDaPdYhA6bKCXgmuQhTY9WD/690x0LCcDoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714555; c=relaxed/simple;
	bh=csiXkm9vLYpB/wDtTKOPdLshfjYMThFeas4O33vo+Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBoQQQmspT1h5FUMc/vfjXleNgWY9WXsbluZ+zLNmctVF+tTamrFPAu+EA2Qg67uRiYwLy8tKBUE2YcbpSuuHN/t/IHoD3dqlS5evOhfPGSJW362cD0pUjZ9zaRPIyaERTUaB+MLH2BuG7TXYxVX5VChY/0AQCHnf4X8jDBDUC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DRJ1jEli; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DRJ1jEli"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZmN5qUZnIFtGEoSl8QZXsDwkoBiJZHzhE9f0dF+Kq+0=; b=DRJ1jEliUuYqSFdjY/GVs760+C
	+koST6Gr/HJqh5gs+TZGXE5W7BCOqiIqv0RJlpyvsr/1TL/n8WkKo3bPteA0487MnfHCMWO2aH4M4
	6SkEZPT8OIbnbE0ApKxfpBMg+btdleOYccXBTBOmCHwmk8Vir/ICVrI+xLg0wsmdfno9szb9REX82
	bXrHrX4I052gJ5MbypmltQuTLI5lmLEeQO82xh4r16qass3aGDbroz2KotRx5j0T4B594M1mr47xS
	e60xKho9x6E+kx9j1Pxk41VitI0p60SeP0JJEpGHYTrv6BMrdixfZHlFQu4580J38EDEMBP5nJAqB
	wVTopkQQ==;
Received: from 2a02-8389-2341-5b80-2b91-e1b6-c99c-08ea.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2b91:e1b6:c99c:8ea] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svJTl-00000000GZZ-17YQ;
	Mon, 30 Sep 2024 16:42:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: error out when a superblock buffer updates reduces the agcount
Date: Mon, 30 Sep 2024 18:41:45 +0200
Message-ID: <20240930164211.2357358-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930164211.2357358-1-hch@lst.de>
References: <20240930164211.2357358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS currently does not support reducing the agcount, so error out if
a logged sb buffer tries to shrink the agcount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 03701409c7dcd6..3b5cd240bb62ef 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3343,6 +3343,10 @@ xlog_recover_update_agcount(
 	int				error;
 
 	xfs_sb_from_disk(&mp->m_sb, dsb);
+	if (mp->m_sb.sb_agcount < old_agcount) {
+		xfs_alert(mp, "Shrinking AG count in log recovery");
+		return -EFSCORRUPTED;
+	}
 	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
 			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
-- 
2.45.2

