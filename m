Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D37346797
	for <linux-xfs@vger.kernel.org>; Sat, 18 Apr 2026 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776505205; cv=none; b=i/0X66na6U90hLQjbdZfmOv3VDP7+XX3/Uj/SVeWGfTpbiHj68yy/ZRefA2UI2KcflVk34Wz1EntDP2tIP3QRG/fJh1QLmDDAHEsSkSZD7uajzkGLyw5YOJUSbE+mvIJbc5IISILEsI319U7XWnQ1QSjCFm5pIJ2kRgLBUEhWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776505205; c=relaxed/simple;
	bh=WkLRT8I9Ze+Rx1QO/xRH1reJiAwoGDZA7SEji7DZ2jc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=angJXagFEiFKdpikgAlvQJYPn8KK6aApZM/wyf4Suf/g/WXLMiS65Fg1dyhT9PqJU4Y/0TjslXID8KnUXuvtAZ+ux49xKrZFtxNyz3X59OOCZtTwq7pGvHVwV8453Krur+38rEgXDk2KqxCf6gYdpebZmRTzCfYxJ9jLhuP/3zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=MkP1KYC4; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="MkP1KYC4"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LoPqTAZMc1Gk2Yu3oS18RYFkFTKn16AftkoyF9yTj4Q=;
	b=MkP1KYC4IvBR+L1C379wzzXqVWbpws9ia38I7h97UsYTVL7diMWwqm61oPmvhIX1p8enhIhFm
	46PkUtHX8oArbCPiwBxoFcKS/D/l5YA0F9pIzGQHSJFuTYhBfS/WS6tOKOHxicBA5KhrhXYuBP6
	xVtttq++FplNezF+8cKdE7k=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fyRQ747pVzLlYJ;
	Sat, 18 Apr 2026 17:33:35 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 04D1A40571;
	Sat, 18 Apr 2026 17:39:55 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Apr 2026 17:39:54 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 18 Apr
 2026 17:39:54 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 1/3] xfs: handle ERR_PTR return from bio_split in xfs_buf_submit_bio
Date: Sat, 18 Apr 2026 17:27:13 +0800
Message-ID: <20260418092715.375850-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260418092715.375850-1-leo.lilong@huawei.com>
References: <20260418092715.375850-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

bio_split() now returns ERR_PTR() on failure rather than NULL.
xfs_buf_submit_bio() currently ignores the return value and
dereferences it unconditionally, which will crash on error.

Add an IS_ERR() check after bio_split(). On failure, flush the plug
to dispatch any already-chained split bios, then call bio_endio()
with BLK_STS_IOERR on the parent bio. Because bio_chain() increments
the parent's bi_remaining for each chained child, the end_io callback
fires only after all children complete, propagating the error back to
xfs_buf through the normal path.

Fixes: e546fe1da9bd ("block: Rework bio_split() return value")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_buf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 580d40a5ee57..fda215dd00df 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1268,6 +1268,12 @@ xfs_buf_submit_bio(
 
 		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
 				&fs_bio_set);
+		if (IS_ERR(split)) {
+			blk_finish_plug(&plug);
+			bio->bi_status = BLK_STS_IOERR;
+			bio_endio(bio);
+			return;
+		}
 		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 		bio_chain(split, bio);
 		submit_bio(split);
-- 
2.39.2

