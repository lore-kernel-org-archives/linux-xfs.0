Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC8413777E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885932; cv=none; b=T1VcPBmBtq0LL5H6MlVYmxSpwid5kKQ+fb2dKp3gxyOcFRXDYGBNhTwo2cctFCKVBf1idy+2F/HmY7dqwHhzU7bRV9K7mzCJba7ilabDfntN83O7bukF9ssbg73T/DuKD8/q+0Vm816dCsueSeA336rydYKawNZt5NhL5QUxvP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885932; c=relaxed/simple;
	bh=7D2ZHkhpcNOR/t+O4ulMEOLRH6d6IIkoiG9BBWar8/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH0EVD69tkoheaWi5uUytWKc7C2OJIw2t3KCdk7qo9Dk3+oMvsgqG9A+slo0ScRd3E/y5PeP4E7CJqK3ewk/hlWDhm+Zgt/4ePG79K/HIOhuLglPguG6I7+rVob2wvgSw1B8qDUwXp8IpCsfUzERAWjifQMmWlRBwLq+dfN3sUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UP0njcwC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UP0njcwC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pDE7nRHJWUtM4PRYCV7r3lajZi2j7oE5Hi3dAdUu8jw=; b=UP0njcwCHuYjqwEY8Ew08EcY+c
	FslkhJe4+hIRCKTzDp0XVH6+fDV26uj9osBezZtagc4auAnxW4ATHYpVV8/PQj8zY1wLQ4BhxOnzb
	IQVg74JTSzG8Ad96kalkE4GjP+ujWWYKUdBvS2bch3xrh9AQd5rYxwO2NpGfuOiO2EBSiN+wVZBPm
	DfckPIDCAe+s2eNSDU6tCQjJQTDaV2pibGGM/JvJCSHOIy6tgb2R2v84Ny1PYHm47Q6IBsDQZGVjN
	tmpQOVJuDJ82aTKJOHDiNI4CEzlZMuLVkVch1bB5FBLTmoSQL7fzm+HYnpwiGMoNqY8Z3lg2EN0dw
	YkhBhfCg==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ECw-00000003peq-2ofZ;
	Mon, 14 Oct 2024 06:05:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: error out when a superblock buffer update reduces the agcount
Date: Mon, 14 Oct 2024 08:04:53 +0200
Message-ID: <20241014060516.245606-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014060516.245606-1-hch@lst.de>
References: <20241014060516.245606-1-hch@lst.de>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index edf1162a8c9dd0..a839ff5dcaa908 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -713,6 +713,11 @@ xlog_recover_do_primary_sb_buffer(
 	 */
 	xfs_sb_from_disk(&mp->m_sb, dsb);
 
+	if (mp->m_sb.sb_agcount < orig_agcount) {
+		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.
-- 
2.45.2

