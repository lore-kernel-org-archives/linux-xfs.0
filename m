Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD23644D3;
	Tue, 10 Mar 2026 08:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773131215; cv=none; b=Qe7ERbB37Y5GygxgeAQ5bzuk0Eevg7095fsYDjqcWP75ADPpb1bThrHWLNKQmxD8WLRU31iqW80j0kmyxKKHISv4KF/wCXxcfT5wCG8hky8UfHO6fdrXCXrRyXl0zIOtNOeIt/kvVMIOTGXm0hWj/yHcBbkbp2nrHD77tq/u+8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773131215; c=relaxed/simple;
	bh=czQ1OUYayR4nuEviClEOViRlyrdT1WDkFHUe6UNLAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h5w+icjBdczjaBvXWmCdx5gNNIxlnxSUM8tnds+5UNmagLb2Rv578QRevGrX8YJqO3ARSbzvj2stlTbjCrsjB2gVxu1BS6nCVak/EO+vGkEsm4Iu8GBNHKHxhB8TlBtSXZ53dzfz5z6rBQnRg1NI53fw04I33bu1en1SsKGxT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fVRmD1VH0zYQtFp;
	Tue, 10 Mar 2026 16:26:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A4F5D4058D;
	Tue, 10 Mar 2026 16:26:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgB3edm+1a9pvaOEAQ--.18691S4;
	Tue, 10 Mar 2026 16:26:49 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH] iomap: fix incorrect did_zero setting in iomap_zero_iter()
Date: Tue, 10 Mar 2026 16:22:50 +0800
Message-ID: <20260310082250.3535486-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3edm+1a9pvaOEAQ--.18691S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1UJr4fuw1kGFW7Wr1ftFb_yoW8ZF15p3
	9xKFWvkFs2qrW7WFn5JF9I9F1Yy3s5GFW7Wr4UGwn8ZF4qvr4akr1FgayYvF1xJ34fAw1I
	yF4jyas7ZF4UCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The did_zero output parameter was unconditionally set after the loop,
which is incorrect. It should only be set when the zeroing operation
actually happens, not when IOMAP_F_STALE is set or when
IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
or when iomap_iter_advance() returns an error.

This causes did_zero to be incorrectly set when zeroing a clean
unwritten extent because the loop exits early without actually zeroing
any data.

Fix it by using a local variable to track whether any folio was actually
zeroed, and only set did_zero after the loop if zeroing happened.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/iomap/buffered-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5297491d5e3e..7a3780242cde 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1537,6 +1537,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		const struct iomap_write_ops *write_ops)
 {
 	u64 bytes = iomap_length(iter);
+	bool zeroed = false;
 	int status;
 
 	do {
@@ -1555,6 +1556,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		/* a NULL folio means we're done with a folio batch */
 		if (!folio) {
 			status = iomap_iter_advance_full(iter);
+			if (status)
+				return status;
 			break;
 		}
 
@@ -1565,6 +1568,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 				bytes);
 
 		folio_zero_range(folio, offset, bytes);
+		zeroed = true;
 		folio_mark_accessed(folio);
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
@@ -1574,10 +1578,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 
 		status = iomap_iter_advance(iter, bytes);
 		if (status)
-			break;
+			return status;
 	} while ((bytes = iomap_length(iter)) > 0);
 
-	if (did_zero)
+	if (did_zero && zeroed)
 		*did_zero = true;
 	return status;
 }
-- 
2.52.0

