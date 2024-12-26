Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F5D17591;
	Thu, 26 Dec 2024 06:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735193794; cv=none; b=ZJlZ0WrnkcQVG4VeWCn84eVZVz+vqp0NlNYuf61yHpzoHIXbPsjqDLFkqyVyVSS3rtGG6NB+R4nhA7be6x54RQkHB7ST5MWsJTueU97I3ppcVjR75lPH0K1mkM9uu7hbbjo1WYpoId/dAfudZJMZcn6EGvUevP2CnlX+ACI5V6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735193794; c=relaxed/simple;
	bh=exKKVV2NF3/SLcIV4iEezaaL2UfMDQXvxdQlUZWfaAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PQMSJILbwiuEGjt+FTZjn+eeL7+VGgZ7PBml46o+RyErrcpzzzU+8KqfPYz7fE5kwH7KgL/2wfIgx6RggF+1Ye5WondFL7/hnvAEtKn8geXimcVTG/zvn50Of7MZLungQvcQa+KUc5/WpRm/75UqKL3qIk9xuQrF7xrO6STI6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=X1ecpBMl; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="X1ecpBMl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=anRDx
	NQ6sJd//qGP2BVP5SHVTKVSuqTV4qb7M1vi+yk=; b=X1ecpBMlNa90Vy3sIkMxS
	0vaw4UMxLRBTz75lYticIxaYrjdPVE5VGPSJRTVeqba9A80uwsI9nJEY0w/jGTmV
	sVIQinr8/VKCR9WvkY3fTFdQ6F8eS7DGGiyXLZCTYCrVi8otc2kDegbcgZoZydjj
	fJ7RBmmo2mA42ABZI0JwgI=
Received: from chi-Redmi-Book.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBn392t9GxnKb_cBg--.36614S2;
	Thu, 26 Dec 2024 14:16:14 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: djwong@kernel.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH] xfs: Remove i_rwsem lock in buffered read
Date: Thu, 26 Dec 2024 14:16:02 +0800
Message-ID: <20241226061602.2222985-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBn392t9GxnKb_cBg--.36614S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF4UWFyxuF48JFyfXrWxtFb_yoW8uw1kpr
	9xKa4rGrsrKw18Cr1fJF40ga45Kw1Ikw4DZrW0gw13XF13tr4qgrWIyF10g345K39avr4j
	qw1xKr93CayqqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnzVbUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBaxjBnWds86QYdAAAsf

From: Chi Zhiling <chizhiling@kylinos.cn>

Using an rwsem to protect file data ensures that we can always obtain a
completed modification. But due to the lock, we need to wait for the
write process to release the rwsem before we can read it, even if we are
reading a different region of the file. This could take a lot of time
when many processes need to write and read this file.

On the other hand, The ext4 filesystem and others do not hold the lock
during buffered reading, which make the ext4 have better performance in
that case. Therefore, I think it will be fine if we remove the lock in
xfs, as most applications can handle this situation.

Without this lock, we achieve a great improvement when multi-threaded
reading and writing. Use the following command to test:
fio -ioengine=libaio -filename=testfile -bs=4k -rw=randrw -numjobs=16 -name="randrw"

Before this patch:
   READ: bw=351MiB/s (368MB/s), 21.8MiB/s-22.0MiB/s (22.9MB/s-23.1MB/s), io=8185MiB (8582MB), run=23206-23347msec
  WRITE: bw=351MiB/s (368MB/s), 21.9MiB/s-22.1MiB/s (23.0MB/s-23.2MB/s), io=8199MiB (8597MB), run=23206-23347msec

After this patch:
   READ: bw=1961MiB/s (2056MB/s), 122MiB/s-125MiB/s (128MB/s-131MB/s), io=8185MiB (8582MB), run=4097-4174msec
  WRITE: bw=1964MiB/s (2060MB/s), 123MiB/s-125MiB/s (129MB/s-131MB/s), io=8199MiB (8597MB), run=4097-4174msec

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/xfs/xfs_file.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9a435b1ff264..7d039cc3ae9e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -279,18 +279,9 @@ xfs_file_buffered_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
-	ssize_t			ret;
-
 	trace_xfs_file_buffered_read(iocb, to);
 
-	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
-	if (ret)
-		return ret;
-	ret = generic_file_read_iter(iocb, to);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	return ret;
+	return generic_file_read_iter(iocb, to);
 }
 
 STATIC ssize_t
-- 
2.43.0

