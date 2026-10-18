Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2303DAACB
	for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 22:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792361914; cv=none; b=Wlfo7tfu/DL2IRfWQ608Pua7MDoGvDSOA1Hw5utHew0nXefyk8vsEWoL7fg4gJ22FJ+k23uhzGXfRKNEYzuZmmZfrYWOUm5GW+ChNiyX0FY1fR2eC9ZRohUeZ3ZVG4kLIadOrXrzIYPO6i5xi9HMMV8x4TgCrVTP1g/DgUw7uNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792361914; c=relaxed/simple;
	bh=uifTPhzW3klOjq5PR/CMdLvkfZTSfOnk3IAKHlWa4uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FopCd9GUn+0LE8pfrsI8Oc2GZqkPdKRn0lEj3v1CiZSxfhLqorhJGNozIJI4OAJgO9CHyq73vmC+zPrFU8E8E1CetBrUFuOnME/5lh5cIiGJCxSe57DswAMWCAxVmE51BzUq+RMF0mHmW01WKIfsjeh3FXcY0xm6rhhBiwidcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0xao2gy; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0xao2gy"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e0d885929so936090f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 15:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792361912; x=1792966712; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JgYjxaCaB98JqwnPs16vqAvxVowHqww+bHKRvE6B7lI=;
        b=a0xao2gyyXVlZNtKN27eN0zgVHpTImDcwgxJgURBip5g5ETZcRiwm91y/D9M+JWqXK
         jBuOfQ1NfQdU5pOu0Waa8rcL54WLVA3m4cey8KAZYupVAMZ89TZ/LDoSdLJWq1OmYTPR
         bvjzG87tEEyAY3g5p67MFqnpVelfFdnT2kApj7/HVtZGINVYdo7ntfh+4oz5AhJ+K1o4
         sDLsMsJ1kpf7ZXM5Is9vj0+4bqkFSt6hgsIfAv/lRhP6JAe9r1ce0IfssqnDAkYMFnei
         wpnDVS6ByWC5xq3KYynIkCfdLVTg1eoMyI6azxCgK0oWtfvpO8M6zG4moBSS98g9y44X
         8zoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792361912; x=1792966712;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JgYjxaCaB98JqwnPs16vqAvxVowHqww+bHKRvE6B7lI=;
        b=X6372GmSYIcwl0+5xZDcjV9OqI87tx+y4HQZab6ka73Wtw5gXWjxZbps+szfVkWOSa
         zVBhSEDeQwNLYxZ57HBOwp/uUu3kQuPqFUiZGia0vXBnZ2/OG2kZ5I9x8/pX+lG0sUCz
         deADq2fYchzswDKqLwySHkRH3tzQjzkNNTPlVGMh9MbHDXN2ad72FgwqX2+Z+5r2R8fg
         D3QFvhQr8Y5YgClfJCax4ObRk2LJN6tbSgVio9oq3guMJbDUexbnG/htY34AF/sJPbNN
         cjwc8ySGpOhI32rf4F7kZHJ4HaC93ns6DqHNh+4+fF9/dZvRc5af8i0Vos+aFRg9xrlJ
         TX5Q==
X-Forwarded-Encrypted: i=1; AKwUvBzbTz2bOLM8p5YSTyEWoZO4X1EIGAGH1zCNRnQQ+Seke6EiaYJH3plEMofymI1c1sN4sWojE+mChIg=@vger.kernel.org
X-Gm-Message-State: AFq9FYItoBlzG+aQa6EXwsiyBED+FYiH2HuZEWs/bRxvjdN53Xv6G63O
	xLqst71aR8cmucVlv8XvY99piuLMZaj6Faf8QHjRPnyvbyYPCKcrsy+a
X-Gm-Gg: AYBFou2Ls9LYi+LOoP6LeNgMPZOOc0IIRrYatsT6zGC+fZFJwTNn43wdUC9AbOntXzz
	i1RZpZ6kNFhY3XPC290ZD9so7AB7N3St5dGO7VU8ZqDzp0xzW3PFR0w5WkW6XrA1BhZshu458Xp
	pw4zBIFkG2Ec9ETyzl6sbGGwfjqa50P6S9uXSzspSOUzN8ik5jVJ6d/nAfcYOyZUqeJVLn32SL+
	0TPNkb1FeCPYjVPj3UC+5mNY2Q01q89G5gqtb7/m3yck/kYOpLeDoL8CbGBwf0AEVyWePoQRr66
	/rKwj2R5iklYw/pRNahs6Z4JmkqYgxboN4bU8fwLIhj161HBtj6FUrYmjzfKghvEw/pfnE8W6NV
	XK6prudQMsHwjnWLSO7xIoxGUVn/d8fKUT8zJX8jT506eruDkhFBYAZEUFgzpQyDKK1dyj9XfFB
	GLsT8h3pPkVWq9xIto/rD3sEx22uhCrS7knSYNrnVB5kbHz84uu+YWHCfJLfTs2lGjJ3ay8KHxb
	UvRK/2git3dTJJudWH7ykk5WHhznsrO5HhGGJ56isksb+HRZm8bZw6W8laA3B4gjpCn9+KT9Dal
	oYlKK4w3JICj94LluBQkk3nGP5vtZQmrAWr8Uk05H+mu80Ce
X-Received: by 2002:adf:e84f:0:b0:48d:f1c9:b10c with SMTP id ffacd0b85a97d-48e07bc6d1dmr8622555f8f.25.1792361911657;
        Sun, 18 Oct 2026 15:18:31 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd471a72sm20934074f8f.4.2026.10.18.15.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 15:18:30 -0700 (PDT)
Message-ID: <4649a20f-aba9-418e-987f-66f21ab24410@gmail.com>
Date: Sun, 18 Oct 2026 23:18:27 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/4] fs: support dma-buf backed direct I/O
To: Anuj Gupta <anuj1072538@gmail.com>, hch@lst.de, djwong@kernel.org,
 cem@kernel.org, brauner@kernel.org, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, anuj20.g@samsung.com,
 nj.shetty@samsung.com
References: <20261016091919.971295-1-anuj1072538@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261016091919.971295-1-anuj1072538@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/26 10:19, Anuj Gupta wrote:
> This series lets an application register a dma-buf against a file,
> so reads and writes go directly to the device as dma-buf backed
> bios with no per-command DMA mapping.

Great to see work done on the filesystem side!

For filesystems to be useful, we'll first need to make a registered
buffer work with all files of the fs and not only the one we used for
the registration. I think about something like below. I'll clean it up
and send out later.


commit 11e25bf0dbce227f87b81cb9436ad347de0deb06
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Oct 18 23:09:44 2026 +0100

     dma-buf-io: allow compatible file to reuse the context
     
     Currently, we limit the use of a dma-buf I/O context to the file it was
     created from. It might be fine for block device files but won't work
     well with file systems as we need to support multiple files. Let the
     importing subsystem to set an opaque handle to file and indirectly to
     the dma-buf I/O context, and use it to allow only compatible files.
     
     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/block/fops.c b/block/fops.c
index 3fcf33bba935..c62f9f6cc4e3 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -685,6 +685,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
  	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
  	if (ret)
  		blkdev_put_no_open(bdev);
+	filp->f_dma_io_tag = (unsigned long)bdev;
  	return ret;
  }
  
diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
index f724936e223b..a99b93cd4be4 100644
--- a/drivers/dma-buf/dma-buf-io.c
+++ b/drivers/dma-buf/dma-buf-io.c
@@ -166,12 +166,15 @@ int dma_buf_io_ctx_create(struct file *file,
  
  	if (!file->f_op->init_dma_buf_io_ctx)
  		return -EOPNOTSUPP;
+	if (WARN_ON(!file->f_dma_io_tag))
+		return -EFAULT;
  
  	ctx = kzalloc_obj(*ctx);
  	if (!ctx)
  		return -ENOMEM;
  	ctx->dir = dir;
  	ctx->dmabuf = dmabuf;
+	ctx->importer_tag = file->f_dma_io_tag;
  	get_dma_buf(dmabuf);
  
  	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
index d9f27650a851..c1d72024dd11 100644
--- a/include/linux/dma-buf-io.h
+++ b/include/linux/dma-buf-io.h
@@ -48,6 +48,15 @@ struct dma_buf_io_ctx {
  	enum dma_data_direction			dir;
  	bool					is_dead;
  
+	/*
+	 * A tag uniqiue to the importing subsystem, which used for filtering
+	 * out files incompatible with the dma-buf I/O context by matching it
+	 * against struct file::f_dma_io_tag. It encodes both the set of
+	 * devices it has been registered for and the subsystem specific
+	 * map / context structures representation.
+	 */
+	unsigned long				importer_tag;
+
  	void					*dev_priv;
  	const struct dma_buf_io_ops		*dev_ops;
  };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0d826777681d..8949ac27308c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1292,6 +1292,12 @@ struct file {
  	};
  	file_ref_t			f_ref;
  	/* --- cacheline 3 boundary (192 bytes) --- */
+
+	/*
+	 * A tag representing the underlying subsystem for dma-buf I/O.
+	 * See struct dma_buf_io_ctx::importer_tag.
+	 */
+	unsigned long			f_dma_io_tag;
  } __randomize_layout
    __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
  
diff --git a/io_uring/dma-buf.c b/io_uring/dma-buf.c
index 132e3d0d7023..d8771dced990 100644
--- a/io_uring/dma-buf.c
+++ b/io_uring/dma-buf.c
@@ -4,7 +4,6 @@ static inline void io_release_dmabuf(void *priv)
  {
  	struct io_buf_dma *bd = priv;
  
-	fput(bd->target_file);
  	dma_buf_io_ctx_release(bd->ctx);
  	kfree(bd);
  }
@@ -52,13 +51,13 @@ int __io_register_dmabuf(struct io_ring_ctx *ctx,
  	if (ret)
  		goto err;
  
-	bd->target_file = target_file;
  	imu->len = dmabuf->size;
  	imu->release = io_release_dmabuf;
  	imu->priv = bd;
  	imu->flags = IO_REGBUF_F_DMABUF;
  	imu->dir = IO_BUF_DEST | IO_BUF_SOURCE;
  	dma_buf_put(dmabuf);
+	fput(target_file);
  	return 0;
  err:
  	kfree(bd);
diff --git a/io_uring/dma-buf.h b/io_uring/dma-buf.h
index a876a9e5e272..3b812758fbf7 100644
--- a/io_uring/dma-buf.h
+++ b/io_uring/dma-buf.h
@@ -9,7 +9,6 @@
  
  struct io_buf_dma {
  	struct dma_buf_io_ctx		*ctx;
-	struct file			*target_file;
  };
  
  int __io_register_dmabuf(struct io_ring_ctx *ctx,
@@ -57,7 +56,7 @@ static inline int io_import_dmabuf_map(struct io_kiocb *req,
  
  	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
  		return -EOPNOTSUPP;
-	if (req->file != bd->target_file)
+	if (req->file->f_dma_io_tag != bd->ctx->importer_tag)
  		return -EBADF;
  	req->flags |= REQ_F_DMABUF;
  	iov_iter_dmabuf_map(iter, ddir, NULL, offset, len);

-- 
Pavel Begunkov

