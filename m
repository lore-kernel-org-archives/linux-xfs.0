Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528393BB680
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123372; cv=none; b=JPekzc3ZrkgsTBFmc4nvaH1eAgOFVzmRMHqpobZVsv/YfYNInkeMkrg6bquYuP8Ai58fn4+bgi/X2mqQqHwofjz26kmtkHlkut1K8Q76ry95ZOnR9lo8i2wzOijf5jtfte4LJQkA9sxYOWr/uu4gv/VGwxwpjErGpJIW6M9D9lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123372; c=relaxed/simple;
	bh=tcfx+RBYR2TtD40m03WiroLS4p9HkzXAgITH5w2ZzNI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DQjApubXKssu+IrycEinkPlRV7kCX4PaRrvYxvjPKJEEuKQ5nG4K7ZhREr8isy/2743EFMcwVa/DBJcKedV+igGS/iX0BqIE685SFZ2jSkCFokt0+/cSV7/4UYMN5XmReAqweF+I+9u7kSeIoESXOGJZTS/WcrAQ1rSpgBjLYBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=KUWN+/ts; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="KUWN+/ts"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jUzfzG4ieTjSDujN0tczUojLtUy/gkrfl8Ex27NRI44=;
	b=KUWN+/tsUMQnvoODYgn/OtOZXEy0bupZCuSnG4hxxLtVaI8u9TIE4RFFdfSdKhQcswPIZnzNA
	2P51K9FID6ZxEUwF32vsn+ySTJ+OhWJw211tuoXmULeME29Ui0YBxeAif8foWw3AJr5oduDGBR4
	yrH92nea/GPMIK6XLClUw5g=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hh9ng4D8hznTVd;
	Fri, 11 Sep 2026 18:31:35 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 85FDF40578;
	Fri, 11 Sep 2026 18:42:43 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 11 Sep
 2026 18:42:43 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Brian Foster <bfoster@redhat.com>, Dave Chinner
	<dchinner@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH RESEND 0/2] xfs: fix NOFS state corruption in btree split worker
Date: Fri, 11 Sep 2026 18:42:25 +0800
Message-ID: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)

xfs_trans_set_context() overwrites tp->t_pflags, dropping the
caller's NOFS protection. Replace it with local
memalloc_nofs_save()/restore() to fix it, also drop the obsolete
kswapd flag inheritance, which simplifying the fix.

Note:
- rebased on v7.3-rc2
- Add ACK/RB
- split the patches, suggested by Christoph Hellwig[1]

[1] https://lore.kernel.org/linux-mm/aqOp035i41XIrDXg@infradead.org/

Kefeng Wang (2):
  xfs: remove dead kswapd flag inheritance from btree split worker
  xfs: fix NOFS state corruption in btree split worker

 fs/xfs/libxfs/xfs_btree.c | 22 ++++++----------------
 fs/xfs/xfs_platform.h     |  4 ----
 2 files changed, 6 insertions(+), 20 deletions(-)

-- 
2.55.0
