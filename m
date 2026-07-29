Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72DF3C9896
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353443; cv=none; b=dAUyQc65dBCObWXn4hfDVAmKmM8oo+5fEkJ6dtnFmGFb7/Mhgffbp0F1JaxLgBAFQsrNKZvRbiuNZkLZ+dARj8uEBVSX22auoD40RuPOOe6H8GfYDviC26jpmzA4NHVh1VVLjai9aLHOxvBgHrFidkjcOgblHiPmMnBu+ooaeos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353443; c=relaxed/simple;
	bh=RAVvjWU3PzVBWv16Hd4Tai94P9Dy53r30XLsHoi9Bgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5/SUGDx4FuOlamfO9ygoUooxziSULQrJIVqg/UnXrg1ZOhloYVO807sVoDXj8B7RBv/0eby8h5hDzkG69Zo2XdyiwkfmPOnb3y1u9rALXj4cP9PYrL7zZwTfa+s5U3FSPu0gLrGNfzJ0FkWnF3zM+geZtsatbAJ6hp4vnpo1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEnxdguy; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEnxdguy"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccf2360620so13333725ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353434; x=1785958234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=HEnxdguynFZb+fmc8HSjbLUPKlvjv/7BKDOifbOIyfb0LSR6JopcPNPmTXQPNLCrac
         kgB7WfrMRrXHl178rVhs8aVPjt3OYYVU9W/AthyoBh5fhqo7q8DE/G4S0ulB+5I7A7WO
         bqvHjzk4E9+s9ke2YZdn5sPovtl7S7jOuPRd2DjtJXGCReMiZnmRzRMJ91gJyMW6VW0C
         WHaSgTBBtbmylKJ19Xwc8NH/bZ1DgbYOUbIP0FhO5G92eyh3Mj8rrbqU0u1Rx+q4VHk/
         /sGuuH1NO2JXxh7By5lPszaVHLDP69t4xqO58DlEgqWmO53/IUIlqribCPP/fYlaOQVI
         e3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353434; x=1785958234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=BeQblQb7KnC459X67xh7DMElEJbGhDFeGV9lwLV09VEFsj0UvnpIXEnNlHWbe3ngmQ
         9NvRL5bkRCEcykV4xKfLcwhHJDPyd3X4wzglE8DzxEp4rCn4UHAVwo4aUIJYu01fGYJm
         wvGASx1K740EbrSjqCf2tPtWhr8GwcmbsnwXbUFR9BlFYJ2AlKJmFc7o9uxBH82fvD+6
         O4QrMcqT6DspCo4V2R7fH5K5dCrBCd1BVCHyEaMRT/Y011pR96yuQYUbr0YOdHtOMBFI
         iUojaHfeLmRjUdMzCqgC16skXKc8hV2IXAl+K1Ey2yrUmPnJyUvjnMg5bu/bp3oxTZri
         wr5g==
X-Forwarded-Encrypted: i=1; AHgh+Rp58sY32+/2cvCZpjqJUqEJebKmmk1b2NIPuwYwlLqH6Y9kIgVjIs6zi4s8dMY2brjoRUeUOQW1L50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw08SYfBJ9VbXY9GiBGL/wKusQXWA28PegbyRgVSZ3xrbRdD5Xx
	FlGEA0hgHQQdYRyHRoH2c/mHX/YHi/+uzwRQBlt0EHKU4EqcUf9msLP4
X-Gm-Gg: AR+sD11MWROgklmuT5OCJNM1xXrtm6pbDP1zdPAaVai/8mgg12udeN31OZQ9kEnnz16
	V7/v7hNodP1z4oKY4KcJV7fdCsnt6WnX0Y2n3BHXdrMjy33HjGtJkYUtRc+j50/NSvhSOIClPKr
	dNjQpojpC9OUSa1R7moE+NDOBjyZgksDoDDwWsS+5lSWYb3ja/HsYS3BIO4qRjQIk6vEyFnDpW2
	gjP7AXKEYUWBouLUtFPVXv+ZkNG1EztH+JF3t1vbRF2kPRa6UJByeMw41/BZLj0hB2J3hyNGg5k
	tucsDBJS9Ppoii+6d61jELlPHmIDlLQNagJoJAHggQ5ks69gCsjNWGgQ1fVzB2Rg/67pMlqgv9i
	LyxfVStxZ6hC6t4q6XnJVGyYkp/ou6pqWUkQo/UBR6EOpFxFEIjOdgrK+hBYPB6HdkoEAVmHeu1
	dxTjXu/T/T6beN4EcyqMBzYF7ZEr8JeedrU0HQjkIx8ENFju29NBqnzNqk4QT4aj5aRbxFlWF2T
	n8XMpz6nxcOBF/FcUbPc4XbagELbcUPJsRKLKvxOg==
X-Received: by 2002:a17:903:3843:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2d0336001eemr2188245ad.0.1785353434068;
        Wed, 29 Jul 2026 12:30:34 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c3721esm15989085ad.77.2026.07.29.12.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:33 -0700 (PDT)
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
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 19/22] exfat: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:34 -0700
Message-ID: <20260729192737.3190206-20-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
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

