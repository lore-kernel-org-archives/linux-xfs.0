Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C444DB566
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353426; cv=none; b=fB2e4fh1PS+iPwCFGFWiYJd+n3x7fGygPUdv/K0tImpVaoZ4ZZCIrooMewHUUPIWiVjqkWgcd8BhOlH7GR71JBs3sgPH/OC0TuRddZn3FxsIMq9n3PM8TeDbr/PUW4jmjSaTxPZ1ZoHotCbdYixOMUnEcnUW45s7S/QgeIam2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353426; c=relaxed/simple;
	bh=NkWTxDB7BVf5kr2NeMKSqq0wtS9n6p/N2UG9HabFDJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjsq+d7EZXkPUTrsE1fUSmXZQ0LfAScMY77SAY7+0NQoi8HM4VP1dMSKa+72n/1oGSZMmbB/OdO0nqqB0O/1rlT6APw1JobZgL/3LZuoS6zm/GWJ77gDoEH6+Tm1mMFwWMzLsrgKL/WnbOJ9+TBIEpxPsimSD9OtaBMKDwKjXWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzjNwIXQ; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzjNwIXQ"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e3efab7e0so17391a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353420; x=1785958220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=RzjNwIXQwrsLc3iXdQispTSj9R5/FlEjfFmgXGQb9PEF7caPycSYLn3C3o8pRgIk+g
         kED15/HnjZSIvZ7AxM8N84cMjdb8B+6J9J3pgM4GFLvxqsa4dfTzmqmolRiDNP9kPH0N
         hh5Kx6pJwWKF+N7ADb/GYUaDTgJpaUeIWuGPFFCuM4fBexqG3OApWHJpFDejajRRnD/x
         ZItS2yKSfr2/VYq0WFmXLUPiHUgAt/pBwgQhpZq2FPvZOKfBURv0YmqCKTlppvhT01Ug
         e7dA+zbEXM5zNDAfxBzxCtM8OxAs8zqPs+gwfRM9HOUpqrUv09N+za9omB1R9bvAjMX1
         kfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353420; x=1785958220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=gF3/MKaZ0iL+HhGVlWkC7sCHjJmsyx+zTmgHnOcXb199W9jrQp2EoHqOxjfyqsF1bL
         9qpPhFaOE3b0z8FZN7+CToNk169Fi5Hjh1HhgpmKejkKShkxZCjDB73y4ZbpI+woTkpY
         YFDQowfZN/OJgGwAafUOKH5cOTYtzjHH7Mh78ZgoahhGgmQYjzavqF5rqnBJ8mBz2ANB
         8dysnmsYUpRGtYa0qULT6czhJ/GlxgHAf3XdmCyWYJt1WGz23eBY6wm6bK9SWw3WE8Wl
         Ade9Y1JaHKenlNAR5oGMlhhqo9U7TRiwEOfC8kkRte3UCnX8FNAEZd0j6MTFpO0gjRqm
         CyHQ==
X-Forwarded-Encrypted: i=1; AHgh+RqLGRtw21aheKYH/6dMYHLOcTjyS6a9MO4PdOr9AATaIIhNIcRp/FsLfNEvxwO8AWwMP7TKyR2dM5E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo3M1kKE34GjbyCd5U68zCHmqLSd9U+2g0iu30sjWpClbfBxMV
	HW8mcZqEYAFwKlUB01arhXejBOWSKSpI4eW5cvcE7u4kNTvCPM8U5BiV
X-Gm-Gg: AR+sD120KYO8wFkwCf0URC6s2n6WSgSEvOgmuKIf5Am5eMQeszabKPRRvyzS3Fnlzwy
	zK/U1Vgi8AkHoJlvZ6YjlJkvyTRAtEAquPBCSgm3/+c7EO9847K4AnNojg0B+0yqM5hBQLt5Ezw
	ZLhuOnooWp1HJFS+TyejwQEM0YF+BQGQss0lyt6XrW5q3R0w3sce0kIhrVw2OhQDsw5E3WzTEKD
	nDb75OyqEutuEhCTAv9kKv9i2UFfewBE4b+Q3Ud5mrlLq5v9TlVJ9CsybTD0CmjVBiLYIj21qbh
	OXi60y0ka2jsUklAaEv8+PwoTNYi1RWWSVxUxSNP03MV11JageBeU5QDXzqZBU/o1ndxu6YrSTP
	NLpAi1Qx1iMlG3vogqr2V6o1HFHI31QoYgx1nSteRkim77PQevtxNHx377rTw9muu9SM1sgocNm
	PNvNS+lcYuskLt4Wm1s1sWWgHQpuI92wCb1z/PUJuqoKAswp59uvnkjockYzoS9N/zqo0yUhUa2
	r+H9bHLRpkWZ9FY9mfOEnWEJ+D+ZCkuviMTZGgL
X-Received: by 2002:a17:90b:1b07:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-38f83519701mr2825738a91.1.1785353419540;
        Wed, 29 Jul 2026 12:30:19 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6410ff7dsm3181791a91.4.2026.07.29.12.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:18 -0700 (PDT)
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
Subject: [PATCH v5 13/22] ext2: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:28 -0700
Message-ID: <20260729192737.3190206-14-joannelkoong@gmail.com>
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

Convert ext2 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext2/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..7e0fa9c454e1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,11 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ext2_iomap_next, ext2_iomap_begin,
+				  ext2_iomap_end);
+
 const struct iomap_ops ext2_iomap_ops = {
-	.iomap_begin		= ext2_iomap_begin,
-	.iomap_end		= ext2_iomap_end,
+	.iomap_next		= ext2_iomap_next,
 };
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
2.52.0

