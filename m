Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643A620C038
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 01:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773624899; cv=none; b=GecqbHLSnfdVlgQXLXH9BeLQiHdfU7QQcAvisVR3vN/HyLfaTl61qlIxfDkKqSB1HCQFTUKYGOG/n1ajOhtk03UYc4IhLcxZ90vRqUbwV4i9M/XDq/ebzIJ22dSQNsogj8mEjUpbLu84LFoP3mstjNc8HiDvOtFegwr3zsMg63g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773624899; c=relaxed/simple;
	bh=9f/U5JUn8QPW5zUyzZHa/BEAVwH41YSi7b4d6eYW298=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aVTgsknZzuk4KbikJOn9EsLsip6KfJ17h46yG/WwkOaJcf3yczQOigK0k6mUC00f5NIhu3jUgSl9C3+oDnJPC14KFuERCHywSjpsE8pcShNXH2vSlSkkS/BBIb+zcSLgTA0dqtWzV0u+E0cFjCY+0OI1dKJRKz2bD6Jrevxr83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=iS/KnTEl; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="iS/KnTEl"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qKMkSgzG9agn2gLddzCy/NNFKaNRPia+Y0ibEoKmw5c=;
	b=iS/KnTEl3TgoHHsaX3T5JnyS6V+b5Sbwd8zXCb2iwJlKLWgy4u24jUk6wS9fZV3GhbDCnBYgy
	11Z6VqKMwvwRrivWaDHCRBNFzR5RQ+P3o8iOailSEfTL3UWgxyKKIp77i3MrSKoIMs0ZsZV1wrF
	an33TxVhXsqtQofpmyi/06k=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fYyDp2xxHz1T4Hh;
	Mon, 16 Mar 2026 09:29:30 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 6583B40363;
	Mon, 16 Mar 2026 09:34:48 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:34:48 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 16 Mar
 2026 09:34:47 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 0/3] xfs: fixes and clean up for attr item
Date: Mon, 16 Mar 2026 09:24:13 +0800
Message-ID: <20260316012416.2413909-1-leo.lilong@huawei.com>
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

This patch set fixes and cleans up several minor issues in the attr item.

Long Li (3):
  xfs: fix possible null pointer dereference in xfs_attri_recover_work
  xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
  xfs: simplify iovec validation in xlog_recover_attri_commit_pass2

 fs/xfs/xfs_attr_item.c | 82 ++++++++----------------------------------
 1 file changed, 14 insertions(+), 68 deletions(-)

-- 
2.39.2

