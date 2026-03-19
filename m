Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A809921ABC9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 01:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883029; cv=none; b=LwxPwwOJCEV/LOGcjlXh/zNy6MALFFjD8DOebXDGQfKcGrqW6SYqeAEqw4AFmj8uk2VJPhSvzUWEF80oDbfMQ2PT0GIV91IuPfdke28uA3FJRkDystXxeCRMiHsp1qhCP3OSGoa4Frt7o4iA9kFIQGS3n4hdIw7iztMkqqZ3Ils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883029; c=relaxed/simple;
	bh=3/Kd3CiWU7zqLydVlbTlZK3t6V4qmME8c1RtfvmdgSE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iLHCD43nxFVz4wl3B3yucRMkNQiMossmJKXa1eU0/YBoqMiQ+7/poyBMxZrQg55ohTfK3ksb6IP+0Fa8KK1El19NInHbcbM1m+m3EO1Y0aza++GuhYox+8fVwqmN+kAFR93cOQiLPq6tWbhkTHc3AXSZs+aLz7JH8F1ENevjT7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=TLaklm/6; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="TLaklm/6"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0HjkSxxnfQzPAyGTO0mn6GMjbXbXXpX42eiJQvpFgag=;
	b=TLaklm/6bK2rpiHg/Z9hsC9/8nwFfWLKJDD34bhNSlk1eovPX41Nm2ENn8IV/VPyLmDt8aX5k
	/RRQy2wxbms+B0GDBI2KFJNBf/z+0za/1Z1tvoiwtUMVNz5lfTUD1gZ5XIMfBAsrDJftMwTH9X3
	lS5sJ9UYX98c9uhsb3Xd+wA=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fbnhh24rmznTWY;
	Thu, 19 Mar 2026 09:11:32 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 99D07402AB;
	Thu, 19 Mar 2026 09:17:03 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Mar 2026 09:17:03 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 19 Mar
 2026 09:17:02 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 0/3] xfs: fixes and clean up for attr item
Date: Thu, 19 Mar 2026 09:06:15 +0800
Message-ID: <20260319010618.722448-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn100013.china.huawei.com (7.202.194.116)

This patch set fixes and cleans up several minor issues in the attr item.

V1->V2:
- Fix ip is not initialized issuse in patch-1
- Add the reproduction script in patch-2.
- Delete only the redundant code, and leave the rest unchanged in patch-3.

Long Li (3):
  xfs: fix possible null pointer dereference in xfs_attri_recover_work
  xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
  xfs: remove redundant validation in xlog_recover_attri_commit_pass2

 fs/xfs/xfs_attr_item.c | 53 ++++--------------------------------------
 1 file changed, 4 insertions(+), 49 deletions(-)

-- 
2.39.2

