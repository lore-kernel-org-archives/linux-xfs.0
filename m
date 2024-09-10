Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348254F218
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 04:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725942562; cv=none; b=ThpjAoLQuXWSXmjE49eHTsaHEoCLViSBFuASuyhwY0UNgnw2JkHwnIlkQXDGHjhE+qcBaG18LgYT/owWDMJk8NBPTg8TtOs3PlA4ZevjUXM1YdE56+yPkbhA1i/WUsnd1mSQRvUtkHQtgqjtFQ5Qa5/wiSgNAc+d1ZpqTMZzNj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725942562; c=relaxed/simple;
	bh=vibFHODPyXyrojWLXyyCmx+KZ5g1as08RQPHjKkL2U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0W4rfAUzJ2Fh9GtQaoFPawOJK2+hlcIcKAe46U2BRvrwChxeqiHKTp0POWi3WwhY+L2FLDtGXKwzJp2f5RMQTQ6RdHSXlOQw6omrplvFIlNlU0BeBIsrV1VEGWLuWtZfEimhHKm4e2QC2h49JY1h06pkBBQPEXIZ0spr4TOsnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x2qKpRMp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x2qKpRMp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3kx0Urg4gMKwHM6v/+uL6M0iwQfWAI2BoAoI4nak4rM=; b=x2qKpRMpkcP4zW7xz9sviGQ86Y
	Kz1AJC0C8gUeAP7VkC6rTeGYhXbJ0u8mwkahGidP0leTX0K8clvWpnu92iG3JY6ynGu5/apHru2uT
	99YZxjO2p0VVtCeJIuUfvc76jYmufcH13J10ZIkfT/8kl0JD2qOdwM9S2CPpK2PvFLsEKxBLS9XNZ
	rKwQcy4VKH3NEYZAUvnfE4ZgO0aSkLQL3kICw6oj2y7vX6EJLNLYVDlehcHUFiCtia7+/xdRJH9ah
	cMd6JBeUH+u4teul/1AKiiv4YONFRfJUSmXE7cZXArxSy6JcwbO8CkDynwrf7zMP1wApbIOClMbZj
	KBM+ZZhw==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snsVC-00000004D7U-1dbt;
	Tue, 10 Sep 2024 04:29:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: don't use __GFP_RETRY_MAYFAIL
Date: Tue, 10 Sep 2024 07:28:47 +0300
Message-ID: <20240910042855.3480387-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240910042855.3480387-1-hch@lst.de>
References: <20240910042855.3480387-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 3f695100d7ab58..f6c666a87dd393 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -289,7 +289,7 @@ xfs_initialize_perag(
 		return 0;
 
 	for (index = old_agcount; index < agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
-- 
2.45.2

