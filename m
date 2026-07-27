Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7728342D75A
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187507; cv=none; b=NZXekITOEmXTNCAe/N+eeVHGXSSM7xl8fl+ixWXsDG/TB4BtRIUAk9H6J2M+M/HsrhLz+01nM1hA0CZeqDCl1zq32xyfC0Ub4jlmPJwa9b3y9xYDD0s3SeuSkBqWoo0GDGRBjBzeSws1JanzZcP78DMyGX90ww5x03NzqGpMk/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187507; c=relaxed/simple;
	bh=RAVvjWU3PzVBWv16Hd4Tai94P9Dy53r30XLsHoi9Bgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/LENDXkEu7/yyL1uBfvnvfU6uk9G8SNej+fd4AEEpPfB+utyoWSDdBZGMExeVlwvByFIhBebrRsDXFa+q/N26qKGwu+TMbUUY3H1IZEr3F/s7TEYkqFhHsoG9vPfqjFZMt1rRkRdO+tt7lMoGmzK4cPxwCO4xYu579InNoAy7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJ9m9qtA; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJ9m9qtA"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cacf197759so45684655ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187506; x=1785792306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=TJ9m9qtAVWvlQZ3bfDpWjyKN2ifrelWkPwJZQehG3Qm8ejoMPM3BedESYsigNL37iT
         kGLf4XYvRo4oZtxuaqQy7MPbHHoBKrOBH8twVdkv+KXEZgtWTuSug2OwFepDXYPjfB0d
         ZhQ5sYgfCGpNCChfvefhmo2zmP9T5ia3jEfofWS1eB/BbAoqGKFZyOPe8pElsM24bRpY
         Bwi4/WhzQCHWLk8rnsuxLQ9hD3ehIx0uNQgfbDrH2xljaQAGQwXgmEnepPW60NERRt94
         agr425+ecpnzzAEYaKzNJRjAlL4Rh24bbDonbbCXW2Uxzh7dL/H/OAwoGzpeNpVixsJ/
         +vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187506; x=1785792306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=rV9BHPTQ6IoBNvCE83XTwxvM2b2T+5390ubZ+Z3b0ZsPYNN3PMSDleUPS+w6X7lyDX
         WmRMeKMsbwS0bnjsU380Oe3RfFeKVajZVAvMvAdEpbJno4yl2tZzxqfhaQsnaSA7TPSU
         5RypEAsZsYhXZXQ8VBSvrbFk0KS4ZLOHhHg5UBJ1wP48+eiueX4odp9vqLfASDKooS8s
         mFCgSAHQVONpuUjvtLG6yz7Vn9YnNwrEu3s/q5QuuiCecPtiTyhWxBWCvinD+uQGCyh9
         zR4yXRHRj6jDRwTEn8EVd14vbI2HMgyP5rv0+8j+dkiFByJ9Jc3riOdKjvE2UK3XqACZ
         FiKA==
X-Forwarded-Encrypted: i=1; AHgh+Rrh/NuSTDsLk5V59i7U4cY8NI/+uKCoqUZRyzIevpjYYWnn3NZwpa0eo3T8Qheac9igkOsYCKUzeH0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz017xi3q5vvq692k8gDTRVq7c8lX2cC9O1CTG9LegCCOulwEbm
	0ZejM5yWFRW3HohrS9TESArzh/4Rewi6oCQFo2cDYn8CcnmvErQd84un
X-Gm-Gg: AR+sD12i/2Ce0O1A4WgQvljQNTO94VBIGAo4LYjEAtXht2zG0P8JC1h+GHpy1MW1qqs
	CGtCdqSoOAf5NxupuUOIk3HvqLabuehToIJb7axT7q7irFESVGP1qj1mR6cJbfl8trkogHmX9kl
	vaoPRvCElKHOdIRSvcZ0X12ATSJMdgbVNP6PpZhp+/NdR8AYlTPXhVNOYg6pb26FMQCS9zZSoFK
	EYgl/GPNSMimEy5fV94ve3RfuFevS6O4runRRaAEwgBctItQ+75EYbQqVZH8eYBiffPaD4xE1yG
	tOzoHTrXmkBlEjR2p/6FdCwIWgb/SdvPOxz28kk6Vszuu3VQKbn9AaBvJ9uuMfqmdrk28PIdS4R
	IHvj5zLAnPbLIdlRa5MYkoDz8zj/jsIdtoLDtrtvs6Zj4XAKoYcXK3S6vy8L+qU+XjHtsjn3qv4
	AvLeHchP3KJHy6t1Noj+wpZJvdvaR0BTNcGAJivtz9bTqpCNuURbKHyw==
X-Received: by 2002:a17:903:2ec8:b0:2c9:c46b:1286 with SMTP id d9443c01a7336-2cfde86f7bdmr86035985ad.34.1785187505979;
        Mon, 27 Jul 2026 14:25:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bbdb7sm40703835ad.38.2026.07.27.14.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:25:04 -0700 (PDT)
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
Subject: [PATCH v4 18/21] exfat: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:55 -0700
Message-ID: <20260727211758.1116539-19-joannelkoong@gmail.com>
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

Convert exfat iomap_ops to the new ->iomap_next() callback. Each
callback is generated with the DEFINE_IOMAP_ITER_NEXT() and
DEFINE_IOMAP_ITER_NEXT_END() macros, which wrap the iomap_iter_next()
helper to finish the previous mapping if needed and produce the next
one. No functional changes are intended.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/exfat/iomap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 1aac38e63fe6..b6dd396aa60a 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -151,8 +151,10 @@ static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t le
 	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
+
 const struct iomap_ops exfat_iomap_ops = {
-	.iomap_begin = exfat_iomap_begin,
+	.iomap_next = exfat_iomap_next,
 };
 
 /*
@@ -186,9 +188,11 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(exfat_write_iomap_next,
+		exfat_write_iomap_begin, exfat_write_iomap_end);
+
 const struct iomap_ops exfat_write_iomap_ops = {
-	.iomap_begin	= exfat_write_iomap_begin,
-	.iomap_end	= exfat_write_iomap_end,
+	.iomap_next	= exfat_write_iomap_next,
 };
 
 /*
-- 
2.52.0

