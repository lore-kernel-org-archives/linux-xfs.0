Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C141D431A32
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187498; cv=none; b=Ydaorg2avqJYXzEX2EW0W5f0+zBqCTWcwroXwEbQfbHwYAbp0Kj7pp8FXCmCegQ2qftgyP5HMbxVLeBvrDiUefDyXtyi11Km0tCyDKy4g0yO7g9eEM6x7z7SmkYTz7YD+1MkJ9o0fClPQ/AOARFWZmCW+WYxjq8rHoF9ch1hpLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187498; c=relaxed/simple;
	bh=3Fbl5MaGSEhPrjx9pliGoJqPoQm8nDp7ZS+WKqitgus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2+M5WzGEtDzVnIzLTD7lKBpEE8OS/IGOiKz9Wl3DAT+AAkw+C+LtE6VeJbHUsGcJuJ0n1sveKr3lzSGIw/AgU8oY4tuybWNJsGutr6U+Z4/yUEGumLXeKaaiiyt7q3l1mBbSHJgXYcQ2lqznvMiHgb+ml1NGWE5SnC+iJXmP14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EkZ+UVDq; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EkZ+UVDq"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-848593533cbso2296630b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187496; x=1785792296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=EkZ+UVDq09X6A5c3r9RfwA38QlXAzXsX0Dei3s7Uo1Tnh6zEXehHR8e5+ztXW02D+f
         GqMkRZ5YxhC0XKbfRBPAl0BKTzTxMbS/0KxABPGk5zViByiLA2nyCMfOgKZknIR152PN
         1zzQmSVlqp5As4jStS1kucydy1sHTGZCva3fVcP64AlfrjQZ8XPf1lTLXARxDUtlNQ+a
         zA+uOkxN4kKPu+0XD5kDqSXV5VhLZ4M0+oZ1qBdcD4N5pCo591WXIMI29E4ziLdaQoFm
         z3oMbAwxBEskwO5T60u4K9tCTfMA9HzI6o/jIieYWKBkKxShjJp0JDL0/y63kw+c4hiK
         P2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187496; x=1785792296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=USXM08xG1BP7PZe0ccXLqTPJjpmMe+QNJ71WVtN1vx/aw2yN9YDoPYcNGrYD6M1o+F
         xmZk4V5UGqHwmIBSUn2pj9DqR4FUD2bbAAeopKI4zPXFsWFplb0dlKqA3NPZEqQyp0dE
         kDALspNRVsYxfKRZ+gY6iovxKUB+ZgJEN64UrpZo39Rc4cxPOr7S+WJTtoeCgtUQyCF3
         5xhhi9AYAUQqdhzxinq8zcQaRw3abPoLB9XMLidCvVRI9lxB+aJB6itW1vPC7+Udydz1
         Bleehl1efIWeq5EbAabwEgCPq1D5HmKQTbViTj+5HjFlxsdb8++dba4BKrzQUwMTI+9M
         J9eA==
X-Forwarded-Encrypted: i=1; AHgh+Rri9ylQM3sEuuaS798CmgxyzwYvwpUU2+rXJe6l6s5U7mTB00muJk2pJGnaRtQo24ATco0cIBAdDvM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMNjkwi9WbKX8nEUGWEdnRciOo6dD8T4ULi2lLzSShsvsi3aBj
	zQSwQD7Ogk6ePFFb3sq+7sSrjmuw6Zr2pOLKowuGl467rOP4h6Gt9SGW
X-Gm-Gg: AR+sD12owD0QphtFsH9+uDMOP8eXOu1w+9ng5dwJGzEQrEGtuLMSJEtzHCMcKOU3o4C
	UZjPDiBWDDAKBHNbWuKH43Hgy+WnIuU02I/SOVuSQsM0xogTvh4fcz4asyXUVZ+hLYGh09nMwdi
	nhAln3yrjpoSot3gmBPWByDGVLc6zOn5zEMX/+9Ld8AIb0o/dunOJXDXDrY6OBDlTIg/yBVOPpY
	bOsdbH8hxoPQe80yZ/FnRT3fJLjsN5VmoHEVOmCF8VxW7jNAsXc53A4wufUdWt1WLQZXEW0Sn9O
	8LBjZ15FrWlA0I0ZDZ4LT3Bt6CC32RtOsMmqKe13o9WfpxFgC3glW/KwGD/SEBTEJRQRIIHZmKk
	ZHEoyZ5FygwHM7Dwk8U2IvarSAZRCV78UZnuRuB4ry+WPeHmzM9uijn38i2qOTXIbBh/LhSbZ4f
	9tv3eqaFVaWpN79qvd8Hu58vKAP1BRi14xRA8hh5Y/+eoWgs6Da1gI1ytJBbIknnORciYsLFJkJ
	KyvnwOx/FfKKt6GqaYT/Po0HbRjtZedECZpOC9E
X-Received: by 2002:a05:6a00:1827:b0:848:8027:cac with SMTP id d2e1a72fcca58-84e8d0950f1mr997486b3a.23.1785187496247;
        Mon, 27 Jul 2026 14:24:56 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4c::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5342471dsm3476124b3a.47.2026.07.27.14.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:55 -0700 (PDT)
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
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 14/21] f2fs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:51 -0700
Message-ID: <20260727211758.1116539-15-joannelkoong@gmail.com>
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

Convert f2fs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a765fda71536..8977ad379f50 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4653,6 +4653,8 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(f2fs_iomap_next, f2fs_iomap_begin);
+
 const struct iomap_ops f2fs_iomap_ops = {
-	.iomap_begin	= f2fs_iomap_begin,
+	.iomap_next	= f2fs_iomap_next,
 };
-- 
2.52.0

