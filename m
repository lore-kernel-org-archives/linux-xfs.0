Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521790;
	b=dDmGs6xKp3G39FsMjARf5WGNu4pn9Uhkxol91093nFJdxQxOOfQjopfKXyRsLFSOMKH4
	 cq0BToK9nANyb4DYdD1StxXRCkgtD4lRDMIQW6EMemk7AexzMmBMNHsJJgNebOckmt7jI
	 /FP7Aib9mouEFuLLVRqwNyy0dxPuiKOYbd8AJ7XVcC12TYYNPSReFBn0MwstkrUFKYWsD
	 9++jJbFFUQa+Y6Cvg43iANpI3oTmFQUJED0hZKJ+Wc8RkO9hrbYpbIP3EVkgmy/IX/Hyr
	 /cYwbhbKEB6r6TH65fPeTBEfdVy+0D4uV7j3wh3C7KgdJFgToSOpuGdEdwkwYhVGsGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521790;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=uTSDb0GDgcQXWfjVDVK/GYbfc8bAe4gxatvfGWZJPsc=;
	b=3DJwuz6hLJoTI78UC8OzJHxmERzWmpvuvovqc+SKMUF5YwrhO44+5+m+/2VYz2Q54zco
	 zMnTUSov52MI02y8UCeLYNzVRnQ52vY8ktbf3dapCy8WEJ4BA3BY1Zgf6CmJid64dWRJH
	 lv5N9AFpkI16t9SONxns5jH8caWG3jHwGSBTGpUDI7pT1y+2yyB4N/YaSkreTnhziZUlU
	 h3vS4wOxlG5ZaM1BN+a4hVFtonYJoOzv2U7upVLrE+0dn5dS0XRicPAJW+0pXUGlsBiwB
	 AfBFsiw/eL+0rOG86U17TYCdIJn8e5pYbnDhoB8YRsSIqP+LjMRz4PEHvmo9dB8yadA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Xv+K4fZH;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E55606A33C
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 12:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62E55606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Xv+K4fZH
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uTSDb0GDgcQXWfjVDVK/GYbfc8bAe4gxatvfGWZJPsc=;
	b=Xv+K4fZHovZMGaIZv5kudk8VQ1L4poPWrAcuAsIFC3CO36QXe5lA61k7KgJPxqu1z1diHejke
	t4hkOBFvgjD9nXd+x8tSz99vqDFNIGfWNi680F33or1B6HCTiiF1VmXKNbJNIpCLBATotg6dAzS
	VRMlSlXphs8RicI5oBN201M=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jYhJW3lP4zLlVf;
	Tue, 24 Nov 2026 20:02:35 +0800 (CST)
Received: from dggpemr200001.china.huawei.com (unknown [7.185.36.96])
	by mail.maildlp.com (Postfix) with ESMTPS id DFCBD40565;
	Tue, 24 Nov 2026 20:02:58 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr200001.china.huawei.com
 (7.185.36.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 24 Nov
 2026 20:02:58 +0800
From: Ran Hongyun <ranhongyun1@huawei.com>
To: <cem@kernel.org>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <ranhongyun1@huawei.com>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>,
	<wozizhi@huawei.com>
Subject: [PATCH 0/2] xfs: fix zero-link inode link count handling
Date: Tue, 24 Nov 2026 19:53:37 +0800
Message-ID: <20261124115337.2297318-1-ranhongyun1@huawei.com>
X-Mailer: git-send-email 2.52.0
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemr200001.china.huawei.com (7.185.36.96)

This series fixes two paths that hand a zero-link inode to the VFS link
count helpers.

Patch 1 makes the metadir repair code set the link count directly when
reconnecting an inode that was found on the unlinked list, instead of
calling inc_nlink() on a zero-link inode.

Patch 2 makes xfs_bumplink() reject the abnormal zero link count with
-EFSCORRUPTED.  A crafted image can contain a reachable directory with
di_nlink == 0; mkdir() or rename() into it then reaches inc_nlink() and
trips the VFS warning.

Ran Hongyun (2):
  xfs: set link count when reconnecting zero-link metadir files
  xfs: refuse to bump the link count of zero-link inodes

 fs/xfs/libxfs/xfs_dir2.c       | 24 ++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_util.c | 14 ++++++++++++--
 fs/xfs/libxfs/xfs_inode_util.h |  2 +-
 fs/xfs/scrub/metapath.c        | 14 ++++++++++++--
 fs/xfs/scrub/orphanage.c       | 11 ++++++++---
 5 files changed, 51 insertions(+), 14 deletions(-)

-- 
2.52.0

