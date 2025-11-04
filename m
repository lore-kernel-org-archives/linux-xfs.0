Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5BA1F1513
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260661; cv=none; b=pLy4qFHsJ8LEM1zN/evzbSdmUh1Vn5UQNB9xYeJFlEpE4403sKpzDEj3elwYUEII91d8rKKW/YfariZ0sbcGXJqXLoOXacQGU7kH09nKI7lBKZgH1CYtyr7B7v3F4uMcNNi3zNMq0qQgyTbMrfTgfBlzpPcs+FrWEK/Y5PDYhoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260661; c=relaxed/simple;
	bh=Zc/y7/iyuhzo73FcQYuGWiCMqi/pQGpHb9Cqw0BNl8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSlfhvTqOE6s80tMrefYl1btAlARAbjlXBNP7A0GllXGb9KpqHzqrZgeLh19rviYRHyMBly2lM3jYIP1pGMN3Wl/72ivrjNqFDjEqEk8QnGAshV5+wULuHVyQwJGeyruuLv7TxIA+p/o8Sih/MAFxzlCsSUGvCPpV+XsKcvhbgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5hbyQCf; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5hbyQCf"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-781206cce18so5848192b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 04:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762260659; x=1762865459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8asDZdZ/5ha36TqW9viVaU035nISljT2hMRnvK4GxFQ=;
        b=N5hbyQCfZj1/OGGI72+GgKXdJ08+1645rRmavy4TlrZ2aP3Rlsohnd6HUAPJeV2/s8
         huUzE/fcj7DETBzdWOTAXqAdzp+rAOIAeluflpmfy2Gicx1lLMqmNheoEioy/GYaYx6u
         DpRK4O9nnXzCvXmOn3AI6pvQ3MbmbF0ONYLiM559v5eiNlnhKPmApca2A7MMPsO/abCf
         pDe7+v8QvbGsSuhhBFIMpreLlmHZZAed15xwJTRQLONTuArUROzG1cH+l0IGOo64Y5fw
         US4ppbUNpttTtn5/j04LmI/UHogRXNbcRaG1ZvP/127r3viM9WVnX/o/BsldFmnN98ha
         6RBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762260659; x=1762865459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8asDZdZ/5ha36TqW9viVaU035nISljT2hMRnvK4GxFQ=;
        b=as7fLZH+omFSuVPi8iNbJvP7utfct7v1Saq7bNI7f2VJWzxTsO0TzqvvSM9gSLWLQD
         Deen6+XRt5GVvQJBpRxpyp16z1cROrTchbjyUj/euIRZ/JP7bRgBrYOBUDXj2t1lKHT4
         d67k3phbVeSaK3If76a61+SlxGFwM06DGBhMzVjgWfSrze1dseS03VcCGhOshS+OPiNi
         ruK2i7/LxJ8a0Y0xS9b5RiTzCV7h/JyOFR50fRP8xG8Kub6PhaPdd+EQ65+FV7P0nwl2
         lpKnEYsWVp8YlK4KOLX0ZeBdvQdD7tttHka6Bz7m0neDJBKKLNKzbhJWIeHB5kWdvgl5
         MNUQ==
X-Gm-Message-State: AOJu0Yzg5Q93vMi8we/fK2p54vJw+EsDt9EyIejDm+qPGI3EkAvFs+mb
	I/icfsZUypf/FSXMKiU7zDHTt7ANRP6AuPQ58y1nyj8iruUgpmkM33Jp
X-Gm-Gg: ASbGncvPXrDoywmoRHFO/7V9SkxcyjLNv8Tce39UlhOMghnQKRjNJcdsKXXHhHlFu4U
	nnxGBzzufGrSM6dsFzlLt9e3IwEa/6F1FKvRxWA+GwrdqXeUtXRlkdplFuEbREaKEGSwSbBk0SR
	x9PII2pWIgbQrRkLfjqP4U3du+A2eLZHwZzEk8XnOPLwxkDjxHi64nLvbyysRv0EUE914FNECPg
	UkOcBeniOOvsh4tvpqznD1u14KLIfaxNr+9e6QwCdw/OeXGPXOqkSEI1Ofyf/s5YdF3LkahzwlF
	eJLLv3afBZ/acnQSXovIQoze/72pE8HWdRTO1bq4wiR6Q20q0cfx1jlL3PLLZOGasgmhmcMv7Ql
	M7yD4BUDEJtO5FljTb768ikFCqiCZCRVmy/x0sNw/kCz8I04+cFmGXni2O0MjcJM351Vns/O3xn
	nHYhLU0QUt1MvLVu+l4PbHd+6RazsBM/6HLvqlNZpDjVM+wbB2Lk8ADp7Fnw==
X-Google-Smtp-Source: AGHT+IFSneBnWTt2VQT9MEymny53bGd7ZCTNmsINIZkl0njlmgUgoGuMpFK6R9EKutPwtc1t3a4fcQ==
X-Received: by 2002:a05:6a00:1988:b0:7a9:7887:f0fa with SMTP id d2e1a72fcca58-7acbf0b9e3amr3856752b3a.1.1762260658993;
        Tue, 04 Nov 2025 04:50:58 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6d026dcsm2860710b3a.70.2025.11.04.04.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:50:58 -0800 (PST)
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
Subject: [PATCH v6 3/5] isofs: check the return value of sb_min_blocksize() in isofs_fill_super
Date: Tue,  4 Nov 2025 20:50:08 +0800
Message-ID: <20251104125009.2111925-4-yangyongpeng.storage@gmail.com>
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
opt->blocksize and sb->s_blocksize is 0.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 1b17a46c9243e9 ("isofs: convert isofs to use the new mount API")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 fs/isofs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 6f0e6b19383c..ad3143d4066b 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -610,6 +610,11 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
 		goto out_freesbi;
 	}
 	opt->blocksize = sb_min_blocksize(s, opt->blocksize);
+	if (!opt->blocksize) {
+		printk(KERN_ERR
+		       "ISOFS: unable to set blocksize\n");
+		goto out_freesbi;
+	}
 
 	sbi->s_high_sierra = 0; /* default is iso9660 */
 	sbi->s_session = opt->session;
-- 
2.43.0

