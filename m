Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E64347503
	for <linux-xfs@vger.kernel.org>; Sat, 18 Apr 2026 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776505205; cv=none; b=F79odfEpDiBZqtGOXDhwTU7Ktj07moIZeomUz7NBCKgrfeg5DKngP5shdHRoHTceTPynWpPoTvCYTh/xI+28wvI5669dZE1xSzBSIYaBnOhYYoQsQaVSpA2uQ5hvROm4W7qO51akd6y+NChSPSKiN2X4hcEUJj5T0FCXq56oq44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776505205; c=relaxed/simple;
	bh=t6jvuL5zoGaYEbb+Yr7Eu1qLqG0NR6my8zO7RwTqT6U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZkoaPl6gocrHvqpNHJO7vNfZyUN88QkZM2Zu5iZA2y7KQPdkEArtEZ0O1oRwbQ7wAZnNt5gXhH0pabS/ovXlDr9P0F/e1NjD0rIfve0U22eQCJ4egZdF2s2kOeppv5sC8d3uoV583soPtPdEaon2IdHosPEevu1JpJiRx8jbCDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=pLTnpCzx; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="pLTnpCzx"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rlkIORG5UGaOZ9AIajE3sViVZCHtv8J6zJM8r6vh+cw=;
	b=pLTnpCzxbjF3f9N6u5fKM52Au5soNDDhg2a07anGCXhVNy7B6xromygh3VciQ1ZMCxDS0S1IN
	U3/26ZqW2Sm5qzoLK0sY8nmZE9iGuAndNxhiYj/nQITKD7HnbAl0fhUtsmsdp0h06gnw1pv1bOo
	4uF8D5cRL6Ioa7oSqk3wd7s=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fyRQ93VyGz1K980;
	Sat, 18 Apr 2026 17:33:37 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B6494056C;
	Sat, 18 Apr 2026 17:39:55 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Apr 2026 17:39:55 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 18 Apr
 2026 17:39:54 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 2/3] xfs: handle ERR_PTR return from bio_split in xlog_write_iclog
Date: Sat, 18 Apr 2026 17:27:14 +0800
Message-ID: <20260418092715.375850-3-leo.lilong@huawei.com>
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

bio_split() now returns ERR_PTR() on failure. xlog_write_iclog()
currently ignores the return value and dereferences it unconditionally,
which will crash on error.

Add an IS_ERR() check after bio_split(). On failure, fall through to
the existing shutdown path, consistent with how the blkdev_issue_flush()
failure is handled in the same function.

Fixes: e546fe1da9bd ("block: Rework bio_split() return value")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..bacc46c53760 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1619,6 +1619,8 @@ xlog_write_iclog(
 
 		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
 				  GFP_NOIO, &fs_bio_set);
+		if (IS_ERR(split))
+			goto shutdown;
 		bio_chain(split, &iclog->ic_bio);
 		submit_bio(split);
 
-- 
2.39.2

