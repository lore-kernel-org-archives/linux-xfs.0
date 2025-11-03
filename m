Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC831961D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188496; cv=none; b=FJi4z3V+5Gbdf+MMwEBObqHsJW6aSmInLL8G42GqGEgSfTajjey7Zi+yYDtgEnuDQ3r3bIYrfQed2LMQLfAGC/HR1OZiDlfbxFfyDEpKHXVb9LHj/Ry8DjzdW3C9hxjoIol8VnceNeZX+SIeAc0UyUDzr9Ou6W5H66mWoiz4Idc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188496; c=relaxed/simple;
	bh=wJjmntvfExnlICRxK102abAFvivMt90fKAxX98hdlYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piLzRiHv+IitDQYGWE+SMzQJ5syYuzmtXSyWnxCVzwNhXBQGCeO95JR/g6bFfRHfAPIPYMCQYNSduT5+BwBIIUfLWCRDa3aoirqfzR9E4GnW2UXz9tWxTsYdW9/t435bja/1pfs4ljS7KbyidPGQASG5WS/48fE1Oh+Aiki1cNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mly6Z4mD; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mly6Z4mD"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3401314d845so6090458a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 08:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762188493; x=1762793293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqJ5gNa1nUUGBUXHUrJf6QlrVR0rCRb3Pp7Ymbcprkc=;
        b=mly6Z4mDv830e117Wb/WZgDoDqVTOArVC6L+MlO0OvVQ4iuT+wrIJAOhFpJFqEBmbS
         DHTEMhiowsYxbYlyyX1TDHQwSgpNwQ3nIln6fkTLmcWJ62oAFyNANcIYG7I775kPBGYv
         qjGlZTVGqan2l5/Z7tAFhODGqtTLvbjd7mYxk0cuGo3l2B3P/8DXWrlURCi8GhvUcPq5
         WAjp++Bll1OlWSGJOHrvXSzQz4gJGCFedWfa9jt+O7aGVUZNsCIvQsq+f7hMt+j8y9zF
         bqsiJmweBjT2QCUNi/dBfmURYpF01wzFBPD3VRPMhOuOI8PKOEXwZ5j826K7qJFqul4B
         ym3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762188493; x=1762793293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqJ5gNa1nUUGBUXHUrJf6QlrVR0rCRb3Pp7Ymbcprkc=;
        b=I8A4fv39fOQosNENg0to7Q/sEZ3FeUq0er6kRSdyVoQiYqE+UIYxmHKRn6EskBM/Ue
         +vP4myPxxaAI+GJsQKN67Ow3JZB1D5vrFQ0WelamUqEk1UVBfkRFWF28R1vFcl7nDLyO
         mMuV750cQAnBhlo6IIR+v+ZlU6l3Wcn+JILqogVyIXjvoUiYlo4Zjy1Qo4KH8+zpw2wu
         aEb0Mhti3lHvaiK8APWwYrDF6P5sjTCxP3Qd1uz56SBUfjxG0y8witz4CPJTS4jULeeL
         Teody761RD2GTCkO0M3bMP/j+uNTbWGAGY4uKSeSLfWejNH+ZfkDx2M+dhnG4FW1WtcA
         RAhA==
X-Gm-Message-State: AOJu0Yy5CQtCj7J3AD7bO3Ah9jeQCA4egj9ob9AqyOoW9wjo6oULQv38
	RyY6jMrlhwh3QLrDUNptfSyJpDfGEUSTWc/93fddyYC1GOSHbv3fQH2R
X-Gm-Gg: ASbGnctz1PR7NI+25++4yqqkS1LOAb/EsUl5/351aw8U1riGQ0sOAF1xGaC7A8/PJMq
	+4KT4ORU5lE3icKdd+m/5TBvZ30hv7NtjUHbZuklVv9rNfN0IC9fFkSMo7z7kwULxtHNsZv9mty
	E9XFk+qCu1XIS72RufxL2TUbQnLjTC76i0+bNtB1ZbenSRja09gzJjX/9CdZNaM2IJYjWs8Nqlr
	mQYnlAOrYioJdqbFPE6mJ6TQbGPjESRiSBBExiG8ZVpCwrlHncdcSungIlRb2YUtBQi1J0O9qzp
	zjHVBWGjeN9LqYJuQ5JHsO3auRAFHi/QYFHaNH9YbtU8xU8mu6AQ8Vh0P91YyGJ7izRHxtYXjbV
	HdAdXoFdYWpOuj7itRIyk7sXViAfRAw+iAs3FYpx0YrERbpsdDQ8yoBRKxsgEISukcmp80Y/X11
	iSIm6pCsxoactQahpaI24O3Dh+3qtTMpI4X2oEVjfqWg==
X-Google-Smtp-Source: AGHT+IHyVbpQ031khovVH+RdF5IYFXxXooq/uMJcv6MssOTN24pCbmD2Np+fsrwq7RaQP1KpB2eDcw==
X-Received: by 2002:a17:90b:3c52:b0:338:3789:2e7b with SMTP id 98e67ed59e1d1-34082fd9099mr17153531a91.13.1762188493051;
        Mon, 03 Nov 2025 08:48:13 -0800 (PST)
Received: from monty-pavel.. ([2409:8a00:79b4:1a90:e46b:b524:f579:242b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a15b6fsm1607264a91.18.2025.11.03.08.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:48:12 -0800 (PST)
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
Subject: [PATCH v5 2/5] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Tue,  4 Nov 2025 00:47:20 +0800
Message-ID: <20251103164722.151563-3-yangyongpeng.storage@gmail.com>
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

