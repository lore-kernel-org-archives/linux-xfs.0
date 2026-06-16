Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01733D566F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633574; cv=none; b=NyvSO0eZsRJYKn4vsTS6bnuidE85AqIprcXQG9MmVWQg44ARt3AIUqsFfuJRFYg8/VO2Vz0iTqCERNOOxmZAxdULiomwM7f872dUhT8T10iKufG+W4NU48PqQgWAwNKZ2K4lNwPseENMPYlf4tQwlNGoHY1vkNx/4LW8n31BdjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633574; c=relaxed/simple;
	bh=SxNEQVHlL+X6WZ0hhR4b1e77s8jZTxTxCiuYSwEKtp4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=h0O3DCobw+nJDm73xkBUj2REL16mWVi2YxoSJWs3+f4kKtPeqzjfxAUWrmIFc7PqItnAfX40GeY330InOdzoKcwceEywzAXMYUm3dISFkNaXwWDdjmDDiAZTdjUNymktn8ylGQbfWUAZsfwAgZ4fRM0mEJL4GlAJBwrqqQeQ/xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jEiO6XOP; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jEiO6XOP"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260616181244epoutp0221bbb9daacd262bfb5a8f08be5eae675~5okmgYKNa2316323163epoutp02I
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260616181244epoutp0221bbb9daacd262bfb5a8f08be5eae675~5okmgYKNa2316323163epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633564;
	bh=ZFLgbjU9mfb8WUFvy1TB4gsK01M7Iew9VMASYlS26po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEiO6XOPO5NF8pfrT/6kAHjKuQ8/rVBhkhMZeDttj9M+02Nj9uyhhvrDp2Zb3aqyK
	 SncP5Gc0eazQ8bECibhena8pFRnUt+nISt/yxdX4UfdXFugVKlIQPOiQkE7Y+aEpqW
	 ZTBRx9Yn5VXHhdnFe/G/b2NQa/KDIGMHajV7lY3w=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260616181243epcas5p2ff4a0a632c8867441b7a1c9621dbc245~5oklmR_JX1264812648epcas5p28;
	Tue, 16 Jun 2026 18:12:43 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4gfw7t5lmnz6B9m4; Tue, 16 Jun
	2026 18:12:42 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260616181242epcas5p28887b4de29580d5fc74448f2b0d45a1d~5okkLozMT2846528465epcas5p2X;
	Tue, 16 Jun 2026 18:12:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181240epsmtip1569397d46b09d5dd4e9c4e384f319534~5okiXvP4o0265502655epsmtip1J;
	Tue, 16 Jun 2026 18:12:40 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 1/6] fs: add generic write-stream management ioctl
Date: Tue, 16 Jun 2026 23:35:50 +0530
Message-Id: <20260616180555.33338-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260616180555.33338-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181242epcas5p28887b4de29580d5fc74448f2b0d45a1d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181242epcas5p28887b4de29580d5fc74448f2b0d45a1d
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181242epcas5p28887b4de29580d5fc74448f2b0d45a1d@epcas5p2.samsung.com>

Wire up the userspace interface for write stream management via a new
vfs ioctl 'FS_IOC_WRITE_STEAM'.
Application communictes the intended operation using the 'op_flags'
field of the passed 'struct fs_write_stream'.
Valid flags are:
FS_WRITE_STREAM_OP_GET_MAX: Returns the number of available streams.
FS_WRITE_STREAM_OP_SET: Assign a specific stream value to the file.
FS_WRITE_STREAM_OP_GET: Query what stream value is set on the file.

Application should query the available streams by using
FS_WRITE_STREAM_OP_GET_MAX first.
If returned value is N, valid stream values for the file are 0 to N.
Stream value 0 implies that no stream is set on the file.
Setting a larger value than available streams is rejected.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/fs.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 13f71202845e..9e87271e610b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -338,6 +338,20 @@ struct file_attr {
 /* Get logical block metadata capability details */
 #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
 
+struct fs_write_stream {
+	__u32		op_flags;	/* IN: operation flags */
+	union {
+		__u32		stream_id;	/* IN/OUT:  stream value to assign/guery */
+		__u32		max_streams;	/* OUT: max streams values supported */
+	};
+	__u64		rsvd;
+};
+
+#define FS_WRITE_STREAM_OP_GET_MAX		(1 << 0)
+#define FS_WRITE_STREAM_OP_GET			(1 << 1)
+#define FS_WRITE_STREAM_OP_SET			(1 << 2)
+
+#define FS_IOC_WRITE_STREAM		_IOWR('f', 135, struct fs_write_stream)
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  *
-- 
2.25.1

