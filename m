Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9857530B524
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 10:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768558378; cv=none; b=b5pjEDqoVsCi26y/MG8xJYnioxpVqsEC1AC4gUFbx45m7+L11oiT6IVnjPImqL8m/GRwYzQSHGLIoI8lrKlqfVbAsTZCOLbhonbILD1jjFSpqAskLOhF8v83xY2ULP653bR8+wp9GQJlG+WQ33NQFFX8RDxOssZY4sRW99aSnY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768558378; c=relaxed/simple;
	bh=/pXx3QT17UDfv/Ksb8AamByFIUcZ323G+riJ4D3rM3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=tINsXUTFbLh0hss5EfG+mnPH8leh2UbDz2StG/Ocm0+cauKBs5fPgSIeFwpAaKUYSmC6qShO2vY2/sqnOWuwiWin23Nml/bsyFPbb6tp/gWUN4SMAMkxSzqhI5ZNuN3xM80zxX8DbW5zDU9pdBfHrLRrqxBQOJ/2l7NfFOjs3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Wlu3/gpc; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Wlu3/gpc"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260116101254epoutp028e321d89d36996b722070b26ba3208a0~LLni7nVz00408804088epoutp02G
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 10:12:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260116101254epoutp028e321d89d36996b722070b26ba3208a0~LLni7nVz00408804088epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558374;
	bh=mYC8Dqvp92r/wg8xMSAO9zq0NNohCtpUQQiPpSCFoCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wlu3/gpcNdeMpzJ58CLEmcpMGyL+ZS1H9/EWZw+4uramp5o3kIwpEw22AoJv34UOt
	 ypGVRVatUCBCp01tWedn9PDMMbWC+XipgGlQmXlQhU3lGy70AXe0EwuKjTgi1AEQPg
	 72eayCEiwiFiv0zHtjo5HhzDEriJ3rplUAsP+K20=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260116101253epcas5p2ca0dc5ea707a8c9493821828dce93539~LLnh7hBVX0062300623epcas5p2Z;
	Fri, 16 Jan 2026 10:12:53 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dswdw4NxKz3hhT4; Fri, 16 Jan
	2026 10:12:52 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc~LLnfqYF-A1384113841epcas5p1R;
	Fri, 16 Jan 2026 10:12:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101246epsmtip2a665d2893c692e021ee430a0b49d0bc2~LLnaypkkV0722507225epsmtip2Q;
	Fri, 16 Jan 2026 10:12:45 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 3/6] xfs: add per-inode AG prediction map and dirty-AG
 bitmap
Date: Fri, 16 Jan 2026 15:38:15 +0530
Message-Id: <20260116100818.7576-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>

Add per-inode structures to track predicted AGs of dirty folios using
an xarray and bitmap. This enables efficient identification of AGs
involved in writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |  5 +++++
 2 files changed, 32 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e44040206851..f97aa6d66271 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
 	return XFS_PERAG_BLOCKGC_MARK;
 }
 
+static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
+{
+	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
+	unsigned int nlongs;
+
+	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
+	ip->i_ag_dirty_bitmap = NULL;
+	ip->i_ag_dirty_bits = bits;
+
+	if (!bits)
+		return 0;
+
+	nlongs = BITS_TO_LONGS(bits);
+	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
+					GFP_NOFS);
+
+	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
+}
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -131,6 +150,8 @@ xfs_inode_alloc(
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
 
+	xfs_inode_init_ag_bitmap(ip);
+
 	return ip;
 }
 
@@ -194,6 +215,12 @@ xfs_inode_free(
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	/* free xarray contents (values are immediate packed ints) */
+	xa_destroy(&ip->i_ag_pmap);
+	kfree(ip->i_ag_dirty_bitmap);
+	ip->i_ag_dirty_bitmap = NULL;
+	ip->i_ag_dirty_bits = 0;
+
 	__xfs_inode_free(ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..dee449168605 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -99,6 +99,11 @@ typedef struct xfs_inode {
 	spinlock_t		i_ioend_lock;
 	struct work_struct	i_ioend_work;
 	struct list_head	i_ioend_list;
+
+	/* AG prediction map: pgoff_t -> packed u32 */
+	struct xarray           i_ag_pmap;
+	unsigned long           *i_ag_dirty_bitmap;
+	unsigned int            i_ag_dirty_bits;
 } xfs_inode_t;
 
 static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
-- 
2.25.1

