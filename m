Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7148E46A61A
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046078; cv=none; b=mZA5uOaT01Dwf+ILuqvIq8U2/gIcWXw4Ed5ASWkGF6FroaAC3Ig75v8XAPFhMem1rkYl0PxJCW5Dk2/MY2HuXToKQwjsFmbudmHNO4o62KsO+lZhg3bUlMf2lBdHrQ2LEcppLUdwYlAgBJ0mKNf1o9iCQrbXb24JGthPEWTBMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046078; c=relaxed/simple;
	bh=1zfh8WYvyPC+uZAMMUK9gnd+1uZ/O/b6YxIevSyM3IE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=MznFgLWABhiiCFVi1n9TruyeFgMi3i5iKTZrb8DOis6yA2AOzYOaf1FRFIsEx/7We8YHba9lAewo8IIaEzAiKGlogAhPVZG4OhPF9wVODRWJdkCzz32Y1zgIBIsWREq0tWnnbcdS+MbshnEBQWRoq1n/iuO88Trc1lGLTEeStpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HCSuR4ln; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HCSuR4ln"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261015063434epoutp01fcb1a35b14cc2fbc112168973b20875c~eoGj-p8HP1745117451epoutp01j
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261015063434epoutp01fcb1a35b14cc2fbc112168973b20875c~eoGj-p8HP1745117451epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046074;
	bh=pDNFca8udjBe17pcAYw3bCus7otOeAAodN7dMh/L1FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCSuR4lncYKv3nM0uP3zyyByY3ZF97xTX/3MHnI2JxlAp6F/s1e9vpRck35zkjQsT
	 ji8IlHQgjiA8GvzUOm+VpjVTGRwMzlBMcvuZRNIe915oVZc4QBzySgihwhIzjITn8q
	 oedt+SeapEV5PzpqTu2LLYVgtCnU+x/K4w/WOtJ8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261015063434epcas5p228cd34692f3294919266b37c503f6e66~eoGje40pw1238112381epcas5p2E;
	Thu, 15 Oct 2026 06:34:34 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4j4ywS6yQVz6B9m5; Thu, 15 Oct
	2026 06:34:32 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015063432epcas5p2a31bc0518d759cefee79673fd27dd0ce~eoGiF4JrO2701427014epcas5p2L;
	Thu, 15 Oct 2026 06:34:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063430epsmtip147dc23139aae424d263a9a7cee0b3f40~eoGgNgmj21270712707epsmtip1x;
	Thu, 15 Oct 2026 06:34:30 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v6 3/8] fs: add i_write_stream, exclusive with the write
 life time hint
Date: Thu, 15 Oct 2026 12:02:41 +0530
Message-Id: <20261015063246.103433-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063432epcas5p2a31bc0518d759cefee79673fd27dd0ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063432epcas5p2a31bc0518d759cefee79673fd27dd0ce
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063432epcas5p2a31bc0518d759cefee79673fd27dd0ce@epcas5p2.samsung.com>

Keep the attached stream id in the VFS inode rather than the
filesystem's own, so that fcntl_set_rw_hint() can see it. It is a u16 in
the 32-bit hole after i_state, so struct inode does not grow on 64-bit.

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
index a9d37be390a1..3bc0251230c0 100644
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
index deb411e86661..ae91cb93eab6 100644
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

