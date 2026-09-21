Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC72489FA1
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983161; cv=none; b=DiwP+b5xvCTUKeV1UGSxqDHPE9JPLo5iHrh7klPi4VGeDUjmROfUUz4Y5d+eyIycTmWuhUpHGRJgdmy2N+qPdy+dc4Ngjt0dT0qL9v6JPZ2IhON8yTWH2nn5z3wLW8Sfj79cpsw0wcRNgxZqI52pFDbdeZu/8Uy8eRJQXCecqd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983161; c=relaxed/simple;
	bh=GcAhyiDZ4QC/x470pv/d1Hq2hh975HlaztIacfnhIlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FDsFT/OAQ26jhhDp5GDef7hqWfJYpnUywej+aB7uBQoi0+fKmn1rnkyqoJRNe75NPrUEg5dRM02dPv4Wmf7BpH+BYKzhgpCsgDI1hhZbN1tDhlV1ZZ9t2oOEd/3ci0hKjWNh1RvINKSx1C9sWkQ0xgfZfnTrOlK8LRej5d2mKCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ko2Q7mN1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ko2Q7mN1"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260921093237epoutp02e28e7d249bff1337a846a213af586ae1~XTDK7MVVQ0919509195epoutp02Q
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260921093237epoutp02e28e7d249bff1337a846a213af586ae1~XTDK7MVVQ0919509195epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983157;
	bh=mFuONrLs6kxMSEsTRrr1knGIpzcYH9g1s70j4UjmN1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ko2Q7mN1uOeCgKjeGHns+BnovKNs12OuJdE0l23tBpplFLWIVKSb3yMqrlcyldZCL
	 BHCUaeH5iDzhngLrkmDj/NmRUr1PJx0+ekrxWwdGtBA3TehFai5FgEGZBqqBQ3DhOv
	 En9/XMzmPMPA8B7Whgo8vqP5FXK9YxD/kxvGohSg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260921093237epcas5p39d0db3b0cd526da1313dfb1fd126ac2f~XTDKpcE6C0221502215epcas5p3G;
	Mon, 21 Sep 2026 09:32:37 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hpJ102MSBz6B9m7; Mon, 21 Sep
	2026 09:32:36 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260921093235epcas5p4f48991b0a4b7d553828b5a5d80524c72~XTDJQC9je0763107631epcas5p4B;
	Mon, 21 Sep 2026 09:32:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093234epsmtip1e0aaf1b82b552c77f78ed5d3225dbbef~XTDHkRTOX0415804158epsmtip1d;
	Mon, 21 Sep 2026 09:32:33 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v5 3/8] fs: add i_write_stream, exclusive with the write
 life time hint
Date: Mon, 21 Sep 2026 15:01:42 +0530
Message-Id: <20260921093147.59935-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093235epcas5p4f48991b0a4b7d553828b5a5d80524c72
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093235epcas5p4f48991b0a4b7d553828b5a5d80524c72
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093235epcas5p4f48991b0a4b7d553828b5a5d80524c72@epcas5p4.samsung.com>

Keep the attached stream id in the VFS inode rather than the
filesystem's own, so that fcntl_set_rw_hint() can see it. It is a u16 in
the 32-bit hole after i_state, so struct inode does not grow.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fcntl.c         | 7 +++++++
 fs/inode.c         | 1 +
 include/linux/fs.h | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index c158f082f1da..a5439e076197 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -380,7 +380,14 @@ static long fcntl_set_rw_hint(struct file *file, unsigned long arg)
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
index ba7da39be4a3..50b91d449a38 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -246,6 +246,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	atomic_set(&inode->i_writecount, 0);
 	inode->i_size = 0;
 	inode->i_write_hint = WRITE_LIFE_NOT_SET;
+	inode->i_write_stream = 0;
 	inode->i_blocks = 0;
 	inode->i_bytes = 0;
 	inode->i_generation = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..3d9ce4d30cd5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -812,7 +812,7 @@ struct inode {
 
 	/* Misc */
 	struct inode_state_flags i_state;
-	/* 32-bit hole */
+	u16			i_write_stream;
 	struct rw_semaphore	i_rwsem;
 
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
-- 
2.25.1

