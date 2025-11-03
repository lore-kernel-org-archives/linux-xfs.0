Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5284731A577
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188515; cv=none; b=mLUUUrMWUW6bHA1E51jjWxLoqQv86Zp8ZhRvabdt7F/SE1XJ3I3C/tt7SfPHJ8hjK+m5d8zj25c5HiiInHGI9KeW5Gvef56poOdGZQ89aLQZzVnEFwF7WTQB2YIGejBukTWsDNwm/tghWF3LZ5yFkbrhdzjMatHknRpJGo8UTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188515; c=relaxed/simple;
	bh=803fn53SStK4wXIjz1Zh8Pjere+o4fW/LFg6pbNfZr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbx+ShdeeA3zQ0COhpS21VtKrTE7Yfsy3N9dzAPXxcl/TypqgCD0WoMDjNyHvZgvn765Bioyv4RDwz7Is69QOUrMvYVyHhhYNmQ7VFSPg4a9A+UOuuGH6jDIlIq0qqyQ89yS29AetV1/Q09fJokvd7uyczEGLdEHYpQFV4Rd+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=by4Nn7Pw; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="by4Nn7Pw"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-340c1c05feeso1867786a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 08:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762188513; x=1762793313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzqCA84hItOJG3LR9jcLPhJDx5yJuZqijNb5+VhOfn8=;
        b=by4Nn7Pw0YzDVlnvK/hIO+LBJjbY8kQynOeCj0qKqfql7QmpuCy/3h+iYUqrHJ0XzN
         syCNrTU9En8G3vfNm+FuJ6zxgPzfc/OBYAeMcm6a3RkUFZn5s4P+CuYV1eKe8gnAuk9F
         +n2gzirLVSWvsJ3spkW9hh4MmElD/TDweMRjCAmX8zuM1G/sbdxIFs7GKgtMus75u23w
         1FaewPOusm8S9eFbhoKjspeZan3Xm/heZk8uQ01tmf5j4C46o1gU6ofeljEE5LXi16mT
         zPBfGT2aZ2wTdnnR7gjjoWR6o69TynZLxNV/0Bt8r299HDRuLR0jYCAAJxV/yK6xcsTn
         kHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762188513; x=1762793313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzqCA84hItOJG3LR9jcLPhJDx5yJuZqijNb5+VhOfn8=;
        b=nnfsWTwNJZkVxaq2tgwaXwAdHMNnEpKfU8vPo5jKY9k9eSpidO34zHXURqkBSvmk2I
         1h9cDdEbOrM/AdahlyhG2LcuNsv5jYtRbk4v14F02TIlafiP/36VPfvWENSwmSqi6dOW
         CIqp2INQuO7AZXMADPV2QQQ/+q69LYzVgYGwTTGBnoJLXz1d8rUmtl6N5WeJUNdvtl6j
         vitLrzef1au5eFYyhuOkea8n5DwQcoalpDQFuUs3leWPFkoUgBrxQ7AWn87Y/naqu2hj
         +iIix3eva55xZ/8wDjWWwgoZlOX6SiHn2bu+J47QQ54FFROWbC1ea/E/rR+tFOWc3ayC
         kyow==
X-Gm-Message-State: AOJu0Yyc6ndo3I5BBjr1AZt1xJmRrPB2nMdCutbh+qdnczhziwekwn9/
	o6WVPA1JKol0hyQRoRL9aPcjHt2CSBq971P+s/V8HGHSaVFa2z0Up+54
X-Gm-Gg: ASbGncvlkA282J5KQno27GVsZ7QJv+jtHzRWsQDLfBQmDRk+lmrZaSWq73RhNq4IE3t
	AyLxuFoIZlSL0vCwHGs1wc65zKIaB/F7YDgqH+4CjKZmhmsNirpmAGxlFggQfaq0ePXDwZ6k5un
	SCDuGw9jmhcFywbdzgoHOEUiQOKNqIzB7FWd0/WNb6/3XtiFw8H6dcrEYqUlQa93XvlMRT0YHqx
	1VAVT0bjb5ZtUHXiT6yWQnBSIQjKl/QXaX4GI8/dptwVZQK/paAUOYYRUITKhepE5bmWzm+7NUN
	s64+tl9v25CL6Y2A46fl4k/ljaqcoljlhsf4l7x73/vJzInvlVWrPuiGPw7RZSoqiNQGFXs8CT7
	sDYLfLd7TXVxtSKPIfNN+ZAhAxp1Xb0dkG7O9p3mkTAubnQd67mdHDue41y4achF+79tV/UyVGt
	6sIyUciXxqDz1DfiQdg7fh
X-Google-Smtp-Source: AGHT+IEKGMkG8LSM8k5x2jtLV6ot/I3WeKc2wYyKsbkf6hGph6RyW15e3Nzs5v2jxgF/0uRopdPS1g==
X-Received: by 2002:a17:90b:1c0a:b0:32e:7270:9499 with SMTP id 98e67ed59e1d1-34082eded6bmr17634572a91.0.1762188513382;
        Mon, 03 Nov 2025 08:48:33 -0800 (PST)
Received: from monty-pavel.. ([2409:8a00:79b4:1a90:e46b:b524:f579:242b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a15b6fsm1607264a91.18.2025.11.03.08.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:48:33 -0800 (PST)
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
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH v5 5/5] block: add __must_check attribute to sb_min_blocksize()
Date: Tue,  4 Nov 2025 00:47:23 +0800
Message-ID: <20251103164722.151563-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
References: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
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
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 block/bdev.c       | 2 +-
 include/linux/fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
index c895146c1444..26d4ca0f859a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3424,7 +3424,7 @@ extern void inode_sb_list_add(struct inode *inode);
 extern void inode_add_lru(struct inode *inode);
 
 extern int sb_set_blocksize(struct super_block *, int);
-extern int sb_min_blocksize(struct super_block *, int);
+extern int __must_check sb_min_blocksize(struct super_block *, int);
 
 int generic_file_mmap(struct file *, struct vm_area_struct *);
 int generic_file_mmap_prepare(struct vm_area_desc *desc);
-- 
2.43.0

