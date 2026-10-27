Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138316;
	b=AAv5YheSIoGUgqAr2Eo/To6Qm/zE0Th65Rp3XMThEUU4/Chmiufa1jQOszW1sAKishwY
	 nQ8kC34jamPHdIGiooKYHHSotuJGc4e5zg/DzvSPuSVu70ZJ929vHWehevx1izEgkfn0U
	 gf1LPUh2NHpmVqZJ82ztnJQzV4M6j71fk1/Et2MkFDr4vMnf+U6mlkPzpwG1DZDPU9sKu
	 EwObXNJDF9NW8eEWk4pX4dsNZpRJpdNT1jBT4/oZHq/XtMAtA1kgvojSlanZY5bdBbjFC
	 m9ox+JUiK+nSUBOMRMlPMWt8g3eOpppanppYzadhGFgbWriNRkZnFajVxNRiZaYgQKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138316;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9OJQx+TcWNp0m+XcidattXlpUlog8C9yogSLSSgROM=;
	b=2qQwIQOfhf167s22JBQBZ5+HY6kMrkzch0lJ8I4hJ7tYl7d8GlxZHuHI3TsCFPN+ryb7
	 Jz03T2ZCPsntWH+nVxvqBsF1Z3s/Nu8BhGAu1mIjvwLMuKdnjoVxA8EICJ6VExD8LBcas
	 6T5WNGTLDOnj0aNmvzMov1eSsKeZREIN7ZFdGRUv/4FaOtuAgmec7APhbIoWmTKeSk2ql
	 o/B/htZxQmYEMJYxic55cK1C7BLFIj4K4+07KltyZRj4cASnf+Evhkg/eGgc8rDbUKiXH
	 +Lj63lCnDXAXOSNLLILeVkbbc+Vp6Hv+hMenKgq3ESXZeXmsG2KDy6s+/dUtmg/SzDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oKDsmVms;
	arc=none smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFB6606A31F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFFB6606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oKDsmVms
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8ad98c3fb15so2730297b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138315; x=1793743115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W9OJQx+TcWNp0m+XcidattXlpUlog8C9yogSLSSgROM=;
        b=oKDsmVmsuk3dkIKPLXCEgrrBz0xgLo11lpY3b+3BJxL16XSKxaj0p+Bmb6QSRClvjk
         vQgeub/fwL+j+/KqtYUrPWdmrqMOoHx4qRiN7qr8wi7AoYcTOgTu8qTvLTN8mlMLlta3
         PRadaYH+I4mJfMBwrxUUOTN4Y17NnYPF5kfY7qSiXSUYMB6ANOrfA2ad1Z7YMIcWrkC4
         ikNN/NuZ7clzkhppK02X+qnkR7AXWJPHiDKqadRAar6whNKO1V0O+2g15MNOLrrR0eHR
         DhtfZtaofy0tspWXl2SLaHkWgeiBPnzHNxLwCbUXaJurLi0FF2JQJ69msPaVlOWQ1s3H
         utUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138315; x=1793743115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W9OJQx+TcWNp0m+XcidattXlpUlog8C9yogSLSSgROM=;
        b=f/92vEkQwAAhpw9Ykj8z1lWUxCtzZTnSOssT8Q8aHABqFs5iE1CkuDPeS8/vtfwl2L
         7+COStlwoU940Kz3Qvu26Pv83nxkSYu8KOGu5ku/d2dczJVXkOKFu70NM1qBE50bJegX
         Ir0XyfFlSjjT0efuKzxMHIZnpUifLKquiBnpGljOCbr6qIFc+UqG9AiMGJGbefhjkPUS
         flg7lBnOgFieDQ7NXT5baKBVSRri6++2Y/hoILdx7i/v4IoiodOYxTTmzsIFg4hLfgSq
         Hxplg+WszLy3Fi9gxv+AfxD6jBJLeMt5OIe7IUOY6WzO207fMvQG2VBJEjLemyCujUEB
         rQYg==
X-Forwarded-Encrypted: i=1; AKwUvBx1tKWZpVKlkQCWsTwlhFoXfyuPysN7r8xQiGMaD05+z4IJiHYgc8E/TTxfyl3/gj1D7WpRKQ7MDp8=@vger.kernel.org
X-Gm-Message-State: AFq9FYI6vQLuhL3TlEK5oUV3tcHC9ArIEFvZC1l2EaYIqr/AtJLi3Xkw
	NjwsqQb3bepSA22GaAOXwikPZyMz5MRVAFSlHX0llqG/SqLD6dMgcx/c
X-Gm-Gg: AYBFou2ORjyZFBqfQILB0HlvOiSHk6QHnG9L2r04XCWW0IgglpVfnqeM4P91ao6vWdP
	ikS1tYMfKye/VQ9Z4hxenJRgl1+AsYq0nHs44fWj0XcnIb97E1FXu13j5b6cKzlViYTYLCaPXAz
	K+069izmY8G5fyPVoAfaoZtgUZp+yPooQa1aHq/iJ+tARzbJ83ukOEu9mwaqrgTNtzoDXaZOmGw
	6SeZiZJNSPYDcuGZmkFLvP8fqZP8tub7ztaHorwgfyUSe8ZPsCuL71fbSbYtYkr5hAr7ia2f1IE
	ifDteBHp4dwEG/STcy+mkHF80T2nU2fre3EgwmCT2YGW1gr0WskU6vOYWVI5Kltj66T5MKIidON
	Nj7XFSrBIwcYe9ejYMgVdURvDSK7kQsYTSI2IM6MED6NKTahTOgGvJBRH0j2gvSQWMhcV2mprZY
	+9xGEQCVgHocH3zF5T6BhdIzV4OkylOxBIMhCotRUfw2qScF+fFWVeX/tj31iqTspoCCl2Afm18
	XyMqAlW0i/zyB0LhoNauqaP7ntqHOSfeCr58KzSExv0fbNmo4UZZpqFfoHtDTjU5FmIZF7yIcv4
	u3iKF+sOPAL+U1iIyD6uYAEaTTLVCmV/
X-Received: by 2002:a05:690c:e194:20b0:8b1:7346:f1b0 with SMTP id 00721157ae682-8b1b5bbd517mr2470267b3.18.1793138314743;
        Tue, 27 Oct 2026 14:58:34 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e67cbf1sm18555897b3.33.2026.10.27.14.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:34 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
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
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
Date: Tue, 27 Oct 2026 14:53:22 -0700
Message-ID: <20261027215326.2693300-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/nilfs2/iomap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
index e130ed63abd9..359786c97f2b 100644
--- a/fs/nilfs2/iomap.c
+++ b/fs/nilfs2/iomap.c
@@ -67,6 +67,8 @@ static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
+
 const struct iomap_ops nilfs_iomap_ops = {
-	.iomap_begin = nilfs_iomap_begin,
+	.iomap_next = nilfs_iomap_next,
 };
-- 
2.52.0

