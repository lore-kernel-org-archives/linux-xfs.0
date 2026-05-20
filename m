Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CBF330B30;
	Wed, 20 May 2026 03:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779246546; cv=none; b=DGvoJAUUdSKK+BxOd3txkYCKVZXXZRTA311pneEbEUbYeFq1onfLtv7eUKxK1aeEoxbYUn/JSHzRqGD39bP/kRGoJtgTDKRBGdf4sTDa/eb9myzFU15VbOVNDMbeC8vct0Ij0m6RtsD9m0V9hZxrwL09c1Ww5AzPSRnX079f19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779246546; c=relaxed/simple;
	bh=p5CNXNOQXismTw3XtlIhCeQCkYo1YhXRmBL2vBnPbvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GkuBwnKiQnLQoq8RAVf6he+NV7guqa1xzhqNXKE/ZTk2qt85oJ4OUC0MWas5AYjKyNNQjbxG4e7TBfwdESG+CSx5cyY8z03EQHMA67h6UuuNjkuFwX35Uu4iMTAVTI/Gsj2SNzmqSMBB6RDy8h694yRCPVXoJ5COs1rlgGckE0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gKxMY68r5zKHMX5;
	Wed, 20 May 2026 11:08:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A8E2440570;
	Wed, 20 May 2026 11:09:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1vGJQ1qn37HCw--.64508S4;
	Wed, 20 May 2026 11:08:58 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	joannelkoong@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 0/5] iomap: trivial fixes for ext4 conversion
Date: Wed, 20 May 2026 11:03:52 +0800
Message-ID: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnb1vGJQ1qn37HCw--.64508S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWkur15CF1rXw1kGw1UGFg_yoW8GF17pF
	Zakay5Kr1jgry7Zws3AFW7Xr1Yv3WfXrW8Wa13GwnYvF45AF1jgF4fKa18uryDGryrCFyF
	qr12v3Z3ua4qyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoWlkDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Changes since v1:
 - Add fix tags to patch 01 and 04.
 - In patch 04, change ifs_set_range_uptodate() to always fall through
   to ifs_is_fully_uptodate(), preventing a false-positive uptodate
   mask.
 - Add patch 05, add comments for ifs_clear/set_range_dirty().

v1: https://lore.kernel.org/linux-fsdevel/20260514062955.1183976-1-yi.zhang@huaweicloud.com/


Original Cover-letter:

This patch series contains a few trivial iomap-related fixes in
preparation for converting ext4 buffered I/O to use iomap. 

The first three patches are taken from my ext4 conversion series [1], as
suggested by Christoph. The last patch fixes a bug originally reported
by Sashiko during review of my series; although unrelated to the ext4
conversion, it is worth fixing on its own. Please see the following
patches for detail.

Thanks,
Yi.

[1] https://lore.kernel.org/linux-ext4/20260511072344.191271-1-yi.zhang@huaweicloud.com/

Zhang Yi (5):
  iomap: correct the range of a partial dirty clear
  iomap: support invalidating partial folios
  iomap: fix incorrect did_zero setting in iomap_zero_iter()
  iomap: fix out-of-bounds bitmap_set() with zero-length range
  iomap: add comments for ifs_clear/set_range_dirty()

 fs/iomap/buffered-io.c | 58 ++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

-- 
2.52.0

