Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595742;
	b=biQQ3+a7CQlDPxTYb7sFCR0yFgntOF4FHuGmnmjCpV0xOqCkBhGhmGNsIMEWBz8dkQy1
	 J8RBtPrrb69N4hnjZJJErwFmNEifwZC7WYspVvjF1D2OjtywZtp31R4pK1gO3LR0Q8y1F
	 15FVP6oqvcke93exYVDuWxG42CxMnVaH1JVF7SMtTjgjlWx6atfcWh9LNTVWSeFFendMm
	 +8dlb6BFiMLh+or1QKUzggbtbvl3jeB9CbIyiWRTTzMpj/dTrYsnYJF3YbE+M8AJ+ytIA
	 GXzBEIfsCseQNwWxE8pLVxDPWIdRyYwBG2LEfZwiI9vvryeIsfIqgiVLMikm3p8wZaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595742;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=VziUcdcM0NREtHKnFOvCZs3L13VqWLF94lVeiV+goYE=;
	b=jn7t3dtNqx259dPOkVpi/0swHl7n56e3JPB53YlDgGJK9YlrfHqqlXhG0aYX6Bvn0qHY
	 AIfoOX5pCNzL2XChVCjZOSvoUE45rPA3KafOD1L6jIf2BJoR5hVj+o/pdEdKsvIjbeYSJ
	 3FxW+A6VgUDzG4ojX/HUASIap11RYlAuzrQm2o42j6q+3W4FEuuCVoxTz6g+jZIlSEBm9
	 ec0iKWe2HMNjiV5uthxKPYX8sXr8Tk55i2OGnFz2PDc3DkrwJk2SGIIzpbLVnpYNznvzk
	 /f3QBILH4weM2zfr4cYWOpfSCZ1hSAmJ4rAWNMnvms5lo+g8UKrqI5c9kEfgiCWFAbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EnqbCfiU;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E50606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09E50606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EnqbCfiU
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261125083540epoutp01d4315fcff29ce250c57db89454c64430~rPM-2ngno2243022430epoutp01s
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261125083540epoutp01d4315fcff29ce250c57db89454c64430~rPM-2ngno2243022430epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595740;
	bh=VziUcdcM0NREtHKnFOvCZs3L13VqWLF94lVeiV+goYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnqbCfiUWbWEZMYP67KZJzdX/bOMnCJY0Jv2pvF9ng56HDH8YYfOJeJ/fKvttfkBv
	 Zx4Exv+PEcwaKJRvHZiGtQwc6BhX0EBSDetgWsP4Cl99qphXGgROnXozxb75H3gjIz
	 3v9+x96D+AhXLaeZq5u38/qGMl7VT0Oz5f7as1zQ=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261125083539epcas5p4a8ca636d70e57bae4be23f23866cace9~rPM-aFQqv0443204432epcas5p4D;
	Wed, 25 Nov 2026 08:35:39 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jZCgG5CHxz6B9m6; Wed, 25 Nov
	2026 08:35:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261125083538epcas5p391a580450c739f3e7b2f0fcd3d537de5~rPM9w9Fz71756117561epcas5p3U;
	Wed, 25 Nov 2026 08:35:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083536epsmtip123908e5c91ca73bec7b8ea314898c806~rPM8QM5oV0486504865epsmtip1J;
	Wed, 25 Nov 2026 08:35:36 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 3/9] fs: add i_write_stream, exclusive with the write
 life time hint
Date: Wed, 25 Nov 2026 14:03:07 +0530
Message-Id: <20261125083313.106334-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261125083313.106334-1-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083538epcas5p391a580450c739f3e7b2f0fcd3d537de5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083538epcas5p391a580450c739f3e7b2f0fcd3d537de5
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083538epcas5p391a580450c739f3e7b2f0fcd3d537de5@epcas5p3.samsung.com>

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
 fs/internal.h                 |  1 +
 fs/write_streams.c            | 22 ++++++++++++++++++++++
 include/linux/fs.h            |  2 +-
 include/linux/write_streams.h |  3 +++
 6 files changed, 36 insertions(+), 1 deletion(-)

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
index a3bd0cfff1dc..cffea14344fe 100644
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
diff --git a/fs/internal.h b/fs/internal.h
index 81c5a65a08e0..2a5b961bd9d1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -376,3 +376,4 @@ struct write_stream_pool;
 int write_stream_alloc_fd(struct write_stream_pool *pool, struct file *file);
 int write_stream_get_id(struct file *file,
 			const struct write_stream_pool *pool);
+int inode_set_write_stream(struct inode *inode, u16 id);
diff --git a/fs/write_streams.c b/fs/write_streams.c
index d277e12dc890..50b0b0769c38 100644
--- a/fs/write_streams.c
+++ b/fs/write_streams.c
@@ -140,3 +140,25 @@ int write_stream_get_id(struct file *file, const struct write_stream_pool *pool)
 		return -EINVAL;
 	return ws->id;
 }
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
index b7f097164f2f..de561540548a 100644
--- a/include/linux/write_streams.h
+++ b/include/linux/write_streams.h
@@ -7,6 +7,9 @@
 
 struct file;
 
+/* i_write_stream value of an inode that has no write stream */
+#define WRITE_STREAM_NOT_SET	0
+
 /*
  * Write stream slot pool, embedded in whatever filesystem object scopes
  * an id space.
-- 
2.25.1

