Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A571B2D2387
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260655; cv=none; b=qEiix0bHLQFxKuBPUd739lAiUymCYf5rYYlI8r5v4MsVxztM0CZbW11dYsT4YDaglFeH6zYM64jszBByL9w/b4KJvQFqtaRNBrWrJ7dIe6nwDp3wHXQ+Yi5FQYi5q6ahGxQlBfRI3hcvAbvrlC89yH4oVlJYLDqKgy+Fyv8Lp4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260655; c=relaxed/simple;
	bh=WmtRZhDWkgJIzqTmohBXn31bc3c2KAlmHgsg5WATPKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld1p1Z/vahUZWlRlrK7ewz3DMiFD1lFGWoJESMavT7dkiFDoIBcAcY2vMOGdJRg8EXtQ/HiVpQ8PJP5MnTW28j2dgseNKUeS+qabbJ+dvT0QI4BgaqDfx4BqE1q0aW52lCfu3DNAwzmncsMoHuYhRaqyZ2IfRU3eoV8SRKdHaJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IonmIC4L; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IonmIC4L"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so5548443b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 04:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762260653; x=1762865453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENGYR35a4dVgm7srDfRUWeoMwLvmN51DMzCkTe+nydE=;
        b=IonmIC4LhN1XzPTkIv8HigOViYXPokTfsztF7j9wSpyOwjWz3r9up6tbmwkDz+ddq/
         MyUVPriJjEjAkPOBz/7nwAPHo4QTJcburF0aBIGHXEv0cjF+769y4DplVvCyBbjC8SSJ
         SSvvhbPEtpGWiuP5uFNSHsBha/nS/Sio/DF3b49qf50jhaih6OJRZZBF5DiHzeQrV+VW
         Vg9hqiJuYJfnKoXyWuudeFXrXq6utP50pFtXlfYM286upkugh6X1OM26ITR6jKZfsEQK
         daj+CBBaP0u3gJO3oGGyqlJTTF5xSd3m1jUQ0usAB8kKDRYhrqx9rTeOmvzOPr+HtVgc
         2UtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762260653; x=1762865453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENGYR35a4dVgm7srDfRUWeoMwLvmN51DMzCkTe+nydE=;
        b=qUqaEn8rS7w/XRwNcfa08qgykMkh/B3pXn5pYwURFG9NxlemM+7jZxJVqfVBkh3Vsh
         W2lS7e8q8YWqouOMLocusFWcbfCSPYXQ9MbBQEYxqmY+wLZHii0qF+znHgwIJee4XD4e
         Hts+4azTA84+HcP77lcVO0lznznxGlPb0ZRSFeYHtu+1Nv5e/rU0lLczAg8PzhSKlsg9
         NT7c1BLUCU410M5cSiWlvT73WzGP6LmmkF1teJLDH0j8TJUoOfHrcsxHfD5YljDmdEne
         yCcrLvaHDSXmw7RqwO20PfsxRKhbV4b5uBs09BdzK1fhqmW3If3UeR6/k/ncElFm49n4
         8Blg==
X-Gm-Message-State: AOJu0Yyr9gPLwyVzpMP1nYQKZINIkojwp8PTxC0l7wa/ATfr3QTAUHAG
	plNAJcMNqs7iT2q0pihbzYSy+vOoIezstafBuF780X8pP7XuSmtXWRPh
X-Gm-Gg: ASbGncvBIkKIneph0f2Oy4gQouybG6m5rQvqDVdU0Z6Ohf+zeviukxsZQdkpmD47sxp
	tGTjSiUz3M6QZo5NtccOfSe2Q6C0fY3gUrpmIwyfsbu5G3KQfpz/LZhokypa8lOLenoR3mnm7uH
	ZoIq3pUzMOnccop9zJ4oOOzvFfID7dTw9YQ8Eg/RrRbkA9Z7Ghx9lYPO+XZnqF01Zq6YBf4/I02
	zxxtgZvV7j1VPZAK0tPBlL0xHplyn0Hzj3KbhAf8r6lmSJPtE58wzvlOFKOfsOwHPw4CS3pXMAn
	1ZYg5AZIwXYt5ZtsuA0B/m5rSkP0JCBViVog2S+JyIYFJCPKBm3sBVRQA9ZXDt+y157Wzj8RI9E
	EPO85UarSrpFWMJ0FGgUe/ttGdXYB3/k5SZS8T9GqRr7VA1b/y1+LsgVTAIapjqx3YOB/bMhxdy
	OvccE1uYO0x77tJBJO5yjg4f7Ci+duTPlpRcRZYZrdUto0nEk=
X-Google-Smtp-Source: AGHT+IF9GGj6LSoxr/C7fblJY9vEfziJTCbSQQeza2nw0zDMlzuQfM4TKJWECjNFJLSbFRIBSCyjKA==
X-Received: by 2002:a05:6a00:4188:b0:7ad:8299:6155 with SMTP id d2e1a72fcca58-7ad82997336mr1106651b3a.2.1762260652783;
        Tue, 04 Nov 2025 04:50:52 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6d026dcsm2860710b3a.70.2025.11.04.04.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:50:52 -0800 (PST)
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
Subject: [PATCH v6 2/5] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Tue,  4 Nov 2025 20:50:07 +0800
Message-ID: <20251104125009.2111925-3-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
References: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

sb_min_blocksize() may return 0. Check its return value to avoid
accessing the filesystem super block when sb->s_blocksize is 0.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 719c1e1829166d ("exfat: add super block operations")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 fs/exfat/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 7f9592856bf7..74d451f732c7 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -433,7 +433,10 @@ static int exfat_read_boot_sector(struct super_block *sb)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	if (!sb_min_blocksize(sb, 512)) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);
-- 
2.43.0

