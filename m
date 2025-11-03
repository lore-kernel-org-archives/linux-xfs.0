Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22C2318156
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762187855; cv=none; b=lkGCSATt+8lhlVxASsGr4gkj5PmvgXiIuKvKVGB607KSP5sALJembLQZllLR5R/bSrBpYlgWGCkBuOBO7HREiEAQApxO5sZyY6uLhsRzc9uj4tdh7xvUZvUu5S6WFRzK3Y53J5hlLtQspnmqkYDFXiBo8Bn6pjS2bqm6TTxyEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762187855; c=relaxed/simple;
	bh=nWCX9Xn/+IKfnehkSs57lbJDTkS9u5nAvInJtc9YeA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+lpLjSiT63W7uKYlS7TUCwaNj6G4a6PaL/6QxjJCDpi6QrWqOJyPje2APBaG+FDjRgwFvToOto7B8qIeyLBO895C/YpRa+n/cGscRzNTezGVid19RcpnYNo0AOGZWz8E38Fg7v94qOLm1+qU6VbReryYmkSlbHeobtvfZ+/WBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZQUmVUb; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZQUmVUb"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-33b9dc8d517so4247196a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Nov 2025 08:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762187853; x=1762792653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UbgPj8GVBWuehInulfgB6O/0NvS5woL/wIoY+Rh1do=;
        b=VZQUmVUbFLd8tjP14YlfkEj+BnVA0HkZGG1iVrcvoAVDds/l82FT4TOF95wMpFst0e
         /g6xGi6MxUMmJz5h/bI23XRQ86NmhJ3qEuOxDODdvzg6AXg6ZoJaM4oxszUScRTVWrsz
         e9bkzUs/18yEut2/k5hfEsP6233MTakx9aAkCovRdMWVDmqh4kUDgRHDiC2CHoKPr9fT
         VeuqTRbh0IzebF+QI2dMfZj6pO9xKOFJwVy5IbQeDtTitIm2GN3MoidrFpft8Vrfolcw
         oIacMBKWdqJzpgAYJVrRZZXdDjMhNSc41ZViFRnk8FFQGPmekmuam6WtA1UskCcR8DDb
         ACzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762187853; x=1762792653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UbgPj8GVBWuehInulfgB6O/0NvS5woL/wIoY+Rh1do=;
        b=J16JE+oJsWnRMos6P3OclKVW5SsvHWnaAnvhPUGplO5J1F/iKPtNUBKEdiqk4fVtNq
         k3JczmBx6/41SVH5fhTwL5mKI39pIcXRkpSdHb3Zd4ajxLkDYBN/rihCC9ZV45qWOf44
         YS7kc8fxEgXld6IVNopPySYOEvJZZiHauU4NdrEoDoJO9l+bviDaP+wprm2tZhA324iB
         eecggqJkCTjUY3OmYHtVHVFz44+/6iFDKZiWElCFkqt8wwQI0ktyNDhQe1qZmXDzLLz9
         kOcTylC/5WarBp+ZHh9ONxvMvytOtLgBWpoAjghQhRMK/C3NOgA71T1MphbHBpKFwY+D
         V3Lw==
X-Gm-Message-State: AOJu0Yx+lgeg4dIBE43vetWERuaKSg1gfJbHuJoh3YedZTkLjBLWnhYk
	4z9dp20RLqp6mHgkxD8NDabDPFKBmoFm9b+r0Icnq6Zn9kDyLKDu6w+r
X-Gm-Gg: ASbGncv9WkaaFtT0VfcQ005SAPzkHiiyMxiCCgpvFab8UMUWRSbdikPhKfIcjBlpbjU
	lEuruAnfMmcZSemyROBnG1D3g2VDu2gEwXr7PBrj7M2tRITCdEk5Rx1Tid+nks6R7VA0pclkT6Q
	e6S+eM/Fr0G5ZOyetVCDrJDRqHrgvpZga8FdRK7x/cjEzE9mjMjJ/vb2RTztLXijQtCH0nru0vl
	QEvU/U6ed0iE5qSspTyIe6vSqxC/Y+jt8gFHJ8zTPr0hRUITN3PJ9Sho0wJPYYfIQKFeuu+C6gX
	lBCR/SGPlBMoi2hF7VrRriuatTBYwDxdkVsUTYpck4ASjBC1INI9npVBi+XOhHOMtsFVa5Wx7Gn
	H5TXm1M6Zap/XsupERguVAn3Gy/Lk/PcSUgNt3QdEIkJMIQwokyAWmtPXZzCrhrbGW7xbEWdRmY
	/HbnoRIJfl+M2o0/uW5eCLFiaobMY=
X-Google-Smtp-Source: AGHT+IEASkA8V+7jhpM5M1UBN9y/LaIZ3ZfddiwA+afwhpAeDYCIo8Ch8f4X0rxhFH+DrE1jj0TzUw==
X-Received: by 2002:a17:90b:48c1:b0:340:c060:4d44 with SMTP id 98e67ed59e1d1-340c0604eccmr10391621a91.14.1762187853008;
        Mon, 03 Nov 2025 08:37:33 -0800 (PST)
Received: from monty-pavel.. ([120.245.115.90])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407ec24330sm6853704a91.2.2025.11.03.08.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:37:32 -0800 (PST)
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
Subject: [PATCH v4 3/5] isofs: check the return value of sb_min_blocksize() in isofs_fill_super
Date: Tue,  4 Nov 2025 00:36:16 +0800
Message-ID: <20251103163617.151045-4-yangyongpeng.storage@gmail.com>
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
opt->blocksize and sb->s_blocksize is 0.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 1b17a46c9243e9 ("isofs: convert isofs to use the new mount API")
Reviewed-by: Jan Kara <jack@suse.cz>
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

