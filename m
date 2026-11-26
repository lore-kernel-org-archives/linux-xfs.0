Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795702157;
	b=E/u4NiVPm00deCBf4kiYPnGvtmqnghLYuE/NOodm4mTSTSPuUP3H9RYsHI0dERaBDpwD
	 3gN0aqPIwPyH1l/No7h/U+fvS2SVC8nRSiNU+tycztJnKdZjt5ofIgLTGV88eWn/23ebf
	 ZKXGW064+EpEVTtop+nZ1kNOuswWXHYPNSjwfP4qxRxdIZvWMzBMHrfTukP5q34ugkEwd
	 p8Z6vC1jTVZh80/3/oYyIyvHBzxYnfX+uwn/+w+CCl943P4q6LnSHATPmg60BJlGIOGyv
	 dtv+jg+zQcNo3AiVNnCsadx+MsB4a1I5P/T0ZQqL8SquX6N7z/Xn8cvScgCUD92aFdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795702157;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=Rf3v+CLOqjZdZyhzB4/SDElBJTZGH4TAHVYUJzau4dM=;
	b=zw/70zz70MjMt2/9GWd10JN+8Kem5h3+IfFhrijTelFWI0H6aX8yJfaC4PVbOjRVrby1
	 hDIZAZ1tU/9q9BwTwrp8ip9evZ55PvrYpk2c7cAFg9DlMg3N/h8QDrQzmJhSLHT5nZO4o
	 0M2DU2eyP9EJ3WRB2zvqBfy3RT8H+PBzsb6aheh2tiLL0eww7U1Ovnx6sgZzY/BX76pFg
	 zAReS43g7IUdr48ytX44sDmoUO2seD9sUk435o2D8y3334503DnOKPVKXJk40O5ilsnUB
	 I3d8r0R0hymU4zkhAQy/ZOBx6CxmFvU1qqrx/2KWny5gU1T3Wbj+vUd1BGPOqkCJH0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B409E606A329;
	Thu, 26 Nov 2026 14:09:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B409E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jZz1b2yL1z1yQR;
	Thu, 26 Nov 2026 22:09:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E101F4056B;
	Thu, 26 Nov 2026 22:09:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzeyHPQhrhJmPFw--.54669S4;
	Thu, 26 Nov 2026 22:09:12 +0800 (CST)
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
Subject: [PATCH V2] xfs: remove duplicated lines
Date: Thu, 26 Nov 2026 21:59:47 +0800
Message-ID: <20261126135947.2820748-1-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXzeyHPQhrhJmPFw--.54669S4
X-Coremail-Antispam: 1UD129KBjvJXoW7trW5tFWkWF13tF18Ar1DJrb_yoW8uF4xpF
	95G3yUKFs8Jw1UuF4fXw409w1Ik34xu3ykJFy8ArySqwn8tr4jkF1DKr1Fvr1rXan5Wrnr
	Xr15tr4IvanrW3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Remove duplicated lines:
- xfs_ondisk.h checks the size of struct xfs_attrlist twice.
- xfs_rtgroup.h declares xfs_rtginode_irele() twice.

No functional changes.

Fixes: 650b774cf944 ("xfs: add static size checks for ioctl UABI")
Fixes: 6b08901a6e8f ("xfs: add realtime reverse map inode to metadata directory")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/libxfs/xfs_ondisk.h  | 1 -
 fs/xfs/libxfs/xfs_rtgroup.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 23cde1248f01..ae16b1bc2bbe 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -303,11 +303,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);
 	XFS_CHECK_STRUCT_SIZE(struct getbmap,			32);
 	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,		256);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index fca2eb74908c..e505be68462b 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -326,12 +326,10 @@ int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		struct xfs_trans *tp);
 int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		bool init);
 void xfs_rtginode_irele(struct xfs_inode **ipp);
 
-void xfs_rtginode_irele(struct xfs_inode **ipp);
-
 static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
 		enum xfs_rtg_inodes type)
 {
 	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
 }
-- 
2.52.0

