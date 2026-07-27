Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408C6429CF1
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187489; cv=none; b=GP+E7OKA0x0/Eh1HZhdA01xZkJoEzFDSN9659R5RQc8XyEvT7anMj2W+vlaS2+nPMl87gAr2xSZ69gh/lljLd44KXhZRhIY8c0D+KWNOKTuwYjpToofwdnof2clD84yIFNJoBbiQQXSvQaiBUQexazzKJ/vCPu/eX4XlLqhsekM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187489; c=relaxed/simple;
	bh=rUAOU3IydJmQYweh2Ff4mzFaQjYgFYXBQUGY5Kg74Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSnDSwAhPwxsTcwsuY/0MZU77swh1JO+rdNQ1ws9QAUWxvQ6bJtF5Dv69fXcPsc8hS52WK28HwSJy13GBJd9OiJmM+cLvSbdJ/VPHEeTzJqySmeJ5r/N915JiJwIzD5bEAAqgKu2+lwAUGZvXXcoCf3TZjrtcp3qzc/RPBMXDAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DzfCBcxE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DzfCBcxE"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cfff5f88dbso12994465ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187487; x=1785792287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4S5rDCc1of8MfqKGvH0/SP90Wdz9xuZW0t7RbrAbJlA=;
        b=DzfCBcxETFFlLtGbPEtuyG0WmSEWe9xvD0gN2SmmdzONQY8zFv55b1Tz6puwHv0LJQ
         QZEOzwOiQICxugR0eAvY1b38e7gOMdpGcXHkxd0WHGLKdxaTkKZsyEADOc92NLiZvqq1
         BiPE4Bg7KwjumyENaxAEkKKHZVg8DVejwTjUxNVaxSlBjNx6/fJYK/PmfPa2C7B5hVpt
         wNseLG3+UMOhVcKW0R5EdCCVRYrW4rlZO+2vzKZmeisdV1up2PEYB/26iyWdxtSbiYDo
         ri8xbcwAR7bNkHpUDfjnYkh6V4s6RF96ETw36e8m8BVAhfZ9otlJIQ2Ap8q2HGYGO2hf
         f8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187487; x=1785792287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4S5rDCc1of8MfqKGvH0/SP90Wdz9xuZW0t7RbrAbJlA=;
        b=Mv0g6hGOaeK4r1gWzrYLKBfKcn7VDbZ4vZkWc6ZbjcLNo8wUQglKNvGQqKx6Y2u9g+
         PNpSPCNj62Qi0/L7ja35mOXKfUhEHQt0a1/Tu27lXmqMGKV/MAHdv2MNcp2E0Uvj34wr
         UGXmPT3bwQ+hNlmzI+JI/c9RKD2J3iFzE0vDopF8+NIvnc3wZ9HLOjoIC2QI2pAmaUIG
         DVbDchPueS9N11g/HqjX6u9xCkAGgt6W6eSiAboyEypB8UZEIxLjLHrXzBfNkTSM2zn+
         e3MxM4OCG7XN2BUtinWGoWHr0R9NlemjbxQv4zQEiR2btDAMM9vDuaxuV1yf6YDvjQtd
         5s2A==
X-Forwarded-Encrypted: i=1; AHgh+Rp6/qsTBkaC7HqKryvMP9gPuXsFdrXTjvBhAGQrbSCBUcG6F768OGjPKrSS0YRneSZbhjttxUkjztE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVtxhtRSoW6BeCtSATeKGW/AQCEnHbu/mY69ebNbX0p7pkuuee
	NIlJsdrpeMsf2AK1oSvWacsMCuN3D+WIs52OnYRcW1O5vhRSR0i5gaIQ
X-Gm-Gg: AR+sD10i9PoNtRkD6zC322i1U9J5wfBPHRFqmddObGaNo0Jg9LpKb4kuXy2P5miB1/D
	R4w0IFtVO5WjLf68xpLz0bGTUupbXX5hVwLlgZfVrtyV0+YCZDnYcfFAnO/ATzUjN+hA3+mv3c1
	KKkh+WckOD/Htej0IGQ7k2t47J7YJXUCuECJLG+jS4daCME2mIQb3nHxc/bCdlKK38Ni/6LxXN8
	iPC6eGFtQqZ9rjg7z9O7XPdhf79p168yWOs3MPtUhy5GmuzGrKJC4s+KU3xZsehlCZcpbZymbQF
	G/ZL/zuaExx/CJHJPf8VENMm0fd2dhwEkXCXXdcndBQr8HwLVEfTZ8zaKO0RZt6MJIeLLp8dUIe
	mcFielQKg/BpINmAgBHEbTxSvJ/prKax9AogL8Tzb3Gwt/Bvad8Hbh4spJ3XpTGIIHpK7HSSCrH
	RVBIQE7OpgXLK7oEKGcpVpPyLuwqb3OF0mBJfpqkqWPb4bJAN8Y8DezQ==
X-Received: by 2002:a17:903:2f07:b0:2c9:97a8:8c1b with SMTP id d9443c01a7336-2d00f44e432mr8707385ad.46.1785187487641;
        Mon, 27 Jul 2026 14:24:47 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde80f50asm40681075ad.77.2026.07.27.14.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:47 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v4 10/21] erofs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:47 -0700
Message-ID: <20260727211758.1116539-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert erofs iomap_ops to the new ->iomap_next() callback. Each
callback is generated with the DEFINE_IOMAP_ITER_NEXT() and
DEFINE_IOMAP_ITER_NEXT_END() macros, which wrap the iomap_iter_next()
helper to finish the previous mapping if needed and produce the next
one. No functional changes are intended.

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/erofs/data.c | 6 ++++--
 fs/erofs/zmap.c | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d1..d2f01245ee79 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -380,9 +380,11 @@ static int erofs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(erofs_iomap_next, erofs_iomap_begin,
+				  erofs_iomap_end);
+
 static const struct iomap_ops erofs_iomap_ops = {
-	.iomap_begin = erofs_iomap_begin,
-	.iomap_end = erofs_iomap_end,
+	.iomap_next = erofs_iomap_next,
 };
 
 int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index bab521613552..3966b62a7051 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -821,6 +821,9 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(z_erofs_iomap_next_report,
+			      z_erofs_iomap_begin_report);
+
 const struct iomap_ops z_erofs_iomap_report_ops = {
-	.iomap_begin = z_erofs_iomap_begin_report,
+	.iomap_next = z_erofs_iomap_next_report,
 };
-- 
2.52.0

