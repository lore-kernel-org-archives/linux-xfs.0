Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A0F17BEBF
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479600; cv=none; b=OikYMHhwrRgUdt2WGKpR0jSmGD0n/BPGEEb7wEih5qWAP/VgbE6jzrG0WFYqH9P0gMlwPvhPDUs3JrxpeqlT9LZ2iDcUvfQgwjR/JlixgqZJsWvoK6kC3T73qpon/R8BysPwX0ZptAsjbweqsdMLbgCW4zv0ujejYu+qIhF/n9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479600; c=relaxed/simple;
	bh=3BGJqaxkQ2MYyntK7M74rTstb9gVXjogrJidmy46oW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwVCfEm1NmoRUprk2WnBI0uBM7kqErYkbqgca0VbyA7bH/YyYbtTlmn9whwMH7D69VyzDxeHDasL8nouXtjtE4rzk2qlw/8CI0IdmeLiAF+QA6uVk7hsCJQ8OY2lY/OysiHAEC1jgHjvT6Mss+mfBC03Qgc50ST1OKv8RUodyK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XH4rHE86; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XH4rHE86"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wcWYe+1pMOW3NXnOlpwusgwOeTruxUvp3Jmd5YbPhQ=;
	b=XH4rHE86dZMu5yl/nFuH1g1v+XmVi2/Ize2x47fXV1/TWYMWZHlWr7lVjKZ0CjGPAcbUuM
	rAf5I0b5D80F1PuXIMrj/VKsb/uqDLfAdKafFRYzO1iTKi+3Dn7g9sXgdQzsBg9BwqNf7D
	E8E6Zkf12eDAuYaymTCGR6+aMubX7nU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-6oQFImulMESROmF0DdoCMg-1; Sun, 29 Dec 2024 08:39:57 -0500
X-MC-Unique: 6oQFImulMESROmF0DdoCMg-1
X-Mimecast-MFC-AGG-ID: 6oQFImulMESROmF0DdoCMg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aaf5cb29e46so12527366b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479595; x=1736084395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wcWYe+1pMOW3NXnOlpwusgwOeTruxUvp3Jmd5YbPhQ=;
        b=kI9DIEacrLc6QrmF6N+YgHHYLG1AJ5j39MdLMApFfmbZjuE0j6DcjoyfmOdVlCjcS/
         oKS32a+tfneCwfHb+hP6Ajkms36Hgc6vwYlBnrI4Go2mQJa9X8gJdHFlCsKY9tM9bKhv
         iPxnp3/YICCCVIzBMX3cQq3Rgx9un6WQSL3mzKlIjEbOqtMa2lpc3mMYNTR2LViQJ3SH
         F672uHDWUXSVFh97vS3zafkzYIKnUwfb/wvYnESXkfC2ZnFYWpD2c7EES507hFgRTjYs
         zr7EH6MYp6TwyePFlbynsxEGpgKQtbY4sBsQM96UWyTcoEWyqT5VPHQKcWE9RVVYS3eX
         yD3w==
X-Gm-Message-State: AOJu0Yz8OGQuF2DRsYVrRgS1RHfg9O9S5dxz9pjZnsfJyQ06FJFNKg7r
	3AjtB2wFcJhIhhTz3+TiU7N5LchfGZdRrjde7rg7uDsL+PyA0ZOoBDLWvvMHLfHLcVnZlLtZ1W5
	zgHyTfSvZJaaeM9EQiSgM0Co/yfJ/RWoXDEpKHznnDCo8x7zP1vQTVBEQqsSiIuPOTB5ydWhqIJ
	TlUekK0vBNanPMRkoSayPd07UEDuSZabg0VYNS9Cj4
X-Gm-Gg: ASbGncum2xTTbHgehdf11+EtkbKZRqEpSWr2YNkC0HkCspAWK58fmwMBngCmOouqmo+
	NKoBOr39Nt36PwkQhboDSgbzm9RQulRYZi4ndXdmgOxeLQdQLBm2amfiOPvMe1n8SP5cr/ZH1NM
	fkma3QbnLEqjnz/QiLKiM7LpaQH8ECnDQTlcfXOfrVIuh/xrQzcpe7GT2z+Q69UR0BFHbSba+aS
	Dx090pY2ABi4uTzrMEJi1+0L24XIlY1MMccGOi1oin8LJonkUaH8hTzW5ZJrPzi7G3ZDMjbHORD
	BREQ50jwdVD/2NM=
X-Received: by 2002:a17:907:9621:b0:aab:f8e8:53b9 with SMTP id a640c23a62f3a-aac345f427dmr3132240066b.58.1735479595349;
        Sun, 29 Dec 2024 05:39:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1JJdMo1zqRPonsX/aIw0+9RYxjEbwZRMAGolNHZsczthyIcdkgIs5SlkK+JMq/1nSyS6guw==
X-Received: by 2002:a17:907:9621:b0:aab:f8e8:53b9 with SMTP id a640c23a62f3a-aac345f427dmr3132236066b.58.1735479594869;
        Sun, 29 Dec 2024 05:39:54 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:54 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de
Subject: [PATCH 05/24] fsverity: expose merkle tree geometry to callers
Date: Sun, 29 Dec 2024 14:39:08 +0100
Message-ID: <20241229133927.1194609-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Create a function that will return selected information about the
geometry of the merkle tree.  Online fsck for XFS will need this piece
to perform basic checks of the merkle tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/verity/open.c         | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h | 11 +++++++++++
 2 files changed, 48 insertions(+)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index fdeb95eca3af..de1d0bd6e703 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -407,6 +407,43 @@ void __fsverity_cleanup_inode(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(__fsverity_cleanup_inode);
 
+/**
+ * fsverity_merkle_tree_geometry() - return Merkle tree geometry
+ * @inode: the inode to query
+ * @block_size: will be set to the log2 of the size of a merkle tree block
+ * @block_size: will be set to the size of a merkle tree block, in bytes
+ * @tree_size: will be set to the size of the merkle tree, in bytes
+ *
+ * Callers are not required to have opened the file.
+ *
+ * Return: 0 for success, -ENODATA if verity is not enabled, or any of the
+ * error codes that can result from loading verity information while opening a
+ * file.
+ */
+int fsverity_merkle_tree_geometry(struct inode *inode, u8 *log_blocksize,
+				  unsigned int *block_size, u64 *tree_size)
+{
+	struct fsverity_info *vi;
+	int error;
+
+	if (!IS_VERITY(inode))
+		return -ENODATA;
+
+	error = ensure_verity_info(inode);
+	if (error)
+		return error;
+
+	vi = inode->i_verity_info;
+	if (log_blocksize)
+		*log_blocksize = vi->tree_params.log_blocksize;
+	if (block_size)
+		*block_size = vi->tree_params.block_size;
+	if (tree_size)
+		*tree_size = vi->tree_params.tree_size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsverity_merkle_tree_geometry);
+
 void __init fsverity_init_info_cache(void)
 {
 	fsverity_info_cachep = KMEM_CACHE_USERCOPY(
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 81b07909d783..8627b11082b0 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -157,6 +157,9 @@ int __fsverity_file_open(struct inode *inode, struct file *filp);
 int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void __fsverity_cleanup_inode(struct inode *inode);
 
+int fsverity_merkle_tree_geometry(struct inode *inode, u8 *log_blocksize,
+				  unsigned int *block_size, u64 *tree_size);
+
 /**
  * fsverity_cleanup_inode() - free the inode's verity info, if present
  * @inode: an inode being evicted
@@ -229,6 +232,14 @@ static inline void fsverity_cleanup_inode(struct inode *inode)
 {
 }
 
+static inline int fsverity_merkle_tree_geometry(struct inode *inode,
+						u8 *log_blocksize,
+						unsigned int *block_size,
+						u64 *tree_size)
+{
+	return -EOPNOTSUPP;
+}
+
 /* read_metadata.c */
 
 static inline int fsverity_ioctl_read_metadata(struct file *filp,
-- 
2.47.0

