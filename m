Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F53A4CB5B
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056308; cv=none; b=mWy6H8JcA4Fjl4euhVj2l4svhqqSSRRoUw5ImI4+hCAbR6tOcow2ahdCmrzBeCKul5tYpj9qXS3rW2tmpSpJ1lLxHdZU5Psl5Ms7jywCdlmsSzwyWeO0l9IB69A8IyXRfCmbcaFwiKuiZLDCqyfgrFxq96B0kJfPAVa8qF8G23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056308; c=relaxed/simple;
	bh=LQUDubAxNlBpo6nL0gD99oWkAH2nSKqO92JP2fS5ziw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iW6/ykBfAr3BypyJ0Xhdvjm7Rpgr1TErrn7ZXQf6Zgqc0qOny0bkXBHS/+Ua7SDVJKgf27M7l3swMRMvjmb9uzYlzhxc5WhUMIKZomnjXc4rDV5TyIuDiYZfHu3coZ5ToaHbKFl8p/A4vtSj/cP9mlt3crD8/dN12xbmmPSaku4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 7B9C5180F2C0;
	Tue, 21 Oct 2025 16:18:10 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 24M5EyKW92ioeRoAKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 21 Oct 2025 16:18:10 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/2] Add FL_WRITE_ZEROES to XFS, fix krealloc on xfs_uuid_table
Date: Tue, 21 Oct 2025 16:17:42 +0200
Message-ID: <20251021141744.1375627-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[PATCH 1/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
the unmap write zeroes operation.

Inspired by the Ext4 implementation of the FALLOC_FL_WRITE_ZEROES. It
can speed up some patterns on specific hardware.

time ( ./fallocate -l 360M /mnt/test.file; dd if=/dev/zero of=/mnt/test \
bs=1M count=360 conv=notrunc,nocreat oflag=direct,dsync)

360+0 records in
360+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 22.0027 s, 17.2 MB/s

real    0m22.114s
user    0m0.006s
sys     0m3.085s

time (./fallocate -wl 360M /mnt/test.file; dd if=/dev/zero of=/mnt/test \
bs=1M count=360 conv=notrunc,nocreat oflag=direct,dsync );
360+0 records in
360+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 2.02512 s, 186 MB/s

real    0m6.384s
user    0m0.002s
sys     0m5.823s

v2 changes:
use xfs_inode_buftarg to determine if the underlying device supports unmap 
write zeroes
v1 patch: 
https://lore.kernel.org/linux-xfs/20251002122823.1875398-2-lukas@herbolt.com/

[PATCH 2/2] xfs: Remove WARN_ONCE if xfs_uuid_table grows over 2x PAGE_SIZE.
Currently using krealloc prints warning if the order is 2x PAGE_SIZE on 
x86_64 it's being trigered when we mount 511 XFS. Use kvrealloc instead.

Lukas Herbolt (2):
  xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
  xfs: Remove WARN_ONCE if xfs_uuid_table grows over 2x PAGE_SIZE.

 fs/xfs/xfs_bmap_util.c |  6 +++---
 fs/xfs/xfs_bmap_util.h |  4 ++--
 fs/xfs/xfs_file.c      | 25 ++++++++++++++++++-------
 fs/xfs/xfs_mount.c     |  2 +-
 4 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.51.0

