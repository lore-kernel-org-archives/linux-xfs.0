Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793862024;
	b=HtybK0GHZ9zlVeP9U/HRf7pmSHS85pOBm8e1Z2ERtXrb2AKPBRjt3fWwY9gQiZgYOCGl
	 qc2n4HtNg+ArhEApOVEopUjO1XVlm9D4roa4sLNwmSP0jDaL2UkwPRiMsRqxGe8aHqgox
	 8IABhMtVvLNP87s4B0ZhSyj+cXHdbocB3yYvqUYFPAswQMHOA8oppv2+03DBRKCK8bSJy
	 0hQEAcX/ZWYiiOeoNanABIOjg5uAHYl0P3KgF0lqRQ4nVu+1dOlG/r2OLNuniDfuZjMyZ
	 eIY2te7mRcfviOyYwk53nHd5luT2ro6S47teq70o02V9zGgUU5Wx0hNvXOMlr6rC7dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793862024;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Kx5WUkjnErrix8wXibd1Wzcuh2GC05qD7z4XDKSCne4=;
	b=2jPstK+lGHJD1UulvfeSqX4dAnr/5e+LI9A6/9RuM6wZ52MtcK0Ilop6W2DjxWum8H5V
	 liite2U7HWJRJ3jPFl/uH+5UGqYvTgO93jH/ey6jLOCtaFFBmK/ai8k7oLJTdLkjyHTgx
	 SsmeQeuNS10+D2GKVoF1/As/Z24qbxJ7APzXEcnqON4wQLrYXgE4PMGUH7bO3Duo/f33D
	 JhP/sJ9RZ5Dd5tMLFPFqcQt48+aYRkQxLbE/+2/Ilra2poxeCaOZZ4Vjmmcam/tbsFPB2
	 5AxmtwGMlvHcamGPT7pKpKkIUDeW07HQ6FbpZRvmv7cOwFqFKVXIRgJanBR9JFNmw/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tLEI0IyM;
	arc=none smtp.remote-ip=95.215.58.44
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C7E606A326
	for <linux-xfs@vger.kernel.org>; Thu,  5 Nov 2026 07:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93C7E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tLEI0IyM
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=J78YU5ZFO0YkJHWe7jsk/frJ8JTGoObKjxZIdpWIbcM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793862021; v=1; x=1794466821;
 b=tLEI0IyM03Jx9PdNIr3UD/tEvPDKgYoO7sQaffewF3sLN+sjQl9i0vtYzf+JFZBfMVImQxHf
 k1Fg3YCSvdSSRiFTKJfj8Xr/R5UM2WP9vkOBMbRE6zUHlO8Ky4+K3wYrJdJAdnm7SdJ1dnhe5dT
 Mi3iTWH7mh7XM0ZeseSWInl4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 56e7aac47ff0582e;
	Thu, 05 Nov 2026 07:00:19 +0000
X-Mizu-Trace-ID: 56e7aac47ff0582e
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted inodes
Date: Thu,  5 Nov 2026 14:58:46 +0800
Message-ID: <20261105065847.196540-6-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
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

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

Contents encryption needs the crypto layer to reach the data pages of
the bio: blk-crypto_fallback kmaps and memcpys them, which a device
mapping does not allow.  Refuse the iterator in __iomap_dio_rw()
before any bio is submitted instead of depending on each filesystem
to keep dmabuf away from encrypted inodes, and in
iomap_file_init_dma_buf_io_ctx() so that registration on an encrypted
file fails up front.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/iomap/direct-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index fc40f4367ee7..aec47b70b084 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -728,6 +728,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_is_dmabuf_map(iter) && (dio_flags & IOMAP_DIO_BOUNCE))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	/*
+	 * Contents encryption walks the bio pages in the crypto layer, which
+	 * a dmabuf bio has none of.  Reject before any bio is submitted.
+	 */
+	if (iov_iter_is_dmabuf_map(iter) &&
+	    fscrypt_needs_contents_encryption(inode))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	dio = kmalloc_obj(*dio);
 	if (!dio)
 		return ERR_PTR(-ENOMEM);
@@ -940,6 +948,8 @@ int iomap_file_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
 
 	if (IS_DAX(inode))
 		return -EOPNOTSUPP;
+	if (fscrypt_needs_contents_encryption(inode))
+		return -EOPNOTSUPP;
 	return bdev_init_dma_buf_io_ctx(file, bdev, ctx);
 }
 EXPORT_SYMBOL_GPL(iomap_file_init_dma_buf_io_ctx);
-- 
2.43.0

