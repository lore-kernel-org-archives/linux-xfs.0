Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E35745FFA3
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 09:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142434; cv=none; b=hUI66n++r93TBkFf5ymu1SnHtyUjYDQtSkGl1LaURof/3A+HPIPi43unHbeRnDgNMUpKrmq1XjesA1f1h7hyV5dO4CeIUGpy1mLz8hZVY2y5M6i6ee2iCbqsEkZ8UA8nAxRoo1vNqEegbildzZTzqYy3xTmgbW1sskhf+aNov8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142434; c=relaxed/simple;
	bh=EwRXNP8tIugxzv8pAp3hfFOiAhX6X71PusXq27pU6+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOY6kOEREWqgfH1MMsAy35X5zjzc98Lp5vOW9jMeLOTOtfEUaq06zRHzby/wmPeD0jSvCfWh5BH2bybBj3K52RzvGbRfCrqoqQDbEapSTmSPO2miJAqOlCf5YPMoF3mG928oEnlfgtyjfwje7KqqOX6cUhfyVKzNPZdhXGlKm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7yYhN3Z; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7yYhN3Z"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33fb4680717so2093277eec.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 02:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792142432; x=1792747232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9h8Utli2sn9TOY9C79OD+M1xwwpfmXbyxA47Gi/ZqKg=;
        b=E7yYhN3ZgUx08ius+UxX/e13EhdgH/0bSYz3s+Xb4vfwibAUy23eLqfte0gdDSpPTu
         W5+b5FXTLxu+du+rmHpea6NqxrFnbhltSiEj5WcbIviCsPwPkQbsLwLHrsK/HgqIiZpv
         Z80e07ZHIoEyJqL9BGnq0yvh1Kg4rYigu84Cu18fptj/jffRGivS1XBAki19K0MEve9v
         qZQcrveprUfCCvQAx80uHGyr/kkQG0V8iXRJInC53FAJlDuLYvBNDE3IfTIO2w3ydKup
         XuZty0HYBm+PGxAWh4qcrEnTH1YvdAA2udot3OmjuFL3CjRv1S1p+FI6/vPaLbH7Qk5y
         YHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792142432; x=1792747232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9h8Utli2sn9TOY9C79OD+M1xwwpfmXbyxA47Gi/ZqKg=;
        b=mOkOc66yzYRB2Cs2S8TEs/9mpVL1bfed+TYomvr7nksgaz51WzT5/B7FoiIMKj6DCU
         hOd1s9FLOGY9N7QayQ4jqU2ShKk4RPV/6ho4RvuTNhy5+2Hkxsu1XVMw3iTd05SMcJmo
         0diIoTAssruedzxLwXIw44vz28jXdW4SjiOfWHLtvNGuaW8szIOzPco7hQwrmlD+7Z6R
         EDtChqIMEHXg+uK9bRB1iLHvDArMEiYTlB0IuPVwvvFGooWFOJKDvkHr47VsntXNz829
         2nmxMGeXMn3TG4dj8Hbs3ciO9EfR5czxgWSl+OGnsxXg4/SbZKNobFRvv88B4dXsaPq6
         vpVA==
X-Forwarded-Encrypted: i=1; AKwUvBxe5JQYom4G2WiTzRjkDM6xMNaKsHlIE3iaVtnVTF3ST3oL5/dxHAXMGZUQn78tTHn+WQ54k4JOTDQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJGYi/snIjPgO4/rhxvlnF1CptW6FWWhGwCkxF684nvcfqj1D24
	D/YAmMxyB4GZqno/yd6giMNBKrJuwQs5jFPiW4xHM7pmPpchprFeJ2o=
X-Gm-Gg: AYBFou3Bcvw7Lq5jAkAroKyEknYEUaCiah13DtVmUjxgj6vvPyLB6Sc5ettiFaDd8JN
	xQbSlwKMTZ0xalBOUpe+OHuL11U51BS+xNrIUhxob03YLig9JjY7C41srHAXfL07Frv/MNlxNnS
	/3M9Z1jkpBHgSKqOYGBsIzrcWWo7tqYlQqJOqsVnbE6ocFktltXrmizHubVaWGnFz0rZ+yNC7Tx
	ILIatWAXZKnmeIgBUAW6q8g5k7Nhfvd4p5jr2L4JmUY6fdEfqxo5QJH/VCRmKt2399hs+xSZpo7
	s+Iy+zEEvkazPmxzJiVTcTG/g0fiuiJd6ApwJ7KlzUrc6tLoPMvCkyGT97UWStN6lWtWIFc5GlG
	JhlkFvCRhA7EgzhxONQBFEbHUKIC/QdyXQ/cH0TVCwRaMXv9cYZXiPnqoJnij5oUwkI2uOwIsXB
	9kRENqYUAxiDN1Sa1dguWdVl9ROt7M6JfRiSa/LzXU/c1FcLg+3W+X1qMGkGYyuHaxlOEZDFl1o
	L/1Y7zqxVCcbKIfhMekJjbRJps0wDhr9l4eo+kCT0YPCZC2RZs=
X-Received: by 2002:a05:7300:2720:b0:35a:84cc:d941 with SMTP id 5a478bee46e88-35a84ccdc1emr20515510eec.37.1792142432091;
        Fri, 16 Oct 2026 02:20:32 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:7bfc:fc3a:e718:89f6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36082a7b33bsm9840943eec.24.2026.10.16.02.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 02:20:31 -0700 (PDT)
From: Anuj Gupta <anuj1072538@gmail.com>
To: asml.silence@gmail.com,
	hch@lst.de,
	djwong@kernel.org,
	cem@kernel.org,
	brauner@kernel.org,
	axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	nj.shetty@samsung.com
Subject: [RFC 4/4] xfs: support dma-buf registered buffers for direct I/O
Date: Fri, 16 Oct 2026 14:49:14 +0530
Message-ID: <20261016091919.971295-5-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016091919.971295-1-anuj1072538@gmail.com>
References: <20261016091919.971295-1-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Add the init_dma_buf_io_ctx fop for XFS files.
XFS picks the device and calls the iomap layer with
the relevant device.

Refuse the iterator from every CPU-copy path: DAX, buffered
fallback from a -ENOTBLK direct write, and read/writes
without O_DIRECT.

If a file is switched between the data and realtime devices
after registration, the block layer cross-device check refuses
the I/O.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 fs/xfs/xfs_file.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 426a67b813a7..f97d5acfaf68 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -340,6 +340,11 @@ xfs_file_read_iter(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	/* a device mapping can only be read by a direct I/O bio */
+	if (iov_iter_is_dmabuf_map(to) &&
+	    (IS_DAX(inode) || !(iocb->ki_flags & IOCB_DIRECT)))
+		return -EOPNOTSUPP;
+
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
 	else if (iocb->ki_flags & IOCB_DIRECT)
@@ -1196,6 +1201,11 @@ xfs_file_write_iter(
 			return ret;
 	}
 
+	/* a device mapping can only be written by a direct I/O bio */
+	if (iov_iter_is_dmabuf_map(from) &&
+	    (IS_DAX(inode) || !(iocb->ki_flags & IOCB_DIRECT)))
+		return -EOPNOTSUPP;
+
 	if (IS_DAX(inode))
 		return xfs_file_dax_write(iocb, from);
 
@@ -1209,6 +1219,9 @@ xfs_file_write_iter(
 		ret = xfs_file_dio_write(iocb, from);
 		if (ret != -ENOTBLK)
 			return ret;
+		/* the page cache cannot copy from a device mapping */
+		if (iov_iter_is_dmabuf_map(from))
+			return -EOPNOTSUPP;
 	}
 
 	if (xfs_is_zoned_inode(ip))
@@ -2173,10 +2186,27 @@ xfs_file_mmap_prepare(
 	return 0;
 }
 
+/*
+ * A realtime file's data lives on the realtime device, anything else on the
+ * data device. If a file is switched between them after registration, the
+ * block layer cross-device check refuses the I/O.
+ */
+static int
+xfs_file_init_dma_buf_io_ctx(
+	struct file		*file,
+	struct dma_buf_io_ctx	*ctx)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(file));
+
+	return iomap_file_init_dma_buf_io_ctx(file,
+			xfs_inode_buftarg(ip)->bt_bdev, ctx);
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read_iter	= xfs_file_read_iter,
 	.write_iter	= xfs_file_write_iter,
+	.init_dma_buf_io_ctx = xfs_file_init_dma_buf_io_ctx,
 	.splice_read	= xfs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.iopoll		= iocb_bio_iopoll,
-- 
2.43.0

