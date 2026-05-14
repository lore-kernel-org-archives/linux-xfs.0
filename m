Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C12989B5;
	Thu, 14 May 2026 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778740490; cv=none; b=pVYpff/HmSxbZMm7tN24jnpg4wIhFmJX0PTgTQhRkfkhXkmhx1gVJfk+19TcmAwp0P5Un3WXXqyz3pPsZHiopN09tNhykWl9ZFoCwIFrSo6TboDQKYMBEaPjH69MRSeXDsucbHe55Ps36lYhVJogzm3AHrtHQV0la2ch5pnZdpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778740490; c=relaxed/simple;
	bh=b4xx33h9mUNDWWKCTA/A3mwHmmzO9UAv7a8vkHCzHRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GjSdIvGeNTFZrYmGhmewsXlsNV8b2eeDAzhGwpUnmCELXu4SjkyYhcyfVLcGV6NZt8J2BvDlcA71pYQKTzuyB3mxUNM8xbjfwQo3JlGikxUwJxHq3AXTY4eZiWrFhuA2y8J2KAzOBvjO4Ag40T2Ns7thRSUA/DTSgtZj+zpVgio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGLBj36v4zKHLw9;
	Thu, 14 May 2026 14:33:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AA9E14058C;
	Thu, 14 May 2026 14:34:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1v4bAVqIcT3CA--.41732S4;
	Thu, 14 May 2026 14:34:43 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH 0/4] iomap: trivial fixes for ext4 conversion
Date: Thu, 14 May 2026 14:29:51 +0800
Message-ID: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnb1v4bAVqIcT3CA--.41732S4
X-Coremail-Antispam: 1UD129KBjvdXoWruF4xXF1xXw4DJrW7Kr4DArb_yoWfKwc_ua
	yvkFykWr1DXF9aka9ruF15JrZFkayUKr1rCFy8trZ3Gr9rArn3CF4vkrZ3Zw18Xr4xJrZ8
	JrnIyayFywnFvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

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

Zhang Yi (4):
  iomap: correct the range of a partial dirty clear
  iomap: support invalidating partial folios
  iomap: fix incorrect did_zero setting in iomap_zero_iter()
  iomap: fix out-of-bounds bitmap_set() with zero-length range

 fs/iomap/buffered-io.c | 45 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 14 deletions(-)

-- 
2.52.0

