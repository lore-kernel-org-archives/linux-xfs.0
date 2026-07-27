Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E342B303
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187482; cv=none; b=XQqwachI2XCAzPdtmrH38oWxKUoG1KMnHbf6Zx8EtoOekvIuh4hvGsN71oMNlnyCsMUO1d2ytLLH2eDvxOpMWWf0aeDzj2N5/BAnk1fnqk8d3hj0CtbYct0/lkxg4QFNoKss64ZWcCOdpMIKhzUhxAhCtqVXcSznYgaP/UARTKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187482; c=relaxed/simple;
	bh=BB0sPqRZ88+T3km26e+GeLS3s0vMjVM5Qt+LGf7fCk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JewCegiUwtROXU4Zt4bYha0C7QWVEnJ30osDxgVRYnJ9efhC9KS8JtkGuHm3GpzM6KsYevintOjS5+wFzucBxXDDdsI8Zzt7+iD3+zqbY4nLkxmHWI4mlyEBE6onLyRISL2WxtXDIYn/41LaJ9TUvKyU9K0wYnOExG0PJlg8z1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ErjXzn2c; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ErjXzn2c"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84e0688b859so1944771b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187480; x=1785792280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q8M3ZYr7j0Vv2huOSINRreA5KjJf/RGJ9R7Nsb1zC5k=;
        b=ErjXzn2cimv0WR//cUytoT91+c77Jc1q9RLDu90FdL+LxX8/ofxi+CchI38NsFeqY/
         28kEqvBxfQCeRM3RiI4+sK/V42roZ7wqTeYEqDbwUv/JV5HqHTjZEJhVwmUd8x6ZVYLF
         dUtI0P4Vujz3CGd0Rh9WyaCdceyCR35ShJt3e5Rerkv2h4khXmE4bq/nMZ4tNs9SHKcY
         O0oS+Rj8nKJw+pHxAPspoW8hWsF/ikryWWRP99iVHsTmaFdrnPXuhqoaN1i+kQUhQ9uc
         ZtMApConb5Vci08QPAQ+DT1WaKdFmBhN9NZS3F3m1QaIc+aykSoicHx9NWOsMsLYD7oh
         ycaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187480; x=1785792280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q8M3ZYr7j0Vv2huOSINRreA5KjJf/RGJ9R7Nsb1zC5k=;
        b=saDA7AXb1/k1xtZwofF4Hcw1r8QWa5YZHpATRLO+U/fLdWGpbS1ma4hkx+xZ91RHtw
         NyiOhySx2qeR4n3qz6/Kz5cOL7L7z5WbQk2t+1t3NBQvMBSRurr5sevGJi7c2y6Y+dkV
         RtL8vKdK6d52iAyRM6xo5PwNN22Az1pf4lMtaOyIouhuaUq16Rl5ajMLzma4YkgjU9cr
         oDoknCPK7ZHwSXXuo+lLN7Km0g5xGFULG4lfG44PSAO0wLHaT6+iNiqRbXzvIGhRb8H7
         rdEYe4P9+fiBiVG6GNQY4HJpLjpgHKMV1+D2UFJ1ji/YRcXPdQj/59s863JT27KFLnn+
         XKFA==
X-Forwarded-Encrypted: i=1; AHgh+RoKM6T63yzp2Sx8W0DdnYwca8U68hd9YMGZXZBh1Ayur+xoLvo84AwehkKkAdUayJ8+MeQJvW58QE8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw30ElWsm5ZZcRdWNaEUovSq/RMBrNrG1f8ysFwTyphpivPMS6p
	BiijLR4B764KOWfn+sbILAKO3a+9T1++RInZSOHpCgl7f1V9Y27NVWAf
X-Gm-Gg: AR+sD12AX0rZM08InZLNs06au09aOXbmFsIEFClSd6gN+VqHYzi1aSe5Lj979Wzd5iq
	Ta3b15JVrzopXfTPVv/4BPxOSXpJrA4xJnwgCaGwiRqH/45GKJa14gm/spC7MnTGi3r6zKQ9iOX
	rJF1vGtIKJL1Lp40v2joupM6U6u1w8LJK8b3bWv9EDIJ4JlXVr7csjhZg96AiIp+YORPklnAhTP
	o/R9Ad/XzhTuX8LPDuGmVaAUj1ZT8SjsGqSxmD44JmemKM9CKqdzzZ4OUrhG0p9BTiTJx0EhZ5/
	gAQ/b+OaO8iFYd05OpxxeQ83WNLm/LjT/nyaeVR2tuWgEvLULHReEKuH3lTHauhq1K2Iz0r9vn7
	2iR+g0PHKkHXe0h5girzNVJWzyNCVF6VFJ2t6vhZZpGZv4U5z/Q8np91tHJ2QHo1GaF0yA1Vl1H
	a6qBzRJKi21W6Dfq9DfrrmLtnnIyZg+wT/S5Fp4ru1mOr04WG1Wpx8
X-Received: by 2002:a05:6a00:1ca8:b0:84e:88dd:5942 with SMTP id d2e1a72fcca58-84e8d372229mr882823b3a.41.1785187480563;
        Mon, 27 Jul 2026 14:24:40 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e533cb54dsm3520606b3a.31.2026.07.27.14.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:40 -0700 (PDT)
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
Subject: [PATCH v4 07/21] ntfs3: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:44 -0700
Message-ID: <20260727211758.1116539-8-joannelkoong@gmail.com>
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

Convert ntfs3 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ntfs3/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index c43101cc064d..53031e71c8fc 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -2101,9 +2101,11 @@ const struct address_space_operations ntfs_aops_cmpr = {
 	.invalidate_folio = iomap_invalidate_folio,
 };
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_iomap_next, ntfs_iomap_begin,
+				  ntfs_iomap_end);
+
 const struct iomap_ops ntfs_iomap_ops = {
-	.iomap_begin	= ntfs_iomap_begin,
-	.iomap_end	= ntfs_iomap_end,
+	.iomap_next	= ntfs_iomap_next,
 };
 
 const struct iomap_write_ops ntfs_iomap_folio_ops = {
-- 
2.52.0

