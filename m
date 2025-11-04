Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99072E0B64
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 12:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260676; cv=none; b=N0FUoAHDONqVPsj662ESPJ+b5u3wFWb7oE1bbb0+Pyja9c5ixP6aPtI3mcH44/K0HfUhA9AXzbVvsj8L1qC+zQ+SAQJ3/YPHdz+aowZYo7a5myvhW9QUVGxRvmYgAJnd8kQxklVfjmr/yc1eZvWa+hhCGh6sZQfD/x1FvWEKVl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260676; c=relaxed/simple;
	bh=s3yhfECKQACggkqiSvS6yFm+dl+Idqcymxv/EyA77Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ic270GCLdNyPr3/lIxehiA2THVC1ESXeJJd/EkkLAu3RKgKGE8zcRqoe3cGstA8G084pvEIqpS8qyMEIGRpqNxg8x+BScAPQKu9rOVPBpeagQbfRn50lY6Da2qq8dsjYlUm6Xo6Q2PhaStiQb3bLig8xI4FZ7Q4sAcFmk3j3Ukg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gzrcw1E7; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gzrcw1E7"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b62e7221351so5245334a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 04:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762260673; x=1762865473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WH7uti94Ifpss7uaEo1ftZ9XWOLDmVeeF5wLRCtaeDE=;
        b=Gzrcw1E7d5y2aoJUnTcshd60F4LWfOQ63t/EsqrvDyfK2Ewh8Wf8pjc/kpCJfHIpwf
         /Rz89C9Ym9ixt/lO8+h3JC04JG7VOy+EaEpt4t0LfphzoJgeFhPgmjXagu6fmSibZKDW
         t4dVVY1MLBP3ao8Er9udkSX66StWVpJBOIH/r2s/sy5JNWw22RFlsVgapeaWWoWIMnP7
         g9hzuMDLaB/DX/l8uJa0S5U1l70CIAEx5DMEAD98CiEmdlDeHn0okSeFIi4NhZgfBrQ9
         ie21cqAQBHOF5XxjXZDJIKqauKNVWYHN3BIBpbIwYcRVneanBSJPbQcojXrQGnaJBd0p
         LqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762260673; x=1762865473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WH7uti94Ifpss7uaEo1ftZ9XWOLDmVeeF5wLRCtaeDE=;
        b=VKM5/IOpuwlUkoz9ATOFuBR4UkQcy/1+ohMlDvLGht6RGmoRPESexH4d+rwG9uulQr
         ZQFyO0cChPPqc+lTUarY6W6PQKAu0TQzWs5/422SXPKg6DHtZMGYuM3IXl83eqPrCHUB
         FS8a6+xnYcV2mFTu1Zwr9JiWofPRai/SVy6IYeA5zV5fdDPhQhzSTeEzwJTW0bWOvgrn
         1PZvInpOtV5vbfx/BIgCfmJvvPwqWPGOY4gVzuXgR9BgjnRn8Xas3ykFqKmNaGEl63jf
         3fO0eOPORcLvPTtxH5P7Y1opJtaZDaYnMnYVBUpyQVTVJutVayvXmpO7b+LiaAcUDnaE
         YyrQ==
X-Gm-Message-State: AOJu0YwWtf0GKq6eAyIYZG66f9Th5j/Uce6/s/5nHKi4GE55iNO/r4MW
	9WlPrQ4lQSlRoDC52da1fwSaYnHMFu5jLqL4z4fZuxQdquSYULfz0DdP
X-Gm-Gg: ASbGncssO45ZNdTeN8FyXvNNK2uZaaGE0W8qhfMF1fXgxTJ+DGkKdD2FfT45nXOWhXM
	GPYt4c4RGN4X4iLdJft42JyR5EJQ2Fn8RfQJqMwPc3ZeB7v6OupNnzr/RmTqM/hLaOSUMxrgy9q
	P4cc70Bs0whnNUivSFpCOzE8i0/GIqISfIiLgM3a7LlMD0yKoL1sWVSNpUhno0EuCXL1DSOSoc1
	CgRdtjoJhl7unt7UB6w34OjTUpKY83FiY80ltq+T3oOlLAQBijJZ7rPHKI0g+8GkOZbfto5uuCP
	7ZVhKtze7yUD1v1Th8ZwwXB7L8CQ7PP6+0gNIweD1zak9Z5bdIAbeqv2tsXvkY73aMjvtuk7ElT
	9AyXvp2QbY/vmIkaUqAvDnL4733jwiopGoWOKJlIcw2EFEs/cDTbF1VUbOWe+8Zrh6fhf1Vh9WP
	9yum/9Jv1E59M6tS9agNaPiWEsa6kuQGn9uMsQrBs4sWT6+A8=
X-Google-Smtp-Source: AGHT+IFyV0Z4aoh1hb5I/IbU1UarLZfuiNquenj/qB2Rx0uGFDeOr6CMSuEHHdT/4+TY88jlIMdvbA==
X-Received: by 2002:a05:6a21:8981:b0:34f:1c92:762 with SMTP id adf61e73a8af0-34f1c92f840mr640906637.19.1762260673189;
        Tue, 04 Nov 2025 04:51:13 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6d026dcsm2860710b3a.70.2025.11.04.04.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:51:13 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	stable@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 5/5] block: add __must_check attribute to sb_min_blocksize()
Date: Tue,  4 Nov 2025 20:50:10 +0800
Message-ID: <20251104125009.2111925-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
References: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

When sb_min_blocksize() returns 0 and the return value is not checked,
it may lead to a situation where sb->s_blocksize is 0 when
accessing the filesystem super block. After commit a64e5a596067bd
("bdev: add back PAGE_SIZE block size validation for
sb_set_blocksize()"), this becomes more likely to happen when the
block device’s logical_block_size is larger than PAGE_SIZE and the
filesystem is unformatted. Add the __must_check attribute to ensure
callers always check the return value.

Cc: <stable@vger.kernel.org> # v6.15
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 block/bdev.c       | 2 +-
 include/linux/fs.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 810707cca970..638f0cd458ae 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -231,7 +231,7 @@ int sb_set_blocksize(struct super_block *sb, int size)
 
 EXPORT_SYMBOL(sb_set_blocksize);
 
-int sb_min_blocksize(struct super_block *sb, int size)
+int __must_check sb_min_blocksize(struct super_block *sb, int size)
 {
 	int minsize = bdev_logical_block_size(sb->s_bdev);
 	if (size < minsize)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..3ea98c6cce81 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3423,8 +3423,8 @@ static inline void remove_inode_hash(struct inode *inode)
 extern void inode_sb_list_add(struct inode *inode);
 extern void inode_add_lru(struct inode *inode);
 
-extern int sb_set_blocksize(struct super_block *, int);
-extern int sb_min_blocksize(struct super_block *, int);
+int sb_set_blocksize(struct super_block *sb, int size);
+int __must_check sb_min_blocksize(struct super_block *sb, int size);
 
 int generic_file_mmap(struct file *, struct vm_area_struct *);
 int generic_file_mmap_prepare(struct vm_area_desc *desc);
-- 
2.43.0

