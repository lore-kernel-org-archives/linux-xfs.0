Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792932105;
	b=lyT432mzMPR9pmJ4MARiwolm77Z+Nz/4/MUb+cMUkztPErrLA4qxDuEU1G5xG91LDn9x
	 6YXWZihpDfgmhUZWImagzphogdhNFo9YyDnBRlu1cWrjNENfU7bbPbITxYSNcfTfk964g
	 Pib87uvg5+H3j+ai3M//OwvwZ+aLi9VswK2olUjc8U3RqDg4kqep6XnKI4Qs3QDVexein
	 fJH4yeKJ69y6axAd2IsA2XPgDdiqIwpKc98KKSSzANHJM6uMy2ZdRfMl4sEb5aDNPxk2f
	 8CjQeXefsHaxyQvw2M2wLERz92d/Havaa6gg97Q8xxPQ/bvWoQs3H4DdMfXpmksrPpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792932105;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=oTgiIkWj6wM6yrGhrFoHWnZG43Qe+XpDPOdbMsJDQpg=;
	b=iGKNPnlPrWKL5T9p3WQQEX9asgzondWcW/2dJnsHnAn34UYpa9Xz83cJkxZKVhnh31Vr
	 AQImmvKD34znmeBEX+gwfaiUC/MJs8kxHcn4b1xDqkXM52STWNwcbLELfAgGTG9auFMBj
	 zY0jUBDXIgsw19zk8pM6tCB1L+KtNWytG+BR2416SWQywP5/v2drCug3pyh1qjrhhAZv1
	 r8wWohSE0Qo0K72MzmfenPGT9cb0IHzHT5fR9IMbAmrdAOh9bfJdxkz30JbhMtbxFlQEk
	 Q5x24VRkZIdmhnoE9nYycjCHSGay48qn3G8OlimLT+dgu0yVDhr5kqH4i+MqSOUsj1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=I2QEjzal;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C863606A31B;
	Sun, 25 Oct 2026 12:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C863606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=I2QEjzal
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=oT
	giIkWj6wM6yrGhrFoHWnZG43Qe+XpDPOdbMsJDQpg=; b=I2QEjzalWqpWYwPZn1
	WacAN1RVKfzC4a/bQfpbGgHSMoIxAVs71T0eR2hoyHhCQ56v4ATxBG7RXQ9NxvGq
	InyGHX3aildNjYX6KZwrR8al/xG0xJI67rGzcMQKrf09k5pVSBA6PU5dgpTn0Y4D
	s2CJZ3tmz/fcuVwXdJTmtsTmg=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnvTzs+N1qxJALCA--.54355S5;
	Sun, 25 Oct 2026 20:41:21 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 3/5] xfs: drain in-flight DIO before buffered writes
Date: Sun, 25 Oct 2026 20:41:12 +0800
Message-Id: <20261025124115.3178287-4-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261025124115.3178287-1-yaojiale02@163.com>
References: <20261025124115.3178287-1-yaojiale02@163.com>
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
X-CM-TRANSID:PigvCgDnvTzs+N1qxJALCA--.54355S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4fKrW8ZF1fXF17WrW8Crg_yoW8XrWDpF
	Z3Kay5Gr1kJrZ7Ar93GF1UW3W5KFWkZw17urW2gw1xZ3WUCwsI93Wjvr1avw45ArZxZr40
	gF4kKFyDCryYyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-cTPUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhKMxmrd+PJ5JAAA32

XFS_IOLOCK_EXCL prevents new direct I/O submissions, but asynchronous
direct writes submitted while the lock was shared can remain active after
their submitting threads release the lock. A buffered write can then dirty
page cache before direct I/O completion performs post-write invalidation.

Wait for active DIO after acquiring XFS_IOLOCK_EXCL and before buffered
write checks can modify page cache. Return -EAGAIN instead of waiting for
an IOCB_NOWAIT request.

Fixes: acdda3aae146 ("xfs: use iomap_dio_rw")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/xfs/xfs_file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7d0c8a197575..aa7cf51b5843 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1018,6 +1018,20 @@ xfs_file_dax_write(
 	return ret;
 }
 
+STATIC int
+xfs_file_buffered_write_dio_wait(
+	struct kiocb		*iocb)
+{
+	struct inode		*inode = file_inode(iocb->ki_filp);
+
+	if (!atomic_read(&inode->i_dio_count))
+		return 0;
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EAGAIN;
+	inode_dio_wait(inode);
+	return 0;
+}
+
 STATIC ssize_t
 xfs_file_buffered_write(
 	struct kiocb		*iocb,
@@ -1035,6 +1049,10 @@ xfs_file_buffered_write(
 	if (ret)
 		return ret;
 
+	ret = xfs_file_buffered_write_dio_wait(iocb);
+	if (ret)
+		goto out;
+
 	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out;
-- 
2.34.1

