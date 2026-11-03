Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705707;
	b=dRz8f/9bMfyM/g/s9lr0/44QK8akBdzhInNNuXFPDekFSRaKb08vmztnw+JkrwNAAc6W
	 WIR0NnDPIAbj0bqs/zozUNJIgN5ybKI7jqIX8G5Jp7VuOcGKS+SXVkem7Jnh7O2mne9xe
	 yC+828BsV34x3zhQUWxwXiKJB9MAAFa9jH/uTB3TvkEs/Oz2H8m1NRkzgsbPnNfTuV2nO
	 WZ+NrARSUz9Okl3rRWwMOLHv9j6zc5mIaz5H+2YI2LRFh4/ts6BIWTE5FArqAjLSbWNDe
	 ORJUvM10GZkBgidSyn4Q2KlwJD85EfKNW+30wSG2yC/esw4ZXT9tW6PEJCZLZRCAsHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705707;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=h0JrNw87CscCaBms8Ase1x7lT41MWkvuKN0Y4IRfPqY=;
	b=ngb0ipAGE7Bd9gKhXdB3a9XyqpRlLYDhbyn80PeDAlBtD8jB/tOm++gm3Tumt1GqrFZ2
	 uRzoW2mdyULe5+p2rl98/suH7aIuQ5DVNnfSw3T0prTNv/b50V+Laak8klSLsuzrUfTgZ
	 xFd8XZESsQdCXZ8loyZhfcD+vZrjb+SNM/ju1etKEc3yIbFDvTIP1h4RKvEV0WAMkpAEW
	 zDUQs5Ls716YGvRFOTpjPgLyo/bA1U53ARAtpPtC8XX1QHgU3JVsiSnHr+2M3XQ4jCnkA
	 L4hNM5rcdrkUboMwZih2QXt/XrU6lNgcW4WSsY3huK9U0rkkBYGbxiTCb5dQoYDMVag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=C4r169oA;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB7606A327
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99FB7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=C4r169oA
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261103113504epoutp02a3d1c849cdc78ad08f01bb65e4eae4bc~khdW7L-SU0877508775epoutp02h
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261103113504epoutp02a3d1c849cdc78ad08f01bb65e4eae4bc~khdW7L-SU0877508775epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705704;
	bh=h0JrNw87CscCaBms8Ase1x7lT41MWkvuKN0Y4IRfPqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4r169oAQ0kxy9sNn9dXpJGVSZZniv5/KipI/EtqVfYVRF7cvoVZlk0FfvLy1vr5v
	 vWk5Gw4BX3kxcIFKSsqG7uXWgr/6EzDjAKJD7OfrWcR47E008laltP2wNn0VzHw0ak
	 msWEfFwiBr/DrqXhZTywdz9rMoECmsOfJtUB9mvU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261103113504epcas5p239c507eaf09727e1f3589fcd27291339~khdWXxSe91162911629epcas5p2x;
	Tue,  3 Nov 2026 11:35:04 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jJmhR06jQz6B9m8; Tue,  3 Nov
	2026 11:35:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111029epcas5p190c5155d6c2702ee7705212e9885dddd~khH5EaXSL0247702477epcas5p1a;
	Tue,  3 Nov 2026 11:10:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111027epsmtip10a53667d58a04bd982970ad43b7fa2b4~khH3XTsH72883528835epsmtip1R;
	Tue,  3 Nov 2026 11:10:27 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 3/8] fs: add i_write_stream, exclusive with the write
 life time hint
Date: Tue,  3 Nov 2026 16:36:35 +0530
Message-Id: <20261103110640.1000095-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111029epcas5p190c5155d6c2702ee7705212e9885dddd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111029epcas5p190c5155d6c2702ee7705212e9885dddd
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111029epcas5p190c5155d6c2702ee7705212e9885dddd@epcas5p1.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

Keep the attached stream id in the VFS inode rather than the
filesystem's own, so that fcntl_set_rw_hint() can see it. It is a u16 in
the 32-bit hole after i_state, so struct inode does not grow on 64-bit.

Add inode_set_write_stream() to set or clear it. It refuses a stream
while a write life time hint is set, under i_lock as fcntl_set_rw_hint()
does, so both sides of the exclusion are enforced in the VFS.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fcntl.c                    |  7 +++++++
 fs/inode.c                    |  2 ++
 fs/write_streams.c            | 23 +++++++++++++++++++++++
 include/linux/fs.h            |  2 +-
 include/linux/write_streams.h |  6 ++++++
 5 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 9b71bc9d71d1..271ff8f61354 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -383,7 +383,14 @@ static long fcntl_set_rw_hint(struct file *file, unsigned long arg)
 	if (!rw_hint_valid(hint))
 		return -EINVAL;
 
+	/* keep write stream and write life time hint mutually exclusive */
+	spin_lock(&inode->i_lock);
+	if (hint != WRITE_LIFE_NOT_SET && READ_ONCE(inode->i_write_stream)) {
+		spin_unlock(&inode->i_lock);
+		return -EBUSY;
+	}
 	WRITE_ONCE(inode->i_write_hint, hint);
+	spin_unlock(&inode->i_lock);
 
 	/*
 	 * file->f_mapping->host may differ from inode. As an example,
diff --git a/fs/inode.c b/fs/inode.c
index f63535ee3629..4b07125f27cd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/list_lru.h>
 #include <linux/iversion.h>
 #include <linux/rw_hint.h>
+#include <linux/write_streams.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <trace/events/writeback.h>
@@ -246,6 +247,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	atomic_set(&inode->i_writecount, 0);
 	inode->i_size = 0;
 	inode->i_write_hint = WRITE_LIFE_NOT_SET;
+	inode->i_write_stream = WRITE_STREAM_NOT_SET;
 	inode->i_blocks = 0;
 	inode->i_bytes = 0;
 	inode->i_generation = 0;
diff --git a/fs/write_streams.c b/fs/write_streams.c
index 4c7ad3198bb9..d97cdafc7d1a 100644
--- a/fs/write_streams.c
+++ b/fs/write_streams.c
@@ -140,3 +140,26 @@ int write_stream_get_id(struct file *file, const struct write_stream_pool *pool)
 	return ws->id;
 }
 EXPORT_SYMBOL_GPL(write_stream_get_id);
+
+/**
+ * inode_set_write_stream - attach or clear the write stream of an inode
+ * @inode: inode to update
+ * @id: stream id, or WRITE_STREAM_NOT_SET to clear
+ *
+ * A write stream and a write life time hint are mutually exclusive.
+ *
+ * Return: 0, or -EBUSY if @inode has a write life time hint.
+ */
+int inode_set_write_stream(struct inode *inode, u16 id)
+{
+	spin_lock(&inode->i_lock);
+	if (id != WRITE_STREAM_NOT_SET &&
+	    inode->i_write_hint != WRITE_LIFE_NOT_SET) {
+		spin_unlock(&inode->i_lock);
+		return -EBUSY;
+	}
+	WRITE_ONCE(inode->i_write_stream, id);
+	spin_unlock(&inode->i_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(inode_set_write_stream);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..3ed20abf4a46 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -812,7 +812,7 @@ struct inode {
 
 	/* Misc */
 	struct inode_state_flags i_state;
-	/* 32-bit hole */
+	u16			i_write_stream;
 	struct rw_semaphore	i_rwsem;
 
 	/* Timestamp for writeback list ordering and age checks (jiffies). */
diff --git a/include/linux/write_streams.h b/include/linux/write_streams.h
index d27f42df5984..258358d9c31d 100644
--- a/include/linux/write_streams.h
+++ b/include/linux/write_streams.h
@@ -6,6 +6,10 @@
 #include <linux/types.h>
 
 struct file;
+struct inode;
+
+/* i_write_stream value of an inode that has no write stream */
+#define WRITE_STREAM_NOT_SET	0
 
 /*
  * Write stream slot pool, embedded in whatever filesystem object scopes
@@ -30,4 +34,6 @@ int  write_stream_alloc_fd(struct write_stream_pool *pool, struct file *file);
 int  write_stream_get_id(struct file *file,
 			 const struct write_stream_pool *pool);
 
+int  inode_set_write_stream(struct inode *inode, u16 id);
+
 #endif /* _LINUX_WRITE_STREAMS_H */
-- 
2.25.1

