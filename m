Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E947886E
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983157; cv=none; b=pyn+vCGuJZSPkPVBisiSQ1kJNCoI7iCU/EW4EmYj1I/qMxjBZyqg1ZauVHvgKb1IT6d1+HreOvvEP8B71O2+JfL/yDfDMyPnfOYRqmVJGkXej3GoogqiCVYf8BeVNuOnKc5T1FnBhtO5eLzan0HbkBc+h6Ph5zERzF/N2oREp/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983157; c=relaxed/simple;
	bh=GTDheRSdwvTM7l1T8j1Wdqg6gtlNlmtWqKBpOMh1AnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Ek4+z24x7kieg2fFRRcIr9Ac8UDGQPr+KU/JFgCyBB3qnw8HbexvX+jIdytvOd3PnVWHQOy/9gE6JZu9qVsjadv7l62IoTR7olkPx+6dL6XTd64WgQsuK50Bp1C0nTQJepkScC0ddvYj5oDVeEUIccKGgEwSBdau769Fxqc9Nps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LhZP2FnL; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LhZP2FnL"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260921093233epoutp02acbfdbef3e3323624b24b9d0a80aaa44~XTDG2Q5LQ1117411174epoutp02D
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260921093233epoutp02acbfdbef3e3323624b24b9d0a80aaa44~XTDG2Q5LQ1117411174epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983153;
	bh=RN7g0JnPUdLwXErtiwoyfhPolDrUinuGfVXjxbpEJ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhZP2FnLa+J7ivj9W9FthbzHb5XVcY/GHhcwkLbqk6MyiIO+b+dWRewS3eDHCxwcH
	 Y3DgHiX5IRKpClVI29m1z1fgDeWnRmoJIka5zduZjwj8//E50YPP6TFhrymNSuI6o/
	 Ff/E4TzEoP7iWBH3yzH9AI9lZ+WWlBLDZWmEeixs=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260921093232epcas5p37c3db3a0d259583ccb42df6cc579c907~XTDGa5kes2556525565epcas5p3G;
	Mon, 21 Sep 2026 09:32:32 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hpJ0w0vvzz6B9m7; Mon, 21 Sep
	2026 09:32:32 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260921093231epcas5p2c87f8ef3f86466a34e9dd1633decf4c9~XTDFY2Y150113601136epcas5p2V;
	Mon, 21 Sep 2026 09:32:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093229epsmtip19dbfc14087ef445d934450b839813b6a~XTDDtMink0528605286epsmtip1s;
	Mon, 21 Sep 2026 09:32:29 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v5 1/8] fs: add write-stream management ioctls
Date: Mon, 21 Sep 2026 15:01:40 +0530
Message-Id: <20260921093147.59935-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093231epcas5p2c87f8ef3f86466a34e9dd1633decf4c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093231epcas5p2c87f8ef3f86466a34e9dd1633decf4c9
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093231epcas5p2c87f8ef3f86466a34e9dd1633decf4c9@epcas5p2.samsung.com>

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

