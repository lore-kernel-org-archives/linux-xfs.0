Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595739;
	b=P+AdNcGwDOPsKcV9XpGh+Es44E2enxYIMFVXBE41Q+7tkIw05kUOG2jid0Wj4goadz+M
	 TcUz86AGkr8JP1zn/lrvLdpZygWIsvtLR7QzGVkC6LZwGLY3PqM1TjgmBVba+4LA+jPL1
	 nXkmRlPTfGHlfcchpnh8jpqgtdUFgl+c7mMnm9WXUyepAgRIGAi+R3ZAIUR2bLRnbeJw4
	 KadyBV6Fr8fDWMD4Zq3LcMHja+wx3UEiS+bJY76xuD56IhqYMO0ZZWJiyIM8seSgVdlR1
	 K9N5LKtIRGt5DRFNuGm/CV9QlvVlZxy1jo1dVlaeHc2aASkaoeMUaJiR0QCLR7wvaIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595739;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=gJzjC/iH8LFh/v0fQJ7hyWp0kYWI9Lg8BWXvdCLKyzI=;
	b=eB74/fJGL921weuJbZeoORS8crPjVQZku6n6358sPT1upGHhTp+e3indjz33JMxunDBX
	 d0LOwdQ5On03kjVslOSTTZ+aNB8Qedgnd1KK/+dduWdczQj5zRrVlpmWBfA4ctxq0Dk7M
	 v01HwuCU7d62megFYe/bEadiy0SkLvQUpANm2YKCJFuJ8jkl4zqehQ14C7nR8Ec6UsfXG
	 NRBS1pSHu5Chyavhsg5JiE4mJ55CXlK+Yv9X0WY2xAqx2XsLfOGDSbN3vJHNDiA5MgTAr
	 fFQ8RV38521Lgx6irIxs/N3VS7MEZm7IZnAISu50TmmK1dzOOxR4YhnRXX7qCwRyhVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=CGnJNtyw;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5831B606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5831B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=CGnJNtyw
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261125083536epoutp04614cedb06a854af124cca82906dbe28f~rPM8GVbqQ1091610916epoutp04-
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261125083536epoutp04614cedb06a854af124cca82906dbe28f~rPM8GVbqQ1091610916epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595736;
	bh=gJzjC/iH8LFh/v0fQJ7hyWp0kYWI9Lg8BWXvdCLKyzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGnJNtyw4veZLX3if7ODzrkVNmPyGKe8coZwomV1xibll4wpHcf9XssOzHXAyqgKO
	 yuCUULkisacne5swYpw2mKAIxmuMSct2YuJBbYIU8e80BAD3+Gq3TMh+EKQSKIccad
	 Kqio5hph+zJNfAz2ZCbzfFQbAploTDh1G9a596RI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261125083535epcas5p10c4f5a23915b65cc5405bacae4d234bd~rPM7emcoL1553915539epcas5p1a;
	Wed, 25 Nov 2026 08:35:35 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jZCgB67G4z2SSKX; Wed, 25 Nov
	2026 08:35:34 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261125083534epcas5p4d3975423a204266a466e04bc8a2651ac~rPM6SMtDr0182501825epcas5p4L;
	Wed, 25 Nov 2026 08:35:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083532epsmtip14f79443105c173eb3fec4983b02727d5~rPM4tubWX0486504865epsmtip1G;
	Wed, 25 Nov 2026 08:35:32 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 1/9] fs: add write-stream management ioctls
Date: Wed, 25 Nov 2026 14:03:05 +0530
Message-Id: <20261125083313.106334-2-joshi.k@samsung.com>
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
X-CMS-MailID: 20261125083534epcas5p4d3975423a204266a466e04bc8a2651ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083534epcas5p4d3975423a204266a466e04bc8a2651ac
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083534epcas5p4d3975423a204266a466e04bc8a2651ac@epcas5p4.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

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
index a13c7b32a1bd..baf2219a8c5d 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -354,6 +354,21 @@ struct file_attr {
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

