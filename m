Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A8B19E7FA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724755959; cv=none; b=L7yfBySdd71DN6yV4hZ7kXsyc1YKz+ZKKutik9pZyfbdxBK0G6no6WskcmldK06Zdg/4BHJaBKK5qD7LKZG1LyHOvqEd8naOo1qVQla0iqRL2fWwNoWlHmJIMoysEALWcL+MJ/jfB9EHrnR60az7Uz+lSzRsMrFihTzUm6VnE0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724755959; c=relaxed/simple;
	bh=YAHryf6iiMmo8Z5kIbH9aWPG4RIhK6tCmOKITSG3vyM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CcnqKIjK0lEI1C+HuHYpm6+QntJr5hqPLGIHrw4RUFX9NgRKtbstFY6ZSVWc2rDYG3P8tEMc7kWofgDd0zmf3msa7lyDa2ZS1VWVKtHNBS2Jm28OXVZ1p7U+2JlSEiat3k0jtXZs28LtmWW6gt4eilbeuhUQBoOam3ihanIekM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=bwvcNJS9; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="bwvcNJS9"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a1d7a544e7so350170185a.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 03:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724755956; x=1725360756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=L1/OASOdgW5eIZgb3nAGmTZU5/BzJCX72a/WaHOTVAA=;
        b=bwvcNJS9v2v4fD7hb0q6wZ5mLetgDxk90+2Fs++T5aox4o3lftNrngzEghGvWCmw9h
         25GA3ziRj/I+VCT/6QvUjkSkXO7+qtoKVtGaos8MjecEZXUQpNQqbZloK8MC2pLWLKqo
         mgGlBdiCYKriH+r6vDh8u+/yUdlrNvqplkk32eIH1pxkiZ/QTP8cfLOLUQnLtda8sUXz
         4DKa2Am23qL+W09BA6FuuIXfqPGlLMgtEL3R0UKmAIVLW6VQCrZ66tycpa5wUfvxhLd4
         kiyd9FY1fevY/1E4TAcOIarJzNFc6AmLGs2Hlm4cMARThZyniuugG8SlRmDOzDpytYvA
         Ahhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724755956; x=1725360756;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L1/OASOdgW5eIZgb3nAGmTZU5/BzJCX72a/WaHOTVAA=;
        b=grYfx7O9ARWHJ/o+jDtsSiD2u/aUxHkNzvcm3UXBtRSPFrCHqIy68tecyL2rgpfOrI
         jg/UkK7+gMzbfIS0Qt5DSUkvj4tbu6oPqDJZUg7CHQOSSsAX6r8b3NyNRIPpJzcjuwx5
         vAWVF+IJl9ZCHDfPEYKoOnJ2HhnJsQquD7AYdm8HUUIoP71vQKm5Ljm5/uyo4CZzwEOt
         USEbE/fHFKQBAhRLa/uwViHqtj5xIRzAGhLWuTVYN7Zm55hUQAzzQIzD4Q0K+3WBKStd
         dBm0cH31QWqVMAqKnHy6pg4OctkFdMPoNA0UcnFpVLy/T19FW+9t/JonDbCGcx8Aa3pv
         RAQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlmWRkDZab5E1e62N1Ybq1icbSAdGuHFcDCW8VWcx+61QS3ZGl74HeUux0vJkKRTxECAlPoZMwtJU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhFBFgooVX+jh/c8S88pwocQxn2dq/n6bSGOmENIb5ydDY+LUU
	PW3tTB1VX+EPCXH6J8Nn6b2KEkrbGSHgCctK9QaMLv9/vJLOu6hGGKYmjt90zltZQOgrivTkiwX
	X
X-Google-Smtp-Source: AGHT+IE/0KGfnI+BxdhiEauhnPCob4ywwYjoJfsqESQCbI3vPjdvAlSHONAnBe+aYMYMzbvGRJ/oLQ==
X-Received: by 2002:a05:620a:4590:b0:79f:181e:3c58 with SMTP id af79cd13be357-7a689728cd7mr1596802185a.42.1724755956035;
        Tue, 27 Aug 2024 03:52:36 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f31b81dsm539781885a.14.2024.08.27.03.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 03:52:35 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-block@vger.kernel.org,
	dlemoal@kernel.org,
	djwong@kernel.org,
	brauner@kernel.org
Subject: [PATCH][RFC] iomap: add a private argument for iomap_file_buffered_write
Date: Tue, 27 Aug 2024 06:51:36 -0400
Message-ID: <7f55c7c32275004ba00cddf862d970e6e633f750.1724755651.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to switch fuse over to using iomap for buffered writes we need
to be able to have the struct file for the original write, in case we
have to read in the page to make it uptodate.  Handle this by using the
existing private field in the iomap_iter, and add the argument to
iomap_file_buffered_write.  This will allow us to pass the file in
through the iomap buffered write path, and is flexible for any other
file systems needs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
Alternatively we could just stuff the iocb in the iter, or the file, or any
other such changes to give us access to the file for the original operation.  I
don't have a strong opinion here, I just want to be able to take advantage of
iomap for FUSE, so whatever the prevailing opinion is here I'll happily do it
differently.

 block/fops.c           | 2 +-
 fs/gfs2/file.c         | 2 +-
 fs/iomap/buffered-io.c | 3 ++-
 fs/xfs/xfs_file.c      | 2 +-
 fs/zonefs/file.c       | 2 +-
 include/linux/iomap.h  | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 9825c1713a49..d16a6dddb12a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -665,7 +665,7 @@ blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t blkdev_buffered_write(struct kiocb *iocb, struct iov_iter *from)
 {
-	return iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops);
+	return iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops, NULL);
 }
 
 /*
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 08982937b5df..f7dd64856c9b 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1057,7 +1057,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	}
 
 	pagefault_disable();
-	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops, NULL);
 	pagefault_enable();
 	if (ret > 0)
 		written += ret;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index f420c53d86ac..a047a11541e6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1022,13 +1022,14 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 
 ssize_t
 iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
-		const struct iomap_ops *ops)
+		const struct iomap_ops *ops, void *private)
 {
 	struct iomap_iter iter = {
 		.inode		= iocb->ki_filp->f_mapping->host,
 		.pos		= iocb->ki_pos,
 		.len		= iov_iter_count(i),
 		.flags		= IOMAP_WRITE,
+		.private	= private,
 	};
 	ssize_t ret;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4cdc54dc9686..e9c693bb20bc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -760,7 +760,7 @@ xfs_file_buffered_write(
 
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops);
+			&xfs_buffered_write_iomap_ops, NULL);
 
 	/*
 	 * If we hit a space limit, try to free up some lingering preallocated
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 3b103715acc9..35166c92420c 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -563,7 +563,7 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
 	if (ret <= 0)
 		goto inode_unlock;
 
-	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
+	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops, NULL);
 	if (ret == -EIO)
 		zonefs_io_error(inode, true);
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 6fc1c858013d..f792b37f7627 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -257,7 +257,7 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 }
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
-		const struct iomap_ops *ops);
+		const struct iomap_ops *ops, void *private);
 int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
 		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
-- 
2.43.0

