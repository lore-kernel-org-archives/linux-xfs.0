Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFC8318155
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 16:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762187874; cv=none; b=J0TljQendQ061uNxLfc7xOYaF/6+MuXQ9NCnWl33TpDpX5M2BAfcgRaT4Cw71BGTvRdboP6L/F2wH4GNSFgu6aRY5c3nZ04b0/yvkgqIzlOybKD7avKJWX4/OojTucX2kd0bq2nXW/Sk3sJvOjB1uHxYRfnnbA9FoDo0muNDOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762187874; c=relaxed/simple;
	bh=/RxgV6GAH6nY0rXVs+txNdzsVeVssdpXirByBf12lhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHoXloL5dGTJZpIGuxzkzqgFZZt+FQD/+VyHuIE9zKQZGG/mCNeuacslql5GpHtrcGTUpGsUgKy/k/KcwxEyCsLktELdfklMkR5JMomiUO9EevpqNAXVTern9geKVAMIK4uqemLpX58OlYEdHOzY9jAj+Ws9SwDDXBTNUUf0TkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKLhAAW/; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKLhAAW/"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-33292adb180so5051025a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 08:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762187873; x=1762792673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dK/8sGZIswEav0IUiwDZwm9zq0rJ+LZHDAICuhXs0I=;
        b=mKLhAAW/yCu07piNY6FX8/jhybjhJ1R8eFmjNDiHryiLluC7Ur+3VCgji+gLIEkEm3
         4Clz44KVrBP199YoDaRREEdn3k6uhpo40mrA24MrzVsyUfooz4Abkjq17jsqsJ1SF4iG
         gcfpBvriE9yx2lQkBbk5wINE44+nyYylnD+/AafdTYpFF9WKNiR6kiYXhZTAzcu3zO2I
         R1fHxF+fkRJsEFVsyBQHaWK0r3CnPiCuaqV9QYpd4581PM/7LZOrCd+Z1hRnCfd/ylDX
         ks9juwkNLpj+lPt9u2I4QqeYpBOI8nZWUrIIvxJNSL0zTlhlQ2zK9ryy+Sjf5oIaLcTM
         dWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762187873; x=1762792673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3dK/8sGZIswEav0IUiwDZwm9zq0rJ+LZHDAICuhXs0I=;
        b=wE+cJ7D5s7iivOxxLcVXNfOPYbQmrd0zBw88l1Ex4iy/uvRwLLjWvdZrvNv8oycry8
         faQdWeHqwuKZIJYQXNPYyJM9Xys1UiiiPZ4/Of+Lffw0+tkiHWWYZl+3mcmTYGi/Dvuy
         WiqnC/J2MhAGD4jnT7HW8YcYM/eGknCDE4drJMNi6w2XbApwNeuVwXoEaKWlMtxfNs6v
         L9xHhJdciyS6YFbWlScTZqxYJOk5AmWjq/uBJ2p89VlwRO0v6SMM4T5tpfwKGbJQQMI3
         D53Jy71I4jINCVKq0Uca3CyLsuusDl4Ad1dbhNltzG/Wlz2yIdvEX0YZmEtR7Hpzq3wJ
         rQAw==
X-Gm-Message-State: AOJu0YyuGvW4M5Ct+DSe+BVQs9lYHkjoeFJK2yn0MiLHbNi9slzg8ZQl
	esCOmh78KjsZr+9TnLijXiWKbAENiWAQ88WURHSE4aw5rnsgApYl7Sra
X-Gm-Gg: ASbGncsjFS0Crx9UvmXb6lGw7FHx9QDnjUNxjO7jhZv/hd0UTl5wyO6exaLalWiqE86
	3feuKP2h8VC0trEWQIvE4TGhN2Eg0W2jKNIMu8APITk7ATfNcts8FxqnwnWGLndvSboiGHvJYoo
	51a2bIDhEniQohp5TzKtYm1Nm35LBY+tmdqgah5Pnd0o6Yae0qym7Kgdc4Dx3xwlHBiEh+xHdr/
	lp9eJuFOa0U0lnIbDq/iFyvtcZ8FrrHVkuWSMgPd5IMCo2F/k+TtGk+jvlWCSfhesyjgDJ5Ic1N
	bMgHyAK3RYUHBtBB1vRxTalNP66YJgf3RhC2LLp+Q1Idl3klU9ifLLYCybw+FaWUpIh19m5nFQR
	xn+HbdGJC1XBAVaNP6tLXYJ67/g+lwXmICYDA9RJbrN1xvCP13YcpOJq9NfdBd1I5F5DIhVGUM5
	u2F80u/gbOHf04aLPvW4DWkcjlSAY=
X-Google-Smtp-Source: AGHT+IHOoUBY/CseGu1rYOaQtYc2Ta6dcd2TXqQsNF64ItkhFWSiHDGtUgBH1/myNfNr7IGUnHaDXg==
X-Received: by 2002:a17:90b:3952:b0:340:dd2c:a3f5 with SMTP id 98e67ed59e1d1-340dd2ca68dmr9568119a91.3.1762187872654;
        Mon, 03 Nov 2025 08:37:52 -0800 (PST)
Received: from monty-pavel.. ([120.245.115.90])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407ec24330sm6853704a91.2.2025.11.03.08.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:37:52 -0800 (PST)
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
Subject: [PATCH v4 5/5] block: add __must_check attribute to sb_min_blocksize()
Date: Tue,  4 Nov 2025 00:36:18 +0800
Message-ID: <20251103163617.151045-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251103163617.151045-2-yangyongpeng.storage@gmail.com>
References: <20251103163617.151045-2-yangyongpeng.storage@gmail.com>
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

