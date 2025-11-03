Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDF23191AD
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762187844; cv=none; b=pxm+mBjT2z7sRKZRN+3AhRSVH/3nUIbFcCszSFtJQ6ERJvK3AHmGS3jK2T0M1WRTMr/adnNzaMUWRO3mXjsqefL7BFNQOjFyg8u/1ALCwMW7EcuHAwFeQEHUNQedkujPgKHAt1zCsr7LTtWk7LoFIk6tEsGkfgf9ftyce1NY3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762187844; c=relaxed/simple;
	bh=wJjmntvfExnlICRxK102abAFvivMt90fKAxX98hdlYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uqft9bALyHfhnM29n405HFdT5JlavQUR7DIhkjYxjbQlGunWTW/WH8tmCHIkYQIyLz6Ukiw0LICIQFlnbwPB2IzQnpv4y6L4JCowOYNKxbouc+o79VOoVbUnyDwMatZzzhzz4HeHWVgYNzZPPJwOctkS811ci5OfLIPn9RZWLPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V9Xh9GEq; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V9Xh9GEq"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7a9c64dfa6eso1316706b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 08:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762187842; x=1762792642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqJ5gNa1nUUGBUXHUrJf6QlrVR0rCRb3Pp7Ymbcprkc=;
        b=V9Xh9GEqqakLENJv++F44TPZ6hs4GdYcXT+kdy11SDPwcY5sh8xJLitGOpmCtW8JDr
         XgXLIGp9vDzDFUwwTpZ9lesxspeUbb4xtz7rQpOA3E8Hb53ijuSEmtzUL1WUMVf7nvXI
         cznb0gCHxb98GYaWQWVdF7b7stGWR9ZMa6CJTApPDpqC5kwUbF3wSz3xWKr84P2sWdS5
         9wWbQY6Wzd5q10MATigfea4EHH70mPWtlC82+ik/TUhToHOdX1ljggAyq78S+lfxwnTW
         QTGRgKHCXEcW1V2kj4LgfIbUb683rfXk+oV1lKY/7kDkjnxRBKucT27jSsbvhxD62gsW
         IAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762187842; x=1762792642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqJ5gNa1nUUGBUXHUrJf6QlrVR0rCRb3Pp7Ymbcprkc=;
        b=s1maNOMBw9iFhENO89C30TdsbMN1C8t0b8bFMBXiK9yl7j89pJmx1EVOzM2CpOLAa2
         h3q4I+Di+f6b8ug/ag68IFuflKAHQrwLrsE5UKsEvigxDbvSxwkcH52/RXyIpC5Fu9bK
         q6aOWcbWexzqHlCVaLdTZxXtEop0KgyjpuWkQU6o0kDzGXuX7C+PhHw+nLeXIHMiUfJa
         9aELYByp0r2FoTqGJD/jZe2/QfNG9xpPs1dV20Txxw8xkGe8Hmorh5DjA914uwvi3SfH
         DfS9xCmXul1mev1wVnjf32uAq0T57tjE+4hJ3f/QlEp6rvqcylHEN6lMKqDCLsSBp3It
         Wusg==
X-Gm-Message-State: AOJu0YxMEwgOmoytg3kfZiHmCQdLEv2W/dJk39D5pTge2sgOmHVnpe+1
	4DQZi9ZLeksFeYJJetFDnw1kL2ixtGY/H+JUSmeae58BIl8ctGsFmoPV
X-Gm-Gg: ASbGnctOka11uk/LhyWFJe8YgXPZLcmCeZ0H940LegJXkqrWXxyL+/6AskO2/YffCkR
	b6b8lgBT6P8eS3Jh1VP9Aw8qydvLNpaj3S9pG4CREYiDLn3xdYlqB7vMvmMiDf2adrLEpTY+Nf4
	LuEdR6xNACh0AaY/RBx+NrZlmPB+pfIzoyMFbP8NCGRFocwwOXi8WxjuSaLryezIZCbHffpalHt
	Q1FSE5LlhtyPuuqeo/jq9hDfJbSlMwy1y0T0OjPnQug45K71iIMtP/lUcoYJhmpVQvXGAHAo7mX
	+wUIBZAa+IHooFFe8LQEjQcTaOXkOgQZad27edJ55y6B0hOD6g+tT0Z7g7nRXFcpWrhZ1rydKnV
	97iEeTg30YVVV+8OrPCaG4uR+EtCMmGxX5w+zMFczA6vhl+1Qylj/r+HkA9ELXwq9uYScD1hAOH
	VTKTedVcGqaU0ii+lRfOtzfW6pYng=
X-Google-Smtp-Source: AGHT+IG+w7iJAzmb9LjCnbErWEAX7LNvJkcpla1jAFDM+Y4gmMZZU0oJMClikIddg63gu998oSNJwA==
X-Received: by 2002:a05:6a20:939f:b0:246:d43a:3856 with SMTP id adf61e73a8af0-348ca565705mr15735758637.22.1762187841867;
        Mon, 03 Nov 2025 08:37:21 -0800 (PST)
Received: from monty-pavel.. ([120.245.115.90])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407ec24330sm6853704a91.2.2025.11.03.08.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:37:21 -0800 (PST)
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
Subject: [PATCH v4 2/5] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Tue,  4 Nov 2025 00:36:15 +0800
Message-ID: <20251103163617.151045-3-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251103163617.151045-2-yangyongpeng.storage@gmail.com>
References: <20251103163617.151045-2-yangyongpeng.storage@gmail.com>
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

