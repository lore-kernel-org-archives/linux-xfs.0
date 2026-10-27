Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138318;
	b=tBvrfMLYN81ESvwrbAUOJTqgfohcGumBn1P+2lc7CdPAs+v52H1bBQDjwpjwTyrs2tzt
	 2iesB1cvCxzGhgZ1TuPCT/nBjqkNNJTLLG496aECZsYpjeD6YgAu7yyFLXXeUvOyH/YBO
	 iBPcPHdiv9C7tEwK18JWICFQuh42Ed9eKwGkjKh1pYQuBajCnwhG6hk5ZnnBQxVDlSXH6
	 MdfHhrEzjijIvB5Lw8VeCR9O0HslnZXDLbs1gpVYDVBiIcTlp0/Ael1IjCG2hi7FKo2ca
	 8HwADabOMPshy++RM4Wtj9GeulUDCjIY9nxrR1YIFTiDBd3vo4v2Dg0WrvglUXWRQYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
	b=Z4y6+o62/QhhrynEcFmaiXsVbgDtBc2hkY/8ZCI0ILMW4pI+6o3Xc5Ds6fUcHFs+CPYG
	 aZWAZyoGi3kyKApkO3onKXNzWVigxqLatZGLSbF//ckQuVFJ3PjNHsoz0b57pIv72ywQ/
	 aDOdvmL/+83ZXWsyNptF847S9CbVBfMMTd2Gvx+RvzYwlDhxB8tkbi9Kg8PdMl45BiwTY
	 1+EcZfQvG4QDz60ac3kKnDBWuhDaiewgf+H4gJHEGj6gBBcVezM59OKsjkKZA06a3g8Tq
	 zanAoQ8eTz64O3K9WHTg6OVmk73O5Yo1EdWp0OzSyYH/KXbil6Tjr1cSAggj+j33XkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHefbI+9;
	arc=none smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F687606A320
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F687606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHefbI+9
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-677d35fd1d2so359754d50.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138317; x=1793743117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
        b=hHefbI+948nzC9V3ObgOm7xqIlu0T2MEDj0gG6avl8Xb2kbhf6Z/cbqoyxSTnA73BW
         CDF5OTDEdklbOqujS6eVhxL5dGvh/C6tEqLgDMTWvMNYjG/xe9C8VnbQomQrlEVPuJFG
         m+SVQ/r0R6uk3NynScu0b7mMuf29mIgeofx6m0l3z2mL0kRhgjYRJbMWyYYrRrbZUIG4
         AG1hLaUcgUGyfeP1pEu8FX4TgOHzM5iAwdAKt4hZbNHbOhfpISpbqGywIGZjvg1dRFdo
         GgL5HVvBjS2vRht/e+neQcTE4BQOXDlg/uGmJh01kZlWUbRinQzJknNHTTrFiU4vjNMu
         iDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138317; x=1793743117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iqfPoWTkUvjEoiyLTnmr5mj5KovsR6sHRhbPRdxo4UA=;
        b=KzD/iotVDlpE1rBjbkLP6wJjRfYRY25ZAYhEd9KqfWCR4eQluQgw8qgL+WKktdkRuk
         jFT2mhEmtgvn2DCELJ5ScSn1NYZUSkyku2ENQwABDT3LS/SgZXn7cfs/cFCvETrsZrkz
         GtzE2kMRivuv2oYPsenVopzWgTr21KkV4kgkWVdvfczjAA4nqxaidf6D/+sEaXFTX2jx
         9hWNyrkfAOFB5XLOsDLzp9+zrp6Va1C7yewTaFVdsmLDANfQaHUGCkXLUEDg/Wtdzsad
         1RwBD6qjY0QotYqCQL4Ywh7K+/wb4oK8WCxLsawE/NVMKm9PglMYhRNObinGLx+FCIbu
         86Bw==
X-Forwarded-Encrypted: i=1; AKwUvByvulOJ3UhpL3BFlgZlRUOLJm5KazN92k9xf68IUlVlstX6HtcK5iJqhzynP/36wdMrdRKh7jjoG+Q=@vger.kernel.org
X-Gm-Message-State: AFq9FYK6+iDuHfcW68MazZZMJVjgS5lwSVmajmUA072qJueJwnmrWGPI
	qhd0iPnqTCuq35FPjQETXIqAqUuMfxUYzEdgjTVebCvFhU2uiD7xuTM9
X-Gm-Gg: AYBFou3s7HqXHtgmFQUHpeapYvzC7CTUnDHY6TTtB0vDvq8B8ZwOeSuPB1B66l2u7j6
	eW/pgTilqLq0PDmJ8O1Vu2BBrT+WzdETe4qafTi+cFKmRQ3rv4AZdnmGBR1+1lQjTO16vmZLunA
	qqDINE7tNxgUg2DESEGrosl8hcz5G1DuZwumNvU4pk0ZCiZBIgJ0lMWHZnB1MIqeZduLl/dWbur
	y9KQVhCFiQPt5Xc5d7aVVj2tudBk5OUtM/RY+VrKg5Y02vMwoS/q2T3xb9+LuXR2kG4xW+zV+bR
	KUCEH6HidZ3kD3B6xquwhHtx3HH35p1fD/SJkIAcckNzg5IJurGG6szMzmdmwBn9n2SObbq3Jes
	jt8e0e1HzAinYLEl6YCm3y+qL6lLZSh5JEZiuPniURWMJM7n8X6PEbJkdz1/H7b5LHyQaoZJA0t
	LYKaYrB3t8KhejzHpFFZAWrYD61NKCYbNLWkhFH/eSa+ngV73QA1uJoUfTBGUvoMH2Ej8eOVk5B
	NlZb5rRu6IEeCyw0LvWViAAavJE5bg+fbSzB3NZDri6cP6VcYsKOBGs0tLbjkP+hNoC9dvqGAab
	599XaY242Wh5Lx0zHcrMxbDupDVH0vbg
X-Received: by 2002:a05:690c:a418:20b0:8b1:691f:ab4d with SMTP id 00721157ae682-8b1b5ba3a5emr1705147b3.35.1793138317281;
        Tue, 27 Oct 2026 14:58:37 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e43e1d2sm18903937b3.5.2026.10.27.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:36 -0700 (PDT)
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
Subject: [PATCH 2/5] fuse: convert ext_map iomap ops to ->iomap_next()
Date: Tue, 27 Oct 2026 14:53:23 -0700
Message-ID: <20261027215326.2693300-3-joannelkoong@gmail.com>
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

Convert the fuse ext_map iomap_ops to the new ->iomap_next() callback.
The callback is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which
wraps the iomap_iter_next() helper to finish the previous mapping if
needed and produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/ext_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index 7f04edc33fe3..edb19498d496 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -210,8 +210,11 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(fuse_ext_map_iomap_next,
+			      fuse_ext_map_iomap_begin);
+
 static const struct iomap_ops fuse_ext_map_iomap_ops = {
-	.iomap_begin		= fuse_ext_map_iomap_begin,
+	.iomap_next		= fuse_ext_map_iomap_next,
 };
 
 static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned int order)
-- 
2.52.0

