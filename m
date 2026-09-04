Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F99415F22;
	Fri,  4 Sep 2026 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502438; cv=none; b=K8xs/56cs0H0eg/4j17qXo4z1ou8CLUwPdUPmHl7SxQfO6JCpAZuxIWOVgB3kan8eB6ncOb1CgQEUCbBWeMZP/3c+cYfYfaPpjSl9MQhVMxM5aDlPT47CmQvyNcmqUMYXpQqyWM41NBAcbGG5XchfpOwYnl7Xa3vmulZG7NAvc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502438; c=relaxed/simple;
	bh=6yubANoTlfE+JFXCBqEAvgBg1wORssAZjBQ1vWXLDe0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aM0nXuSPra3Axr87/GouVVOpMTS9vITCOSqEN12uhgcE4vBBKzbAkaYqe3/ettSKE7zPYZYSD4aRUM478MqELyX25tyHy3PkDY1vGJ38GOu9eWKDCtKmFWj2dmQjDoER+/DHdrTjz2/auqfJGq6fGnQelC4cXdwdcMt51RGVDYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbmNh1pmWzYQtwr;
	Fri,  4 Sep 2026 14:13:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5ED4E40DC0;
	Fri,  4 Sep 2026 14:13:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCHbwqeYZpqTb3FAg--.50434S4;
	Fri, 04 Sep 2026 14:13:52 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: cem@kernel.org,
	dgc@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH 0/5] xfs: remove leftover dead declarations in headers
Date: Fri,  4 Sep 2026 14:06:43 +0800
Message-ID: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCHbwqeYZpqTb3FAg--.50434S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4xJFW3ZF47tw1rKw4rZrb_yoW8Jw43p3
	WSg3WIk3WDJ34jvFn2qwn7G3y293ykC347W3ZxK34Iqwn8Crn2qr17tF4j9FyrGFWYqw4Y
	gryUtr98uw15ZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

While reading the XFS log code I noticed that the implementation of
xlog_assign_tail_lsn() had already been removed, but its declaration was
left behind in the header. Such orphaned declarations (implementation gone,
no callers) can simply be dropped.

Suspecting more of these existed, I scanned the XFS headers (using GLM-5.2
to help, then verified each by hand) and this series removes the leftover
declarations I could confirm. Some of these have been stale for a long time
-- the oldest dates back to 2006.

Note that scrub still has a fair number of functions that do have
implementations but no callers (e.g. xchk_process_rt_error). I'm not sure
removing those is appropriate, since they may be intended for future use,
so they are not touched here.

Cleanup only, no functional change.

Zizhi Wo (5):
  xfs: remove unused xlog_assign_tail_lsn declarations
  xfs: remove unused xfs_iext_realloc declaration
  xfs: remove unused xfs_buf_iodone declaration
  xfs: remove unused kmem_to_page helper
  xfs: remove never-implemented scrub declarations

 fs/xfs/scrub/common.h   |  1 -
 fs/xfs/scrub/scrub.h    |  1 -
 fs/xfs/scrub/tempfile.h |  4 ----
 fs/xfs/xfs_buf_item.h   |  1 -
 fs/xfs/xfs_inode.h      |  1 -
 fs/xfs/xfs_log.h        |  2 --
 fs/xfs/xfs_platform.h   | 11 -----------
 7 files changed, 21 deletions(-)

-- 
2.52.0

