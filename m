Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD2431A550
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188507; cv=none; b=Fsuq+F2grTmEOyO0XSsmBn1Kgk1lcUr4rW2j6ORyggsFypz1R4BGF3prSaHRab+V5w+qb2UfG+XUZmnLbN68uCRSQC58/t0fR8PWJChPzDdCpqxYI3u6Ak0jSRm55KxVLtZDWsrRtvU8R0sw9I/Pqk/GySMBMo4tz4D2MaiOK60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188507; c=relaxed/simple;
	bh=QVjhfMLQHjrgRMPIbt314bhjxXbir3hpnY4sM9EUf7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxvSemdR1Dff8EgZ9Thggv0clLF7eV3hkwH0zHix0GA1Fc+aMkh8tEvWU+6nG0dyyVrZ3E768sc8sYyMraxd0DkqGd72zqjMZeo5jeRlMlR4ACfVRxU/FXLCF7AZAhtPUH791VZSvwlPCxVbYauJ//JekKKUqD8jMiGf8iUvFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D1cDta+0; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1cDta+0"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29599f08202so18001005ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 08:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762188505; x=1762793305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZeg8I26rc6UbearIJ6Ec2S3DjEynyvxSgAdjW2/ZNw=;
        b=D1cDta+0aILAknYn5nm1LmtJDQOYWRMoVh6ldmqDhA1OKI7azLUKxuVjOyP8PPAxGZ
         WBTBtJbvAF1fuOzqh++jzfQlHzE8YT0TaqVrbeRjrWRAO+B6cTpmSiGON79QvtKt4fo6
         kiBYUY8kdnw90EZqNqoAIc393CnV8Gc7zZ5saGVLdhTR73uk8pDw4D2v0p8NnZyowlII
         wDemScjx3lu6id0YkOwEMdfJE1OSOPKKoW8jD5HBxVf03v4vkvsXz4O9VmaRmffVg7sl
         erXgXMPU0P/ShLjLKfrBIc+o2a2fBPrlKTckIqrcpp+Yq6XvIEfPsKnF+XTydD3AWGmU
         LMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762188505; x=1762793305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZeg8I26rc6UbearIJ6Ec2S3DjEynyvxSgAdjW2/ZNw=;
        b=Y5nAdOppZnYXoarUnLBHWA4diqBZwdM+hotjtyAYWUTUj5b16mryervE3rEmvtTg8K
         xQhcg2eQN586BQRvTDxFyvyORdBCXPwNFy7zOSFx9IC4/+JvHNNeiYVr3pI0XaI905hL
         NkG7+KYWYAmrAyPy7sdlHBygyD9YfJfL7wiTMyMa25hjyPeVjlP2+LrRIzMd2ZE7kKoZ
         /0i2apaF/kRbELRBHlPL6iVQqRjEp9ueqBUdi0Klbl2CR5TC/AcoML7mIXNZP5wDME/s
         pkoRN17ipHuFe9KcksbUs+AEQ+afIN99iltHtexQ1IPWGYDqbePls+oKS3tNUscjwRHU
         UYfA==
X-Gm-Message-State: AOJu0YwHYkCpAEQ/ob0WzS/vIRdx917uhaum+7+gXcHeOuKszZcENpc+
	jNSfUuxLoeJmdKY8RPLugJnKeUsJYTV8x/FevK7/dIdu3NBF9DnM0NyA
X-Gm-Gg: ASbGnctxqfMdheI96FsAqx4ivp55lfAyTxhRy6mQ+gx7c7TMiBhBr2i1jM9LbrMDJfJ
	GHYxKOIik1XnYsKOijF2y1IaljeU+QeN/ar9UP7dd+LTE7aKDjMNbtD6U9EnarWe5zmibrksfQx
	AHq9XSfGiNqInMjvouJd1tj2gnR1nNdU2DyhImg4Vr0Q9frNUIylmd5AhIqzSxjevYVzURPCfaK
	KubF1yqNYn05SCyax+ZfobWZ6HzXbcUrOnLUn8jruZYIMRWWA8EJvQ927X63+h4Gr3/ENPt2Bhj
	hfsFwpDLrjXlLKLXRBSQDsoyN3JcC7K6ofW2fS6P9KnebasFAQNhwxbxNEpRWQUIhfAX23wg2g9
	3tGROjgIOHNA9IfMgtg0z4gQ1BAkjNMbAkf1npt39AqDNnReyRhukOVFz9j4hQCgsh91frbUyaK
	wMeI/iCex0iGKac7JXutgn
X-Google-Smtp-Source: AGHT+IH4dvliuPCPeEksMdouK++OLCepXxAi6BbzFrOf3xBpwY6kdtXvLuXYSMFRaScgJRVXvvJYDQ==
X-Received: by 2002:a17:903:2442:b0:295:82c6:dac3 with SMTP id d9443c01a7336-29582c6de47mr78872695ad.32.1762188505225;
        Mon, 03 Nov 2025 08:48:25 -0800 (PST)
Received: from monty-pavel.. ([2409:8a00:79b4:1a90:e46b:b524:f579:242b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a15b6fsm1607264a91.18.2025.11.03.08.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:48:24 -0800 (PST)
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
Subject: [PATCH v5 4/5] xfs: check the return value of sb_min_blocksize() in xfs_fs_fill_super
Date: Tue,  4 Nov 2025 00:47:22 +0800
Message-ID: <20251103164722.151563-5-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
References: <20251103164722.151563-2-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

sb_min_blocksize() may return 0. Check its return value to avoid the
filesystem super block when sb->s_blocksize is 0.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: a64e5a596067bd ("bdev: add back PAGE_SIZE block size validation
for sb_set_blocksize()")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 fs/xfs/xfs_super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1067ebb3b001..bc71aa9dcee8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1693,7 +1693,10 @@ xfs_fs_fill_super(
 	if (error)
 		return error;
 
-	sb_min_blocksize(sb, BBSIZE);
+	if (!sb_min_blocksize(sb, BBSIZE)) {
+		xfs_err(mp, "unable to set blocksize");
+		return -EINVAL;
+	}
 	sb->s_xattr = xfs_xattr_handlers;
 	sb->s_export_op = &xfs_export_operations;
 #ifdef CONFIG_XFS_QUOTA
-- 
2.43.0

