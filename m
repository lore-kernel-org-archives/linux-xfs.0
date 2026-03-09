Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C84317163
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773034482; cv=none; b=Y6cJF0hfs6c+s7zw92P3gK6YCQLvvKaMt136pdFqdbUfs6AvuwAV73CVLQvemSV+m8SJdK/32v46ZFEO8jBgyasDRBTdmcSpUbZVOEpm2qxZ7OBWdBDcdTSJcGMYJ5nP7KY31p5Sl3KXWa6lI3xbkXfy9qo+zsDES5T+UJiwtSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773034482; c=relaxed/simple;
	bh=TzlRSpQAsw9cHmftjomyrgB2OYMeXWd0KmsT56rYgr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=IjkYF95aBnt45Sg9Fs5AWEGRDMNky9F+odz8+Afb58nO/MvlSMCmmKHrGGWfbaVMh+cKhZSSLBBDifibfqK10zoge8knDQogvvdZXb5coTIbbACVp966l4fDUIN+9O3ejC/+Krc3RhIcmCGSVi6+jwZ6LHiOAvfJIJPEWt0E3PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YHrWtd7W; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YHrWtd7W"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260309053429epoutp02835ce6aca33828fb0495ff12732aca99~bFXTXO-4e0835308353epoutp02M
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 05:34:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260309053429epoutp02835ce6aca33828fb0495ff12732aca99~bFXTXO-4e0835308353epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773034469;
	bh=yuk2o0L1L2sHLcx86UPn/Z9tvgjc3PMdZfNWzeNxH/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHrWtd7WpZEAPLtcHnFHe9J6JhZxaGfuKBzmQ76925X3ct2wjCjx3CRXY7LjTY81j
	 Vs/OZ+Ix62D226gL7LkQ21qGNimkYaO6RHwFRdfV6eVMYntETKkk5//xdkeFDFqWzA
	 l5JfH8E4Q1Ji7Rp/KYoU+qWrwDfu5fyfPgsMGBbo=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260309053429epcas5p39c93b0c08c1f444f2be7d4e175c05df2~bFXS1JlSN3063730637epcas5p3N;
	Mon,  9 Mar 2026 05:34:29 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fTm0h2GNyz3hhTD; Mon,  9 Mar
	2026 05:34:28 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260309053427epcas5p23419afbe49e4e35526388601e162ee94~bFXRhsip40112901129epcas5p2-;
	Mon,  9 Mar 2026 05:34:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260309053426epsmtip22fa535911620209d04a6c56b2a9f3e09~bFXP2JyX_1941719417epsmtip2c;
	Mon,  9 Mar 2026 05:34:25 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 1/5] fs: add generic write-stream management ioctl
Date: Mon,  9 Mar 2026 10:59:40 +0530
Message-Id: <20260309052944.156054-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260309052944.156054-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260309053427epcas5p23419afbe49e4e35526388601e162ee94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053427epcas5p23419afbe49e4e35526388601e162ee94
References: <20260309052944.156054-1-joshi.k@samsung.com>
	<CGME20260309053427epcas5p23419afbe49e4e35526388601e162ee94@epcas5p2.samsung.com>

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
 include/uapi/linux/fs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 70b2b661f42c..4d0805b52949 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -338,6 +338,18 @@ struct file_attr {
 /* Get logical block metadata capability details */
 #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
 
+struct fs_write_stream {
+	__u32		op_flags;	/* IN: operation flags */
+	__u32		stream_id;	/* IN/OUT:  stream value to assign/guery */
+	__u32		max_streams;	/* OUT: max streams values supported */
+	__u32		rsvd;
+};
+
+#define FS_WRITE_STREAM_OP_GET_MAX		(1 << 0)
+#define FS_WRITE_STREAM_OP_GET			(1 << 1)
+#define FS_WRITE_STREAM_OP_SET			(1 << 2)
+
+#define FS_IOC_WRITE_STREAM		_IOWR('f', 43, struct fs_write_stream)
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  *
-- 
2.25.1

