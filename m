Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8D93A9615
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046074; cv=none; b=u8TLE25QC7jZB+yIHOngksH83+P6Xg8RIaQ4XdS5XeGFf5bt5Wq4ysYuyMEUrmOgovcq5Wy88hUDB09YL1y60FwceLNVlZtnO7U2966PL1YOTYQAm5hfjn+gC+CRtXps1DEX/Qj6UrW3ux/tO90RfCNv4L7KLT9XCaV8buhjA1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046074; c=relaxed/simple;
	bh=GTDheRSdwvTM7l1T8j1Wdqg6gtlNlmtWqKBpOMh1AnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=QJKuXXRAeCic2YEhyha5U8lPFZxQjIaxFbf43UkBolzk/QUSs7sFIlyrmcKoRKwN22Qj/1j5uoDI1gU2vGo8iXNcVTRiWDj8ZGDNRPyxmGwav7INormcisW8w8iBqZsBlrt4I7nyJnv08xaUyja8X05lY+4lZfQhmiRJmMzgoOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qVF9HbJt; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qVF9HbJt"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261015063429epoutp02f9205692ab3680d3ddbef1aa8166effb~eoGfl1a5s2696226962epoutp022
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261015063429epoutp02f9205692ab3680d3ddbef1aa8166effb~eoGfl1a5s2696226962epoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046069;
	bh=RN7g0JnPUdLwXErtiwoyfhPolDrUinuGfVXjxbpEJ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVF9HbJt05e309/5FvI2qrtLWjsR3UScFpVcMI0hKwOppTSOWRxYwPzlnVaH5kziv
	 RB6UYhea9xLNLDPEx5+nrTyWdD2inEdp/2VZUPD/Pg/8cS9yYbxUVkKN3x9U4sYqpw
	 z0qCzXVxcVdnvRfThc8xA79bD0j/fWwyHJmvNcwQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261015063429epcas5p46a83f5ba79c20d32490b756d5bc02e25~eoGfHGP-P0533305333epcas5p4z;
	Thu, 15 Oct 2026 06:34:29 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j4ywN2Xy9z3hhT8; Thu, 15 Oct
	2026 06:34:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015063427epcas5p239975160aeb6c82580b92e198f4c2d62~eoGdwjaBw1238112381epcas5p20;
	Thu, 15 Oct 2026 06:34:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063425epsmtip1a05d16c8f3e85589a2cfb4e5455e098f~eoGb6Nlia1270712707epsmtip1t;
	Thu, 15 Oct 2026 06:34:25 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v6 1/8] fs: add write-stream management ioctls
Date: Thu, 15 Oct 2026 12:02:39 +0530
Message-Id: <20261015063246.103433-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063427epcas5p239975160aeb6c82580b92e198f4c2d62
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063427epcas5p239975160aeb6c82580b92e198f4c2d62
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063427epcas5p239975160aeb6c82580b92e198f4c2d62@epcas5p2.samsung.com>

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
index 34c6f219462a..1974052aa476 100644
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

