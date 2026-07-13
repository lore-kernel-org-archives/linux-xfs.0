Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD80A390237;
	Mon, 13 Jul 2026 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783928247; cv=none; b=XHHauyzuKQl7trbDUkvEY59GJQUfRV3XXEqB1fkx4nnzy2OBdaO/yTiAnsl270bjba0DvpbdYuwZCPJOVVzzDmdkpOZ+68km+U7VuNCslWk9fWI5+RuLt3v7yoLgKHxs+Fjphpt0vOeRIdtj//+XwxaxVx9lLxGSBvHtMatVkWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783928247; c=relaxed/simple;
	bh=kXdLVb6ndLGpax5uwJZ+z+XlSDVQ1Z18TjlIPmZuRaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YC0JwYcHGRnClSYAKfUzDGNKYms/dTODroqLQFB9DJ266JMJXLwtiBTXKGZ16gF9DXj+kN9lKbvdrpNtfkLucE9Rr6mjvtK1+I7Qo4fuHyK/n38vFJko6DsjMr28rUc2MWJPlnRx1nTKvqRzh9ClTYq7yxccOxXQ6PG9htsOpg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzDm53WdvzYQthf;
	Mon, 13 Jul 2026 15:37:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B0A2A405FB;
	Mon, 13 Jul 2026 15:37:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nKmlVRq7pA+BA--.39618S4;
	Mon, 13 Jul 2026 15:37:22 +0800 (CST)
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 0/5] iomap: trivial fixes for ext4 conversion
Date: Mon, 13 Jul 2026 15:29:01 +0800
Message-ID: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH1nKmlVRq7pA+BA--.39618S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyfZr1kur4xurWkAF4Utwb_yoW8Cw15pF
	Z3Ka15Gr4UGry3G3yfAFWxXr1Yv3WfXr48Wa13Gwn5ZF45AF18WF4xKa15ZryDGrWrCrWF
	qr1jv3Z3CFyqyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Hi,

This is the v3 revision of the trivial iomap fixes for the ext4
conversion. There are no code changes relative to v2.

Changes since v2:
 - Collect RVB tags from Darrick and Joanne.
 - Remove CC stable tag in patch 01 as Joanne suggested.
Changes since v1:
 - Add fix tags to patch 01 and 04.
 - In patch 04, change ifs_set_range_uptodate() to always fall through
   to ifs_is_fully_uptodate(), preventing a false-positive uptodate
   mask.
 - Add patch 05, add comments for ifs_clear/set_range_dirty().

v2: https://lore.kernel.org/linux-fsdevel/20260520030357.679687-1-yi.zhang@huaweicloud.com/
v1: https://lore.kernel.org/linux-fsdevel/20260514062955.1183976-1-yi.zhang@huaweicloud.com/


Original Cover-letter:

This patch series contains a few trivial iomap-related fixes in
preparation for converting ext4 buffered I/O to use iomap. 

The first three patches are taken from my ext4 conversion series [1], as
suggested by Christoph. The fourth patch fixes a bug originally reported
by Sashiko during review of my series; although unrelated to the ext4
conversion, it is worth fixing on its own. Please see the following
patches for detail. The fifth patch add comments for
ifs_clear/set_range_dirty(), and the last patch avoids merging ioends
that have different private data.

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

