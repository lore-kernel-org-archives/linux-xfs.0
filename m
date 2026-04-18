Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682733F58D
	for <linux-xfs@vger.kernel.org>; Sat, 18 Apr 2026 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776505204; cv=none; b=hL36VFZ5Zmq/1ib+rf5DbBLPm0iD/954UEnTCOlA+kvP2VUG68sangLwBu+IzuriJ1p8L4crNL8ee8s0PK0EDeQK8ymITb7XdyDbbCNOSYSYfTyowmVKmxITPuhBTc2UNYXh4ZFBpwTwmUYU9w8admKa7+/GrauD8D1WGGURZHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776505204; c=relaxed/simple;
	bh=NJM0UrWncGHhELRtLYtIugvgAkO35EZw1f9s3wjaiWY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RCDDcKmbj1HkiRnc8ThYbzGPVIxXDcoD5PYAvnhhL+Nf5NtahgvbzhnUrQtdNC+Exwz9MPqGnVO+x6Gk8CH6dhNj8sL3+IQ5vf0NFtQn0tMLl0hh3h2YLihJ4kMlFp7reXoeOTg7VgiQwVIF7Mb4IH+JNgEKyRsEqTuRDMdIczA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=RH8OPeRB; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="RH8OPeRB"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wRqN5VY7XpKH/6jS0v77xHyojWDA0cGl7F6z8LwgCNw=;
	b=RH8OPeRBCHSIUphDfC05AYEj4GOpfMTQsHgqgp1lPhN5Lv8gHcjiwrZmJyMWQlJpUzCwA8FeT
	5gsacVR3fXPf7lBERen+4tjX11+uR3DssBOhzOrF11jSn8vh6DXqInS84CYLtVoeKS9snydpDwU
	Q1kSwhiRZby9/cXjRyzw7MU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fyRQ33kSJz1prLm;
	Sat, 18 Apr 2026 17:33:31 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 81A0E40569;
	Sat, 18 Apr 2026 17:39:54 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Apr 2026 17:39:54 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 18 Apr
 2026 17:39:53 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 0/3] xfs: handle ERR_PTR return from bio_split
Date: Sat, 18 Apr 2026 17:27:12 +0800
Message-ID: <20260418092715.375850-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
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

bio_split() now returns ERR_PTR() on failure rather than NULL. xfs code
currently ignores the return value of bio_split() and dereferences it
unconditionally, which will crash if bio_split() returns an error pointer.

Add an IS_ERR() check after bio_split(), and perform corresponding error
handling.

Long Li (3):
  xfs: handle ERR_PTR return from bio_split in xfs_buf_submit_bio
  xfs: handle ERR_PTR return from bio_split in xlog_write_iclog
  xfs: handle ERR_PTR return from bio_split in xfs_zone_gc_split_write

 fs/xfs/xfs_buf.c     |  6 ++++++
 fs/xfs/xfs_log.c     |  2 ++
 fs/xfs/xfs_zone_gc.c | 10 +++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.39.2

