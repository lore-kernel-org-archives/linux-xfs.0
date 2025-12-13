Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6323F29B8C7
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 03:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765598399; cv=none; b=EVaOXeu701MKufbSnMwAuj++/pKk6HY+dHVindmo2g/Z+sJHM5yz2RnecXaio9gnB6+g2lmbiLJXj1eIjTYIXN+A20VbRsB0XFl0e3/mcjxKGPsPBGLUlho9ZOGrNEVnybMbBxyf6q4FxEYp/VjDRGnZ/se5KhKxkZCvlcSmTE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765598399; c=relaxed/simple;
	bh=bs2Os6JE78uhfuPMdH3QXKuS8c4LIic7+22vUk6+TB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Md1KrNI8PXyH6wpTblHQm48j6uJx+8HbzlN4ugNj2ATX2o5vDR82wPQ9DVzLPjV/Bsv9wD34alp8ADBodPGOoiDlcChbvinjWt8cN3RU3D68xCApf06JBtq1R3AS4jAMU4znERz3OGFg4PKYPtmkGaQaIT6/fOTNgK8tiLRiWTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dSszC6xynzKHLxb
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 11:59:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6ED651A01A1
	for <linux-xfs@vger.kernel.org>; Sat, 13 Dec 2025 11:59:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPi45DxpYwMCAA--.611S5;
	Sat, 13 Dec 2025 11:59:54 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	dchinner@redhat.com
Cc: yebin10@huawei.com
Subject: [PATCH 1/2] xfs: fix checksum error when call xfs_recover_inode_owner_change()
Date: Sat, 13 Dec 2025 11:59:50 +0800
Message-Id: <20251213035951.2237214-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251213035951.2237214-1-yebin@huaweicloud.com>
References: <20251213035951.2237214-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPi45DxpYwMCAA--.611S5
X-Coremail-Antispam: 1UD129KBjvJXoW7KFWDAF1UArWUKF4xWF1Utrb_yoW8Kw1kpF
	4ktw1DKr4kGryUCryxtr1YqryDtF1UAa1UJr1fGw17Wwn8GF1jqry8JFyUGrWUtFZ2qw4q
	qr18AryDtry5JaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64
	vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x
	07UN2-5UUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's a issue as follows:
XFS (sda): Metadata corruption detected at xfs_dinode_verify+0x621/0x25e0,
XFS (sda): Unmount and run xfs_repair
XFS (sda): First 128 bytes of corrupted metadata buffer:
00000000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 69 3c b0 4e 29 aa 08 0b 69 3c b0 52 01 d9 29 a7  i<.N)...i<.R..).
00000030: 69 3c b0 52 01 d9 29 a7 00 00 00 00 00 01 e0 00  i<.R..).........
00000040: 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00 0f  ................
00000050: 00 00 00 02 00 00 00 00 00 00 00 02 fb d9 c8 fa  ................
00000060: ff ff ff ff bc 93 09 78 00 00 00 00 00 00 00 f7  .......x........
00000070: 00 00 00 01 00 00 00 49 00 00 00 00 00 00 00 00  .......I........
XFS (sda): Filesystem has been shut down due to log error (0x2).
XFS (sda): Please unmount the filesystem and rectify the problem(s).
XFS (sda): log mount/recovery failed: error -117
XFS (sda): log mount failed

Above issue happens as miss re-generate the inode checksum before call
xfs_recover_inode_owner_change(). As xfs_inode_from_disk() will call
xfs_dinode_verify() to verify inode.

Fixes: 2d6051d49653 ("xfs: call xfs_dinode_verify from xfs_inode_from_disk")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/xfs/xfs_inode_item_recover.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 9d1999d41be1..d27f43d81127 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -566,13 +566,18 @@ xlog_recover_inode_commit_pass2(
 	}
 
 out_owner_change:
+	/*
+	 * re-generate the checksum before recover inode owner change as
+	 * xfs_inode_from_disk() will call xfs_dinode_verify().
+	 */
+	xfs_dinode_calc_crc(log->l_mp, dip);
+
 	/* Recover the swapext owner change unless inode has been deleted */
 	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum and validate the recovered inode. */
-	xfs_dinode_calc_crc(log->l_mp, dip);
+	/* Validate the recovered inode */
 	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
 	if (fa) {
 		XFS_CORRUPTION_ERROR(
-- 
2.34.1

