Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD333546C3
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 13:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293512; cv=none; b=SjGJkpZQJQDUZTCv0fwEm694d5Su3EwENj5L7RrW69a/jQdJ9jgwu3plz9vom8K7hE+nvXbRDEPzOD089YTO1PnhAVCJHJmrAWeCEPGE2CfdmHpnZBR2v+1jh/TWnEm190G0H89ZivmiVglo6JXoKijONh4u7OE4JlPc0ZsB/8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293512; c=relaxed/simple;
	bh=+S161UNQBlt6BwZQkSKfXoQecbi4lgUMX7fYfR017qk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=htxDCXoi0bn+ZPZO8meXLvRG3AOoxJa2Uo8MHSMVM7caLp32YLx3sNM94lcvhhJJ3Bot3ZrjbeaEIERvlcMZLuJavys7bYxXrocedSeXQ2QakNA/TTrnZ0eJkMBl2B7lVDxmX8JPV4Ph9YlvtSbMdqK9fI4n9hNsOZvfj0bwWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MlJXBPgt; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MlJXBPgt"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260717125629epoutp0395994f529034d20fe61899b7238f2a94~DFQVC_yPy3137631376epoutp03R
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260717125629epoutp0395994f529034d20fe61899b7238f2a94~DFQVC_yPy3137631376epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784292989;
	bh=3AMDvBn6ma/cX4Ovor/jyA+F92z1Qwa40XQ6d/qJL4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlJXBPgtwPRYTKkJQscAHgA0a8WGfQubUFAi6tYWS+wTpDqNHsdw6dN/LiJwwBMed
	 YLPqbuazXOdkSEk+NnaXzFuYY1FSH88VvuiBaDyFiOT+Q2UYtS8VKbfpO6JgTiYIjo
	 dfToC6DfB4qOJYSASmE5VdTLve5cOIwdORFciClc=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260717125628epcas5p37985b0c2c5b37b6c74ae6e5a8901be78~DFQUSESuU1729017290epcas5p3J;
	Fri, 17 Jul 2026 12:56:28 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h1qfg6fVKz6B9m5; Fri, 17 Jul
	2026 12:56:27 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319~DFQS_Yu290710307103epcas5p3M;
	Fri, 17 Jul 2026 12:56:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125624epsmtip28b7bfdb1560736a5d781ad4f7af78330~DFQQQDVgg1798617986epsmtip2K;
	Fri, 17 Jul 2026 12:56:24 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 1/6] fs: add write-stream management ioctls
Date: Fri, 17 Jul 2026 18:25:33 +0530
Message-Id: <20260717125538.508925-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717125538.508925-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Wire up the userspace interface for write stream management via four
ioctls:

  FS_IOC_WRITE_STREAM_GET_MAX  query the max streams supported
  FS_IOC_WRITE_STREAM_OPEN     open a stream id, returns a stream fd
  FS_IOC_WRITE_STREAM_SET      attach the stream fd to an open file
  FS_IOC_WRITE_STREAM_GET      query the stream id value set on a file

Application should query the available streams by using
FS_IOC_WRITE_STREAM_GET_MAX. If returned value is N, valid stream id for
the file are 1 to N.

Application calls FS_IOC_WRITE_STREAM_OPEN to get fd for a stream-id.
By default, kernel picks an available stream-id and returns the fd for
it. The flag FS_WRITE_STREAM_OPEN_EXACT can be used to request a
specific stream_id. This is useful if application cares about keeping a
stable stream-id-to-spatial-isolation-bucket mapping across restarts.

Suggested-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/fs.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index bd87262f2e34..a756d27bdf84 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -345,6 +345,22 @@ struct file_attr {
 /* Get logical block metadata capability details */
 #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
 
+struct fs_write_stream_open {
+	__u32		stream_id;	/* IN: requested id if OPEN_EXACT set; OUT: assigned id */
+	__u32		flags;		/* IN: FS_WRITE_STREAM_OPEN_* */
+};
+
+/*
+ * Flag to ask for specific stream_id, otherwise kernel can return any.
+ * Fails with -EBUSY if that stream_id is already held
+ */
+#define FS_WRITE_STREAM_OPEN_EXACT	(1 << 0)
+
+#define FS_IOC_WRITE_STREAM_GET_MAX	_IOR('f', 135, __u32)
+#define FS_IOC_WRITE_STREAM_OPEN	_IOWR('f', 136, struct fs_write_stream_open)
+#define FS_IOC_WRITE_STREAM_SET		_IOW('f', 137, __s32)
+#define FS_IOC_WRITE_STREAM_GET		_IOR('f', 138, __u32)
+
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  *
-- 
2.25.1

