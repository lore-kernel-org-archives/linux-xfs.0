Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795696321;
	b=Kji9/QPcEFzOFvwQt06rLl4/BWo5L5dIgmIn14WqG7i7ZzXgfPjduRz4XHT2PomylZFl
	 NmdGxqfPWnG0kiCrC8f4T2zL71MgShwd7KDEIa6G5sqXuoAXvU8SvLzwNFJ3jlFFw9N9s
	 aHvMBB+f4FrILCsJCCBCz+YPDoKQPhMTNLeDCTXois/ThAxaUUP4x/VQXQ7mvF1QlpgUL
	 YP9qdXu3keXMWoxFCex91L2t8G1YQstVFXqCYTozsm4ne2IoW4iUIj9A35ul7tr5EWAsu
	 WQfzeEiVeAVbLVdROEj8nPZXVUqHvyzSa3UTxoZuxAvq1+Vo/GJ4/x5ouqFKPUecSNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795696321;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=uekKP1e+ZxB5m0N00GWw0kdKHIRnUoyGr3yEVp62UDM=;
	b=G/hSdc1WH+ZCIEuEAtokQ1s6P7unUC5HYIrIJDFmbsFL7+tnEL6+u2s4r6ixDjpEEQD8
	 BRHomdSmFNA8QScW/SYqy6pQOfxHK0JqPFfG2gyLBCr5IG8WZhycmrzXunA1wuw43fDRk
	 FzihrUVnZg2yFMxM8ce+XzgP/6+qcURvu2RiMnLsLLfE74fDRrD3gq8Uxx0SEa8wxRDhe
	 n63QQR9AOysWpWuqiiK6A7kiXVbjlqtKK7QWbhatOcVWyLrglECsidH6c3uJ38Y6uEBy3
	 i8DPmgVFCsJcRaypSAsG4WtxyAeJTQwDaO5tzgEemRDw0jxZe9pYE4isvfym317YGZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E87606A31C;
	Thu, 26 Nov 2026 12:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23E87606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jZwsJ6TzTz1yQv;
	Thu, 26 Nov 2026 20:31:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 46F1140628;
	Thu, 26 Nov 2026 20:31:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZPO4Jghr_ZKGFw--.23639S4;
	Thu, 26 Nov 2026 20:31:54 +0800 (CST)
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
Subject: [PATCH] xfs: remove a few duplicated lines
Date: Thu, 26 Nov 2026 20:22:29 +0800
Message-ID: <20261126122229.2281679-1-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnZPO4Jghr_ZKGFw--.23639S4
X-Coremail-Antispam: 1UD129KBjvJXoW7trW5Ar1rZFyrXF4fAFy3twb_yoW8trW7pF
	93J3y0kFs8Jw17ur4fXw409wn7J34xurW0kFykArnaqwn8JF40kF90kr10qw1Fqa15urnr
	Wrs8Kr4xZa13W3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Remove duplicated lines:
- xfs_alloc_read_agf() checks pagf_freeblks twice.
- xfs_ondisk.h checks the size of struct xfs_attrlist twice.
- xfs_rtgroup.h declares xfs_rtginode_irele() twice.

No functional changes.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/libxfs/xfs_alloc.c   | 1 -
 fs/xfs/libxfs/xfs_ondisk.h  | 1 -
 fs/xfs/libxfs/xfs_rtgroup.h | 2 --
 3 files changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ae221a158764..2c5b73803a6b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3509,7 +3509,6 @@ xfs_alloc_read_agf(
 	if (!xfs_is_shutdown(pag_mount(pag))) {
 		bool	ok = true;
 
-		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
 		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
 		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
 		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 23cde1248f01..ae16b1bc2bbe 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -305,7 +305,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index fca2eb74908c..e505be68462b 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -328,8 +328,6 @@ int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		bool init);
 void xfs_rtginode_irele(struct xfs_inode **ipp);
 
-void xfs_rtginode_irele(struct xfs_inode **ipp);
-
 static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
 		enum xfs_rtg_inodes type)
 {
-- 
2.53.0

