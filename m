Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705703;
	b=B8jBJU9wkNkpXM4h/OvqJGyi50aKyZGOgqgq76GnHg/A+krwMwNiz8tEx/F8sbJxel55
	 vWzsMP+9mYodTvNwIwfOzPgSPfCcsfWPaGCBFP6XeVQDGv3Oj+XvB324mmMadPBc0qy8l
	 dmgSM3K8FwBx7JUVt/D3BghDeD3Q3Z/j+hDUSYMG55npflvxZI/acwWnn9hqQqYle0XgS
	 zBf8RF0pitJMmmjAdMq6q+VkdtlXIy1XkQ8zxXadZEBDujWumW0lrl7DpmhVj48LhioQ5
	 6FAgN05kKJ2d40wFZfq5JcxzI1M8sgAkHw+fufTdRqERG7TjZ+B51lvSDTl0wYztA/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705703;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=CAI1h5YO8LYTf9x/LoRpduAEOlD23JNm6Y6TXo0PMN8=;
	b=yA8EuLr+09VWT2PTcCWcqSAXYDUmO/NalmyskNxNOg8qFr2oYdpIWkQgW3VSApBQmU18
	 5BCvVTJAuipFxT97xHSsfrGQTebWuetk0+85dhl1LcSBL8Tpyt0CNN3ImBhAUjr7WsKi4
	 5HZ6vRpeCR7SJa/mfZt+xW05BE7XgaKDlRflRf3Z6UPg7m/E/lVFpGOE69CTlpZ4ffBvt
	 r9Mu2DhtJbmCkKrvehYeRhN10Yr0OkRo0QtMNzNVsXj8YHQaWnQKJRwDsNQtHsyJ1w6kc
	 cSbAgAbNrSuuHrw5ee0Vkz7L5REEdKXQEXgXC8NA4nv9leqjF8wKCMLjLexFiUfMRRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WNE8mjBZ;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CF606A324
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C7CF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WNE8mjBZ
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261103113459epoutp04c702da1d1cf526e999a2108b36c0bc2f~khdR92BdR1940919409epoutp04F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:34:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261103113459epoutp04c702da1d1cf526e999a2108b36c0bc2f~khdR92BdR1940919409epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705699;
	bh=CAI1h5YO8LYTf9x/LoRpduAEOlD23JNm6Y6TXo0PMN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNE8mjBZ3JZZUBozjLcKmUzHC6gTnDqWkErehE9RooN7CjX4WNLzQQ+CapF7EIwIO
	 XqTV9fUx5TNuOBh4QUxKySrbcBRCwv+XNeIn4BvWJX+qfkT9zJ1BLhaF91qRbpzGh5
	 JemPQl0X/3Avak6ZM1ry9wpRP9rkkFOlwplal2JQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261103113458epcas5p483f3e741ee13e8c0486942ff7914ee74~khdRVrQgz1832818328epcas5p4L;
	Tue,  3 Nov 2026 11:34:58 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jJmhK6Scbz6B9m7; Tue,  3 Nov
	2026 11:34:57 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261103111024epcas5p3ebaf05995f2105fa7c41239296ebf894~khH00Q2043164131641epcas5p3H;
	Tue,  3 Nov 2026 11:10:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111022epsmtip12546f0e60f7cbd38fc9f7b2ee147567d~khHyxcGMq2962229622epsmtip1P;
	Tue,  3 Nov 2026 11:10:22 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 1/8] fs: add write-stream management ioctls
Date: Tue,  3 Nov 2026 16:36:33 +0530
Message-Id: <20261103110640.1000095-2-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111024epcas5p3ebaf05995f2105fa7c41239296ebf894
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111024epcas5p3ebaf05995f2105fa7c41239296ebf894
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111024epcas5p3ebaf05995f2105fa7c41239296ebf894@epcas5p3.samsung.com>

Add three ioctls for write stream management:

  FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
  FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns an fd
  FS_IOC_WRITE_STREAM_SET      set or clear a stream on a file

Write streams are a resource the kernel manages and applications ask
for.

ALLOC reserves a stream and returns a stream fd; the stream stays
reserved as long as that fd is open. ALLOC fails once all streams are
reserved.

SET assigns the stream named by the stream_fd in struct
fs_write_stream_set to an open file; the same stream fd can be used to
set the stream on any number of files. SET with FS_WRITE_STREAM_SET_CLEAR
and a stream_fd of -1 clears whatever stream the file carries.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/fs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a46c33692aa2..4a20ceb4e742 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -345,6 +345,21 @@ struct file_attr {
 /* Get logical block metadata capability details */
 #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
 
+struct fs_write_stream_set {
+	__s32		stream_fd;	/* IN: stream to attach, -1 to clear */
+	__u32		flags;		/* IN: FS_WRITE_STREAM_SET_* */
+};
+
+/* Clear the file's write stream. Requires stream_fd to be -1. */
+#define FS_WRITE_STREAM_SET_CLEAR	(1U << 0)
+
+/* GET_MAX returns the count through its argument; ALLOC returns a stream fd
+ * as the ioctl return value and takes none.
+ */
+#define FS_IOC_WRITE_STREAM_GET_MAX	_IOR(0x15, 3, __u32)
+#define FS_IOC_WRITE_STREAM_ALLOC	_IO(0x15, 4)
+#define FS_IOC_WRITE_STREAM_SET		_IOW(0x15, 5, struct fs_write_stream_set)
+
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  *
-- 
2.25.1

